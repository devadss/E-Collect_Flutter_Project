import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/account_list_model.dart';
import '../repository/rdcl_custList_repo.dart';

class RdclCustListProvider with ChangeNotifier {
  final RdclCustListRep _rdclCustListRep;

  RdclCustListProvider(this._rdclCustListRep);

  RdclCustomerListModel? _rdclCustomerListModel;

  RdclCustomerListModel? get rdclCustomerListModel => _rdclCustomerListModel;

  Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
      String? agentID, String? branchID,int pgNo, int pgSize) async {
    final data =
        await _rdclCustListRep.getRdclCustomerunderAgent(agentID, branchID,pgNo, pgSize);
    data.fold((err) {}, (success) {
      _rdclCustomerListModel = success;
    });
    notifyListeners();
    return data;
  }
}
