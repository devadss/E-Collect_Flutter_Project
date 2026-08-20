import 'package:e_Collect/data/repository/group/delete_group/delete_group_repository.dart';
import 'package:e_Collect/domain/model/group/delete_group/delete_group_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class GroupDeleteProvider with ChangeNotifier {
  final DeleteGroupRepository _deleteGroupRepository;

  GroupDeleteProvider(this._deleteGroupRepository);

  DeleteGroupResponse? _deleteGroupResponse;

  DeleteGroupResponse? get deleteGroupResponse => _deleteGroupResponse;

  Future<Either<String, DeleteGroupResponse>> deleteGroup(int groupId) async {
    final data = await _deleteGroupRepository.deleteGroup(groupId);
    data.fold((err) {}, (success) {
      _deleteGroupResponse = success;
    });
    notifyListeners();
    return data;
  }
}
