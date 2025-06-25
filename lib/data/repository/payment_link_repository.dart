import 'dart:convert';
import '../../core/constants.dart';
import '../../core/general.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/payment_link_interface.dart';
import '../../domain/model/payment_link_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class PaymentLinkRepository implements IPaymentLinkRepository {
  @override
  Future<Either<ErrorHandler, PaymentLinkModel>> getPaymentLink(
      String agentName,
      String agentId,
      String agentOriginId,
      String agentPhone,
      String agentEmail,
      String customerName,
      String customerPhone,
      String customerAccountNumber,
      String customerEmail,
      String customerId,
      num linkAmount,
      String note,
      String corpCode,
      String cardRefNum,String token,
      String  subAgentId) async {
    final url = Uri.parse("${baseUrl}api/Cashfree/CreatePaymentLink");

    final Map<String, dynamic> body = {
      "agent_details": {
        "agent_name": agentName,
        "agent_id": agentId,
        "agent_orginId": agentOriginId,
        "agent_phone": agentPhone,
        "agent_email": agentEmail,
        "SubAgentId":subAgentId
      },
      "customer_details": {
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "customer_accno": customerAccountNumber,
        "customer_id": customerId,
        "customer_email": customerEmail
      },
      "link_amount": linkAmount,
      "note": note,
      "CorpCode": corpCode,
      "CardRefNum": cardRefNum
    };

    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if (!checkConnection) {
      return Left(FetchDataError("No Internet Connection"));
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add token here
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body), // Convert Map to JSON String
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        printLog("---------------------body----------------------");
        printLog(response.body);
        printLog("-----------------------BODY-----------------------");
        printLog(body);
        return Right(PaymentLinkModel.fromJson(jsonDecode(response.body)));
      } else {
        return Left(FetchDataError("Failed to fetch data: ${response.statusCode}"));
      }
    } catch (e) {
      return Left(DataParsingException(e.toString()));
    }
  }
}
