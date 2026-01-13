import 'package:collection_qr_flutter/domain/model/rdcl_duelist_model/rdcl_due_list_success.dart';

sealed class RdclDueListModel {}

class RdclDulistSuccess extends RdclDueListModel{
  RdclduesListSuccessModel rdclduesListSuccessModel;
  RdclDulistSuccess(this.rdclduesListSuccessModel);
}

class RdclDueListFail extends RdclDueListModel{
  String error;
  RdclDueListFail(this.error);
}