import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/core/constants.dart';

//This class will be used for all api request

class ApiService {
  final String  _baseUrl;

  ApiService(this._baseUrl);

// A header without token
  Map<String, String> _headers() => {'Content-Type': 'application/json', 'Accept': 'application/json'};

  //A common api get request
  Future<dynamic> getApiData(String endPoint) async {
    print("Inside ApiService");
    final uri = Uri.parse("$_baseUrl$endPoint");
    print("$_baseUrl$endPoint");
    final response = await http.get(uri, headers: _headers());
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }
}
