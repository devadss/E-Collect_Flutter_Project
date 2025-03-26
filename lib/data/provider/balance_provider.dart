import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection_qr_flutter/data/repository/balance_repository.dart';
import 'package:collection_qr_flutter/domain/model/balance_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/fetch_balance_model.dart';

class BalanceProvider with ChangeNotifier{

final BalanceRepository _balanceRepository;
BalanceProvider(this._balanceRepository);

Future<Either<BalanceFailModel , BalanceModel>>getchBalance(String entityID , String token)async{
  return _balanceRepository.getBalance(entityID, token);

}
}