part of 'rdcl_duelist_bloc.dart';

abstract class RdclDuelistEvent {
  const RdclDuelistEvent();
}

class RdclDueListFetchEvent extends RdclDuelistEvent {
  final String agentId;
  final String branchCode;
  final String accNo;
  final String custName;
  final String pageNo;
      final String pageSize;
  const RdclDueListFetchEvent(
    this.agentId,
    this.branchCode,
    this.accNo,
    this.custName,
      this.pageNo,
      this.pageSize
  );
}
