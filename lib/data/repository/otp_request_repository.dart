import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart'as http;

import '../../widgets/constants.dart';
import '../../domain/interface/otp_request_interface.dart';
import '../../domain/model/otp_request_model.dart';


class OtpRequestRepository implements OtpRequestInterface {
  @override
  Future<Either<String, OtpRequestResponse>> requestOtp(String mobnum) async {
    try {
      final uri = Uri.parse("${baseUrl}api/RequestOTP");

      final request = await http.post(
        uri,
        body: json.encode({
          "MobileNo":"+91$mobnum"
        }),
        headers: {'Content-Type': 'application/json'}
      );
      if(request.statusCode == 200){
        OtpRequestResponse otpRequestResponse = OtpRequestResponse.fromJson(jsonDecode(request.body));
        return Right(otpRequestResponse);
      }else{
        return const Left("ERROR");
      }
    } catch (e) {
      return const Left("ERROR");
    }
  }
}
