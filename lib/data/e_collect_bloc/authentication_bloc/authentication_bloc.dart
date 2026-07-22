import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/e_collect/authentication_model.dart';
import '../../../domain/model/e_collect/basic_registartion/request/basic_registration_request_model.dart';
import '../../../domain/model/e_collect/onboard/onboard_request_model.dart';
import '../../repository/e_collect_repository/authentication_repository/authentication_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository authenticationRepository;
  AuthenticationBloc(this.authenticationRepository)
      : super(MobLoginInitialState()) {
    on<MobLoginVerificationEvent>((event, emit) async {
      await authenticationRepository.mobLoginRepository();
    });
    ///*********************REQUEST-OTP******************************
    on<EventMobOtpRequest>((event, emit) async {
      emit(MobLoginRequestOtpLoaderState());
      var data = await authenticationRepository
          .mobOtpRequestRepository(event.mobileNumber);
      if (data is OtpRequestSuccessModel) {
        emit(MobLoginRequestOtpSuccessState(data));
      } else if (data is OtpRequestFailureModel) {
        emit(MobLoginRequestOtpFailureState(data));
      }
    });
    ///*********************RESEND-OTP******************************
    on<EventMobOtpResend>((event, emit) async {
      emit(MobLoginResendOtpLoaderState());
      var data =
          await authenticationRepository.mobOtpResendRepository(event.id);
      if (data is OtpRequestSuccessModel) {
        emit(MobLoginResendOtpSuccessState(data));
      } else if (data is OtpRequestFailureModel) {
        emit(MobLoginResendOtpFailureState(data));
      }
    });
    ///*********************OTP_VERIFICATION******************************
    on<EventMobOtpVerification>((event, emit) async {
      emit(MobLoginVerifyOtpLoaderState());
      var data = await authenticationRepository.mobOtpVerificationRepository(
          event.mobileNumber, event.id, event.otp);
      if (data is OtpVerificationSuccessModel) {
        emit(MobLoginVerifyOtpSuccessState(data));
      } else if (data is OtpVerificationFailureModel) {
        emit(MobLoginVerifyOtpFailureState(data));
      }
    });
    ///*********************MERCHANT-ONBOARDING******************************
    on<OnboardingEvent>((event, emit) async {
      await authenticationRepository.merchantOnboardingRepository();
    });
    ///*********************MERCHANT-ONBOARDING-STATUS******************************
    on<OnboardingStatusEvent>((event, emit) async {
      await authenticationRepository.merchantOnboardingStatusRepository();
    });
    ///*********************BASIC-REGISTRATION******************************
    on<BasicRegistrationEvent>((event, emit) async {
      emit(BasicRegistrationLoaderState());
      var data = await authenticationRepository
          .basicRegistrationRepository(event.basicUserRegisterModel);
      if (data is BasicRegistrationSuccessModel) {
        emit(BasicRegistrationSuccessState(data));
      } else if (data is BasicRegistrationFailureModel) {
        emit(BasicRegistrationFailureState(data));
      }
    });
    //--------------------------------------------------------------
  }
}
