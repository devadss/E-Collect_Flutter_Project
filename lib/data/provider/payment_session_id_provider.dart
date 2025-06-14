import '../../data/service/error_handler.dart';
import '../../domain/model/paymet_session_id_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../repository/payment_session_id_repository.dart';

class CreatePaymentSessionIdProvider with ChangeNotifier{
  final CreatePaymentSessionIdRepository _createPaymentSessionIdRepository;
  CreatePaymentSessionIdProvider(this._createPaymentSessionIdRepository);
  Future<Either<ErrorHandler,PaymentSessionIdModel>>getPaymentSessionId(String? token, String? amount, String? phoneNumber, String? entityId, String? note) {
    return _createPaymentSessionIdRepository.getPaymentSessionId(token, amount, phoneNumber, entityId, note);
  }
}