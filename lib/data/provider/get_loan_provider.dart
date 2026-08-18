// import 'package:flutter/material.dart';
// import '../../core/utils.dart';
// import '../../domain/model/loan_model.dart';
// import '../repository/get_loan_repository.dart';
//
// class GetLoanProvider with ChangeNotifier {
//   final GetLoanRepository _getLoanRepository;
//   GetLoanProvider(this._getLoanRepository);
//   CollectionLoanModel? _collectionLoanModel;
//   CollectionLoanModel? get collectionLoanModel => _collectionLoanModel;
//   Future<void> getLoans(
//       LoanRequestModel loanRequestModel
//       ) async {
//     final result = await _getLoanRepository.getLoans(loanRequestModel);
//     result.fold((error) {
//       print("---------------------------ERROR------------------");
//       print(error);
//     }, (data) {
//       _collectionLoanModel = data;
//       if(printStatementStatus){
//         print("---------------------DATA---------------");
//         print(data);
//       }
//
//       notifyListeners();
//     });
//   }
// }
