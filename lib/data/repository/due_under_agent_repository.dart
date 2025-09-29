import 'dart:convert';

import '../../data/service/error_handler.dart';
import '../../domain/interface/due_under_agent_inteface.dart';
import '../../domain/model/due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../storage/shared_pref_helper.dart';

class DueUnderAgentRepository implements IDueUnderAgentRepository {
  Future<String> loadVendorUrl() async {
    //final liveUrl = await SharedPref().getVendorUrlLive();
    return await SharedPref().getDueListUrl();
  }

  @override
  Future<Either<ErrorHandler, DueUnderAgentModel>> getDuesUnderAgent(
      String? agentId) async {
    //final url = Uri.parse("https://doorstepmftctest.digicob.in/GetDuesListunderAgent?agent_id=$agentId");
    final vendorUrl = await loadVendorUrl();
    print(
        "--------------------------DUE UNDER AGENT VENDOR URL------------------");
    print(vendorUrl);
    final url = Uri.parse("$vendorUrl?agent_id=$agentId");
    print("--------------------------DUE UNDER AGENT URL------------------");
    print(url);
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if (checkConnection) {
      final response = await http.get(url);
      print(
          "--------------------------DUE UNDER AGENT STATUS CODE------------------");
      print(response.statusCode);
      print("--------------------------DUE UNDER AGENT BODY------------------");
      print(response.body);
      print(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return Right(DueUnderAgentModel.fromJson(jsonDecode(response.body)));
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        return Left(FetchDataError("Failed To fetch Data"));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
