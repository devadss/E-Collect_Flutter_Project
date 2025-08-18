import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/bank_account_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/bank_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class BankAccountRepository implements BankAccountInterface {
  @override
  Future<Either<String, BankDetailSubmitApiResponse>> submitBankDetails(
      String userID,
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
        "EntityId": userID
      }),
      headers: {'Content-Type': 'application/json'},
    );
print({
  "userId": userID,
  "accountHolderName": accountHolderName,
  "accountNumber": accountNumber,
  "ifsc": ifsc,
  "CorpCode": "MOBWER",
  "BranchCode": "MOBWER",
  "EntityId": userID
});
print(request.body);
    if (request.statusCode == 200) {
      return Right(BankDetailSubmitApiResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(request.body);
    }
  }
}
