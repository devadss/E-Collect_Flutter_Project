import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/new_qr_code_model.dart';

abstract class INewQrCodeRepository{
  Future<Either<ErrorHandler,NewQrCodeModel>>getQrCode(String? paymentSessionId,String? token);
}