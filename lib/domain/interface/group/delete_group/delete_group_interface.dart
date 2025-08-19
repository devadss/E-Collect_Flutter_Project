import 'package:collection_qr_flutter/domain/model/group/delete_group/delete_group_model.dart';
import 'package:dartz/dartz.dart';

abstract class DeleteGroupInterface{
  Future<Either<String, DeleteGroupResponse>>deleteGroup(int groupId);
}