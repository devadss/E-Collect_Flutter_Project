
part of 'parent_agent_bloc.dart';
abstract class ParentAgentEvent {}

class FetchParentAgentEvent extends ParentAgentEvent{
  final String mobNum;
  FetchParentAgentEvent(this.mobNum);
}