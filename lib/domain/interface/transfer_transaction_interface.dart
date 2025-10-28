import 'package:collection_qr_flutter/domain/model/transfer_history_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';

abstract class TransferTransactionInterface{
  Future<Either<ErrorHandler,TransferHistoryModel>>getTransferTranscationHistory(String? dateFilterType,String? startDate,String?
  endDate,String? source,
      String?corpCode
      ,String? agentOrginId

      );
}