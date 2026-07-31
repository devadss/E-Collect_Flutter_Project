import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/core/constants.dart';
import '../../../../domain/model/e_collect/authentication_model.dart';
import '../../../../domain/model/e_collect/basic_registartion/basic_registration_failure_response.dart';
import '../../../../domain/model/e_collect/basic_registartion/basic_registration_success_response.dart';
import '../../../../domain/model/e_collect/basic_registartion/request/basic_registration_request_model.dart';
import '../../../../domain/model/e_collect/ifsc_model/ifsc_success_model.dart';
import '../../../../domain/model/e_collect/merchant_registation_model/merchant_registration_success.dart';
import '../../../../domain/model/e_collect/merchant_registation_model/merchat_registration_fail.dart';
import '../../../../domain/model/e_collect/merchant_registation_model/request/merchant_request_model.dart';
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
  final String _onBoardingEndPoint = "api/Merchant/register";
  final String _tokenValidationEndPoint = "api/Auth/validate-token";
  final String _ifscBranchApiUrl = "https://ifsc.razorpay.com/";
  final Map<String, String> contentType = {"Content-Type": "application/json"};

  ///*********************LOGIN******************************
  Future<void> mobLoginRepository() async {

  }

  ///*********************REQUEST-OTP******************************
  Future<AuthenticationModel> mobOtpRequestRepository(
      String mobileNumber) async {
    final Uri uri = Uri.parse("$eCollectBaseUrl$_requestOtpEndPoint");
    final http.Response request = await http.post(uri, body: jsonEncode({"mobileNumber": mobileNumber}), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body))) :
    OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************RESEND-OTP******************************
  Future<AuthenticationModel> mobOtpResendRepository(int id) async {
    final Uri uri = Uri.parse("$eCollectBaseUrl$_resendOtpEndPoint");
    final http.Response request = await http.post(uri,
        body: jsonEncode({"userId": id}), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? OtpRequestSuccessModel(
          OtpRequestSuccessResponse.fromJson(jsonDecode(request.body))) : OtpRequestFailureModel(
          OtpRequestErrorResponse.fromJson(jsonDecode(request.body)));
  }
  ///*********************OTP_VERIFICATION******************************
  Future<AuthenticationModel> mobOtpVerificationRepository(
      String mobileNumber, int id, String otp) async {
    final Uri uri = Uri.parse("$eCollectBaseUrl$_verifyOtpEndPoint");
    final http.Response request = await http.post(uri,
        body: jsonEncode(
            {"userId": id, "mobileNumber": mobileNumber, "otp": otp}),
        headers: contentType);
    print(request.body);
    print(uri);
    return request.statusCode != 200 ? OtpVerificationFailureModel(
          OtpVerificationErrorResponse.fromJson(jsonDecode(request.body))) : OtpVerificationSuccessModel(
          LoginResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************MERCHANT-ONBOARDING******************************
  Future<AuthenticationModel> merchantOnboardingRepository(MerchantRegistrationRequestModel merchantRegistrationRequestModel) async {
    final uri = Uri.parse("$eCollectBaseUrl$_onBoardingEndPoint");
    final request = await http.post(uri, body: jsonEncode(merchantRegistrationRequestModel),
    headers: {
      "Content-Type":"application/json"
    }
    );
    print(request.body);
    if(request.statusCode == 200){
      return OnboardOkModel(MerchantRegistrationSuccess.fromJson(jsonDecode(request.body)));
    }else{
      return OnboardFailModel(MerchantRegistrationFailResponse.fromJson(jsonDecode(request.body)));
    }

  }

  ///*********************MERCHANT-ONBOARDING-STATUS******************************
  Future<void> merchantOnboardingStatusRepository() async {}

  ///*********************BASIC-REGISTRATION******************************
  Future<AuthenticationModel> basicRegistrationRepository(
      BasicUserRegisterModel basicUserRegisterModel) async {
    final Uri uri = Uri.parse("$eCollectBaseUrl$_basicRegistrationEndPoint");
    final http.Response request = await http.post(uri,
        body: jsonEncode(basicUserRegisterModel), headers: contentType);
    print(request.body);
    return request.statusCode == 200 ? BasicRegistrationSuccessModel(
          BasicRegistrationSuccessResponse.fromJson(jsonDecode(request.body))) : BasicRegistrationFailureModel(
          BasicRegistrationErrorResponse.fromJson(jsonDecode(request.body)));
  }

  ///*********************TOKEN-VERIFICATION******************************
  Future<AuthenticationModel> tokenVerificationRepository(
      String tokenValue) async {
    final Uri uri = Uri.parse("$eCollectBaseUrl$_tokenValidationEndPoint");
    final http.Response request = await http.post(uri,
        body: jsonEncode({"token": tokenValue}), headers: contentType);
    return request.statusCode == 200
        ? TokenVerificationSuccessModel(
            TokenValidationSuccessResponse.fromJson(jsonDecode(request.body)))
        : TokenVerificationFailureModel(
            TokenValidationFailureResponse.fromJson(jsonDecode(request.body)));
  }


  ///*********************IFSC******************************
  Future<AuthenticationModel> ifscBranchRepository(
      String ifscCode) async {
    final Uri uri = Uri.parse("$_ifscBranchApiUrl$ifscCode");
    final http.Response request = await http.get(uri, headers: contentType);
    print(request.body);
    return request.statusCode == 200
        ? IfscCodeOkModel(
        BankIfscSuccessModel.fromJson(jsonDecode(request.body)))
        : IfscCodeFailModel(request.body);
  }

}
