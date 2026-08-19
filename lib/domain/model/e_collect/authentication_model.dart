import 'package:collection_qr_flutter/domain/model/e_collect/ifsc_model/ifsc_success_model.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_regeneratiion/ecollect_token_gen_fail.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_regeneratiion/ecollect_token_gen_success.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_validation_fail.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/token_validation/token_validation_success.dart';
import 'basic_registartion/basic_registration_failure_response.dart';
import 'basic_registartion/basic_registration_success_response.dart';
import 'fcm/unregister_fail.dart';
import 'fcm/unregister_success.dart';
import 'merchant_registation_model/merchant_registration_success.dart';
import 'merchant_registation_model/merchat_registration_fail.dart';
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

///********************TOKEN_REGENERATION******************************
class TokenRegenerationSuccessModel extends AuthenticationModel{
  final ECollectTokenGenSuccess eCollectTokenGenSuccess;
  const TokenRegenerationSuccessModel(this.eCollectTokenGenSuccess);
}

class TokenRegenerationFailureModel extends AuthenticationModel{
  final RefreshTokenError refreshTokenError;
  const TokenRegenerationFailureModel(this.refreshTokenError);
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
///********************ONBAORDING******************************
class OnboardOkModel extends AuthenticationModel{
  final MerchantRegistrationSuccess merchantRegistrationSuccess;
  const OnboardOkModel(this.merchantRegistrationSuccess);
}

class OnboardFailModel extends AuthenticationModel{
  final MerchantRegistrationFailResponse merchantRegistrationFailResponse;
  const OnboardFailModel(this.merchantRegistrationFailResponse);
}

///********************FCM UNREGISTER******************************
class FcmUnregisterSuccess extends AuthenticationModel{
  final UnregisterDeviceSuccessResponse unregisterDeviceSuccessResponse;
  FcmUnregisterSuccess(this.unregisterDeviceSuccessResponse);
}

class FcmUnregisterFail  extends AuthenticationModel{
  final DeviceUnregisterFailResponse deviceUnregisterFailResponse;
  FcmUnregisterFail(this.deviceUnregisterFailResponse);
}

