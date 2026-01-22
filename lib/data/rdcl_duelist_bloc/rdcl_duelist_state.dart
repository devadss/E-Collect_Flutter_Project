part of 'rdcl_duelist_bloc.dart';
abstract class RdclDuelistState {
  const RdclDuelistState();
}

class RdclDueListInitialState extends RdclDuelistState{
  const RdclDueListInitialState();
}

class RdclDueListLoaderState extends RdclDuelistState{
  const RdclDueListLoaderState();
}

class RdclDueListSuccessState  extends RdclDuelistState{
  final RdclDulistSuccess rdclDulistSuccess;
 const RdclDueListSuccessState(this.rdclDulistSuccess);
}

class RdclDueListFailState extends RdclDuelistState{
  final RdclDueListFail rdclDueListFail;
  const RdclDueListFailState(this.rdclDueListFail);
}
