import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/balance_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/fetch_balance_model.dart';

abstract class BalanceInterface{
  Future<Either<BalanceFailModel, BalanceModel>>getBalance(String entityID, String token);
}