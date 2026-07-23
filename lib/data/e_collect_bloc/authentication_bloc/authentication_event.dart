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
  const EventMobOtpVerification(this.mobileNumber, this.id, this.otp,  );
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