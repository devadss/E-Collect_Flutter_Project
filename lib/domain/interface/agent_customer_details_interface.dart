
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/agent_customer_details_model.dart';

abstract class IAgentCustomerDetailsRepository{
  Future<Either<ErrorHandler,AgentCustomerDetailsModel>>getAgentCustomerDetails(String agentId);
}