import 'package:collection_qr_flutter/domain/model/no_transaction.dart';
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/agent_transction_model.dart';

abstract class IAgentTransactionRepository{
  Future<Either<NoTransactionModel,AgentPaymentTransctionModel>>getTransactions(String token);
}