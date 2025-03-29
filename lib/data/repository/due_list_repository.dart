import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../../domain/interface/due_list_inteface.dart';
import '../../domain/model/due_list_model.dart';
import '../service/error_handler.dart';

class DueListRepository implements IDueListRepository {
  @override
  Future<Either<ErrorHandler, DueListModel>> getDueList(
      String accountNumber, String onDate) async {
    final url = Uri.parse(
        "https://doorstepmftctest.digicob.in/GetDuesList?accNo=$accountNumber&asOnDate=$onDate");
    bool checkConnection = await InternetConnectionChecker().hasConnection;


    if (checkConnection) {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return Right(DueListModel.fromJson(jsonDecode(response.body)));
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    } else {
      return Left(FetchDataError("failed to Fetch data"));
    }
  }
}
