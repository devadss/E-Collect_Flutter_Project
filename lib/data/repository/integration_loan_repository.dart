import 'dart:convert';
import 'package:collection_qr_flutter/domain/interface/integrated_loan_list_interface.dart';
import 'package:collection_qr_flutter/domain/model/integrated_loan_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class IntegrationLoanRepository extends IntegrationLoanInterface {
  @override
  Future<Either<String, IntegratedLoanListResponse>> fetchIntegratedLoans(

      String? requestUrl,
      String? agentId,
      String? branchId,
      String? schemeCode,
      String? accNo) async {
   // final uri = Uri.parse("https://mftctest.digicob.in/getLoanCustUnderAgent");
    final uri = Uri.parse(requestUrl!);
    final data = await http.post(uri,
        body: jsonEncode({
          "agent_id": agentId,
          "branch_id": branchId,
          "sch_code": schemeCode,
          "acno": accNo
        }),
        headers: {'Content-Type': 'application/json'});
    print({
      "agent_id": agentId,
      "branch_id": branchId,
      "sch_code": schemeCode,
      "acno": accNo
    });
    print({
      "agent_id": agentId,
      "branch_id": branchId,
      "sch_code": schemeCode,
      "acno": accNo
    });
    print("getLoanCustUnderAgent = ${data.body}");
    if (data.statusCode == 200) {
      return Right(IntegratedLoanListResponse.fromJson(jsonDecode(data.body)));
    } else {
      return Left(data.body);
    }
  }
}
