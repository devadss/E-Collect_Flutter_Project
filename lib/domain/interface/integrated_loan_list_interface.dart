import 'package:collection_qr_flutter/domain/model/integrated_loan_list_model.dart';
import 'package:dartz/dartz.dart';


abstract class IntegrationLoanInterface{
  Future<Either<String , IntegratedLoanListResponse>>fetchIntegratedLoans(
      String? requestUrl ,
      String? agentId ,
      String? branchId ,
      String? schemeCode ,
      String? accNo
      );
}
