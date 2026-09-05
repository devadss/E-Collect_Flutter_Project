import '../non_integarted_loan_list_due.dart';
import 'loan_all_data/complete_loanlist.dart';

abstract class NonIntegratedModel {}

class CompleteLoanListNonIntegratedSuccess extends NonIntegratedModel {
  final CompleteLoanLisResponse completeLoanLisResponse;
  CompleteLoanListNonIntegratedSuccess(this.completeLoanLisResponse);
}

class CompleteLoanListNonIntegratedFail extends NonIntegratedModel {
  final String completeLoanLisResponseFail;
  CompleteLoanListNonIntegratedFail(this.completeLoanLisResponseFail);
}
//-------------------------------------------------------------------
class DueLoanListNonIntegratedSuccess extends NonIntegratedModel{
  final NonIntegratedLoanDueList nonIntegratedLoanDueList;
  DueLoanListNonIntegratedSuccess(this.nonIntegratedLoanDueList);
}

class DueLoanListNonIntegratedFail extends NonIntegratedModel{
  final String dueLoanListNonIntegratedFail;
  DueLoanListNonIntegratedFail(this.dueLoanListNonIntegratedFail);
}