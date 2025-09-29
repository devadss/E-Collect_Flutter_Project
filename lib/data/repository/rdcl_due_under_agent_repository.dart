// import 'dart:convert';
// import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart'as http;
// import '../../domain/interface/rdcl_due_under_agent_interface.dart';
// import '../storage/shared_pref_helper.dart';
//
// class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface{
//   Future<String> loadVendorUrl() async {
//     return await SharedPref().getDueListUrl();
//
//   }
//
//   @override
//   Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(String agentId,
//       String branchCode, String accNo, int pageNo, int pageSize,String custName) async {
//     print("inside getRdclDueList");
//     final vendorUrl = await loadVendorUrl();
//     print("vendorUrl = $vendorUrl");
//    final uri = Uri.parse("$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
//    //final uri = Uri.parse("https://doorstepclientuat.digicob.in/GetRdclDuesListunderAgent?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
//     print("uri = $uri");
//    final request = await  http.get(uri);
//    print(request.statusCode);
//    print("$vendorUrl?agent_id=$agentId");
//    print("GetRdclDuesList ${request.body}");
//    if(request.statusCode == 200){
//      return Right(RdclDueUnderAgentModel.fromJson(jsonDecode(request.body)));
//
//    }else{
//      return Left(request.body);
//    }
//
//   }
//
// }

import 'dart:convert';
import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../domain/interface/rdcl_due_under_agent_interface.dart';
import '../storage/shared_pref_helper.dart';

class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface {
  @override
  Future<Either<ErrorHandler, RdclDueUnderAgentModel>> getRdclDueList(
      String agentId,
      String branchCode,
      String accNo,
      int pageNo,
      int pageSize,
      String custName) async {
    Future<String> loadVendorUrl() async {
      return await SharedPref().getDueListUrl();
    }

    print("inside getRdclDueList");
    final vendorUrl = await loadVendorUrl();
    print("vendorUrl = $vendorUrl");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    final uri = Uri.parse(
        "$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
    if (checkConnection) {
      printLog(
          "-------------------------------------------------URI------------------------------------");
      printLog(uri);
      final response = await http.get(uri);
      printLog(
          "-------------------------------------------------Status Code------------------------------------");
      printLog(response.statusCode);
      printLog(
          "-------------------------------------------------VENDOR URL------------------------------------");
      printLog("$vendorUrl?agent_id=$agentId");

      printLog(
          "-------------------------------------------------Response Body------------------------------------");
      printLog(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return Right(
              RdclDueUnderAgentModel.fromJson(jsonDecode(response.body)));
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
