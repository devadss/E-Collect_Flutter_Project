
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/all_trans_data.dart';
import '../model/link_transaction_history_model.dart';
import '../model/qr_transaction_history_model.dart';

abstract class ILinkTransactionHistoryRepository{
  Future<Either<ErrorHandler,AllTranscationHistoryModel>>getLinkTransactionHistory(String filterType,String startDate,String endDate,String subAgentId,String corpCode,String agentOrginId);
}