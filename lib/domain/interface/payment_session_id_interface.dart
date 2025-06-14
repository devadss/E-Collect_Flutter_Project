import '../../data/service/error_handler.dart';
import '../../domain/model/paymet_session_id_model.dart';
import 'package:dartz/dartz.dart';

abstract class ICreatePaymentSessionIdRepository{
  Future<Either<ErrorHandler,PaymentSessionIdModel>>getPaymentSessionId(String? token,String? amount,String? phoneNumber,String? entityId,String? note);
}