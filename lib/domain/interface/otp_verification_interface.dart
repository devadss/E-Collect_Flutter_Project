import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/domain/model/otp_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/otp_verification_success.dart';

abstract class OtpVerificationInterface{
  Future<Either<OtpFailModel, OtpSuccessModel>>verifyOtp(
      String mobnum , String otp
      );
}