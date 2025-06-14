import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/model/new_qr_code_model.dart';
import '../repository/new_qr_code_repository.dart';
import '../service/error_handler.dart';


class NewQrCodeProvider with ChangeNotifier{
  final NewQrCodeRepository _newQrCodeRepository;
  NewQrCodeProvider(this._newQrCodeRepository);
  Future<Either<ErrorHandler,NewQrCodeModel>>getQrCode(
      String? paymentSessionId,String? token
      ) async{
    return _newQrCodeRepository.getQrCode(paymentSessionId, token);
  }
}