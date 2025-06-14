import '../../data/service/error_handler.dart';
import '../../domain/model/collection_summary_model.dart';
import 'package:dartz/dartz.dart';

abstract class ICollectionSummaryRepository{
  Future<Either<ErrorHandler,CollectionSummaryModel>>getCollectionSummary(String agentId,String startDate,String endDate,String token);
}