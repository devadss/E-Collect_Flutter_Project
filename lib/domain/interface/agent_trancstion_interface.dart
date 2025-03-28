import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/agent_transction_model.dart';

abstract class IAgentTransactionRepository{
  Future<Either<ErrorHandler,AgentPaymentTransctionModel>>getTransactions();
}