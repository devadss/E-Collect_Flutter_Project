part of 'authentication_bloc.dart';

abstract class AuthenticationState {const AuthenticationState();}

///*********************MOB-NUM_VERIFICATION******************************
class MobLoginInitialState extends AuthenticationState {
  const MobLoginInitialState();
}

class MobLoginLoaderState extends AuthenticationState {
  const MobLoginLoaderState();
}

class MobLoginSuccessState extends AuthenticationState {
  const MobLoginSuccessState();
}

class MobLoginFailureState extends AuthenticationState {
  const MobLoginFailureState();
}

///*********************OTP-REQUEST******************************
class MobLoginRequestOtpInitialState extends AuthenticationState {
  const MobLoginRequestOtpInitialState();
}

class MobLoginRequestOtpLoaderState extends AuthenticationState {
  const MobLoginRequestOtpLoaderState();
}

class MobLoginRequestOtpSuccessState extends AuthenticationState {
  final OtpRequestSuccessModel otpRequestSuccessModel;
  const MobLoginRequestOtpSuccessState(this.otpRequestSuccessModel);
}

class MobLoginRequestOtpFailureState extends AuthenticationState {
  final OtpRequestFailureModel otpRequestFailureModel;
  const MobLoginRequestOtpFailureState(this.otpRequestFailureModel);
}

///*********************RESEND-OTP******************************
class MobLoginResendOtpLoaderState extends AuthenticationState {
  const MobLoginResendOtpLoaderState();
}

class MobLoginResendOtpSuccessState extends AuthenticationState {
  final OtpRequestSuccessModel otpRequestSuccessModel;
  const MobLoginResendOtpSuccessState(this.otpRequestSuccessModel);
}

class MobLoginResendOtpFailureState extends AuthenticationState {
  final OtpRequestFailureModel otpRequestFailureModel;
  const MobLoginResendOtpFailureState(this.otpRequestFailureModel);
}

///********************OTP-VERIFICATION*******************************
class MobLoginVerifyOtpInitialState extends AuthenticationState {
  const MobLoginVerifyOtpInitialState();
}

class MobLoginVerifyOtpLoaderState extends AuthenticationState {
  const MobLoginVerifyOtpLoaderState();
}

class MobLoginVerifyOtpSuccessState extends AuthenticationState {
  final OtpVerificationSuccessModel otpVerificationSuccessModel;
  const MobLoginVerifyOtpSuccessState(this.otpVerificationSuccessModel);
}

class MobLoginVerifyOtpFailureState extends AuthenticationState {
  final OtpVerificationFailureModel otpVerificationFailureModel;
  const MobLoginVerifyOtpFailureState(this.otpVerificationFailureModel);
}

///**********************ONBOARDING*****************************
class OnboardingInitialState extends AuthenticationState {
  const OnboardingInitialState();
}

class OnboardingLoaderState extends AuthenticationState {
  const OnboardingLoaderState();
}

class OnboardingSuccessState extends AuthenticationState {
  const OnboardingSuccessState();
}

class OnboardingFailureState extends AuthenticationState {
  const OnboardingFailureState();
}

///**********************ONBOARDING-STATUS*****************************
class OnboardingStatusInitialState extends AuthenticationState {
  const OnboardingStatusInitialState();
}

class OnboardingStatusLoaderState extends AuthenticationState {
  const OnboardingStatusLoaderState();
}

class OnboardingStatusSuccessState extends AuthenticationState {
  final OnboardOkModel iOnboardOkModel;
  const OnboardingStatusSuccessState(this.iOnboardOkModel);
}

class OnboardingStatusFailureState extends AuthenticationState {
  final OnboardFailModel onboardFailModel;
  const OnboardingStatusFailureState(this.onboardFailModel);
}

///*********************BASIC-REGISTRATION******************************
class BasicRegistrationInitialState extends AuthenticationState {
  const BasicRegistrationInitialState();
}

class BasicRegistrationLoaderState extends AuthenticationState {
  const BasicRegistrationLoaderState();
}

class BasicRegistrationSuccessState extends AuthenticationState {
  final BasicRegistrationSuccessModel basicRegistrationSuccessModel;
  const BasicRegistrationSuccessState(this.basicRegistrationSuccessModel);
}

class BasicRegistrationFailureState extends AuthenticationState {
  final BasicRegistrationFailureModel basicRegistrationFailureModel;
  const BasicRegistrationFailureState(this.basicRegistrationFailureModel);
}

///*********************TOKEN_VERIFICATION******************************
class TokenVerificationLoaderState extends AuthenticationState {
  const TokenVerificationLoaderState();
}

class TokenVerificationSuccessState extends AuthenticationState {
  final TokenVerificationSuccessModel tokenVerificationSuccessModel;
  const TokenVerificationSuccessState(this.tokenVerificationSuccessModel);
}

class TokenVerificationFailureState extends AuthenticationState {
  final TokenVerificationFailureModel tokenVerificationFailureModel;
  const TokenVerificationFailureState(this.tokenVerificationFailureModel);
}

///*********************IFSC******************************
class IfscBranchLoaderState extends AuthenticationState {
  const IfscBranchLoaderState();
}

class IfscBranchSuccessState extends AuthenticationState {
  final IfscCodeOkModel ifscCodeOkModel;
  const IfscBranchSuccessState(this.ifscCodeOkModel);
}

class IfscBranchFailureState extends AuthenticationState {
  final IfscCodeFailModel ifscCodeFailModel;
  const IfscBranchFailureState(this.ifscCodeFailModel);
}

