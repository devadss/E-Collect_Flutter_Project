import 'package:e_Collect/data/service/error_handler.dart';
import 'package:e_Collect/domain/model/group/default_model/default_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUpdateBankAccountDetailsRepository {
  Future<Either<ErrorHandler, DefaultModel>> updateBankAccountDetails(
      int? accountId,
      String? userId,
      String? accountHolderName,
      String? accountNumber,
      String? ifsc,
      String? corpCode,
      String? branchCode,
      String? entityId);
}
