import 'package:dartz/dartz.dart';

import '../../model/group/bank_account/bank_update_model.dart';

abstract class BankAccountUpdateInterface{
  Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(
      int id
      );
}