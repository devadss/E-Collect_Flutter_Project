// import 'package:e_Collect/data/repository/loan_cash_collection_repository.dart';
// import 'package:e_Collect/domain/model/loan_cash_collect_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class LoanCashCollectionProvider with ChangeNotifier {
//   final LoanCashCollectionRepository _loanCashCollectionRepository;
//
//   LoanCashCollectionProvider(this._loanCashCollectionRepository);
//
//   LoanCashCollectionResponse? _loanCashCollectionResponse;
//
//   LoanCashCollectionResponse? get loanCashCollectionResponse =>
//       _loanCashCollectionResponse;
//
//   String? _loanCollectionErr;
//
//   String? get loanCollectionErr => _loanCollectionErr;
//
//   Future<Either<String, LoanCashCollectionResponse>> submitCashCollection(
//       String agentName,
//       String agentId,
//       String agentOriginId,
//       String agentPhone,
//       String agentEmail,
//       int subAgentId,
//       String subAgentBranch,
//       String subAgentBranchCode,
//       String customerName,
//       String customerPhone,
//       String customerAccNo,
//       String customerId,
//       String customerEmail,
//       double collectionAmount,
//       String note,
//       String corpCode,
//       String branchCode,
//       String cardRefNo,
//       String qrSource,
//       String paymentMode,
//       String utrNumber,
//       String collectionType
//       ) async {
//     final data = await _loanCashCollectionRepository.submitCashCollection(
//         agentName,
//         agentId,
//         agentOriginId,
//         agentPhone,
//         agentEmail,
//         subAgentId,
//         subAgentBranch,
//         subAgentBranchCode,
//         customerName,
//         customerPhone,
//         customerAccNo,
//         customerId,
//         customerEmail,
//         collectionAmount,
//         note,
//         corpCode,
//         branchCode,
//         cardRefNo,
//         qrSource, paymentMode, utrNumber, collectionType);
//
//     data.fold((err) {
//       _loanCollectionErr = err;
//       _loanCashCollectionResponse = null;
//     }, (success) {
//       _loanCashCollectionResponse = success;
//       _loanCollectionErr = null;
//     });
//     notifyListeners();
//     return data;
//
//   }
//
// }