import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../model/loan_model.dart';

abstract class IGetLoanRepository{
  Future<Either<ErrorHandler,CollectionLoanModel>>getLoans(String? customerName,String? accountNo,String? status,String? scheme,String? agent,int? page,int? pageSize);
}