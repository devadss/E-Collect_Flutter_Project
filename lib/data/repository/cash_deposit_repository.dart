import 'dart:convert';

import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/interface/cash_deposit_interface.dart';
import 'package:collection_qr_flutter/domain/model/cash_deposit_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CashDepositRepository implements CashDepositInterface {
  @override
  Future<Either<ErrorHandler, CashDepositModel>> depositCash(
      String accountNumber, String agentId, String amount) async {
    final uri = Uri.parse("https://doorstepmftctest.digicob.in/cashDeposit");
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

    print(request.statusCode);
    print(request.body);

    if(request.statusCode == 200){
      CashDepositModel cashDepositModel = CashDepositModel.fromJson(jsonDecode(request.body));
      return Right(cashDepositModel);
    }else{
      ErrorHandler errorHandler = ErrorHandler("ERROR", "TRANSACTION FAILED");
      return Left(errorHandler);
    }
  }
}
