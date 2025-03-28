
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/payment_link_model.dart';

abstract class IPaymentLinkRepository {
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
      String cardRefNum);
}
