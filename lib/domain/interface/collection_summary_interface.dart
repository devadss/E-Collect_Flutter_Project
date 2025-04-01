import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/collection_summary_model.dart';

abstract class ICollectionSummaryRepository{
  Future<Either<ErrorHandler,CollectionSummaryModel>>getCollectionSummary(String agentId,String startDate,String endDate,String token);
}