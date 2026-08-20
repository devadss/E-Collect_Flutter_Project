import 'dart:convert';

import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/domain/interface/group/group_update/group_update_interface.dart';
import 'package:e_Collect/domain/model/group/update_group/group_update_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
//9995764687
class GroupUpdateRepository implements GroupUpdateInterface {
  @override
  Future<Either<String, GroupUpdateResponse>> updateGroup(
    int groupId,
    String groupName,
    double defaultAmount,
    String defaultDueDate,
    String corpCode,
    String branchCode,
  ) async {
    final uri = Uri.parse("${baseUrl}api/UpdateGroup/$groupId");
    final request = await http.put(uri,
        body: jsonEncode({
          "groupName": groupName,
          "defaultAmount": defaultAmount,
          "defaultDueDate": defaultDueDate,
          "CorpCode": corpCode,
          "BranchCode": branchCode
        }),
        headers: {'Content-Type': 'application/json'});
    print({"groupId":groupId,
      "groupName": groupName,
      "defaultAmount": defaultAmount,
      "defaultDueDate": defaultDueDate,
      "CorpCode": corpCode,
      "BranchCode": branchCode
    });
    print(request.body);
    if (request.statusCode == 200) {
      return Right(GroupUpdateResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(jsonDecode(request.body));
    }
  }
}
