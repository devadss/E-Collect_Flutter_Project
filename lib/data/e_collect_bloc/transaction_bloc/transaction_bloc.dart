import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/e_collect/transaction_report/transaction_report.dart';
import '../../repository/e_collect_repository/transation_report/transaction_reposrt_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class PaymentTransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionReportRepository reportRepository;
  PaymentTransactionBloc(this.reportRepository)
      : super(PaymentTransactionInitialState()) {
    on<GetTransactionByMerchant>((event, emit) async {

      final data = await reportRepository.getTransactionReportByMerchantId(event.merchantID);
      if (data is TransactionSuccessModel) {
        var newTotal = 0.0;
        var totalSuccessTransactionCount = 0;
        var totalPendingTransactionCount = 0;
        var totalFailedTransactionCount = 0;

        for (var total in data.transactionOkReport.data) {
          newTotal += total.amount;
          if(total.status.toLowerCase().startsWith("pending")){
            totalPendingTransactionCount++;
          }
          if(total.status.toLowerCase().startsWith("success")){
            totalSuccessTransactionCount++;
          }
          if(total.status.toLowerCase().startsWith("failed")){
            totalFailedTransactionCount++;
          }
        }

        if (data.transactionOkReport.data.isNotEmpty) {
          emit(TransactionReportSuccessState(data, newTotal, totalSuccessTransactionCount, totalFailedTransactionCount,totalPendingTransactionCount));
        } else {}
      }
      else if (data is TransactionFailModel) {
        emit(TransactionReportFailureState(data));
      }
    });
    on<GetTransactionByMerchantDateRange>((event, emit) async {
      emit(TransactionReportLoaderState());
      final data = await reportRepository.getTransactionReportByMerchantIdDate(event.merchantID, event.fromDate, event.toDate);
      if (data is TransactionSuccessModel) {

          emit(TransactionReportSuccessState(data,
              0, 0, 0,0));

      }
      else if (data is TransactionFailModel) {
        emit(TransactionReportFailureState(data));
      }

    });
    on<SettlementTransactionEvent>((event, emit) {});
  }
}
