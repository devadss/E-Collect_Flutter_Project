import 'dart:convert';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/service/api_services.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/utils.dart';
import '../../domain/interface/loan_interface.dart';
import '../../domain/model/loan_model.dart';

class GetLoanRepository implements IGetLoanRepository {
  final ApiService _apiService;

  GetLoanRepository(this._apiService);

  @override
  Future<Either<ErrorHandler, CollectionLoanModel>> getLoans(
    LoanRequestModel loanRequestModel,
  ) async {
    bool checkConnection =
        await InternetConnectionChecker.createInstance().hasConnection;
    final data = await _apiService.getApiData(
        "api/GetLoans?customerName=${loanRequestModel.customerName}&accountNo=${loanRequestModel.accountNo}&status=${loanRequestModel.status}&scheme=${loanRequestModel.scheme}&agent=${loanRequestModel.agent}&page=${loanRequestModel.page}&pageSize=${loanRequestModel.pageSize}&corpcode=${loanRequestModel.corpCode}");
    // print("GetLoanRepository");
    // print(data);
    if (checkConnection) {
      try {
        return Right(CollectionLoanModel.fromJson(jsonDecode(data)));
      } catch (e) {
        return Left(DataParsingException(e));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
