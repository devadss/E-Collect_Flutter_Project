import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants.dart';
import '../../../domain/model/parent_credential_model/parent_credential_model.dart';
import '../../../domain/model/subagent/fetch_parent_credentials/parent_agent_credentials.dart';
import '../../../domain/model/subagent/fetch_parent_credentials/parent_agent_credentila_fail.dart';

class ParentCredentialRepo {


  Future<ParentCredentialModel> fetchCredentials(String mobileNumber) async {
    final uri = Uri.parse(
        "${baseUrl}api/GetMerchantCardCredentials?phoneNumber=%2B91$mobileNumber");

    final request =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    if(request.statusCode == 200){
      return ParentCredentialSuccess(ParentAgentCredentialModel.fromJson(jsonDecode(request.body)));
    }else{
      return ParentCredentialFail(ParentAgentCredentialFailResponse.fromJson(jsonDecode(request.body)));
    }
  }
}