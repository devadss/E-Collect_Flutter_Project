import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../core/constants.dart';
import 'package:http/http.dart' as http;

import '../../domain/interface/verify_aadhaar_detail_interface.dart';
import '../../domain/model/aadhaar_otp_request_fail_model.dart';
import '../../domain/model/verify_aadhaar_model.dart';


class VerifyAadhaarDetailRepository implements VerifyAadhaarDetailInterface {
  @override
  Future<Either<AadhaarOtpRequestFailModel, VerifyAadhaarDetailsModel>> getAadhaarDetails(
      String otp, String refId, String vendorCode, String custId) async {
    final uri = Uri.parse("${baseUrl}api/verifyAadhaarOtp");
    final request = await http.post(
      uri,
      body: jsonEncode({"Otp": otp, "RefId": refId, "VendorCode": vendorCode, "Cust_id":custId}),
      headers: {'Content-Type': 'application/json'},
    );
    print("RefId : $refId");
    print("vendorCode : $vendorCode");
    print("VerifyAadhaarDetailRepository : ${request.body}");
    if (request.statusCode == 200) {
      return Right(
          VerifyAadhaarDetailsModel.fromJson(jsonDecode(request.body)));
    } else {
      return Left(AadhaarOtpRequestFailModel.fromJson(jsonDecode(request.body)));
    }
  }
}
