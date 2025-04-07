import 'package:collection_qr_flutter/domain/model/no_transaction.dart';
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/collection_summary_model.dart';

abstract class ICollectionSummaryRepository{
  Future<Either<NoTransactionModel,CollectionSummaryModel>>getCollectionSummary(String agentId,String startDate,String endDate,String token);
}