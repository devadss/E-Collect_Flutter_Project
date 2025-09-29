import 'dart:convert';
import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/interface/rdcl_due_under_agent_interface.dart';
import '../storage/shared_pref_helper.dart';

class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface {
  Future<String> loadVendorUrl() async {
    return await SharedPref().getDueListUrl();
  }

  @override
  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
      String agentId,
      String branchCode,
      String accNo,
      int pageNo,
      int pageSize,
      String custName) async {
    print("inside getRdclDueList");
    final vendorUrl = await loadVendorUrl();
    print("vendorUrl = $vendorUrl");
    final uri = Uri.parse(
        "$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
    print("uri = $uri");
    try {
      if (checkInternetConnection() == true) {
        print("Network connection success");
        final request = await http.get(uri);
        print(request.statusCode);
        print("$vendorUrl?agent_id=$agentId");
        print("GetRdclDuesList ${request.body}");
        if (request.statusCode == 200) {
          return Right(
              RdclDueUnderAgentModel.fromJson(jsonDecode(request.body)));
        } else {
          return Left(request.body);
        }
      } else {
        return const Left("Check internet connection");
      }
    } catch (e) {
      return const Left("Unable to fetch Due Under Agent");
    }
  }
}

//final uri = Uri.parse("https://doorstepclientuat.digicob.in/GetRdclDuesListunderAgent?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
