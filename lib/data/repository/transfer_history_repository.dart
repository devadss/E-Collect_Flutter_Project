import 'dart:convert';
import 'package:collection_qr_flutter/domain/interface/transfer_transaction_interface.dart';
import 'package:collection_qr_flutter/domain/model/transfer_history_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/constants.dart';
import '../../core/general.dart';
import '../service/error_handler.dart';

class TransferHistoryRepository implements TransferTransactionInterface{
  @override
  Future<Either<ErrorHandler, TransferHistoryModel>> getTransferTranscationHistory(String? dateFilterType, String? startDate, String? endDate, String? source, String? corpCode, String? agentOrginId)
     async{
   // final url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&CorpCode=$corpCode&agentOrginId=1231&PaymentMode=TRANSFER");
    final url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&CorpCode=$corpCode&agentOrginId=$agentOrginId&PaymentMode=TRANSFER");
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if(checkConnection){
      print(url);
      final response = await http.get(url);
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          printLog("==================================ALL TRANSACTION STATUS CODE=================================");
          printLog(response.statusCode);
          printLog("==================================ALL TRANSFER TRANSACTION STATUS CODE=================================");
          printLog(response.body);
          if(response.body.contains("OrderId")){
            return Right(TransferHistoryModel.fromJson(jsonDecode(response.body)));

          }else{
            return Left(DataParsingException(response.body));

          }
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        // return Left(FetchDataError("Failed to Fetch Data"));
        return Left(DataParsingException(response.body));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }


}
