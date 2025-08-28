import 'package:collection_qr_flutter/data/repository/group/member_update_repository/member_update_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/member_updation/member_update_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../service/error_handler.dart';

class MemberUpdateProvider with ChangeNotifier {
  final MemberUpdateRepository _memberUpdateRepository;

  MemberUpdateProvider(this._memberUpdateRepository);

  UpdateMemberResponse? _memberResponse;

  UpdateMemberResponse? get memberResponse => _memberResponse;

  String? _errMsg;
  String? get errMsg => _errMsg;

  Future<Either<ErrorHandler, UpdateMemberResponse>> updateMember(
      int memberId,
      int groupId,
      String memberName,
      String memberNumber,
      double amount,
      String dueDate,
      String collectionStartDate,
      String corpCode,
      String branchCode,
      String entityId) async {
    final response = await _memberUpdateRepository.updateMember(
        memberId,
        groupId,
        memberName,
        memberNumber,
        amount,
        dueDate,
        collectionStartDate,
        corpCode,
        branchCode,
        entityId);
    response.fold((err) {
      _errMsg = err.message;
      print("err ${err.message}");
    }, (success) {
      _memberResponse = success;
    });
    notifyListeners();
    return response;
  }
}
