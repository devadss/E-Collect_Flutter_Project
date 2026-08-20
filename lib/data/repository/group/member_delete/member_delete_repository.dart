import 'dart:convert';

import 'package:e_Collect/domain/interface/group/member_delete/member_delete_interface.dart';
import 'package:e_Collect/domain/model/group/member_delete/member_delete.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;

import '../../../../core/constants.dart';
class MemberDeleteRepository implements MemberDeleteInterface {


  @override
  Future<Either<String, DeleteMemberResponse>> deleteMember(int memberId) async {
    final uri = Uri.parse("${baseUrl}api/DeleteMember/$memberId");
    final request = await http.delete(uri);
    print(request.body);
    print(uri);
    if (request.statusCode == 200) {
      return Right(DeleteMemberResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(request.body);
    }
  }
}