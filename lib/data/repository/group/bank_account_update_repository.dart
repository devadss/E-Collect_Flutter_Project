import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/bank_account_update_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;

import '../../../domain/model/group/bank_account/bank_update_model.dart';

class BankAccountUpdateRepository implements BankAccountUpdateInterface{
  @override
  Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(int id) async {

    final uri = Uri.parse("${baseUrl}api/GetAccountByUser/$id");
    final request = await http.get(uri);
    print("api/GetAccountByUser/$id");
    print(request.body);
    if(request.statusCode == 200){
      return Right(BankAccountUpdateResponse.fromJson(jsonDecode(request.body)));
    }else{
      return Left(jsonDecode(request.body));
    }
  }

}