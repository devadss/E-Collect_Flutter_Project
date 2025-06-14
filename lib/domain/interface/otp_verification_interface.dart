import 'package:dartz/dartz.dart';

import '../model/otp_fail_model.dart';
import '../model/otp_verification_success.dart';


abstract class OtpVerificationInterface{
  Future<Either<OtpFailModel, OtpSuccessModel>>verifyOtp(
      String mobnum , String otp
      );
}