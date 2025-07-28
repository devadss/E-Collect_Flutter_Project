import 'package:dartz/dartz.dart';

import '../model/due_model/rdcl_due_under_agent_model.dart';

abstract class RdclDueUnderAgentModelInterface{
  Future<Either<String, RdclDueUnderAgentModel>>getRdclDueList(String agentId,
      String branchCode,
      String accNo,
      int pageNo,
      int pageSize,
      String custName

      );
}

