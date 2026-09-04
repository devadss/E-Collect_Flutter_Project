// import 'package:e_Collect/data/repository/group/create_group/create_group_with_member_repository.dart';
// import 'package:e_Collect/data/service/error_handler.dart';
// import 'package:e_Collect/domain/model/group/group_creation/group_with_member.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
//
// class CreateGroupWithMemberProvider with ChangeNotifier {
//   final CreateGroupWithMemberRepository _createGroupWithMemberRepository;
//
//   CreateGroupWithMemberProvider(this._createGroupWithMemberRepository);
//
//   CreateGroupWithMemberResponse? _createGroupWithMemberResponse;
//   CreateGroupWithMemberResponse? get createGroupWithMemberResponse => _createGroupWithMemberResponse;
//
//   Future<Either<ErrorHandler, CreateGroupWithMemberResponse>> createGroupWitMember(Map<String, dynamic> payload) async {
//     final result = await _createGroupWithMemberRepository.createGroupWitMember(payload);
//
//     result.fold((error) {
//     }, (response) {
//       _createGroupWithMemberResponse = response;
//     });
//
//     notifyListeners();
//     return result;
//   }
// }
