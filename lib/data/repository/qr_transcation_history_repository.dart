// import 'dart:convert';
// import 'package:collection_qr_flutter/core/utils.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// import '../../core/constants.dart';
// import '../../core/general.dart';
// import '../../domain/interface/qr_transcation_history_interface.dart';
// import '../../domain/model/qr_transaction_history_model.dart';
// import '../service/error_handler.dart';
//
// class QRTransactionHistoryRepository implements IQRTransactionHistoryRepository{
//   @override
//   Future<Either<ErrorHandler, QrTranscationHistoryModel>> getQrTranscationHistory(String? dateFilterType,String? startDate,String? endDate,String? source,
//       String? corpCode, String? agentOrginId) async{
//     Uri url =Uri();
//    // source == "COLLECTION"?
//     source == "ALL"?
//     url = Uri.parse("${baseUrl}api/eCollect/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=COLLECTION&CorpCode=$corpCode&agentOrginId=$agentOrginId&PaymentMode=QR")
//    : url = Uri.parse("${baseUrl}api/eCollect/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=COLLECTION&CorpCode=$corpCode&agentOrginId=$agentOrginId&PaymentMode=QR");
//
//
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//    if(checkConnection){
//      if(printStatementStatus){
//        print(url);
//      }
//
//      final response = await http.get(url);
//      if(response.statusCode == 200 || response.statusCode == 201){
//        try{
//          if(printStatementStatus){
//            printLog("==================================QR TRANSACTION STATUS CODE=================================");
//            printLog(response.statusCode);
//            printLog("==================================QR TRANSACTION STATUS CODE=================================");
//            printLog("QR TRANSACTION ${response.body}");
//          }
//
//          if(response.body.contains("OrderId")){
//            return Right(QrTranscationHistoryModel.fromJson(jsonDecode(response.body)));
//
//          }else{
//            return Left(DataParsingException(response.body));
//
//          }
//        }catch(e){
//          return Left(DataParsingException(e));
//        }
//      }else{
//       // return Left(FetchDataError("Failed to Fetch Data"));
//        return Left(DataParsingException(response.body));
//      }
//    }else{
//      return Left(FetchDataError("No Internet Connection"));
//    }
//   }
// }
