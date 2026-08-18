// import 'package:collection_qr_flutter/core/utils.dart';
//
// import '../../core/general.dart';
// import '../../data/repository/agent_transaction_repository.dart';
// import '../../domain/model/agent_transction_model.dart';
// import 'package:flutter/material.dart';
//
//
// class AgentTransactionProvider with ChangeNotifier{
//   final AgentTransactionRepository _agentTransactionRepository;
//   AgentTransactionProvider(this._agentTransactionRepository);
//   AgentPaymentTransctionModel? _agentPaymentTransctionModel;
//   AgentPaymentTransctionModel? get agentPaymentTransctionModel =>_agentPaymentTransctionModel;
//   Future<void>getTransactions(String token) async{
//     if(printStatementStatus){
//       printLog("------------------------AgentPaymentTransctionModel-----------------------");
//       printLog(agentPaymentTransctionModel);
//     }
//
//     final result = await _agentTransactionRepository.getTransactions(token);
//     result.fold(
//         (error){
//           if(printStatementStatus){
//             printLog("--------------------ERROR Transcation-----------------");
//             printLog(error);
//           }
//
//         },
//         (data){
//           _agentPaymentTransctionModel = data;
//           if(printStatementStatus){
//             printLog("-------------------------DATA-----------------------");
//             printLog(data);
//           }
//
//           notifyListeners();
//         }
//     );
//   }
// }