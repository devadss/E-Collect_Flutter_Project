import 'package:collection_qr_flutter/data/repository/group/create_member/create_member_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/member_creation/member_creation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CreateMemberProvider with ChangeNotifier {
  final CreateMemberRepository _createMemberRepository;

  CreateMemberProvider(this._createMemberRepository);

  CreateMemberResponse? _createMemberResponse;

  CreateMemberResponse? get createMemberResponse => _createMemberResponse;

  String? _err;
  String? get err => _err;

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
    final data = await _createMemberRepository.createMember(
        groupId,
        memberName,
        mobileNumber,
        amount,
        dueDate,
        feeCollectionStartDate,
        corpCode,
        branchCode,
        entityId);
    data.fold((err) {
      _err = err;
    }, (success) {
      _createMemberResponse = success;
    });
    notifyListeners();
    return data;
  }
}
