import 'package:e_Collect/domain/model/e_collect/payment/response/payment_response_fail.dart';
import 'package:e_Collect/domain/model/e_collect/payment/response/payment_response_success.dart';

import '../cash/cash_model.dart';

sealed class PaymentResponse {}

class QrPaymentSuccess extends PaymentResponse{
  final PaymentResponseSuccess paymentResponseSuccess;
  QrPaymentSuccess(this.paymentResponseSuccess);
}

class QrPaymentFail extends PaymentResponse{
  final PaymentFailResponse paymentFailResponse;
  QrPaymentFail(this.paymentFailResponse);
}

class CashPaymentSuccess extends PaymentResponse{
  final CashPaymentSuccessResponse cashPaymentSuccessResponse;
  CashPaymentSuccess(this.cashPaymentSuccessResponse);
}

class CashPaymentFail  extends PaymentResponse{
  final String payemtError;
  CashPaymentFail(this
  .payemtError);
}

