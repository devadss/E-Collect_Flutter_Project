import 'dart:convert';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/interface/cash_transcation_interface.dart';
import 'package:collection_qr_flutter/domain/model/cash_transcation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CashTranscationRepository implements ICashTranscationRepository {
  @override
  Future<Either<ErrorHandler, CashTranscation>> getTranscations(
      {required String? agentName,
     required String? agentId,
     required String? agentOriginId,
     required String? agentPhone,
     required String? agentEmail,
     required String? subAgentId,
     required String? customerName,
     required String? customerPhone,
     required String? customerAccNo,
     required String? customerId,
     required String? customerEmail,
     required String? amount,
     required String? note,
     required String? corpCode,
     required String? cardRefNum,
     required String? token,
     required String? subagentBranchCode

      }) async {
    final uri =
        Uri.parse("${baseUrl}api/Cashfree/ReceiveCash");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    final body = {
      "agent_details": {
        "agent_name": agentName,
        "agent_id": agentId,
        "agent_orginId": agentOriginId,
        "agent_phone": agentPhone,
        "agent_email": agentEmail,
        "SubAgentId": subAgentId,
        "SubAgentBranchCode":subagentBranchCode
      },
      "customer_details": {
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "customer_accno": customerAccNo,
        "customer_id": customerId,
        "customer_email": customerEmail,

      },
      "Amount": amount,
      "note": note,
      "CorpCode": corpCode,
      "CardRefNum": cardRefNum
    };
    if (checkConnection) {
      final response = await http.post(uri, body: json.encode(body), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      print(response.statusCode);
      print(response.body);
      print(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          print("===============+CASH STATUS CODE=====================");
          print(response.statusCode);
          print(body);
          print("==============CASH RESPONSE BODY===================");
          print(response.body);
          return Right(CashTranscation.fromJson(jsonDecode(response.body)));
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
