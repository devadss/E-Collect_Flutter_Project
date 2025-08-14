import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../../domain/interface/aadhaar_detial_otp_interface.dart';
import '../../domain/model/aadhaar_detail_otp_response.dart';
import '../../domain/model/aadhaar_otp_request_fail_model.dart';

class AadhaarOtpRequestRepository implements AadhaarOtpRequestInterface{
  @override
  Future<Either<AadhaarOtpRequestFailModel, AadhaarDetailOtpRequestModel>> verifyAadhaarNumber(String? aadhaarNumber) async {
    final uri = Uri.parse("${baseUrl}api/SendAadhaarOtp");
    final request = await http.post(uri ,
    body: jsonEncode({
      "aadhaar_number":aadhaarNumber
    }),
    headers: {'Content-Type': 'application/json'
    }

    );
    print("AadhaarOtpRequestRepository : ${request.body}");
    if(request.statusCode == 200){
      return Right(AadhaarDetailOtpRequestModel.fromJson(jsonDecode(request.body)));
    }else{
      return Left(AadhaarOtpRequestFailModel.fromJson(jsonDecode(request.body)));
    }
  }
  
}