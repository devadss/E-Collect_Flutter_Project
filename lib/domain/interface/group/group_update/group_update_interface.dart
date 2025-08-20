import 'package:collection_qr_flutter/domain/model/group/update_group/group_update_model.dart';
import 'package:dartz/dartz.dart';

abstract class GroupUpdateInterface{
  Future<Either<String, GroupUpdateResponse>> updateGroup(int groupId,
      String groupName,
      double defaultAmount,
      String defaultDueDate,
      String corpCode,
      String branchCode,
      );
}