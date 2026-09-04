// import 'package:e_Collect/data/repository/group/member_delete/member_delete_repository.dart';
// import 'package:e_Collect/domain/model/group/member_delete/member_delete.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class DeleteMemberProvider with ChangeNotifier {
//   final MemberDeleteRepository _memberDeleteRepository;
//
//   DeleteMemberProvider(this._memberDeleteRepository);
//
//   DeleteMemberResponse? _deleteMemberResponse;
//
//   DeleteMemberResponse? get deleteMemberResponse => _deleteMemberResponse;
//
//   Future<Either<String, DeleteMemberResponse>> deleteMember(
//       int memberId) async {
//     final data = await _memberDeleteRepository.deleteMember(memberId);
//     data.fold((err) {}, (success) {
//       _deleteMemberResponse = success;
//     });
//     notifyListeners();
//     return data;
//   }
// }
