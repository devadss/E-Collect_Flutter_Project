import 'dart:convert';

import '../../core/constants.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/payment_session_id_interface.dart';
import '../../domain/model/paymet_session_id_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CreatePaymentSessionIdRepository
    implements ICreatePaymentSessionIdRepository {
  @override
  Future<Either<ErrorHandler, PaymentSessionIdModel>>
  getPaymentSessionId({
    required String? token,
    required String? agentName,
      required String? agentId,
      required String? agentOriginId,
      required String? agentPhone,
      required String? agentEmail,
      required String? subAgentId,
      required String? customerName,
      required String? customerPhone,
      required String? customerAccno,
      required String? customerId,
      required String? customerEmail,
      required String? amount,
      required String? note,
      required String? corpCode,
      required String? cardRefNum,
      required String? subAgentBranchCode

  }) async {
    //final url = Uri.parse("${baseUrl}api/Cashfree/MerchantOrderCreate");
    final url = Uri.parse("${baseUrl}api/Cashfree/CollectiontOrderCreate");
    final body = {
      "agent_details": {
        "agent_name": agentName,
        "agent_id": agentId,
        "agent_orginId": agentOriginId,
        "agent_phone": agentPhone,
        "agent_email": agentEmail,
        "SubAgentId": subAgentId,
        "SubAgentBranchCode":subAgentBranchCode
      },
      "customer_details": {
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "customer_accno": customerAccno,
        "customer_id": customerId,
        "customer_email": customerEmail
      },
      "Amount": amount,
      "note": "Payment for Order",
      "CorpCode": corpCode,
      "CardRefNum": ""
    };
      // "Amount": amount,
      // "CustomerMobNo": phoneNumber,
      // "EntityId": entityId,
      // "Note": note,
      // "SubAgentId":subAgentID
    print("Body = $body");

    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if (checkConnection) {
      final response = await http.post(
          url,
          body: json.encode(body),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }
      );
      print("Body = ${response.body}");
      print("status = ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return Right(
              PaymentSessionIdModel.fromJson(jsonDecode(response.body)));
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}