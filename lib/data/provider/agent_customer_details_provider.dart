
import 'package:flutter/material.dart';

import '../../core/general.dart';
import '../../domain/model/agent_customer_details_model.dart';
import '../repository/agent_customer_details_repository.dart';

class AgentCustomerDetailsProvider with ChangeNotifier{
  final AgentCustomerDetailsRepository _agentCustomerDetailsRepository;
  AgentCustomerDetailsProvider(this._agentCustomerDetailsRepository);
  AgentCustomerDetailsModel? _agentCustomerDetailsModel;
  AgentCustomerDetailsModel? get agentCustomerDetailsModel =>_agentCustomerDetailsModel;
  Future<void>getAgentCustomerDetails(String agentId) async{
    printLog("-----------------AGENT CUST DETAILS----------------");
    printLog(agentCustomerDetailsModel);
    final result = await _agentCustomerDetailsRepository.getAgentCustomerDetails(agentId);
    result.fold(
        (error){
          printLog("-----------------------ERROR------------------");
          printLog(error);
        },
        (data){
          _agentCustomerDetailsModel = data;
          printLog("---------------------CUST DATA-------------------");
          printLog(data);
          notifyListeners();
        }
    );
  }
}