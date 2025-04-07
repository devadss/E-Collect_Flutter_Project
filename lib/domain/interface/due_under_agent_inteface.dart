import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/due_under_agent_model.dart';

abstract class IDueUnderAgentRepository{
  Future<Either<ErrorHandler,DueUnderAgentModel>>getDuesUnderAgent(String? agentId);
}