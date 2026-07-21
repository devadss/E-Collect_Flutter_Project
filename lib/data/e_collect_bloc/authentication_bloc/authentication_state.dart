part of 'authentication_bloc.dart';

abstract class  AuthenticationState {
  const AuthenticationState();
  String printData(String data){
    return "LALAL$data";
  }
}

///*********************MOB-NUM_VERIFICATION******************************

class MobLoginInitialState extends AuthenticationState{
  const MobLoginInitialState();
}
class MobLoginLoaderState extends AuthenticationState{
  const MobLoginLoaderState();
}
class MobLoginSuccessState extends AuthenticationState{
  const MobLoginSuccessState();
}
class MobLoginFailureState extends AuthenticationState{
  const MobLoginFailureState();
}
///*********************OTP-REQUEST******************************
class MobLoginRequestOtpInitialState extends AuthenticationState{
  const MobLoginRequestOtpInitialState();
}
class MobLoginRequestOtpLoaderState extends AuthenticationState{
  const MobLoginRequestOtpLoaderState();
}
class MobLoginRequestOtpSuccessState extends AuthenticationState{
  const MobLoginRequestOtpSuccessState();
}
class MobLoginRequestOtpFailureState extends AuthenticationState{
  const MobLoginRequestOtpFailureState();
}
///********************OTP-VERIFICATION*******************************
class MobLoginVerifyOtpInitialState extends AuthenticationState{
  const MobLoginVerifyOtpInitialState();
}
class MobLoginVerifyOtpLoaderState extends AuthenticationState{
  const MobLoginVerifyOtpLoaderState();
}
class MobLoginVerifyOtpSuccessState extends AuthenticationState{
  const MobLoginVerifyOtpSuccessState();
}
class MobLoginVerifyOtpFailureState extends AuthenticationState{
  const MobLoginVerifyOtpFailureState();
}

///**********************ONBOARDING*****************************
class OnboardingInitialState extends AuthenticationState{
  const OnboardingInitialState();
}
class OnboardingLoaderState extends AuthenticationState{
  const OnboardingLoaderState();
}
class OnboardingSuccessState extends AuthenticationState{
  const OnboardingSuccessState();
}
class OnboardingFailureState extends AuthenticationState{
  const OnboardingFailureState();
}
///**********************ONBOARDING-STATUS*****************************
class OnboardingStatusInitialState extends AuthenticationState{
  const OnboardingStatusInitialState();
}
class OnboardingStatusLoaderState extends AuthenticationState{
  const OnboardingStatusLoaderState();
}
class OnboardingStatusSuccessState extends AuthenticationState{
  const OnboardingStatusSuccessState();
}
class OnboardingStatusFailureState extends AuthenticationState{
  const OnboardingStatusFailureState();
}

