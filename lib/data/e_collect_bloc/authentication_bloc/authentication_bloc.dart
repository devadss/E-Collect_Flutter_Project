import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/e_collect/authentication_model.dart';
import '../../../domain/model/e_collect/basic_registartion/request/basic_registration_request_model.dart';
import '../../../domain/model/e_collect/merchant_registation_model/request/merchant_request_model.dart';
import '../../repository/e_collect_repository/authentication_repository/authentication_repository.dart';
import '../../storage/shared_pref_helper.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository authenticationRepository;
  AuthenticationBloc(this.authenticationRepository) : super(MobLoginInitialState()) {
    ///********************LOGIN******************************
    on<MobLoginVerificationEvent>((event, emit) async {
      await authenticationRepository.mobLoginRepository();
    });
    ///*********************REQUEST-OTP******************************
    on<EventMobOtpRequest>((event, emit) async {
      emit(MobLoginRequestOtpLoaderState());
      final AuthenticationModel data = await authenticationRepository
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
      final AuthenticationModel data =
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
      final AuthenticationModel data = await authenticationRepository.mobOtpVerificationRepository(
          event.mobileNumber, event.id, event.otp);
      if (data is OtpVerificationSuccessModel) {
        List<String> typeList = [];
        List<String> eCollectUrlList = [];

        emit(MobLoginVerifyOtpSuccessState(data));
        SharedPref.shared.setECollectLoginStatus(data.loginResponse.isAuthenticated);
        SharedPref.shared.setECollectMerchantBranchCode(data.loginResponse.branchCode);
        SharedPref.shared.setECollectBranchID(data.loginResponse.branchId.toString());
        SharedPref.shared.setECollectAgentID(data.loginResponse.agentId.toString());
        SharedPref.shared.setECollectMerchantIntegrationStatus(data.loginResponse.integrationStatus);
       for(var x in data.loginResponse.listUrl.keys){
          typeList.add(x);
       }
        for(var x in data.loginResponse.listUrl.values){
          for(var c in x){
            eCollectUrlList.add(c);
          }

        }
        SharedPref.shared.setECollectTypeList(typeList);
        SharedPref.shared.setECollectUrlList(eCollectUrlList);
        SharedPref.shared.setECollectMerchantUserName(data.loginResponse.fullName);
        SharedPref.shared.setECollectUserType(data.loginResponse.productType);
        SharedPref.shared.setECollectToken(data.loginResponse.token);
        SharedPref.shared.setECollectRefreshToken(data.loginResponse.refreshToken);
        SharedPref.shared.setECollectUserEmail(data.loginResponse.email);
        SharedPref.shared.setECollectUserNumber(data.loginResponse.phone);
        SharedPref.shared.setECollectMerchantID(data.loginResponse.merchantId.toString());
        SharedPref.shared.setECollectUserID(data.loginResponse.userId.toString());


      } else if (data is OtpVerificationFailureModel) {
        emit(MobLoginVerifyOtpFailureState(data));
      }
    });
    ///*********************MERCHANT-ONBOARDING******************************
    on<OnboardingEvent>((event, emit) async {
      emit(OnboardingStatusLoaderState());
      final AuthenticationModel data = await authenticationRepository.merchantOnboardingRepository(event.merchantRegistrationRequestModel);
      if(data is OnboardOkModel){
        emit(OnboardingStatusSuccessState(data));
      }else if(data is OnboardFailModel){
        emit(OnboardingStatusFailureState(data));
      }
    });
    ///*********************MERCHANT-ONBOARDING-STATUS******************************
    on<OnboardingStatusEvent>((event, emit) async {
      await authenticationRepository.merchantOnboardingStatusRepository();
    });
    ///*********************BASIC-REGISTRATION******************************
    on<BasicRegistrationEvent>((event, emit) async {
      emit(BasicRegistrationLoaderState());
      final AuthenticationModel data = await authenticationRepository.basicRegistrationRepository(event.basicUserRegisterModel);
      if (data is BasicRegistrationSuccessModel) {
        emit(BasicRegistrationSuccessState(data));
      } else if (data is BasicRegistrationFailureModel) {
        emit(BasicRegistrationFailureState(data));
      }
    });
    ///*********************TOKEN_VERIFICATION******************************
    on<TokenVerificationEvent>((event, emit) async {
      var data = await authenticationRepository.tokenVerificationRepository(event.token);
      if(data is TokenVerificationSuccessModel){
        emit(TokenVerificationSuccessState(data));
      }else if(data is TokenVerificationFailureModel){
        emit(TokenVerificationFailureState(data));
      }
    });


    ///*********************IFSC******************************
    on<IfscBranchEvent>((event, emit) async {
      emit(IfscBranchLoaderState());
      final AuthenticationModel data = await authenticationRepository.ifscBranchRepository(event.ifscCode);
      if(data is IfscCodeOkModel){
        emit(IfscBranchSuccessState(data));
      }else if(data is IfscCodeFailModel){
        emit(IfscBranchFailureState(data));
      }
    });

    ///*********************FCM_UNREGISTER******************************
    on<FcmUnregisterEvent>((event, emit) async {
      emit(FcmUnRegisterLoaderState());
      final AuthenticationModel data = await authenticationRepository.fcmUnregisterRepository(
        event.customerId, event.mobileNumber, event.deviceToken
      );
      if(data is FcmUnregisterSuccess){
        emit(FcmUnRegisterSuccessState(data));
      }else if(data is FcmUnregisterFail){
        emit(FcmUnRegisterFailureState(data));
      }
    });
  }
}
