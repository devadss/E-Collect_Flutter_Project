part of 'non_integrated_bloc.dart';
abstract class NonIntegratedState {}

class AllNonIntegratedLoanInitialState extends NonIntegratedState{}

class AllNonIntegratedLoanLoaderState extends NonIntegratedState{}

class AllNonIntegratedLoanSuccessState extends NonIntegratedState{
  final CompleteLoanListNonIntegratedSuccess completeLoanListNonIntegratedSuccess;
  AllNonIntegratedLoanSuccessState(this.completeLoanListNonIntegratedSuccess);
}

class AllNonIntegratedLoanFailureState extends NonIntegratedState{
  final CompleteLoanListNonIntegratedFail completeLoanListNonIntegratedFail;
  AllNonIntegratedLoanFailureState(this.completeLoanListNonIntegratedFail);
}
//-----------------------------------------------------
class NonIntegratedLoanDueLoaderState extends NonIntegratedState{}

class NonIntegratedLoanDueSuccessState extends NonIntegratedState{
  final DueLoanListNonIntegratedSuccess dueLoanListNonIntegratedSuccess;
  NonIntegratedLoanDueSuccessState(this.dueLoanListNonIntegratedSuccess);
}

class NonIntegratedLoanDueFailureState extends NonIntegratedState{
  final DueLoanListNonIntegratedFail dueLoanListNonIntegratedFail;
  NonIntegratedLoanDueFailureState(this.dueLoanListNonIntegratedFail);
}