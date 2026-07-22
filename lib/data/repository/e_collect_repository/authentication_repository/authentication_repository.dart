import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/core/constants.dart';
import '../../../../domain/model/e_collect/authentication_model.dart';
import '../../../../domain/model/e_collect/basic_registartion/basic_registration_failure_response.dart';
import '../../../../domain/model/e_collect/basic_registartion/basic_registration_success_response.dart';
import '../../../../domain/model/e_collect/basic_registartion/request/basic_registration_request_model.dart';
import '../../../../domain/model/e_collect/otp_request/otp_request_fail.dart';
import '../../../../domain/model/e_collect/otp_request/otp_request_success.dart';
import '../../../../domain/model/e_collect/otp_verification/otp_verification_fail.dart';
import '../../../../domain/model/e_collect/otp_verification/otp_verification_success.dart';

class AuthenticationRepository {
  ///*********************LOGIN******************************
  Future<void> mobLoginRepository() async {}
  ///*********************REQUEST-OTP******************************
  Future<AuthenticationModel> mobOtpRequestRepository(
      String mobileNumber) async {
    final uri = Uri.parse("${eCollectBaseUrl}api/Auth/request-otp");
    final request = await http.post(uri,
        body: jsonEncode({"mobileNumber": mobileNumber}),
        headers: {"Content-Type": "application/json"});
    print(request.body);
    if (request.statusCode == 200) {
      return OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body)));
    } else {
      return OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
    }
  }
  ///*********************RESEND-OTP******************************
  Future<AuthenticationModel> mobOtpResendRepository(int id) async {
    final uri = Uri.parse("${eCollectBaseUrl}api/Auth/resend-otp");
    final request = await http.post(uri,
        body: jsonEncode({"userId": id}),
        headers: {"Content-Type": "application/json"});
    print(request.body);
    if (request.statusCode == 200) {
      return OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body)));
    } else {
      return OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
    }
  }
   ///*********************OTP_VERIFICATION******************************
  Future<AuthenticationModel> mobOtpVerificationRepository(
      String mobileNumber, int id, String otp) async {
    final uri = Uri.parse("${eCollectBaseUrl}api/Auth/verify-otp");
    final request = await http.post(uri,
        body: jsonEncode(
            {"userId": id, "mobileNumber": mobileNumber, "otp": otp}),
        headers: {"Content-Type": "application/json"});
    print(request.body);
    if (request.statusCode == 200) {
      return OtpVerificationSuccessModel(
          LoginResponse.fromJson(jsonDecode(request.body)));
    } else {
      return OtpVerificationFailureModel(
          OtpVerificationErrorResponse.fromJson(jsonDecode(request.body)));
    }
  }
  ///*********************MERCHANT-ONBOARDING******************************
  Future<void> merchantOnboardingRepository() async {}
  ///*********************MERCHANT-ONBOARDING-STATUS******************************
  Future<void> merchantOnboardingStatusRepository() async {}
  ///*********************BASIC-REGISTRATION******************************
  Future<AuthenticationModel> basicRegistrationRepository(
      BasicUserRegisterModel basicUserRegisterModel) async {
    final uri = Uri.parse("${eCollectBaseUrl}api/Auth/register");
    final request = await http.post(uri,
        body: jsonEncode(basicUserRegisterModel),
        headers: {"Content-Type": "application/json"});
    print(request.body);
    if (request.statusCode == 200) {
      return BasicRegistrationSuccessModel(
          BasicRegistrationSuccessResponse.fromJson(jsonDecode(request.body)));
    } else {
      return BasicRegistrationFailureModel(
          BasicRegistrationErrorResponse.fromJson(jsonDecode(request.body)));
    }
  }
//--------------------------------------------------------------

}
