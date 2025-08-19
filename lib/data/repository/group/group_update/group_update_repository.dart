import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/group/group_update/group_update_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/update_group/group_update_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class GroupUpdateRepository implements GroupUpdateInterface {
  @override
  Future<Either<String, GroupUpdateResponse>> updateGroup(int groupId) async {
    final uri = Uri.parse("${baseUrl}api/UpdateGroup/$groupId");
    final request = await http.put(uri);
    if (request.statusCode == 200) {
      return Right(GroupUpdateResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(jsonDecode(request.body));
    }
  }
}
