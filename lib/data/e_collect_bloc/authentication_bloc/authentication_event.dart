
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
  final OnboardRequestModel onboardRequestModel;
  const OnboardingEvent(this.onboardRequestModel);
}

///**********************ONBOARDING STATUS*****************************
class OnboardingStatusEvent extends AuthenticationEvent{
  final String mobileNumber;
  const OnboardingStatusEvent(this.mobileNumber);
}

class BasicRegistrationEvent extends AuthenticationEvent{
  final BasicUserRegisterModel basicUserRegisterModel;
  const BasicRegistrationEvent(this.basicUserRegisterModel);
}