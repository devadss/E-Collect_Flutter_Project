import 'dart:convert';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../domain/interface/loan_interface.dart';
import '../../domain/model/loan_model.dart';

class GetLoanRepository implements IGetLoanRepository {
  @override
  Future<Either<ErrorHandler, CollectionLoanModel>> getLoans(
      String? customerName,
      String? accountNo,
      String? status,
      String? scheme,
      String? agent,
      int? page,
      int? pageSize) async {
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    final url = Uri.parse("${baseUrl}api/GetLoans?customerName=$customerName&accountNo=$accountNo&status=$status&scheme=$scheme&agent=$agent&page=$page&pageSize=$pageSize");

    if(checkConnection){
      final response = await http.get(url);
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          return Right(CollectionLoanModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
