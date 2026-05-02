import 'dart:convert';

import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;

import '../../../core/utils.dart';
import '../../../domain/model/rdcl_duelist_model/rdcl_due_list_model.dart';
import '../../../domain/model/rdcl_duelist_model/rdcl_due_list_success.dart';

class RdclDueListRepo {
Future<String> loadVendorUrl()async{
  return await SharedPref().getDueListRdclUrl();
}
  Future<RdclDueListModel> fetchRdclDueList(
      String agentId,
      String branchCode,
      String accNo,
      String custName,
      ) async {
  final vendorUrl = await loadVendorUrl();
    final uri = Uri.parse("$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=0&PageSize=0&CustName=$custName");
    final request =  await http.get(uri , headers: {"Content-Type":"application/json"});
    if(printStatementStatus ){
      print("Uri = $uri");
      print(request.body);
      print(request.statusCode);
    }

    var data  = jsonDecode(request.body);
    var d = data.toString();
    if(request.statusCode == 200 && !d.contains("No results found")){
      final success =
      await compute(parseRdclDuesSuccess, request.body);


     // return CustomerListSuccessModel(successResponse);
      return RdclDulistSuccess(success);
    }else if(request.statusCode == 200 && d.contains("No results found")){
      return RdclDueListFail(request.body);
    }


    else{
      return RdclDueListFail(request.body);
    }

  }
}