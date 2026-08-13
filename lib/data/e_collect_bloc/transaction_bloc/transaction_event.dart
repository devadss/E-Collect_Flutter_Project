part of 'transaction_bloc.dart';
abstract class TransactionEvent {
  const TransactionEvent();
}

class GetTransactionByMerchant extends TransactionEvent{
  final String merchantID;
  const GetTransactionByMerchant(this.merchantID);
}
// class GetTransactionByMerchantDateRange extends TransactionEvent{
//   final String merchantID;
//   final String fromDate;
//   final String toDate;
//   const GetTransactionByMerchantDateRange(this.merchantID, this.fromDate, this.toDate);
// }

class GetTransactionByMerchantDateWithStatus extends TransactionEvent{
  final String merchantID;
  final String fromDate;
  final String toDate;
  final String status;
  const GetTransactionByMerchantDateWithStatus(this.merchantID, this.fromDate, this.toDate, this.status);
}

// class GetTransactionByMerchantDate extends TransactionEvent{
//   final String merchantID;
//   final String fromDate;
//   final String toDate;
//   const GetTransactionByMerchantDateWithStatus(this.merchantID, this.fromDate, this.toDate);
// }


class SettlementTransactionEvent extends TransactionEvent{
  const SettlementTransactionEvent();
}