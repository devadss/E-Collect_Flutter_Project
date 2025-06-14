import '../../data/service/error_handler.dart';
import '../../domain/model/new_qr_code_model.dart';
import 'package:dartz/dartz.dart';

abstract class INewQrCodeRepository{
  Future<Either<ErrorHandler,NewQrCodeModel>>getQrCode(String? paymentSessionId,String? token);
}