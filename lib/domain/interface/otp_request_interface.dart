import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/domain/model/otp_request_model.dart';

abstract class OtpRequestInterface{
  Future<Either<String, OtpRequestResponse>>requestOtp(String mobnum);

}