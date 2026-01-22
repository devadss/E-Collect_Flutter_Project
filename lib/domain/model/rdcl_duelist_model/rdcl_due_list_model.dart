import 'package:collection_qr_flutter/domain/model/rdcl_duelist_model/rdcl_due_list_success.dart';

sealed class RdclDueListModel {
  const RdclDueListModel();
}

class RdclDulistSuccess extends RdclDueListModel{
  final RdclduesListSuccessModel rdclduesListSuccessModel;
  const RdclDulistSuccess(this.rdclduesListSuccessModel);
}

class RdclDueListFail extends RdclDueListModel{
  final String error;
  const RdclDueListFail(this.error);
}