
part of 'payment_bloc.dart';

abstract class PaymentState {
  const PaymentState();
}

class QrPaymentInitialState extends PaymentState{
  const QrPaymentInitialState();
}

class QrPaymentLoaderState extends PaymentState{
  const QrPaymentLoaderState();
}

class QrPaymentSuccessState extends PaymentState{
  final QrPaymentSuccess qrPaymentSuccess;
  const QrPaymentSuccessState(this.qrPaymentSuccess);
}

class QrPaymentFailState extends PaymentState{
  final QrPaymentFail qrPaymentFail;
  const QrPaymentFailState(this.qrPaymentFail);
}

// *****************************************************
class LinkPaymentInitialState extends PaymentState{
  const LinkPaymentInitialState();
}

class LinkPaymentLoaderState extends PaymentState{
  const LinkPaymentLoaderState();
}

class LinkPaymentSuccessState extends PaymentState{
  const LinkPaymentSuccessState();
}

class LinkPaymentFailState extends PaymentState{
  const LinkPaymentFailState();
}
//------------
class CashPaymentInitialState extends PaymentState{
  const CashPaymentInitialState();
}

class CashPaymentLoaderState extends PaymentState{
  const CashPaymentLoaderState();
}

class CashPaymentSuccessState extends PaymentState{
  final CashPaymentSuccess cashPaymentSuccess;
  const CashPaymentSuccessState(this.cashPaymentSuccess);
}

class CashPaymentFailState extends PaymentState{
  final CashPaymentFail cashPaymentFail;
  const CashPaymentFailState(this.cashPaymentFail);
}
