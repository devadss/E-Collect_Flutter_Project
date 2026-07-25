import 'package:collection_qr_flutter/domain/model/e_collect/ifsc_model/ifsc_success_model.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_validation_fail.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_validation_success.dart';
import 'basic_registartion/basic_registration_failure_response.dart';
import 'basic_registartion/basic_registration_success_response.dart';
import 'otp_request/otp_request_fail.dart';
import 'otp_request/otp_request_success.dart';
import 'otp_verification/otp_verification_fail.dart';
import 'otp_verification/otp_verification_success.dart';

sealed class AuthenticationModel {
  const AuthenticationModel();
}
///********************OTP_REQUEST******************************
class OtpRequestSuccessModel extends AuthenticationModel{
final OtpRequestSuccessResponse otpRequestSuccessResponse;
const OtpRequestSuccessModel(this.otpRequestSuccessResponse);
}
class OtpRequestFailureModel extends AuthenticationModel{
final OtpRequestErrorResponse otpRequestErrorResponse;
const OtpRequestFailureModel(this.otpRequestErrorResponse);
}

///********************BASIC_REGISTRATION******************************
class BasicRegistrationSuccessModel extends AuthenticationModel{
final BasicRegistrationSuccessResponse basicRegistrationSuccessResponse;
const BasicRegistrationSuccessModel(this.basicRegistrationSuccessResponse);
}

class BasicRegistrationFailureModel extends AuthenticationModel{
final BasicRegistrationErrorResponse basicRegistrationErrorResponse;
const BasicRegistrationFailureModel(this.basicRegistrationErrorResponse);
}

///********************OTP_VERIFICATION******************************
class OtpVerificationSuccessModel extends AuthenticationModel{
  final LoginResponse loginResponse;
  const OtpVerificationSuccessModel(this.loginResponse);
}

class OtpVerificationFailureModel extends AuthenticationModel{
  final OtpVerificationErrorResponse otpVerificationErrorResponse;
  const OtpVerificationFailureModel(this.otpVerificationErrorResponse);
}

///********************TOKEN_VERIFICATION******************************
class TokenVerificationSuccessModel extends AuthenticationModel{
  final TokenValidationSuccessResponse tokenValidationSuccessResponse;
  const TokenVerificationSuccessModel(this.tokenValidationSuccessResponse);
}

class TokenVerificationFailureModel extends AuthenticationModel{
  final TokenValidationFailureResponse tokenValidationFailureResponse;
  const TokenVerificationFailureModel(this.tokenValidationFailureResponse);
}

///********************IfscCode******************************
class IfscCodeOkModel extends AuthenticationModel{
  final BankIfscSuccessModel bankIfscSuccessModel;
  const IfscCodeOkModel(this.bankIfscSuccessModel);
}

class IfscCodeFailModel extends AuthenticationModel{
  final String ifscCodeFail;
  const IfscCodeFailModel(this.ifscCodeFail);
}

