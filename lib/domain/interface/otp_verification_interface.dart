import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/otp_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/otp_verification_success.dart';

abstract class OtpVerificationInterface{
  Future<Either<OtpFailModel, OtpSuccessModel>>verifyOtp(
      String mobnum , String otp
      );
}