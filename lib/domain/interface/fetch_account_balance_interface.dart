import 'package:dartz/dartz.dart';
import '../../data/service/error_handler.dart';
import '../model/fetch_account_balance_model.dart';


abstract class IFetchAccountBalanceRepository{
  Future<Either<ErrorHandler,FetchBalanceModel>>getFetchBalance(String? entityId,String? token);
}