part of 'payment_bloc.dart';


abstract class PaymentEvent {}

class QrPaymentEvent extends PaymentEvent{
  final QrPaymentRequestModel qrPaymentRequestModel;
  QrPaymentEvent(this.qrPaymentRequestModel);
}

class LinkPaymentEvent extends PaymentEvent{
}