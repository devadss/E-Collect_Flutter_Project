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
import '../../../../domain/model/e_collect/token_validation/token_validation_fail.dart';
import '../../../../domain/model/e_collect/token_validation/token_validation_success.dart';

class AuthenticationRepository {
  final String _requestOtpEndPoint = "api/Auth/request-otp";
  final String _resendOtpEndPoint = "api/Auth/resend-otp";
  final String _verifyOtpEndPoint = "api/Auth/verify-otp";
  final String _basicRegistrationEndPoint = "api/Auth/register";
  final String _tokenValidationEndPoint = "api/Auth/validate-token";
  final Map<String, String> contentType = {"Content-Type": "application/json"};

  ///*********************LOGIN******************************
  Future<void> mobLoginRepository() async {}

  ///*********************REQUEST-OTP******************************
  Future<AuthenticationModel> mobOtpRequestRepository(
      String mobileNumber) async {
    final uri = Uri.parse("$eCollectBaseUrl$_requestOtpEndPoint");
    final request = await http.post(uri,
        body: jsonEncode({"mobileNumber": mobileNumber}), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body))) :
    OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************RESEND-OTP******************************
  Future<AuthenticationModel> mobOtpResendRepository(int id) async {
    final uri = Uri.parse("$eCollectBaseUrl$_resendOtpEndPoint");
    final request = await http.post(uri,
        body: jsonEncode({"userId": id}), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body))) : OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
  }
  ///*********************OTP_VERIFICATION******************************
  Future<AuthenticationModel> mobOtpVerificationRepository(
      String mobileNumber, int id, String otp) async {
    final uri = Uri.parse("$eCollectBaseUrl$_verifyOtpEndPoint");
    final request = await http.post(uri,
        body: jsonEncode(
            {"userId": id, "mobileNumber": mobileNumber, "otp": otp}),
        headers: contentType);
    print(request.body);
    return request.statusCode != 200 ? OtpVerificationFailureModel(
          OtpVerificationErrorResponse.fromJson(jsonDecode(request.body))) : OtpVerificationSuccessModel(
          LoginResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************MERCHANT-ONBOARDING******************************
  Future<void> merchantOnboardingRepository() async {}

  ///*********************MERCHANT-ONBOARDING-STATUS******************************
  Future<void> merchantOnboardingStatusRepository() async {}

  ///*********************BASIC-REGISTRATION******************************
  Future<AuthenticationModel> basicRegistrationRepository(
      BasicUserRegisterModel basicUserRegisterModel) async {
    final uri = Uri.parse("$eCollectBaseUrl$_basicRegistrationEndPoint");
    final request = await http.post(uri,
        body: jsonEncode(basicUserRegisterModel), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? BasicRegistrationSuccessModel(
          BasicRegistrationSuccessResponse.fromJson(jsonDecode(request.body))) : BasicRegistrationFailureModel(
          BasicRegistrationErrorResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************TOKEN-VERIFICATION******************************
  Future<AuthenticationModel> tokenVerificationRepository(
      String tokenValue) async {
    final uri = Uri.parse("$eCollectBaseUrl$_tokenValidationEndPoint");
    final request = await http.post(uri,
        body: jsonEncode({"token": tokenValue}), headers: contentType);
    return request.statusCode == 200
        ? TokenVerificationSuccessModel(
            TokenValidationSuccessResponse.fromJson(jsonDecode(request.body)))
        : TokenVerificationFailureModel(
            TokenValidationFailureResponse.fromJson(jsonDecode(request.body)));
  }
}
