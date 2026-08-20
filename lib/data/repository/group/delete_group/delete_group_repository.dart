import 'dart:convert';

import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/domain/interface/group/delete_group/delete_group_interface.dart';
import 'package:e_Collect/domain/model/group/delete_group/delete_group_model.dart';
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
