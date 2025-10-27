import 'package:collection_qr_flutter/data/repository/cash_qr_repo.dart';
import 'package:collection_qr_flutter/domain/model/qr_cash_combined_response.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class CashQrProvider with ChangeNotifier {
  final CashQrRepository _cashQrRepository;

  CashQrProvider(this._cashQrRepository);

  CashQrCombinedResponse? _cashQrCombinedResponse;

  CashQrCombinedResponse? get cashQrCombinedResponse => _cashQrCombinedResponse;


  String? _errResponse;
  String? get errResponse => _errResponse;

  Future<Either<String, CashQrCombinedResponse>> getCombinedResponse(
      String filterType,
      String startDate,
      String endDate,
      String subAgentId,
      String corpCode,
      String agentOrginId) async {
    final data = await _cashQrRepository.getCombinedResponse(
        filterType, startDate, endDate, subAgentId, corpCode, agentOrginId);
    data.fold((err) {
      _errResponse = err;
      _cashQrCombinedResponse = null;
    }, (success) {
      _errResponse = null;
      _cashQrCombinedResponse = success;
    });
    notifyListeners();
    return data;
  }
}
