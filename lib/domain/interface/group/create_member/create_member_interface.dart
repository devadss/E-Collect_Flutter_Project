import 'package:collection_qr_flutter/domain/model/group/member_creation/member_creation_model.dart';
import 'package:dartz/dartz.dart';

abstract class CreateMemberInterface {
  Future<Either<String, CreateMemberResponse>> createMember(
      int groupId,
      String memberName,
      String mobileNumber,
      double amount,
      String dueDate,
      String feeCollectionStartDate,
      String corpCode,
      String branchCode,
      String entityId);
}
