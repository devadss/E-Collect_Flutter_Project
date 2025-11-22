import 'dart:convert';

import '../../data/service/error_handler.dart';
import '../../domain/interface/due_list_inteface.dart';
import '../../domain/model/due_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../storage/shared_pref_helper.dart';

class DueListRepository implements IDueListRepository {

  Future<String> loadVendorUrl() async {
    //final liveUrl = await SharedPref().getVendorUrlLive();
    return await SharedPref().getDueListUrl();

  }


  @override
  Future<Either<ErrorHandler, DueListModel>> getDueList(
      String accountNumber, String onDate) async {
    final vendorUrl = await loadVendorUrl();
    final url = Uri.parse(
       // "https://doorstepmftctest.digicob.in/GetDuesList?accNo=$accountNumber&asOnDate=$onDate");
       // "${vendorUrl}GetDuesList?accNo=$accountNumber&asOnDate=$onDate");
        "$vendorUrl?accNo=$accountNumber&asOnDate=$onDate");
    print("getDueList = ${url}");
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if (checkConnection) {
      final response = await http.get(url);
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
