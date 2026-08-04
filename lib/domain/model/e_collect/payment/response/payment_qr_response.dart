import 'package:collection_qr_flutter/domain/model/e_collect/payment/response/payment_response_fail.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/payment/response/payment_response_success.dart';

sealed class PaymentResponse {}

class QrPaymentSuccess extends PaymentResponse{
  final PaymentResponseSuccess paymentResponseSuccess;
  QrPaymentSuccess(this.paymentResponseSuccess);
}

class QrPaymentFail extends PaymentResponse{
  final PaymentFailResponse paymentFailResponse;
  QrPaymentFail(this.paymentFailResponse);
}


