import 'dart:convert';

import 'package:collection_qr_flutter/domain/model/no_transaction.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

import '../../constants.dart';
import '../../domain/interface/agent_trancstion_interface.dart';
import '../../domain/model/agent_transction_model.dart';
import '../service/error_handler.dart';

class AgentTransactionRepository implements IAgentTransactionRepository{
  @override
  Future<Either<NoTransactionModel, AgentPaymentTransctionModel>> getTransactions(String token) async{
   final url = Uri.parse("${baseUrl}api/Cashfree/GetPaymentLinksQrTransactions");
   bool checkConnection = await InternetConnectionChecker().hasConnection;
   if(checkConnection){
     final response = await http.get(url, headers: {'Content-Type': 'application/json',
       'Authorization': 'Bearer $token',
     });
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         return Right(AgentPaymentTransctionModel.fromJson(jsonDecode(response.body)));
       }catch(e){
         return Left(NoTransactionModel.fromJson(jsonDecode(response.body)));
       }
     }else{
       return Left(NoTransactionModel.fromJson(jsonDecode(response.body)));
     }
   }else{
     return Left(NoTransactionModel(message: "NO INTERNET"));
   }
  }
}