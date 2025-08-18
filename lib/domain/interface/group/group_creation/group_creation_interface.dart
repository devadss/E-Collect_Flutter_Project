import 'package:collection_qr_flutter/domain/model/group/group_creation/group_creation_model.dart';
import 'package:dartz/dartz.dart';

abstract class GroupCreationInterface{
  Future<Either<String, CreateGroupResponse>>createGroup(
      String groupName,
      double defaultAmount,
      String defaultDueDate,
      String corpCode,
      String branchCode,
      );
}