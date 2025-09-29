// import 'dart:convert';
//
// import 'package:collection_qr_flutter/domain/interface/collection_base_url_interface.dart';
// import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
//
// import '../../core/constants.dart';
//
// class CollectionBaseUrlRepo implements CollectionBaseUrlInterface {
//   @override
//   Future<Either<String, CollectionBaseUrlModel>> getCollectionUrl(
//       String? parentMobNum) async {
//     parentMobNum!.startsWith("+91")
//         ? parentMobNum.replaceAll("+91", "")
//         : parentMobNum;
//     print("parentMobNum $parentMobNum");
//     final uri = Uri.parse("$dopBaseUrl$parentMobNum");
//     final request = await http.get(uri);
//     print("CollectionBaseUrlRepo : $uri");
//     print("CollectionBaseUrlRepo Body:${request.body}");
//     if (request.statusCode == 200) {
//       return Right(CollectionBaseUrlModel.fromJson(jsonDecode(request.body)));
//     } else {
//       return Left(request.body);
//     }
//   }
// }


import 'dart:convert';
import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/constants.dart';
import '../../domain/interface/collection_base_url_interface.dart';
import 'package:http/http.dart' as http;

class CollectionBaseUrlRepo implements CollectionBaseUrlInterface{
  @override
  Future<Either<ErrorHandler, CollectionBaseUrlModel>> getCollectionUrl(String? parentMobNum) async{
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    parentMobNum!.startsWith("+91") ?parentMobNum.replaceAll("+91", "") : parentMobNum;
    final url = Uri.parse("$dopBaseUrl$parentMobNum");
    if(checkConnection){
      final response = await http.get(url);
      if(response.statusCode ==200 || response.statusCode == 201){
        printLog("-----------------------------LOAD VENDER URL STATUS CODE-------------------------");
        printLog(response.statusCode);
        printLog("-----------------------------LOAD VENDER URL Body-------------------------");
        printLog(response.body);
        try{
          return Right(CollectionBaseUrlModel.fromJson(jsonDecode(response.body)));
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