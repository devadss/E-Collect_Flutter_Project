import 'package:collection_qr_flutter/domain/model/group/bank_update_model.dart';
import 'package:dartz/dartz.dart';

abstract class BankAccountUpdateInterface{
  Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(
      int id
      );
}