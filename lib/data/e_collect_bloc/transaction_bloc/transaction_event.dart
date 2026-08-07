part of 'transaction_bloc.dart';
abstract class TransactionEvent {
  const TransactionEvent();
}

class GetTransactionByMerchant extends TransactionEvent{
  final String merchantID;
  const GetTransactionByMerchant(this.merchantID);
}

class SettlementTransactionEvent extends TransactionEvent{
  const SettlementTransactionEvent();
}