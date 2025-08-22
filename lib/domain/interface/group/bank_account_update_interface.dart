import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:fpdart/fpdart.dart';

import '../../model/group/bank_account/bank_update_model.dart';

abstract class BankAccountUpdateInterface{
  Future<Either<ErrorHandler, BankAccountUpdateResponse>> getBankAccountDetails(int id);
}

// abstract class BankAccountUpdateInterface{
//   Future<Either<String, BankAccountUpdateResponse>> getBankAccountDetails(
//       int id
//       );
// }