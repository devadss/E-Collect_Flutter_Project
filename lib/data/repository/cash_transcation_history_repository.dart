import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/constants.dart';
import '../../core/general.dart';
import '../../domain/interface/cash_transcation_history_interface.dart';
import '../../domain/model/qr_transaction_history_model.dart';
import '../service/error_handler.dart';

class CashTransactionHistoryRepository
    implements ICashTransactionHistoryRepository {
  @override
  Future<Either<ErrorHandler, QrTranscationHistoryModel>>
      getCashTranscationHistory(String? dateFilterType, String? startDate,
          String? endDate, String? source, String? subAgentId, String? corpCode,  String? agentOriginId) async {
    Uri url = Uri();
    source == "COLLECTION_CASH"?
     url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&subAgentId=$subAgentId&CorpCode=$corpCode&agentOrginId=1231")
     //url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&subAgentId=$subAgentId&CorpCode=$corpCode&agentOrginId=$agentOriginId")
     :url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&subAgentId=$subAgentId&CorpCode=$corpCode&agentOrginId=1231&PaymentMode=CASH");
    // :url = Uri.parse("${baseUrl}api/GetMerchantOrders?dateFilterType=$dateFilterType&startDate=$startDate&endDate=$endDate&Source=$source&subAgentId=$subAgentId&CorpCode=$corpCode&agentOrginId=$agentOriginId&PaymentMode=CASH");
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if (checkConnection) {
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          printLog(
              "==================================QR TRANSACTION STATUS CODE=================================");
          printLog(response.statusCode);
          printLog(
              "==================================QR TRANSACTION STATUS CODE=================================");
          printLog(response.body);
          if (response.body.contains("OrderId")) {
            return Right(
                QrTranscationHistoryModel.fromJson(jsonDecode(response.body)));
          } else {
            return Left(DataParsingException(response.body));
          }
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        // return Left(FetchDataError("Failed to Fetch Data"));
        return Left(DataParsingException(response.body));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
