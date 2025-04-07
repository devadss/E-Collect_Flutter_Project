
import 'package:collection_qr_flutter/domain/model/no_transaction.dart';
import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/agent_transction_model.dart';
import '../repository/agent_transaction_repository.dart';


class AgentTransactionProvider with ChangeNotifier{
  final AgentTransactionRepository _agentTransactionRepository;
  AgentTransactionProvider(this._agentTransactionRepository);
  AgentPaymentTransctionModel? _agentPaymentTransctionModel;
  AgentPaymentTransctionModel? get agentPaymentTransctionModel =>_agentPaymentTransctionModel;

 NoTransactionModel? _noTransactionModel;
 NoTransactionModel? get noTransactionModel => _noTransactionModel;
  Future<void>getTransactions(String token) async{
    printLog("------------------------AgentPaymentTransctionModel-----------------------");
    printLog(agentPaymentTransctionModel);
    final result = await _agentTransactionRepository.getTransactions(token);
    result.fold(
        (error){
          printLog("--------------------AgentTransactionProvider ERROR-----------------");
          _noTransactionModel = error;
        },
        (data){
          _agentPaymentTransctionModel = data;
          printLog("-------------------------TRANS DATA-----------------------");
          printLog(data);
          notifyListeners();
        }
    );

  }
}