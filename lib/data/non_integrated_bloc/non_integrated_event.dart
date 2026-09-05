part of 'non_integrated_bloc.dart';

abstract class NonIntegratedEvent {}

class FetchAllNonIntegratedLoans extends NonIntegratedEvent {
  final String endPoint;
  final String branchCode;
  final String productType;
  final String agentCode;
  final String searchKeyWord;
  FetchAllNonIntegratedLoans(this.endPoint, this.branchCode, this.productType,
      this.agentCode, this.searchKeyWord);
}

class FetchNonIntegratedLoanDues extends NonIntegratedEvent {
  final String endPoint;
  final String agentCode;
  final String branchCode;
  final String productType;
  final int pageNo;
  final int pageSize;
  final String agentCodeRoute;

  FetchNonIntegratedLoanDues(
    this.endPoint,
    this.agentCode,
    this.branchCode,
    this.productType,
    this.pageNo,
    this.pageSize,
    this.agentCodeRoute,
  );
}
