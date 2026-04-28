
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../../../domain/model/parent_agent_model/parent_agent_fail_model.dart';
import '../../../domain/model/parent_agent_model/parent_agent_model.dart';
import '../../../domain/model/parent_agent_model/parent_agent_success_model.dart';

class ParentAgentRepo {

 Future<ParentAgentModel> getParentAgentDetails(String mobNum) async {
   final uri = Uri.parse(
       "${baseUrl}api/SubAgent/AgentMobNumBySubAgentMobNum?mobileNumber=%2B91$mobNum");
   final request =
       await http.get(uri, headers: {'Content-Type': 'application/json'});

   if(request.statusCode == 200){
     return ParentAgentSuccessModel(ParentAgentSuccessResponse.fromJson(jsonDecode(request.body)));
   }else{
     return ParentAgentFailModel(ParentAgentFailResponse.fromJson(jsonDecode(request.body)));
   }
 }
}