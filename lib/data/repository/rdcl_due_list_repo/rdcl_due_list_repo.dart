import 'dart:convert';

import 'package:http/http.dart'as http;

import '../../../domain/model/rdcl_duelist_model/rdcl_due_list_model.dart';
import '../../../domain/model/rdcl_duelist_model/rdcl_due_list_success.dart';

class RdclDueListRepo {

  Future<RdclDueListModel> fetchRdclDueList(
      String agentId,
      String branchCode,
      String accNo,
      String custName,
      ) async {
    final uri = Uri.parse("https://doorstepmeenachilmscs.digicob.in/GetRdclDuesListunderAgent?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=0&PageSize=0&CustName=$custName");
    final request =  await http.get(uri , headers: {"Content-Type":"application/json"});
    if(request.statusCode == 200){
      return RdclDulistSuccess(RdclduesListSuccessModel.fromJson(jsonDecode(request.body)));
    }else{
      return RdclDueListFail(request.body);
    }

  }
}