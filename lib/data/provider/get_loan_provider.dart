import 'package:flutter/material.dart';
import '../../domain/model/loan_model.dart';
import '../repository/get_loan_repository.dart';

class GetLoanProvider with ChangeNotifier {
  final GetLoanRepository _getLoanRepository;
  GetLoanProvider(this._getLoanRepository);
  CollectionLoanModel? _collectionLoanModel;
  CollectionLoanModel? get collectionLoanModel => _collectionLoanModel;
  Future<void> getLoans(String? customerName, String? accountNo, String? status,
      String? scheme, String? agent, int? page, int? pageSize) async {
    final result = await _getLoanRepository.getLoans(
        customerName, accountNo, status, scheme, agent, page, pageSize);
    result.fold((error) {
      print("---------------------------ERROR------------------");
      print(error);
    }, (data) {
      _collectionLoanModel = data;
      print("---------------------DATA---------------");
      print(data);
      notifyListeners();
    });
  }
}
