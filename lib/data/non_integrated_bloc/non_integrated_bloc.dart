import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/non_integrated/non_integrated_model.dart';
import '../repository/non_integrated_repository/non_integrated_repository.dart';
part 'non_integrated_event.dart';
part 'non_integrated_state.dart';

class NonIntegratedBloc extends Bloc<NonIntegratedEvent, NonIntegratedState> {
  final NonIntegratedRepository nonIntegratedRepository;
  NonIntegratedBloc(this.nonIntegratedRepository)
      : super(AllNonIntegratedLoanInitialState()) {
    on<FetchAllNonIntegratedLoans>((event, emit) async {
      emit(AllNonIntegratedLoanLoaderState());
      final data = await nonIntegratedRepository.fetchAllNonIntegratedLoanList(
          event.endPoint,
          event.branchCode,
          event.productType,
          event.agentCode,
          event.searchKeyWord);

      if (data is CompleteLoanListNonIntegratedSuccess) {
        emit(AllNonIntegratedLoanSuccessState(data));
      } else if (data is CompleteLoanListNonIntegratedFail) {
        emit(AllNonIntegratedLoanFailureState(data));
      }
    });

    on<FetchNonIntegratedLoanDues>((event, emit) async {
      emit(NonIntegratedLoanDueLoaderState());
      final data = await nonIntegratedRepository.fetchNonintegratedDueLoanList(
          event.endPoint,
          event.agentCode,
          event.branchCode,
          event.productType,
          event.pageNo,
          event.pageSize,
          event.agentCodeRoute);

      if (data is DueLoanListNonIntegratedSuccess) {
        emit(NonIntegratedLoanDueSuccessState(data));
      } else if (data is DueLoanListNonIntegratedFail) {
        emit(NonIntegratedLoanDueFailureState(data));
      }
    });
  }
}
