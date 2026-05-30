import 'package:collection_qr_flutter/core/utils.dart';
import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/core/constants.dart';

import '../../data/storage/shared_pref_helper.dart';

//This class will be used for all api request

class ApiService {
  final String _baseUrl;

  ApiService(this._baseUrl);

// A header without token
  Map<String, String> _headers() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};

  //A common api get request
  Future<dynamic> getApiData(String endPoint) async {
    if (printStatementStatus) {
      print("Inside ApiService");
    }
    var mobnum = await SharedPref.shared.getParentAgentMobNum();
    isRunningLiveBaseUrl(true, mobnum);
    isRunningLiveDopBaseUrl(true, mobnum);
    // final uri = Uri.parse("$_baseUrl$endPoint");
    final uri = Uri.parse("$baseUrl$endPoint");
    if (printStatementStatus) {
      // print("$_baseUrl$endPoint");
      print("$baseUrl$endPoint");
    }

    final response = await http.get(uri, headers: _headers());
    if (printStatementStatus) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }
}
