import 'package:collection_qr_flutter/data/repository/qr_generation_repository_new.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/qr_response_data.dart';

class QrGenerationProviderNew with ChangeNotifier {
  final QrGenerationRepositoryNew _generationRepositoryNew;

  QrGenerationProviderNew(this._generationRepositoryNew);

  QrResponseData? _qrResponseData;

  QrResponseData? get qrResponseData => _qrResponseData;

  Future<Either<String, QrResponseData>> generateQrCode(
      String paymentSessionId) async {
    final data =
        await _generationRepositoryNew.generateQrCode(paymentSessionId);
    data.fold((err) {}, (success) {
      _qrResponseData = success;
    });
    notifyListeners();
    return data;
  }
}
