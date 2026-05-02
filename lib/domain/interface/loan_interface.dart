import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../../core/utils.dart';
import '../model/loan_model.dart';

abstract class IGetLoanRepository {
  Future<Either<ErrorHandler, CollectionLoanModel>> getLoans(
      LoanRequestModel loanRequestModel
      );
}
