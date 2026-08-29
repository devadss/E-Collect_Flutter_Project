import 'dart:convert';

import '../../../../core/constants.dart';
import '../../../../domain/model/e_collect/payment/cash/cash_model.dart';
import '../../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/model/e_collect/payment/response/payment_qr_response.dart';
import '../../../../domain/model/e_collect/payment/response/payment_response_fail.dart';
import '../../../../domain/model/e_collect/payment/response/payment_response_success.dart';
class PaymentRepository {
  final String baseURL = eCollectBaseUrl;
  final String qrEndpoint = "api/payment/UpiIntent";
  final String linkEndpoint = "api/payment/PaymentLink";
  final String cashEndpoint = "api/payment/Cash_Collection";
  Future<PaymentResponse> qrPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel, String eCollectToken) async {

    final uri = Uri.parse("$baseURL$qrEndpoint");
    final data = await http.post(uri,

    body: jsonEncode(qrPaymentRequestModel),
      headers: {
        'Authorization':"Bearer $eCollectToken",
        "Content-Type":"application/json"
      }
    );
    print("eCollectToken $eCollectToken");
    print("PAYMENT body: ${jsonEncode(qrPaymentRequestModel)}");
    print("PAYMENT RES: ${data.body}");
    print("PAYMENT QR CALL");
    if(data.statusCode == 200){
      return QrPaymentSuccess(PaymentResponseSuccess.fromJson(jsonDecode(data.body)));
    }else{
      return QrPaymentFail(PaymentFailResponse.fromJson(jsonDecode(data.body)));
    }
    
  }

  Future<PaymentResponse> linkPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel,String eCollectToken) async {
    final uri = Uri.parse("$baseURL$linkEndpoint");
    final data = await http.post(uri,

        body: jsonEncode(qrPaymentRequestModel),
        headers: {
          'Authorization':"Bearer $eCollectToken",
          "Content-Type":"application/json"
        }
    );
    print(jsonEncode(qrPaymentRequestModel));
    print("PAYMENT RES: ${data.body}");
    print("PAYMENT LINK CALL");
    if(data.statusCode == 200){
      return QrPaymentSuccess(PaymentResponseSuccess.fromJson(jsonDecode(data.body)));
    }else{
      return QrPaymentFail(PaymentFailResponse.fromJson(jsonDecode(data.body)));
    }

  }

  Future<PaymentResponse> cashPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel,String eCollectToken) async {
    final uri = Uri.parse("$baseURL$cashEndpoint");
    final data = await http.post(uri,

        body: jsonEncode(qrPaymentRequestModel),
        headers: {
          'Authorization':"Bearer $eCollectToken",
          "Content-Type":"application/json"
        }
    );
    print(jsonEncode(qrPaymentRequestModel));
    print("PAYMENT RES: ${data.body}");
    print("PAYMENT CASH CALL");
    if(data.statusCode == 200){
      return CashPaymentSuccess(CashPaymentSuccessResponse.fromJson(jsonDecode(data.body)));
    }else{
      return CashPaymentFail(data.body);
    }

  }

}