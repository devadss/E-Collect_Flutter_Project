import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/model/group/update_group/group_update_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

import '../../../domain/interface/group/account_update_interface.dart';

class UpdateBankAccountRepository implements BankAccountUpdateInterface {
  @override
  Future<Either<String, GroupUpdateResponse>> updateBankDetails(
      int groupId,
      String userId,
      String accountHolderName,
      String accountNumber,
      String ifsc,
      String corpCode,
      String branchCode,
      String entityId) async {
    final uri = Uri.parse("${baseUrl}api/UpdateAccount/$groupId");
    final request = await http.put(uri,
        body: jsonEncode({
          "userId": userId,
          "accountHolderName": accountHolderName,
          "accountNumber": accountNumber,
          "ifsc": ifsc,
          "CorpCode": corpCode,
          "BranchCode": branchCode,
          "EntityId": entityId
        }),
      headers: {'Content-Type': 'application/json'},);
print({"groupId":groupId,
  "userId": userId,
  "accountHolderName": accountHolderName,
  "accountNumber": accountNumber,
  "ifsc": ifsc,
  "CorpCode": corpCode,
  "BranchCode": branchCode,
  "EntityId": entityId
});
print("response :${request.body}");
    if (request.statusCode == 200) {
      return Right(GroupUpdateResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(jsonDecode(request.body));
    }
  }
}
