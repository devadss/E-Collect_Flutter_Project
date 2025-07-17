import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/qr_transaction_history_model.dart';

abstract class IQRTransactionHistoryRepository{
  Future<Either<ErrorHandler,QrTranscationHistoryModel>>getQrTranscationHistory(String? dateFilterType,String? startDate,String?
  endDate,String? source,
      String?corpCode
     ,String? agentOrginId

      );
}