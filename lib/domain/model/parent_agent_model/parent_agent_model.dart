import 'package:collection_qr_flutter/domain/model/parent_agent_model/parent_agent_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/parent_agent_model/parent_agent_success_model.dart';

sealed class ParentAgentModel {}

class ParentAgentSuccessModel extends ParentAgentModel{
  final ParentAgentSuccessResponse parentAgentSuccessResponse;
  ParentAgentSuccessModel(this.parentAgentSuccessResponse);
}

class ParentAgentFailModel extends ParentAgentModel{
  final ParentAgentFailResponse parentAgentFailResponse;
  ParentAgentFailModel(this.parentAgentFailResponse);
}