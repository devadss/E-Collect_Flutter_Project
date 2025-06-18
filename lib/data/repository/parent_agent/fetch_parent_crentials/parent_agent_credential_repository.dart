import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/sub_agent/fetch_parent_credential_interface/parent_agent_crential_interface.dart';
import 'package:collection_qr_flutter/domain/model/subagent/fetch_parent_credentials/parent_agent_credentials.dart';
import 'package:collection_qr_flutter/domain/model/subagent/fetch_parent_credentials/parent_agent_credentila_fail.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ParentAgentCredentialRepository
    implements ParentAgentCredentialInterface {
  @override
  Future<Either<ParentAgentCredentialFailResponse, ParentAgentCredentialModel>>
      fetchParentAgentCredentials(String mobileNumber) async {
    final uri = Uri.parse(
        "${baseUrl}api/GetMerchantCardCredentials?phoneNumber=%2B91$mobileNumber");
    print("uri $uri");
    final request =
        await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (request.statusCode == 200) {
      return Right(
          ParentAgentCredentialModel.fromJson(jsonDecode(request.body)));
    } else {
      return Left(
          ParentAgentCredentialFailResponse.fromJson(jsonDecode(request.body)));
    }
  }
}
