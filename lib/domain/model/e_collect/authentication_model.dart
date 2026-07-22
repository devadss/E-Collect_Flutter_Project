import 'basic_registartion/basic_registration_failure_response.dart';
import 'basic_registartion/basic_registration_success_response.dart';
import 'otp_request/otp_request_fail.dart';
import 'otp_request/otp_request_success.dart';
import 'otp_verification/otp_verification_fail.dart';
import 'otp_verification/otp_verification_success.dart';

sealed class AuthenticationModel {const AuthenticationModel();}

class OtpRequestSuccessModel extends AuthenticationModel{
final OtpRequestSuccessResponse otpRequestSuccessResponse;
const OtpRequestSuccessModel(this.otpRequestSuccessResponse);
}

class OtpRequestFailureModel extends AuthenticationModel{
final OtpRequestErrorResponse otpRequestErrorResponse;
const OtpRequestFailureModel(this.otpRequestErrorResponse);
}


class BasicRegistrationSuccessModel extends AuthenticationModel{
final BasicRegistrationSuccessResponse basicRegistrationSuccessResponse;
const BasicRegistrationSuccessModel(this.basicRegistrationSuccessResponse);
}

class BasicRegistrationFailureModel extends AuthenticationModel{
final BasicRegistrationErrorResponse basicRegistrationErrorResponse;
const BasicRegistrationFailureModel(this.basicRegistrationErrorResponse);
}

class OtpVerificationSuccessModel extends AuthenticationModel{
  final LoginResponse loginResponse;
  const OtpVerificationSuccessModel(this.loginResponse);
}

class OtpVerificationFailureModel extends AuthenticationModel{
  final OtpVerificationErrorResponse otpVerificationErrorResponse;
  const OtpVerificationFailureModel(this.otpVerificationErrorResponse);
}


