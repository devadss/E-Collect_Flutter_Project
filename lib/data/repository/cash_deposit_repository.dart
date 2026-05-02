import 'dart:convert';
import 'package:collection_qr_flutter/core/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/interface/cash_deposit_interface.dart';
import '../../domain/model/cash_deposit_model.dart';
import '../service/error_handler.dart';
import '../storage/shared_pref_helper.dart';

class CashDepositRepository implements CashDepositInterface {
  Future<String> loadVendorUrl() async {
    //final liveUrl = await SharedPref().getVendorUrlLive();
    return await SharedPref().getDueListRdUrl();

  }

  @override
  Future<Either<ErrorHandler, CashDepositModel>> depositCash(
      String accountNumber, String agentId, String amount) async {
    //final uri = Uri.parse("https://doorstepmftctest.digicob.in/cashDeposit");
    final vendorUrl = await loadVendorUrl();
    final uri = Uri.parse("${vendorUrl.replaceAll("GetRdclDuesListunderAgent", "").trim()}cashDeposit");
    final request = await http.post(
      uri,
      body: json.encode({
        "account_no": accountNumber,
        "deposit_amount": amount,
        "agent_id": agentId,
        "particular": "agent transfer",
        "bank_account_no": "",
        "TranType": "cash",
        "UPIId": ""
      }),
      headers: {'Content-Type': 'application/json'},
    );
if(printStatementStatus){
  print(request.statusCode);
  print(request.body);
}


    if(request.statusCode == 200){
      CashDepositModel cashDepositModel = CashDepositModel.fromJson(jsonDecode(request.body));
      return Right(cashDepositModel);
    }else{
      ErrorHandler errorHandler = ErrorHandler("ERROR", "TRANSACTION FAILED");
      return Left(errorHandler);
    }
  }
}

