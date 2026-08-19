part of 'authentication_bloc.dart';

abstract class AuthenticationEvent{const AuthenticationEvent();}
///*********************MOB-NUM_VERIFICATION******************************

class MobLoginVerificationEvent extends AuthenticationEvent{
  final String mobileNumber;
  const MobLoginVerificationEvent(this.mobileNumber);
}
///*********************OTP-REQUEST******************************
class EventMobOtpRequest extends AuthenticationEvent{
  final String mobileNumber;
  const EventMobOtpRequest(this.mobileNumber);
}
///*********************OTP-RESEND******************************
class EventMobOtpResend extends AuthenticationEvent{
  final int id;
  const EventMobOtpResend(this.id);
}
///********************OTP-VERIFICATION*******************************
class EventMobOtpVerification extends AuthenticationEvent{
  final String mobileNumber;
  final String otp;
  final int id;
  const EventMobOtpVerification(this.mobileNumber, this.id, this.otp);
}
///**********************ONBOARDING*****************************
class OnboardingEvent extends AuthenticationEvent{
  final MerchantRegistrationRequestModel merchantRegistrationRequestModel;
  const OnboardingEvent(this.merchantRegistrationRequestModel);
}
///**********************ONBOARDING STATUS*****************************
class OnboardingStatusEvent extends AuthenticationEvent{
  final String mobileNumber;
  const OnboardingStatusEvent(this.mobileNumber);
}
///**********************Basic Registration*****************************
class BasicRegistrationEvent extends AuthenticationEvent{
  final BasicUserRegisterModel basicUserRegisterModel;
  const BasicRegistrationEvent(this.basicUserRegisterModel);
}
///**********************TOKEN_VERIFICATION*****************************
class TokenVerificationEvent extends AuthenticationEvent{
  final String token;
  const TokenVerificationEvent(this.token);
}
///**********************TOKEN_REGENERATION*****************************
class TokenRegenerationEvent extends AuthenticationEvent{
  final String token;
  final String refreshToken;
  const TokenRegenerationEvent(this.token, this.refreshToken);
}
///**********************IFSC*****************************
class IfscBranchEvent extends AuthenticationEvent{
  final String ifscCode;
  const IfscBranchEvent(this.ifscCode);
}

///**********************FCM_UNREGISTER*****************************
class FcmUnregisterEvent extends AuthenticationEvent{
  final String customerId;
  final String mobileNumber;
  final String deviceType;
  final String appVersion;
  final String deviceToken;
  const FcmUnregisterEvent(this.customerId, this.mobileNumber, this.deviceToken, this.appVersion, this.deviceType);
}