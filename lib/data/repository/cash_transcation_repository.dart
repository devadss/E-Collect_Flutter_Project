import 'dart:convert';
import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/data/service/error_handler.dart';
import 'package:e_Collect/domain/interface/cash_transcation_interface.dart';
import 'package:e_Collect/domain/model/cash_transcation_model.dart';
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
     required String? subagentBranchCode,
     required String? branchCode,
     required String? collectionType

      }) async {
    final uri =
        Uri.parse("${baseUrl}api/Cashfree/ReceiveCash");
       //Uri.parse("${baseUrl}api/Cashfree/24234234");
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
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
      "CollectionType":collectionType,
      "Amount": amount,
      "note": note,
      "CorpCode": corpCode,
      "BranchCode": branchCode,
      "CardRefNum": cardRefNum
    };
    print("cash request body $body");
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
