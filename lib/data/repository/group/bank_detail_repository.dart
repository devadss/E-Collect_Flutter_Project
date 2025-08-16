import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/bank_account_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class BankAccountRepository implements BankAccountInterface {
  @override
  Future<Either<String, BankDetailSubmitApiResponse>> submitBankDetails(
      int userID,
      String accountHolderName,
      String accountNumber,
      String ifsc,
      String corpCode,
      String branchCode,
      String entityId) async {
    final uri = Uri.parse("${baseUrl}api/CreateAccount");
    final request = await http.post(
      uri,
      body: jsonEncode({
        "userId": userID,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifsc": ifsc,
        "CorpCode": "MOBWER",
        "BranchCode": "MOBWER",
        "EntityId": "MOBWER"
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (request.statusCode == 200) {
      return Right(BankDetailSubmitApiResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(request.body);
    }
  }
}
