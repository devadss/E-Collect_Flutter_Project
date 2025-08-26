import 'package:collection_qr_flutter/data/repository/group/group_status/group_status_repository.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/group/group_status/group_status_model.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class GroupStatusProvider with ChangeNotifier {
  final GroupStatusRepository _groupStatusRepository;
  GroupStatusProvider(this._groupStatusRepository);
  Map<int, bool> currentGroupStatus = {};

  // Method to update status for a specific group
  void updateGroupStatus(int groupId, bool status) {
    currentGroupStatus[groupId] = status;
    notifyListeners();
  }
  Future<Either<ErrorHandler, GroupStatusModel>> getGroupStatus(int? groupId) {
    return _groupStatusRepository.getGroupStatus(groupId);
  }
}
