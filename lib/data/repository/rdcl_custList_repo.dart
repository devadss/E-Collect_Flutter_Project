import 'dart:convert';

import 'package:collection_qr_flutter/domain/model/account_list_model.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/interface/rdcl_customer_list_interface.dart';

class RdclCustListRep implements RdclCustomerListInterface {
  @override
  Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
      String? agentID, String? branchID) async {
    final uri = Uri.parse(
        "https://doorstepfapmcomscs.digicob.in/getRdclCustomerunderAgentList");
    final data = await http.post(
      uri,
      body: jsonEncode({"agent_id": "1008", "branch_id": "00"}),
      headers: {'Content-Type': 'application/json'},
    );

    if (data.statusCode == 200) {
      return Right(RdclCustomerListModel.fromJson(jsonDecode(data.body)));
    } else {
      return Left(data.body);
    }
  }
}
