import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:merchant_app_flutter/data/repository/otp_verification_repository.dart';
import 'package:merchant_app_flutter/domain/model/otp_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/otp_verification_success.dart';

class OtpVerificationProvider with ChangeNotifier{
  final OtpVerificationRepository _otpVerificationRepository;
  OtpVerificationProvider(this._otpVerificationRepository);

  Future<Either<OtpFailModel , OtpSuccessModel>>verifyOtp(
      String mobnum, String otp)async{
    return _otpVerificationRepository.verifyOtp(mobnum, otp);
  }


}