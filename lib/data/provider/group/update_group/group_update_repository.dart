import 'package:e_Collect/data/repository/group/group_update/group_update_repository.dart';
import 'package:e_Collect/domain/model/group/update_group/group_update_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class GroupUpdateProvider with ChangeNotifier {
  final GroupUpdateRepository _groupUpdateRepository;

  GroupUpdateProvider(this._groupUpdateRepository);

  GroupUpdateResponse? _groupUpdateResponse;

  GroupUpdateResponse? get groupUpdateResponse => _groupUpdateResponse;

  Future<Either<String, GroupUpdateResponse>> updateGroup(
    int groupId,
    String groupName,
    double defaultAmount,
    String defaultDueDate,
    String corpCode,
    String branchCode,
  ) async {
    final data = await _groupUpdateRepository.updateGroup(groupId,
        groupName, defaultAmount, defaultDueDate, corpCode,branchCode
    );
    data.fold((err) {}, (success) {
      _groupUpdateResponse = success;
    });
    notifyListeners();
    return data;
  }
}
