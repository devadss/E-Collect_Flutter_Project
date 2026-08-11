import 'dart:convert';

import '../../../../domain/model/e_collect/payment/cash/cash_model.dart';
import '../../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/model/e_collect/payment/response/payment_qr_response.dart';
import '../../../../domain/model/e_collect/payment/response/payment_response_fail.dart';
import '../../../../domain/model/e_collect/payment/response/payment_response_success.dart';
class PaymentRepository {
  
  Future<PaymentResponse> qrPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel) async {
    final uri = Uri.parse("https://dev.collect.org.in/api/payment/UpiIntent");
    final data = await http.post(uri,

    body: jsonEncode(qrPaymentRequestModel),
      headers: {
      "Content-Type":"application/json"
      }
    );
    print(jsonEncode(qrPaymentRequestModel));
    print("PAYMENT RES: ${data.body}");
    if(data.statusCode == 200){
      return QrPaymentSuccess(PaymentResponseSuccess.fromJson(jsonDecode(data.body)));
    }else{
      return QrPaymentFail(PaymentFailResponse.fromJson(jsonDecode(data.body)));
    }
    
  }

  Future<PaymentResponse> linkPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel) async {
    final uri = Uri.parse("https://dev.collect.org.in/api/payment/PaymentLink");
    final data = await http.post(uri,

        body: jsonEncode(qrPaymentRequestModel),
        headers: {
          "Content-Type":"application/json"
        }
    );
    print(jsonEncode(qrPaymentRequestModel));
    print("PAYMENT RES: ${data.body}");
    if(data.statusCode == 200){
      return QrPaymentSuccess(PaymentResponseSuccess.fromJson(jsonDecode(data.body)));
    }else{
      return QrPaymentFail(PaymentFailResponse.fromJson(jsonDecode(data.body)));
    }

  }

  Future<PaymentResponse> cashPaymentApiIntentCall(QrPaymentRequestModel qrPaymentRequestModel) async {
    final uri = Uri.parse("https://dev.collect.org.in/api/payment/Cash_Collection");
    final data = await http.post(uri,

        body: jsonEncode(qrPaymentRequestModel),
        headers: {
          "Content-Type":"application/json"
        }
    );
    print(jsonEncode(qrPaymentRequestModel));
    print("PAYMENT RES: ${data.body}");
    if(data.statusCode == 200){
      return CashPaymentSuccess(CashPaymentSuccessResponse.fromJson(jsonDecode(data.body)));
    }else{
      return CashPaymentFail(data.body);
    }

  }

}