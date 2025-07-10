import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/qr_transaction_history_model.dart';
import '../repository/cash_transcation_history_repository.dart';

class CashTransactionHistoryProvider with ChangeNotifier {
  final CashTransactionHistoryRepository _qrTransactionHistoryRepository;
  CashTransactionHistoryProvider(this._qrTransactionHistoryRepository);
  String? _errResponse;
  String? get errResponse  => _errResponse;
  QrTranscationHistoryModel? _qrTranscationHistoryModel;
  QrTranscationHistoryModel? get qrTranscationHistoryModel =>
      _qrTranscationHistoryModel;
  Future<void> getCashTranscationHistory(
    String? dateFilterType,
    String? startDate,
    String? endDate,
    String? source,
    String? subAgentId,
    String? corpCode,
  ) async {
    printLog(
      "==================================QR TRANSACTION MODEL=================================",
    );
    printLog(qrTranscationHistoryModel);
    final result = await _qrTransactionHistoryRepository
        .getCashTranscationHistory(dateFilterType, startDate, endDate, source,subAgentId,corpCode);
    result.fold(
      (error) {
        _errResponse = error.message;
        _qrTranscationHistoryModel = null;
        printLog("-------------Error QR Transcation-------------");
        printLog(error);
      },
      (data) {
        _qrTranscationHistoryModel = data;
        _errResponse = null;
        printLog("-------------------DATA QR TRANS-----------------");
        printLog(data);
        notifyListeners();
      },
    );
  }
}
