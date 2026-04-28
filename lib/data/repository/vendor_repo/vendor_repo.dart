
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants.dart';
import '../../../domain/model/vendor_model/vendor_model.dart';
import '../../../domain/model/vendor_model/vendor_model_success.dart';

class VendorRepo {

  Future<VendorModel> fetchVendorUrl(String mobNum) async {
    mobNum.startsWith("+91") ?mobNum.replaceAll("+91", "") : mobNum;
    final url = Uri.parse("$dopBaseUrl$mobNum");
    final response = await http.get(url);

    if(response.statusCode ==  200){
      return VendorSuccessModel(VendorSuccessResponse.fromJson(jsonDecode(response.body)));
    }else{
      return VendorFailModel("error");
    }
  }
}