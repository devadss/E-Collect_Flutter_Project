import 'package:e_Collect/domain/model/loan_cash_collect_model.dart';
import 'package:dartz/dartz.dart';

abstract class LoanCashCollectionInterface{
  Future<Either<String , LoanCashCollectionResponse>>submitCashCollection(
      String agentName,
      String agentId,
      String agentOriginId,
      String agentPhone,
      String agentEmail,
      int subAgentId,
      String subAgentBranch,
      String subAgentBranchCode,
      String customerName,
      String customerPhone,
      String customerAccNo,
      String customerId,
      String customerEmail,
      double collectionAmount,
      String note,
      String corpCode,
      String branchCode,
      String cardRefNo,
      String qrSource,
      String paymentMode,
      String UTRNumber,
      String collectionType
      );
}