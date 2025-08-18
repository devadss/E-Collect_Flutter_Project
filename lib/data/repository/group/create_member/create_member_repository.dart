import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/model/group/member_creation/member_creation_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

import '../../../../domain/interface/group/create_member/create_member_interface.dart';

class CreateMemberRepository implements CreateMemberInterface {
  @override
  Future<Either<String, CreateMemberResponse>> createMember(
      int groupId,
      String memberName,
      String mobileNumber,
      double amount,
      String dueDate,
      String feeCollectionStartDate,
      String corpCode,
      String branchCode,
      String entityId) async {
    final uri = Uri.parse("${baseUrl}api/CreateMember");
    final request = await http.post(uri,
        body: jsonEncode({
          "groupId": groupId,
          "memberName": memberName,
          "mobileNumber": mobileNumber,
          "amount": amount,
          "dueDate": dueDate,
          "feeCollectionStartDate": feeCollectionStartDate,
          "CorpCode": corpCode,
          "BranchCode": branchCode,
          "EntityId": entityId
        }),
        headers: {'Content-Type': 'application/json'});

    if (request.statusCode == 200) {
      return Right(CreateMemberResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(jsonDecode(request.body));
    }
  }
}
