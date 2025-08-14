import 'package:dartz/dartz.dart';
import '../model/aadhaar_otp_request_fail_model.dart';
import '../model/verify_aadhaar_model.dart';

abstract class VerifyAadhaarDetailInterface{
  Future<Either<AadhaarOtpRequestFailModel, VerifyAadhaarDetailsModel>>getAadhaarDetails(String
      otp, String refId, String vendorCode, String custId);
}