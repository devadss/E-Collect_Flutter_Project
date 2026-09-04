// import 'dart:convert';
//
// import 'package:e_Collect/core/constants.dart';
// import 'package:e_Collect/domain/interface/group/member_list/member_list_interface.dart';
// import 'package:e_Collect/domain/model/group/members_listing/members_listing_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
//
// class MemberListRepository implements MemberListInterface {
//   @override
//   Future<Either<String, MemberListResponse>> getMemberByGroup(
//       int groupId) async {
//     final uri = Uri.parse("${baseUrl}api/GetMembersByGroup/$groupId");
//     final request = await http.get(uri);
//     if (request.statusCode == 200) {
//       return Right(MemberListResponse.fromJson(jsonDecode(request.body)));
//     } else {
//       return Left(jsonDecode(request.body));
//     }
//   }
// }
