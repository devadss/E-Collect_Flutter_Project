import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../core/constants.dart';
import '../../core/general.dart';
import '../../domain/interface/link_transaction_history_interface.dart';
import '../../domain/model/all_trans_data.dart';
import '../service/error_handler.dart';

class LinkTransactionHistoryRepository implements ILinkTransactionHistoryRepository{
  @override
  Future<Either<ErrorHandler, AllTranscationHistoryModel>> getLinkTransactionHistory(String filterType, String startDate, String endDate, String subAgentId,String corpCode,String agentOrginId) async{
  // final url = Uri.parse("${baseUrl}api/Cashfree/GetPaymentLinksQrTransactions?filterType=$filterType&startDate=$startDate&endDate=$endDate&subAgentId=$subAgentId");
    final url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$filterType&startDate=$startDate&endDate=$endDate&Source=ALL&CorpCode=$corpCode&agentOrginId=$agentOrginId");

  printLog("URL = ${"${baseUrl}api/GetMerchantOrders?dateFilterType=$filterType&startDate=$startDate&endDate=$endDate&Source=ALL&CorpCode=$corpCode&agentOrginId=$agentOrginId"}");
   bool checkConnection = await InternetConnectionChecker().hasConnection;
   if(checkConnection){
    final response = await http.get(url);
    if(response.statusCode == 200 || response.statusCode == 201){
      printLog("--------------------------------RESPONSE STATUS CODE LINK TRANSCATIONS---------------------------------");
      printLog(response.statusCode);
      printLog("--------------------------------RESPONSE BODY LINK TRANSCATIONS---------------------------------");
      printLog(response.body);
      try{
        return Right(AllTranscationHistoryModel.fromJson(jsonDecode(response.body)));
      }catch(e){
        return Left(DataParsingException(e));
      }
    }else{
      return Left(DataParsingException(response.body));
     // return Left(FetchDataError("Failed To Fetch Data"));
    }
   }else{
     return Left(FetchDataError("No Internet Connection"));
   }
  }
}