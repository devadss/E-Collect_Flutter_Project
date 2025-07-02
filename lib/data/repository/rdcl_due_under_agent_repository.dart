import 'dart:convert';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;
import '../../domain/interface/rdcl_due_under_agent_interface.dart';
import '../storage/shared_pref_helper.dart';

class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface{
  Future<String> loadVendorUrl() async {
    return await SharedPref().getDueListUrl();

  }

  @override
  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(String agentId,
      String branchCode) async {
    final vendorUrl = await loadVendorUrl();
   final uri = Uri.parse("$vendorUrl?agent_id=$agentId&br_code=$branchCode");
   final request = await  http.get(uri);
   print(request.statusCode);
   print("$vendorUrl?agent_id=$agentId");
   print("GetRdclDuesList ${request.body}");
   if(request.statusCode == 200){
     return Right(RdclDueUnderAgentModel.fromJson(jsonDecode(request.body)));

   }else{
     return Left(request.body);
   }

  }
  
}