import '../../data/service/error_handler.dart';
import '../../domain/model/due_under_agent_model.dart';
import 'package:dartz/dartz.dart';

abstract class IDueUnderAgentRepository{
  Future<Either<ErrorHandler,DueUnderAgentModel>>getDuesUnderAgent(String? agentId);
}