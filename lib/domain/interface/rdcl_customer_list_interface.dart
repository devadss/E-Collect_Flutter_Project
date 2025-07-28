import 'package:collection_qr_flutter/domain/model/account_list_model.dart';
import 'package:dartz/dartz.dart';

abstract class RdclCustomerListInterface{
  Future<Either<String, RdclCustomerListModel>>getRdclCustomerunderAgent(
      String? agentID,
      String? branchID,
      int pgNo, int pgSize, String custName
      );
}