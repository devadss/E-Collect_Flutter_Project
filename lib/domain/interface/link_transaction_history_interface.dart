
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/all_trans_data.dart';

abstract class ILinkTransactionHistoryRepository{
  Future<Either<ErrorHandler,AllTransactionHistoryResponse>>getLinkTransactionHistory(String filterType,String startDate,String endDate,String subAgentId,String corpCode,String agentOrginId);
}