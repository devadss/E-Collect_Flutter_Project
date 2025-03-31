import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/otp_request_interface.dart';
import 'package:collection_qr_flutter/domain/model/otp_request_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class OtpRequestRepository implements OtpRequestInterface {
  @override
  Future<Either<String, OtpRequestResponse>> requestOtp(String mobnum) async {
    try {
      final uri = Uri.parse("${baseUrl}api/RequestOTP");
      bool checkConnection = await InternetConnectionChecker().hasConnection;
      if (checkConnection == true) {
        final request = await http.post(uri,
            body: json.encode({"MobileNo": "+91$mobnum"}),
            headers: {'Content-Type': 'application/json'});
        if (request.statusCode == 200) {
          OtpRequestResponse otpRequestResponse =
              OtpRequestResponse.fromJson(jsonDecode(request.body));
          return Right(otpRequestResponse);
        } else {
          return const Left("ERROR");
        }
      } else {
        return const Left("CHECK INTERNET CONNECTION");
      }
    } catch (e) {
      return const Left("ERROR");
    }
  }
}
