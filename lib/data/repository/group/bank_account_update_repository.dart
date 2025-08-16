import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/bank_account_update_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_update_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;

class BankAccountUpdateRepository implements BankAccountUpdateInterface{
  @override
  Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(int id) async {

    final uri = Uri.parse("${baseUrl}api/GetAccountByUser/$id");
    final request = await http.get(uri);
    if(request.statusCode == 200){
      return Right(BankAccountUpdateResponse.fromJson(jsonDecode(request.body)));
    }else{
      return Left(jsonDecode(request.body));
    }
  }
  
}