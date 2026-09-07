part of 'customer_list_bloc.dart';

abstract class CustomerListEvent {
  const CustomerListEvent();
}

class CustomerListFetchEvent extends CustomerListEvent{
  final String baseUrl;
  final String agentId;
  final String branchId;
  final String pageNo;
  final String pageSize;
  final String customerName;
  const CustomerListFetchEvent(this.baseUrl,this.agentId, this.branchId, this.pageNo, this.pageSize, this.customerName);
}
//--------------------------RD----------------------------------------------
class RdCustomerListFetchEvent extends CustomerListEvent{
  final String requestUrl;
  final String agentId;
  final String branchId;
  const RdCustomerListFetchEvent(this.requestUrl, this.agentId, this.branchId);
}
//--------------------------RD FILTER----------------------------------------------

class RdCustomerListFilterEvent extends CustomerListEvent{
  final String filterName;
  const RdCustomerListFilterEvent(this.filterName);
}
//--------------------------LOAN----------------------------------------------

class LoanCustomerListFetchEvent extends CustomerListEvent{
  final String baseUrl;
  final String agentId;
  final String branchId;
  final String schemeCode;
  final String accNo;
  const LoanCustomerListFetchEvent(this.baseUrl,this.agentId, this.branchId, this.schemeCode, this.accNo);
}
