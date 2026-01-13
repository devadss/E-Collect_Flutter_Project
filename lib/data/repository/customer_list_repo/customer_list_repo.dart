import 'dart:convert';

import '../../../domain/model/customer_list_model/customer_list_fail_model.dart';
import '../../../domain/model/customer_list_model/customer_list_model.dart';
import 'package:http/http.dart'as http;

import '../../../domain/model/customer_list_model/customer_list_success.dart';

class CustomerListRepo {

  Future<CustomerListModel> fetchCustList(
      String agentId, String branchId, String pageNo, String pageSize , String custName
      ) async {
    final uri = Uri.parse("https://doorstepmeenachilmscs.digicob.in/getRdclCustomerunderAgentList");
    final request = await http.post(uri, body: jsonEncode({"agent_id": agentId,
      "branch_id": branchId, "PageNumber": pageNo, "PageSize": pageSize, "cust_name":custName}
    ),
    headers: {"Content-Type":"application/json"}
    );
    print(request.body);
    if(request.statusCode == 200){
      return CustomerListSuccessModel(CustomerListSuccessResponse.fromJson(jsonDecode(request.body)));
    }else{
      return CustomerListFailModel(CustomerListFailResponse.fromJson(jsonDecode(request.body)));
    }
  }
  
}