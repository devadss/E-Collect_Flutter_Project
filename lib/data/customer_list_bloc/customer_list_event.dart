part of 'customer_list_bloc.dart';

abstract class CustomerListEvent {}

class CustomerListFetchEvent extends CustomerListEvent{
  final String agentId;
  final String branchId;
  final String pageNo;
  final String pageSize;
  final String customerName;
  CustomerListFetchEvent(this.agentId, this.branchId, this.pageNo, this.pageSize, this.customerName);
}