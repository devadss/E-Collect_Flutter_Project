// import 'package:collection_qr_flutter/core/utils.dart';
// import 'package:collection_qr_flutter/data/repository/transfer_history_repository.dart';
// import 'package:collection_qr_flutter/domain/model/transfer_history_model.dart';
// import 'package:flutter/material.dart';
// import '../../core/general.dart';
//
// class TransferHistoryProvider with ChangeNotifier {
//   final TransferHistoryRepository _qrTransactionHistoryRepository;
//   TransferHistoryProvider(this._qrTransactionHistoryRepository);
//   String? _errResponse;
//   String? get errResponse  => _errResponse;
//   TransferHistoryModel? _qrTranscationHistoryModel;
//   TransferHistoryModel? get qrTranscationHistoryModel =>
//       _qrTranscationHistoryModel;
//
//   bool? _showProgressDialog;
//   bool? get showProgressDialog  => _showProgressDialog;
//   Future<void> getQrTranscationHistory(
//       String? dateFilterType,
//       String? startDate,
//       String? endDate,
//       String? source,
//       String? corpCode,
//       String? agentOriginId,
//       ) async {
//     if(printStatementStatus){
//       printLog(
//         "==================================QR TRANSACTION MODEL=================================",
//       );
//     }
//
//     _showProgressDialog = true; // ✅ Add this line!
//     notifyListeners();
//     if(printStatementStatus){
//       printLog(qrTranscationHistoryModel);
//     }
//
//     final result = await _qrTransactionHistoryRepository
//         .getTransferTranscationHistory(dateFilterType, startDate, endDate, source,corpCode,agentOriginId);
//
//     result.fold(
//           (error) {
//         _errResponse = error.message;
//         _qrTranscationHistoryModel = null;
//         if(printStatementStatus){
//           printLog("-------------Error QR Transcation-------------");
//           printLog(error);
//         }
//
//         _showProgressDialog = false;
//         notifyListeners();
//       },
//           (data) {
//         _qrTranscationHistoryModel = data;
//         _errResponse = null;
//         _showProgressDialog = false;
//         if(printStatementStatus){
//           printLog("-------------------DATA QR TRANS-----------------");
//           printLog(data);
//         }
//
//         notifyListeners();
//       },
//
//     );
//     notifyListeners();
//   }
// }
