import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../../../../core/utils.dart';
import '../../../../domain/model/agent_customer_details_model.dart';
import '../../../../domain/model/customer_list_model/customer_list_fail_model.dart';
import '../../../../domain/model/customer_list_model/customer_list_model.dart';
import '../../../../domain/model/customer_list_model/customer_list_success.dart';
import '../../../../domain/model/integrated_loan_detail_model.dart';
import '../../../../domain/model/integrated_loan_list_model.dart';
import '../../../customer_list_bloc/customer_list_bloc.dart';

class CustomerListRepo {
  Future<CustomerListModel> fetchCustList(String baseUrl, String agentId,
      String branchId, String pageNo, String pageSize, String custName) async {
    final vendorUrl = baseUrl;
    //final uri = Uri.parse("https://doorstepmeenachilmscs.digicob.in/getRdclCustomerunderAgentList");
    final uri = Uri.parse(vendorUrl);
    final request = await http.post(uri,
        body: jsonEncode({
          "agent_id": agentId,
          "branch_id": branchId,
          "PageNumber": pageNo,
          "PageSize": pageSize,
          "cust_name": custName
        }),
        headers: {"Content-Type": "application/json"});
    if (printStatementStatus) {
      print(uri);
      print({
        "agent_id": agentId,
        "branch_id": branchId,
        "PageNumber": pageNo,
        "PageSize": pageSize,
        "cust_name": custName
      });
      print(request.body);
    }

    if (request.statusCode == 200) {
      final successResponse = await compute(parseCustomerSuccess, request.body);

      return CustomerListSuccessModel(successResponse);
      return CustomerListSuccessModel(
          CustomerListSuccessResponse.fromJson(jsonDecode(request.body)));
    } else {
      return CustomerListFailModel(
          CustomerListFailResponse.fromJson(jsonDecode(request.body)));
    }
  }

  Future<CustomerListModel> fetchRdCustList(
    String baseUrl,
    String agentId,
    String branchId,
  ) async {
    final uri = Uri.parse(baseUrl);
    final response = await http.post(uri,
        body: json.encode({
          "agent_id": agentId,
          "branch_id": branchId,
          "PageNumber": 0,
          "PageSize": 0,
          "cust_name": ""
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return RdCustomerListSuccessModel(
          AgentCustomerDetailsModel.fromJson(jsonDecode(response.body)));
    } else {
      return RdCustomerListFailModel(response.body);
    }
  }

  Future<CustomerListModel> fetchLoanCutomerList(
    String baseUrl,
    String agentId,
    String branchId,
    String schemeCode,
    String accNo,
  )
  async {
    final uri = Uri.parse(baseUrl);
    final data = await http.post(uri,
        body: jsonEncode({
          "agent_id": agentId,
          "branch_id": branchId,
          "sch_code": schemeCode,
          "acno": accNo
        }),
        headers: {"Content-Type": "application/json"});

    if (data.statusCode == 200) {
      return LoanCustomerListSuccessModel(
          IntegratedLoanListResponse.fromJson(jsonDecode(data.body)));
    } else {
      return LoanCustomerListFailModel(data.body);
    }
  }


  Future<CustomerListModel> fetchLoanDetailList(
      String baseUrl,
      String flag,
      String branchId,
      String schemeCode,
      String demandDate,
      String accountNumber,
      ) async {
    final uri = Uri.parse(baseUrl);
    final data = await http.post(uri,
        body: jsonEncode({
          "flag": flag,
          "branch_id": branchId,
          "sch_code": schemeCode,
          "demandDate": demandDate,
          "account_no": accountNumber
        }),
        headers: {"Content-Type": "application/json"});

    print(data.body);
    print({
      "flag": flag,
      "branch_id": branchId,
      "sch_code": schemeCode,
      "demandDate": demandDate,
      "account_no": accountNumber
    });
    if (data.statusCode == 200) {
      return LoanDetailListSuccessModel(IntegratedLoanDetails.fromJson(jsonDecode(data.body)));
    } else {
      return LoanDetailListFailModel(data.body);
    }
  }
}
