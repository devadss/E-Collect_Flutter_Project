import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/model/non_integarted_loan_list_due.dart';
import '../../../domain/model/non_integrated/loan_all_data/complete_loanlist.dart';
import '../../../domain/model/non_integrated/non_integrated_model.dart';

class NonIntegratedRepository {
  Future<NonIntegratedModel> fetchAllNonIntegratedLoanList(
      String endPoint,
      String branchCode,
      String productType,
      String agentCode,
      String searchKeyWord) async {
    final uri =
        Uri.parse("$endPoint?branchCode=$branchCode&productType=$productType");
    final request =
        await http.get(uri, headers: {"Content-Type": "application/json"});

    print("$endPoint?branchCode=$branchCode&productType=$productType");
    if (request.statusCode == 200) {
      return CompleteLoanListNonIntegratedSuccess(
          CompleteLoanLisResponse.fromJson(jsonDecode(request.body)));
    } else {
      return CompleteLoanListNonIntegratedFail(request.body);
    }
  }

  Future<NonIntegratedModel> fetchNonintegratedDueLoanList(
      String endPoint,
      String agentCode,
      String branchCode,
      String productType,
      int pageNo,
      int pageSize,
      String agentCodeRoute) async {
    final uri = Uri.parse(
        "$endPoint?agentCode=$agentCode&branchCode=$branchCode&productType=$productType&page=$pageNo&pageSize=$pageSize");
    final request =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    print(
        "$endPoint?agentCode=$agentCode&branchCode=$branchCode&productType=$productType&page=$pageNo&pageSize=$pageSize");
    if (request.statusCode == 200) {
      return DueLoanListNonIntegratedSuccess(
          NonIntegratedLoanDueList.fromJson(jsonDecode(request.body)));
    } else {
      return DueLoanListNonIntegratedFail(request.body);
    }
  }
}
