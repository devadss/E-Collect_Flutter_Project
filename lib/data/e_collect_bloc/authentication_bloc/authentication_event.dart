
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
///********************OTP-VERIFICATION*******************************
class EventMobOtpVerification extends AuthenticationEvent{
  final String mobileNumber;
  final String otp;
  const EventMobOtpVerification(this.mobileNumber, this.otp);
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