part of 'rdcl_duelist_bloc.dart';
abstract class RdclDuelistState {}

class RdclDueListInitialState extends RdclDuelistState{}

class RdclDueListLoaderState extends RdclDuelistState{}

class RdclDueListSuccessState  extends RdclDuelistState{
  final RdclDulistSuccess rdclDulistSuccess;
  RdclDueListSuccessState(this.rdclDulistSuccess);
}

class RdclDueListFailState extends RdclDuelistState{
  final RdclDueListFail rdclDueListFail;
  RdclDueListFailState(this.rdclDueListFail);
}
