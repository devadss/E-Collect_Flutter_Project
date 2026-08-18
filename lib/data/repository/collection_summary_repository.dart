// import 'package:collection_qr_flutter/core/utils.dart';
//
// import '../../core/constants.dart';
// import '../../data/service/error_handler.dart';
// import '../../domain/interface/collection_summary_interface.dart';
// import '../../domain/model/collection_summary_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class CollectionSummaryRepository implements ICollectionSummaryRepository {
//   @override
//   Future<Either<ErrorHandler, CollectionSummaryModel>> getCollectionSummary(
//       String agentId, String startDate, String endDate, String token) async {
//     final url = Uri.parse(
//         "${baseUrl}api/Cashfree/GetCollectionSummary?agentId=$agentId&startDate=$startDate&endDate=$endDate");
//
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//    if(checkConnection){
//      final response = await http.get(
//        url,
//        headers: {
//          "Authorization": "Bearer $token",
//          "Content-Type": "application/json",
//        },
//      );
//      if(printStatementStatus){
//        print("CollectionSummaryRepository : ${response.body}");
//        print("agentId=$agentId");
//        print("startDate=$startDate");
//        print("endDate=$endDate");
//        print("token=$token");
//      }
//
//      if(response.statusCode == 200 || response.statusCode == 201){
//        try{
//          return Right(CollectionSummaryModel.fromJson(jsonDecode(response.body)));
//        }catch(e){
//          return Left(DataParsingException(e));
//        }
//      }else{
//        return Left(FetchDataError("Failed To Fetch Data"));
//      }
//    }else{
//      return Left(FetchDataError("No Internet Connection"));
//    }
//   }
// }
