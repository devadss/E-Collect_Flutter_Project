part of 'payment_bloc.dart';


abstract class PaymentEvent {}

class QrPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel qrPaymentRequestModel;
  QrPaymentEvent(this.qrPaymentRequestModel);
}

class LinkPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel linkPaymentRequestModel;
  LinkPaymentEvent(this.linkPaymentRequestModel);
}

class CashPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel cashPaymentRequestModel;
  CashPaymentEvent(this.cashPaymentRequestModel);
}