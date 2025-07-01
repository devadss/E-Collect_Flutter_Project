import 'dart:convert';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;
import '../../domain/interface/rdcl_due_under_agent_interface.dart';

class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface{
  @override
  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(String agentId) async {
   final uri = Uri.parse("https://doorstepfapmcomscs.digicob.in/GetRdclDuesListunderAgent?agent_id=1008");
   final request = await  http.get(uri);
   print(request.statusCode);
   print("GetRdclDuesList ${request.body}");
   if(request.statusCode == 200){
     return Right(RdclDueUnderAgentModel.fromJson(jsonDecode(request.body)));

   }else{
     return Left(request.body);
   }

  }
  
}