import 'dart:convert';
import 'package:collection_qr_flutter/domain/interface/integrated_loan_details_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/integrated_loan_detail_model.dart';

class IntegratedLoanDetailRepository implements IntegratedLoanDetailInterface{

  @override
  Future<Either<String, IntegratedLoanDetails>> getIntegratedLoanDetails
      (
      String requestUrl,
      String flag,

      String branchId, String schemeCode, String demandDate, String accountNumber) async {
   // final uri = Uri.parse("https://mftctest.digicob.in/getLoanAccountHolder");
    final uri = Uri.parse(requestUrl);
    final request = await http.post(uri,
    body: jsonEncode({
      "flag": flag,
      "branch_id": branchId,
      "sch_code": schemeCode,
      "demandDate": demandDate,
      "account_no": accountNumber
    }),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    print({
      "flag": flag,
      "branch_id": branchId,
      "sch_code": schemeCode,
      "demandDate": demandDate,
      "account_no": accountNumber
    });
    print(request.body);
    if(request.statusCode == 200){
      return Right(IntegratedLoanDetails.fromJson(jsonDecode(request.body)));
    }else{
      return Left(request.body);
    }
  }
  
}