import 'dart:convert';

import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/domain/model/group/group_creation/group_creation_model.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/interface/group/group_creation/group_creation_interface.dart';

class CreateGroupRepository implements GroupCreationInterface {
  @override
  Future<Either<String, CreateGroupResponse>> createGroup(
      String groupName,
      double defaultAmount,
      String defaultDueDate,
      String corpCode,
      String branchCode) async {
    final uri = Uri.parse("${baseUrl}api/CreateGroup");
    final request = await http.post(uri,
        body: jsonEncode({
          "groupName": groupName,
          "defaultAmount": defaultAmount,
          "defaultDueDate": defaultDueDate,
          "CorpCode": corpCode,
          "BranchCode": branchCode
        }),
        headers: {'Content-Type': 'application/json'});
print(request.body);
print(defaultDueDate);
    if (request.statusCode == 200) {
      return Right(CreateGroupResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(jsonDecode(request.body));
    }
  }
}
