import 'package:collection_qr_flutter/data/repository/parent_agent/parent_agent_detail_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../../domain/model/subagent/agent_subagent_model.dart';
import '../../../domain/model/subagent/detail_fetch/agent_subagent_faill.dart';

class ParentDetailAgentProvider with ChangeNotifier {
  final ParentAgentDetailRepository _parentAgentDetailRepository;

  ParentDetailAgentProvider(this._parentAgentDetailRepository);

  SubAgentResponse? _subAgent;
  SubAgentResponse? get subAgent => _subAgent;

  AgentSubagentDetailFail? _agentSubagentDetailFail;
  AgentSubagentDetailFail? get agentSubagentDetailFail => _agentSubagentDetailFail;


  Future<Either<AgentSubagentDetailFail, SubAgentResponse>> fetchParentAgentDetails(
      String mobNum) async {
    final data =
        await _parentAgentDetailRepository.fetchParentAgentDetails(mobNum);
    data.fold((error) {
     // _subAgent = null;
      _agentSubagentDetailFail = error;

    }, (success) {
      _agentSubagentDetailFail = null;
      _subAgent = success;
    });
    notifyListeners();
    return data;
  }
}
