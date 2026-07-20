import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class PaymentTransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  PaymentTransactionBloc() : super(PaymentTransactionInitialState()) {
    on<PaymentTransactionEvent>((event, emit) {});
    on<SettlementTransactionEvent>((event, emit) {});
  }
}
