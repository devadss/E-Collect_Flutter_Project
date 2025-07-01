import 'package:collection_qr_flutter/data/repository/rdcl_due_under_agent_repository.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class RdclDueUnderAgentProvider with ChangeNotifier {
  final RdclDueUnderAgentRepo _rdclDueUnderAgentRepo;

  RdclDueUnderAgentProvider(this._rdclDueUnderAgentRepo);

  RdclDueUnderAgentModel? _rdclDueUnderAgentModel;

  RdclDueUnderAgentModel? get rdclDueUnderAgentModel => _rdclDueUnderAgentModel;

  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
      String agentId) async {
    final data = await _rdclDueUnderAgentRepo.getRdclDueList(agentId);
    data.fold((err) {}, (success) {
      _rdclDueUnderAgentModel = success;
    });
    notifyListeners();
    return data;
  }
}
