
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:collection_qr_flutter/core/constants.dart';
import '../../../domain/model/complaint/complaint_track/complaint_track_resposne.dart';
import '../../../domain/model/complaint/complaint_track/complaint_track_success.dart';

class ComplaintTrackRepository {

  Future<ComplaintTrackResponse> trackComplaint(String complaintID) async {
    final Uri uri = Uri.parse(baseUrl);
    final request = await http.post(uri,
    body: jsonEncode({
      "complaintId":complaintID
    }),
      headers: {
      "Content-Type":"application/json"
      }
    );
    if(request.statusCode == 200){
      return ComplaintTrackSuccess(ComplaintTrackSuccessResponse.fromJson(jsonDecode(request.body)));
    }else{
      return CompliantTrackFail(request.body.toString());
    }
  }
}