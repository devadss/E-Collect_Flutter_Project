import 'package:e_Collect/domain/model/group/members_listing/members_listing_model.dart';
import 'package:dartz/dartz.dart';

abstract class MemberListInterface{
  Future<Either<String , MemberListResponse>>getMemberByGroup(int groupId);
}