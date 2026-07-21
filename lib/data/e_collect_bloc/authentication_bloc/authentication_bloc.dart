import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/e_collect/onboard/onboard_request_model.dart';
import '../../repository/e_collect_repository/authentication_repository/authentication_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class MobLoginBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository authenticationRepository;
  MobLoginBloc(this.authenticationRepository) : super(MobLoginInitialState()) {
    on<MobLoginVerificationEvent>((event, emit) async {
      await authenticationRepository.mobLoginRepository();
    });
    on<EventMobOtpRequest>((event, emit) async {
      await authenticationRepository.mobOtpRequestRepository();
    });
    on<EventMobOtpVerification>((event, emit) async {
      await authenticationRepository.mobOtpVerificationRepository();
    });
    on<OnboardingEvent>((event, emit) async {
      await authenticationRepository.merchantOnboardingRepository();
    });
    on<OnboardingStatusEvent>((event, emit) async {
      await authenticationRepository.merchantOnboardingStatusRepository();
    });
  }
}
