part of 'customer_list_bloc.dart';
abstract class CustomerListState {
  const CustomerListState();
}

class CustomerListInitialState extends CustomerListState{
  const CustomerListInitialState();
}

class CustomerListLoaderState extends CustomerListState{
  const CustomerListLoaderState();
}

class CustomerListSuccessState extends CustomerListState{
  final CustomerListSuccessModel customerListSuccessModel;
  const CustomerListSuccessState(this.customerListSuccessModel);
}

class CustomerListFailState extends CustomerListState{
  final CustomerListFailModel customerListFailModel;
  const CustomerListFailState(this.customerListFailModel);
}

//-------------------------RD-----------------------------------
class RdCustomerListLoaderState extends CustomerListState{
  const RdCustomerListLoaderState();
}

class RdCustomerListSuccessState extends CustomerListState{
  final RdCustomerListSuccessModel rdCustomerListSuccessModel;
  const RdCustomerListSuccessState(this.rdCustomerListSuccessModel);
}

class RdCustomerListFailState extends CustomerListState{
  final RdCustomerListFailModel rdCustomerListFailModel;
  const RdCustomerListFailState(this.rdCustomerListFailModel);
}
//----------------------RD FILTER-------------------------------------------
class RdCustomerListFilteredState extends CustomerListState{
  final RdCustomerListSuccessModel rdCustomerListSuccessModel;
  const RdCustomerListFilteredState(this.rdCustomerListSuccessModel);
}
//-------------------------LOAN-----------------------------------
class LoanCustomerListLoaderState extends CustomerListState{
  const LoanCustomerListLoaderState();
}

class LoanCustomerListSuccessState extends CustomerListState{
  final LoanCustomerListSuccessModel loanCustomerListSuccessModel;
  const LoanCustomerListSuccessState(this.loanCustomerListSuccessModel);
}

class LoanCustomerListFailState extends CustomerListState{
  final LoanCustomerListFailModel loanCustomerListFailModel;
  const LoanCustomerListFailState(this.loanCustomerListFailModel);
}

//-------------------------LOAN_DETAIL-----------------------------------
class LoanDetailListLoaderState extends CustomerListState{
  const LoanDetailListLoaderState();
}

class LoanDetailListSuccessState extends CustomerListState{
  final LoanDetailListSuccessModel loanDetailListSuccessModel;
  const LoanDetailListSuccessState(this.loanDetailListSuccessModel);
}

class LoanDetailListFailState extends CustomerListState{
  final LoanDetailListFailModel loanDetailListFailModel;
  const LoanDetailListFailState(this.loanDetailListFailModel);
}