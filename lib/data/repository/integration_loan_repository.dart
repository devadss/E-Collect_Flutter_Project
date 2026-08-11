import 'dart:convert';

import 'package:collection_qr_flutter/domain/interface/integrated_loan_list_interface.dart';
import 'package:collection_qr_flutter/domain/model/integrated_loan_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../storage/shared_pref_helper.dart';
class IntegrationLoanRepository extends IntegrationLoanInterface{
  // Future<List<String>> loadVendorUrl() async {
  //   //final liveUrl = await SharedPref().getVendorUrlLive();
  //   return await SharedPref().getECollectUrlList();
  // }


  @override
  Future<Either<String, IntegratedLoanListResponse>> fetchIntegratedLoans(String? agentId, String? branchId, String? schemeCode, String? accNo) async {
    // print("loadVendorUrl = ${await loadVendorUrl()}");
    // var urls = await loadVendorUrl();
    final uri = Uri.parse("https://mftctest.digicob.in/getLoanCustUnderAgent");
  //  print("loadVendorUrl = ${urls[1]}");
    final data  = await http.post(uri,
    body: jsonEncode({"agent_id":agentId,"branch_id":branchId,"sch_code":schemeCode,"acno":accNo}),
    headers: {'Content-Type': 'application/json'});
print({"agent_id":agentId,"branch_id":branchId,"sch_code":schemeCode,"acno":accNo});
    print({"agent_id":agentId,"branch_id":branchId,"sch_code":schemeCode,"acno":accNo});
    print("getLoanCustUnderAgent = ${data.body}");
    if(data.statusCode == 200){
      return Right(IntegratedLoanListResponse.fromJson(jsonDecode(data.body)));
    }else{
      return Left(data.body);
    }


  }
  
}