import 'package:collection_qr_flutter/data/repository/group/create_group/create_group_with_member_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/group_creation/group_with_member.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';


class CreateGroupWithMemberProvider with ChangeNotifier {
  final CreateGroupWithMemberRepository _createGroupWithMemberRepository;

  CreateGroupWithMemberProvider(this._createGroupWithMemberRepository);

  CreateGroupWithMemberResponse? _createGroupWithMemberResponse;
  CreateGroupWithMemberResponse? get createGroupWithMemberResponse => _createGroupWithMemberResponse;

  Future<Either<String, CreateGroupWithMemberResponse>> createGroupWitMember(Map<String, dynamic> payload) async {
    final result = await _createGroupWithMemberRepository.createGroupWitMember(payload);

    result.fold((error) {
    }, (response) {
      _createGroupWithMemberResponse = response;
    });

    notifyListeners();
    return result;
  }
}
