import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/cash_deposit_model.dart';
import 'package:dartz/dartz.dart';

abstract class CashDepositInterface {
  Future<Either<ErrorHandler, CashDepositModel>> depositCash(
      String accountNumber, String agentId, String amount);
}
