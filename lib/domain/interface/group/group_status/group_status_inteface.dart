import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/group/group_status/group_status_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class IGroupStatusRepository{
  Future<Either<ErrorHandler,GroupStatusModel>>getGroupStatus(int? groupId);
}