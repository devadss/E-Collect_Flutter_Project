import 'dart:convert';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:http/http.dart' as http;
import '../../../domain/model/complaint/complaint_request_model/complaint_request_model.dart';
import '../../../domain/model/complaint/complaint_resposne/complaint_success_resposne.dart';
import '../../../domain/model/complaint/complaint_resposne/compliant_response.dart';

class ComplaintRegisterRepository {
  Future<CompliantResponse> registerComplaint(
      ComplaintRequest complaintRequest) async {
    final Uri uri = Uri.parse(baseUrl);
    var request = await http.post(uri,
        body: jsonEncode(complaintRequest),
        headers: {"Content-Type": "application/json"});

    if (request.statusCode == 200) {
      return ComplaintResponseSuccess(
          ComplaintResponse.fromJson(jsonDecode(request.body)));
    } else {
      return ComplaintResponseFail(request.body.toString());
    }
  }
}
