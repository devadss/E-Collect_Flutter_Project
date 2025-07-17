import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/qr_transaction_history_model.dart';

abstract class ICashTransactionHistoryRepository{
  Future<Either<ErrorHandler,QrTranscationHistoryModel>>
  getCashTranscationHistory(String? dateFilterType,String?
  startDate,String? endDate,String? source,
      String? subAgentId,
      String? corpCode,
      String? agentOriginId
      );
}