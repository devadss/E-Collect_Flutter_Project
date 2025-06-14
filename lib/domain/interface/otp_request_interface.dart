import 'package:dartz/dartz.dart';

import '../model/otp_request_model.dart';

abstract class OtpRequestInterface{
  Future<Either<String, OtpRequestResponse>>requestOtp(String mobnum);

}