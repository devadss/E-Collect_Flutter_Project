part of 'transaction_bloc.dart';
abstract class TransactionEvent {
  const TransactionEvent();
}

class PaymentTransactionEvent extends TransactionEvent{
  const PaymentTransactionEvent();
}

class SettlementTransactionEvent extends TransactionEvent{
  const SettlementTransactionEvent();
}