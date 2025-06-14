
import '../../domain/model/agent_transction_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';

abstract class IAgentTransactionRepository{
  Future<Either<ErrorHandler,AgentPaymentTransctionModel>>getTransactions(String token);
}