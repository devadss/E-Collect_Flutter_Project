import '../subagent/fetch_parent_credentials/parent_agent_credentials.dart';
import '../subagent/fetch_parent_credentials/parent_agent_credentila_fail.dart';

sealed class ParentCredentialModel {}

class ParentCredentialSuccess extends ParentCredentialModel{
  final ParentAgentCredentialModel parentAgentCredentialModel;
  ParentCredentialSuccess(this.parentAgentCredentialModel);
}

class ParentCredentialFail extends ParentCredentialModel{
final ParentAgentCredentialFailResponse parentAgentCredentialFailResponse;
ParentCredentialFail(this.parentAgentCredentialFailResponse);
}