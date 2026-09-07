import '../agent_customer_details_model.dart';
import '../integrated_loan_list_model.dart';
import 'customer_list_fail_model.dart';
import 'customer_list_success.dart';

sealed class CustomerListModel {
  const CustomerListModel();
}

class CustomerListSuccessModel extends CustomerListModel{
  final CustomerListSuccessResponse customerListSuccessResponse;
  const CustomerListSuccessModel(this.customerListSuccessResponse);
}

class CustomerListFailModel extends CustomerListModel{
  final CustomerListFailResponse customerListFailResponse;
  const CustomerListFailModel(this.customerListFailResponse);
}
//---------------------------RD----------------------------------
class RdCustomerListSuccessModel extends CustomerListModel{
  final AgentCustomerDetailsModel rdCustomerListModel;
  const RdCustomerListSuccessModel(this.rdCustomerListModel);
}

class RdCustomerListFailModel extends CustomerListModel{
  final String rdCustomerListFailError;
  const RdCustomerListFailModel(this.rdCustomerListFailError);
}
//---------------------------LOAN----------------------------------
class LoanCustomerListSuccessModel extends CustomerListModel{
  final IntegratedLoanListResponse loanCustomerListSuccessModel;
  const LoanCustomerListSuccessModel(this.loanCustomerListSuccessModel);
}

class LoanCustomerListFailModel extends CustomerListModel{
  final String rdCustomerListFailError;
  const LoanCustomerListFailModel(this.rdCustomerListFailError);
}
//---------------------------------------------------------------