import 'package:dartz/dartz.dart';
import '../model/aadhaar_detail_otp_response.dart';
import '../model/aadhaar_otp_request_fail_model.dart';

abstract class AadhaarOtpRequestInterface {
  Future<Either<AadhaarOtpRequestFailModel, AadhaarDetailOtpRequestModel>> verifyAadhaarNumber(String? aadhaarNumber);
}
