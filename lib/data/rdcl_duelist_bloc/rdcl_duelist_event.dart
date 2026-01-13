part of 'rdcl_duelist_bloc.dart';

abstract class RdclDuelistEvent {}

class RdclDueListFetchEvent extends RdclDuelistEvent {
  String agentId;
  String branchCode;
  String accNo;
  String custName;
  RdclDueListFetchEvent(
    this.agentId,
    this.branchCode,
    this.accNo,
    this.custName,
  );
}
