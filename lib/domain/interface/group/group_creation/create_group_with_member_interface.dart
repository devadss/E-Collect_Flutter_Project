import 'package:e_Collect/data/service/error_handler.dart';
import 'package:e_Collect/domain/model/group/group_creation/group_with_member.dart';
import 'package:dartz/dartz.dart';

abstract class CreateGroupWithMemberInterface {
  Future<Either<ErrorHandler, CreateGroupWithMemberResponse>>
      createGroupWitMember(
    Map<String, dynamic> payload,
  );
}

// abstract class CreateGroupWithMemberInterface{
//   Future<Either<String , CreateGroupWithMemberResponse>>createGroupWitMember(
//       String groupName,
//       String corpCode,
//       double defaultAmount,
//       String defaultDueDate,
//       String entityId,
//       String memberName,
//       String mobileNumber,
//       double amount,
//       String dueDate,
//       String feeCollectionStartDate,
//
//
//       );
// }
