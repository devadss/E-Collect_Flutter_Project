import 'dart:convert';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/sub_agent/parent_agent_data_interface/parent_agent_detial_interface.dart';
import 'package:collection_qr_flutter/domain/model/subagent/agent_subagent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../domain/model/subagent/detail_fetch/agent_subagent_faill.dart';

class ParentAgentDetailRepository implements ParentDataDetailInterface {
  @override
  Future<Either<AgentSubagentDetailFail, SubAgentResponse>> fetchParentAgentDetails(
      String mobNum) async {
    final uri = Uri.parse(
        "${baseUrl}api/SubAgent/AgentMobNumBySubAgentMobNum?mobileNumber=%2B91$mobNum");
    final request =
        await http.get(uri, headers: {'Content-Type': 'application/json'});
    print(uri);
    print('ParentAgentDetailRepository : ${request.body}');
    if (request.statusCode == 200) {
      return Right(SubAgentResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(AgentSubagentDetailFail.fromJson(jsonDecode(request.body)));
    }
  }
}
