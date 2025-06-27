
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/link_transaction_history_model.dart';

abstract class ILinkTransactionHistoryRepository{
  Future<Either<ErrorHandler,LinkTranscationHistoryModel>>getLinkTransactionHistory(String filterType,String startDate,String endDate,String subAgentId);
}