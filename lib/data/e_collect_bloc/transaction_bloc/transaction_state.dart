part of 'transaction_bloc.dart';

abstract class TransactionState {
  const TransactionState();
}
//*******************PAYMENT-TRANSACTION************
class PaymentTransactionInitialState extends TransactionState{
  const PaymentTransactionInitialState();
}

class PaymentTransactionLoaderState extends TransactionState{
  const PaymentTransactionLoaderState();
}

class PaymentTransactionSuccessState extends TransactionState{
  const PaymentTransactionSuccessState();
}

class PaymentTransactionFailureState extends TransactionState{
  const PaymentTransactionFailureState();
}

//*******************SETTLEMENT-TRANSACTION************
class SettlementTransactionInitialState extends TransactionState{
  const SettlementTransactionInitialState();
}

class SettlementTransactionLoaderState extends TransactionState{
  const SettlementTransactionLoaderState();
}

class SettlementTransactionSuccessState extends TransactionState{
  const SettlementTransactionSuccessState();
}

class SettlementTransactionFailureState extends TransactionState{
  const SettlementTransactionFailureState();
}

/////////////////
class TransactionReportInitialState extends TransactionState{
  const TransactionReportInitialState();
}

class TransactionReportLoaderState extends TransactionState{
  const TransactionReportLoaderState();
}

class TransactionReportSuccessState extends TransactionState{
  final TransactionSuccessModel transactionSuccessModel;
  final double finalTotal;
  final int successCount;
  final int failCount;
  final int pendingCount;
  const TransactionReportSuccessState(this.transactionSuccessModel, this.finalTotal,  this.successCount,  this.failCount,   this.pendingCount);
}

class TransactionReportFailureState extends TransactionState{
  final TransactionFailModel transactionFailModel;
  const TransactionReportFailureState(this.transactionFailModel);
}