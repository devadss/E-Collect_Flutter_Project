import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/model/payment_link_model.dart';
import '../repository/payment_link_repository.dart';
import '../service/error_handler.dart';

class PaymentLinkProvider with ChangeNotifier {
  final PaymentLinkRepository _paymentLinkRepository;
  PaymentLinkProvider(this._paymentLinkRepository);
  Future<Either<ErrorHandler, PaymentLinkModel>> getPaymentLink(
      String agentName,
      String agentId,
      String agentOriginId,
      String agentPhone,
      String agentEmail,
      String customerName,
      String customerPhone,
      String customerAccountNumber,
      String customerEmail,
      String customerId,
      num linkAmount,
      String note,
      String corpCode,
      String cardRefNum,
      String token) async {
    return _paymentLinkRepository.getPaymentLink(
        agentName,
        agentId,
        agentOriginId,
        agentPhone,
        agentEmail,
        customerName,
        customerPhone,
        customerAccountNumber,
        customerEmail,
        customerId,
        linkAmount,
        note,
        corpCode,
        cardRefNum, token);
  }
}
