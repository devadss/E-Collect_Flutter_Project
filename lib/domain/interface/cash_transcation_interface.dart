import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/model/cash_transcation_model.dart';
import 'package:dartz/dartz.dart';

abstract class ICashTranscationRepository {
  Future<Either<ErrorHandler, CashTranscation>> getTranscations(
      {
   required String? agentName,
   required String? agentId,
   required String? agentOriginId,
   required String? agentPhone,
   required String? agentEmail,
   required String? subAgentId,
   required String? customerName,
   required String? customerPhone,
   required String? customerAccNo,
   required String? customerId,
   required String? customerEmail,
   required String? amount,
   required String? note,
   required String? corpCode,
   required String? cardRefNum,
   required String? token,
   required String? subagentBranchCode,
   required String? branchCode,
  });
}
