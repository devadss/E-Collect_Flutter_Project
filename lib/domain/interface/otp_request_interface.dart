import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/otp_request_model.dart';

abstract class OtpRequestInterface{
  Future<Either<String, OtpRequestResponse>>requestOtp(String mobnum);

}