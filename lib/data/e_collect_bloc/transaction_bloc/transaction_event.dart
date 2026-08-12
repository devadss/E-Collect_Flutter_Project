part of 'transaction_bloc.dart';
abstract class TransactionEvent {
  const TransactionEvent();
}

class GetTransactionByMerchant extends TransactionEvent{
  final String merchantID;
  const GetTransactionByMerchant(this.merchantID);
}
class GetTransactionByMerchantDateRange extends TransactionEvent{
  final String merchantID;
  final String fromDate;
  final String toDate;
  const GetTransactionByMerchantDateRange(this.merchantID, this.fromDate, this.toDate);
}
class SettlementTransactionEvent extends TransactionEvent{
  const SettlementTransactionEvent();
}