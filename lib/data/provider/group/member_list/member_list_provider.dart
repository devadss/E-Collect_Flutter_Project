import 'package:collection_qr_flutter/data/repository/group/member_list/member_list_repository.dart';
import 'package:collection_qr_flutter/domain/model/group/members_listing/members_listing_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class MemberListProvider with ChangeNotifier{
  final MemberListRepository _memberListRepository;
  MemberListProvider(this._memberListRepository);

  MemberListResponse? _memberListResponse;
  MemberListResponse? get memberListResponse => _memberListResponse;

  String? _err;
  String? get err=> _err;

  Future<Either<String , MemberListResponse>>getMemberByGroup(int groupId) async {
    final data = await _memberListRepository.getMemberByGroup(groupId);
    data.fold((er){}, (success){
      _memberListResponse = success;

    });
    notifyListeners();
    return data;
  }
}