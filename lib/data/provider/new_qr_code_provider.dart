// import '../../data/repository/new_qr_code_repository.dart';
// import '../../data/service/error_handler.dart';
// import '../../domain/model/new_qr_code_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
//
//
// class NewQrCodeProvider with ChangeNotifier{
//   final NewQrCodeRepository _newQrCodeRepository;
//   NewQrCodeProvider(this._newQrCodeRepository);
//   Future<Either<ErrorHandler,NewQrCodeModel>>getQrCode(
//       String? paymentSessionId,String? token
//       ) async{
//     return _newQrCodeRepository.getQrCode(paymentSessionId, token);
//   }
// }