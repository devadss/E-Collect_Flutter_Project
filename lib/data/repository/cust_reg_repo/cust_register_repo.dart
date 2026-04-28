
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants.dart';
import '../../../domain/model/cust_register_model/cust_register_model.dart';
import '../../../domain/model/cust_register_model/cust_register_success_model.dart';

class CustRegisterRepo {

  Future<CustRegisterModel> checkCustRegister(String mobNum) async {
    final uri = Uri.parse("${baseUrl}api/RegisteredCust");
    final data = {'MobileNo': '+91$mobNum'};

    final response = await http.post(
      uri,
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200){
      return CustRegisterSuccess(RegistedCustomer.fromJson(jsonDecode(response.body)));
    }else{
      return CustRegisterFail("error");
    }
  }
}