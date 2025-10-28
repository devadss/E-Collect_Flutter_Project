import '../../data/service/error_handler.dart';
import '../../domain/model/payment_link_model.dart';
import 'package:dartz/dartz.dart';

abstract class IPaymentLinkRepository {
  Future<Either<ErrorHandler, PaymentLinkModel>> getPaymentLink(
      {required String agentName,
     required String agentId,
     required String agentOriginId,
     required String agentPhone,
     required String agentEmail,
     required String customerName,
     required String customerPhone,
     required String customerAccountNumber,
     required String customerEmail,
     required String customerId,
     required num linkAmount,
     required String note,
      required String corpCode,
     required String cardRefNum,
        required String token,
        required String subAgentId
      });
}
