import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/qr_transaction_history_model.dart';
import '../repository/qr_transcation_history_repository.dart';

class QRTransactionHistoryProvider with ChangeNotifier {
  final QRTransactionHistoryRepository _qrTransactionHistoryRepository;
  QRTransactionHistoryProvider(this._qrTransactionHistoryRepository);
  String? _errResponse;
  String? get errResponse  => _errResponse;
  QrTranscationHistoryModel? _qrTranscationHistoryModel;
  QrTranscationHistoryModel? get qrTranscationHistoryModel =>
      _qrTranscationHistoryModel;
  Future<void> getQrTranscationHistory(
    String? dateFilterType,
    String? startDate,
    String? endDate,
    String? source,
  ) async {
    printLog(
      "==================================QR TRANSACTION MODEL=================================",
    );
    printLog(qrTranscationHistoryModel);
    final result = await _qrTransactionHistoryRepository
        .getQrTranscationHistory(dateFilterType, startDate, endDate, source);
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
