import 'package:collection_qr_flutter/domain/model/qr_cash_combined_response.dart';
import 'package:dartz/dartz.dart';

abstract class CashQrCombinedInterface{
  Future<Either<String, CashQrCombinedResponse>> getCombinedResponse(
      String filterType,
      String startDate,
      String endDate,
      String subAgentId,
      String corpCode,
      String agentOrginId
      );
}