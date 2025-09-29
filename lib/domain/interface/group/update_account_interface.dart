import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/group/default_model/default_model.dart';
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
