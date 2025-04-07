
import 'package:flutter/material.dart';

import '../../domain/model/due_under_agent_model.dart';
import '../repository/due_under_agent_repository.dart';

class DueUnderAgentProvider with ChangeNotifier{
  final DueUnderAgentRepository _dueUnderAgentRepository;
  DueUnderAgentProvider(this._dueUnderAgentRepository);
  DueUnderAgentModel? _agentModel;
  DueUnderAgentModel? get agentModel =>_agentModel;
  Future<void> getDuesUnderAgent(String? agentId) async{
    print("=------------------------DUE UNDERAGENT MODEL---------------------");
    print(_agentModel);
    final result = await _dueUnderAgentRepository.getDuesUnderAgent(agentId);
    result.fold(
        (error){
          print("---------------ERROR------------");
          print(error);
        },
        (data){
          _agentModel = data;
          print("------------------DATA-------------");
          print(data);
          notifyListeners();
        }
    );
  }
}