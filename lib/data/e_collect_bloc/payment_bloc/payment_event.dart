part of 'payment_bloc.dart';


abstract class PaymentEvent {}

class QrPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel qrPaymentRequestModel;
  final String eCollectToken;
  QrPaymentEvent(this.qrPaymentRequestModel, this.eCollectToken);
}

class LinkPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel linkPaymentRequestModel;
  final String eCollectToken;
  LinkPaymentEvent(this.linkPaymentRequestModel, this.eCollectToken);
}

class CashPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel cashPaymentRequestModel;
  final String eCollectToken;
  CashPaymentEvent(this.cashPaymentRequestModel, this.eCollectToken);
}