// import 'dart:convert';
//
// import 'package:collection_qr_flutter/core/constants.dart';
// import 'package:collection_qr_flutter/domain/interface/group/bank_account_update_interface.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart'as http;
//
// import '../../../domain/model/group/bank_account/bank_update_model.dart';
//
// class BankAccountUpdateRepository implements BankAccountUpdateInterface{
//   @override
//   Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(int id) async {
//
//     final uri = Uri.parse("${baseUrl}api/GetAccountByUser/$id");
//     final request = await http.get(uri);
//     if(request.statusCode == 200){
//       return Right(BankAccountUpdateResponse.fromJson(jsonDecode(request.body)));
//     }else{
//       return Left(jsonDecode(request.body));
//     }
//   }
//
// }

import 'dart:convert';

import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_account/bank_update_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/constants.dart';
import '../../../domain/interface/group/bank_account_update_interface.dart';

class BankAccountUpdateRepository implements BankAccountUpdateInterface{
  @override
  Future<Either<ErrorHandler, BankAccountUpdateResponse>> getBankAccountDetails(int id) async{
    final uri = Uri.parse("${baseUrl}api/GetAccountByUser/$id");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if(checkConnection){
      final response = await http.get(uri);
      if(response.statusCode == 200 || response.statusCode == 201){
        printLog("-------------------------------STATUS CODE FETCH ACCOUNT DETAILS-----------------------");
        printLog(response.statusCode);
        printLog("-------------------------------Body FETCH ACCOUNT DETAILS-----------------------");
        printLog(response.body);
        try{
          return right(BankAccountUpdateResponse.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}