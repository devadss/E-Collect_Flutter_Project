import '../../data/service/error_handler.dart';
import '../../domain/model/paymet_session_id_model.dart';
import 'package:dartz/dartz.dart';

abstract class ICreatePaymentSessionIdRepository {
  Future<Either<ErrorHandler, PaymentSessionIdModel>> getPaymentSessionId(
      {
        required String? token,
        required String? agentName,
        required String? agentId,
        required String? agentOriginId,
        required String? agentPhone,
        required String? agentEmail,
        required String? subAgentId,
        required String? customerName,
        required String? customerPhone,
        required String? customerAccno,
        required String? customerId,
        required String? customerEmail,
        required String? amount,
        required String? note,
        required String? corpCode,
        required String? cardRefNum});
}
