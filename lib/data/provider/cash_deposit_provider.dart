// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
// import '../../domain/model/cash_deposit_model.dart';
// import '../repository/cash_deposit_repository.dart';
// import '../service/error_handler.dart';
//
// class CashDepositProvider with ChangeNotifier {
//
//   final CashDepositRepository _cashDepositRepository;
//
//   CashDepositProvider(this._cashDepositRepository);
//
//   CashDepositModel? cashDepositModel;
//
//   CashDepositModel? get cashDeposit => cashDepositModel;
//
//   Future<Either<ErrorHandler, CashDepositModel>> depositCash(
//       String accountNumber, String agentId, String amount) async {
//     final response = await _cashDepositRepository.depositCash(
//         accountNumber, agentId, amount);
//     response.fold((error) {}, (data) {
//       cashDepositModel = data;
//       notifyListeners();
//     });
//     return response;
//   }
// }
