import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/paymet_session_id_model.dart';

abstract class ICreatePaymentSessionIdRepository{
  Future<Either<ErrorHandler,PaymentSessionIdModel>>getPaymentSessionId(String? token,String? amount,String? phoneNumber,String? entityId,String? note);
}