import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/delete_group/delete_group_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/delete_group/delete_group_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class DeleteGroupRepository implements DeleteGroupInterface {
  @override
  Future<Either<String, DeleteGroupResponse>> deleteGroup(int groupId) async {
    final uri = Uri.parse("${baseUrl}DeleteGroup/$groupId");
    final request = await http.delete(uri);
    print(request.body);
    if (request.statusCode == 200) {
      return (Right(DeleteGroupResponse.fromJson(jsonDecode(request.body))));
    } else {
      return (Left(jsonDecode(request.body)));
    }
  }
}
