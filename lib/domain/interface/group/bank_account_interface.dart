import 'package:collection_qr_flutter/domain/model/group/bank_detail_model.dart';
import 'package:dartz/dartz.dart';

abstract class BankAccountInterface {
  Future<Either<String, BankDetailSubmitApiResponse>> submitBankDetails(
      String userID,
    String accountHolderName,
    String accountNumber,
    String ifsc,
    String corpCode,
    String branchCode,
    String entityId,
  );
}
