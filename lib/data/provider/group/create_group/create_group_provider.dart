import 'package:e_Collect/data/repository/group/create_group/create_group_repository.dart';
import 'package:e_Collect/domain/model/group/group_creation/group_creation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CreateGroupProvider with ChangeNotifier {
  final CreateGroupRepository _createGroupRepository;

  CreateGroupProvider(this._createGroupRepository);

  CreateGroupResponse? _createGroupResponse;

  CreateGroupResponse? get createGroupResponse => _createGroupResponse;

  Future<Either<String, CreateGroupResponse>> createGroup(
    String groupName,
    double defaultAmount,
    String defaultDueDate,
    String corpCode,
    String branchCode,
  ) async {
    final data = await _createGroupRepository.createGroup(
        groupName, defaultAmount, defaultDueDate, corpCode, branchCode);
    data.fold((err) {}, (success) {
      _createGroupResponse = success;
    });
    notifyListeners();
    return data;
  }
}
