// import 'package:flutter/material.dart';
// import '../../domain/model/fetch_account_balance_model.dart';
// import '../repository/fetch_account_balance_repository.dart';
//
//
// class BalanceProvider extends ChangeNotifier{
//   final FetchAccountBalanceRepository _fetchAccountBalanceRepository;
//   BalanceProvider(this._fetchAccountBalanceRepository);
//   FetchBalanceModel? _fetchBalanceModel;
//   FetchBalanceModel? get fetchBalanceModel => _fetchBalanceModel;
//   Future<void> getFetchBalance(String? entityId ,String? token)async{
//     print("------------------------FETCH ACCOUNT BALANCE MODEL--------------------");
//     print(fetchBalanceModel);
//     final result = await _fetchAccountBalanceRepository.getFetchBalance(entityId, token);
//     result.fold(
//           (failure) {
//         print("failure");
//         print(failure);
//       },
//           (data) {
//         _fetchBalanceModel = data; // Corrected this line
//         print("notifyListeners");
//         print(data);
//         notifyListeners();
//       },
//     );
//   }
// }