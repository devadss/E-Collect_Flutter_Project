import 'package:e_Collect/domain/model/group/group_listing/group_list_model.dart';
import 'package:dartz/dartz.dart';

abstract class GroupListInterface{
  Future<Either<String, GroupListResponse>> listGroupUnderUser();
}