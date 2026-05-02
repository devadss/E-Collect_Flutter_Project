import 'dart:convert';
import 'package:collection_qr_flutter/core/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../../domain/interface/otp_verification_interface.dart';
import '../../domain/model/otp_fail_model.dart';
import '../../domain/model/otp_verification_success.dart';



class OtpVerificationRepository implements OtpVerificationInterface {
  @override
  Future<Either<OtpFailModel, OtpSuccessModel>> verifyOtp(
      String mobnum, String otp) async {
    try {
      if(printStatementStatus){
        print("mobnum = $mobnum");
        print("otp = $otp");
      }

      final uri = Uri.parse("${baseUrl}api/VerifyOTPV1"); // Now we can use 2025 as the otp for verification.
      //final uri = Uri.parse("${baseUrl}api/VerifyOTP");
      final data = {'MobileNo': '+91$mobnum', 'OTp': otp};  // Fixed "OTp" key

      final request = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if(printStatementStatus){
        print("request = ${request.body}");
        print("request ststus code= ${request.statusCode}");
      }


      if (request.statusCode == 200) {
        final otpSuccessModel = OtpSuccessModel.fromJson(jsonDecode(request.body));
        return Right(otpSuccessModel);
      }
      else if(request.statusCode == 401){
        if(printStatementStatus){
          print("request.statusCode == 401");
        }

        final otpFailModel = OtpFailModel.fromJson(jsonDecode(request.body));
        return Left(otpFailModel);
      }
      else if(request.statusCode == 429){
        final otpfailmodel =OtpFailModel(message: "OTP Verification failed", status: "N");
        return Left(otpfailmodel);
      }
      else {
        // Handle all non-200 status codes with the same logic
        final otpfailmodel =OtpFailModel(message: "Multiple attempts please try again after some time", status: "N");
        return Left(otpfailmodel);
      }
    } catch (e) {
      if(printStatementStatus){
        print("Error: $e");
      }

      // Handle cases where JSON is invalid or any other exception occurs
      return Left(OtpFailModel.fromJson({"error": "Something went wrong"}));
    }
  }
}
/*class OtpVerificationRepository implements OtpVerificationInterface {
  @override
  Future<Either<OtpFailModel, OtpSuccessModel>> verifyOtp(
      String mobnum, String otp) async {
    try {
      print("mobnum = $mobnum");
      print("OTp = $otp");
      final uri = Uri.parse("${baseUrl}api/VerifyOTP");
      final data = {'MobileNo': '+91$mobnum', 'OTp': otp};

      final request = await http.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print("request = ${request.body}");
      if (request.statusCode == 200) {
        OtpSuccessModel otpSuccessModel = OtpSuccessModel.fromJson(jsonDecode(request.body));
        return Right(otpSuccessModel);
      }else {
        if(request.statusCode == 401){
          OtpFailModel otpFailModel = OtpFailModel.fromJson(jsonDecode(request.body));
          return Left(otpFailModel);
        }else{
          if(request.statusCode == 403){
            OtpFailModel otpFailModel = OtpFailModel.fromJson(jsonDecode(request.body));
            return Left(otpFailModel);
          }else{
            OtpFailModel otpFailModel = OtpFailModel.fromJson(jsonDecode(request.body));
            return Left(otpFailModel);
          }

        }
        
      }
    } catch (e) {
      OtpFailModel otpFailModel = OtpFailModel.fromJson(jsonDecode("ERROR"));
      return Left(otpFailModel);
    }
  }
}*/
