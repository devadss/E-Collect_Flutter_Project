import 'package:dartz/dartz.dart';
import '../../data/service/error_handler.dart';
import '../model/cash_deposit_model.dart';

abstract class CashDepositInterface {
  Future<Either<ErrorHandler, CashDepositModel>> depositCash(
      String accountNumber, String agentId, String amount);
}
