import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/constants.dart';
import 'package:merchant_app_flutter/domain/interface/balance_interface.dart';
import 'package:merchant_app_flutter/domain/model/balance_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/fetch_balance_model.dart';
import 'package:http/http.dart' as http;

class BalanceRepository extends BalanceInterface{
  @override
  Future<Either<BalanceFailModel, BalanceModel>> getBalance(String entityID, String token) async {
 final uri = Uri.parse("${baseUrl}api/Fetchbalance");
 final request = await http.post(
   uri ,
   body: json.encode({
     "entityId":entityID
   }),
     headers: {
       'Content-Type': 'application/json',
       'Authorization': 'Bearer $token',
     }
 );

 if(request.statusCode == 200){
   BalanceModel balanceModel = BalanceModel.fromJson(json.decode(request.body));
   return Right(balanceModel);
 }else{
   BalanceFailModel balanceFailModel = BalanceFailModel.fromJson(json.decode(request.body));
   return Left(balanceFailModel);
 }
    throw UnimplementedError();
  }
  
}