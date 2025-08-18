import 'package:collection_qr_flutter/domain/model/group/member_delete/member_delete.dart';
import 'package:dartz/dartz.dart';

abstract class MemberDeleteInterface{
  Future<Either<String, DeleteMemberResponse>> deleteMember(int memberId);
}