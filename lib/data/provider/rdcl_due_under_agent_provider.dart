import 'package:collection_qr_flutter/data/repository/rdcl_due_under_agent_repository.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class RdclDueUnderAgentProvider with ChangeNotifier {
  final RdclDueUnderAgentRepo _rdclDueUnderAgentRepo;

  RdclDueUnderAgentProvider(this._rdclDueUnderAgentRepo);

  RdclDueUnderAgentModel? _rdclDueUnderAgentModel;

  RdclDueUnderAgentModel? get rdclDueUnderAgentModel => _rdclDueUnderAgentModel;

  bool? _showDialog;
  bool? get showDialog => _showDialog;

  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
      String agentId,String branchCode, String accNo, int pageNo, int pageSize) async {
    final data = await _rdclDueUnderAgentRepo.getRdclDueList(agentId, branchCode,accNo, pageNo, pageSize);
    _showDialog = true;
    notifyListeners();
    data.fold((err) {
      _rdclDueUnderAgentModel = null;
      _showDialog = false;
    }, (success) {
      _rdclDueUnderAgentModel = success;
      _showDialog = false;
    });
    notifyListeners();
    return data;
  }
}
