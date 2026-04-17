import 'dart:convert';

import '../../core/general.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/agent_customer_details_interface.dart';
import '../../domain/model/agent_customer_details_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../storage/shared_pref_helper.dart';

class AgentCustomerDetailsRepository
    implements IAgentCustomerDetailsRepository {
  Future<String> loadVendorUrl() async {
    //final liveUrl = await SharedPref().getVendorUrlLive();
    return await SharedPref().getCustomerRdUrl();
  }

  @override
  Future<Either<ErrorHandler, AgentCustomerDetailsModel>>
      getAgentCustomerDetails(String agentId) async {
    final vendorUrl = await loadVendorUrl();
    final url =
        //Uri.parse("https://mftctest.digicob.in/getRDCustomerunderAgentList");
        //  Uri.parse("${vendorUrl}getCustomerlist");
        Uri.parse(vendorUrl);
    print("--------------------------AGENT CUSTOMER DETAILS VENDOR URL------------------");
    print(vendorUrl);
    print("çl = ${await loadVendorUrl()}");
    print("--------------------------AGENT CUSTOMER DETAILS URL------------------");
    print(url);
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    final body = {"agent_id": agentId};
    print("agentId : $agentId");
    if (checkConnection) {
     final response = await http.post(url, body:{"agent_Id": agentId},);
     // final response = await http.post(url, body:{"agent_Id": "1002"},);
      printLog("------------------------AGENT CUSTOMER DETAILS STATUSCODE-------------------");
      printLog(response.statusCode);
      printLog("------------------------AGENT CUSTOMER DETAILS BODY RD--------------------------");
      printLog(response.body);
      if (response.statusCode == 200 ) {
        try {
          return Right(
              AgentCustomerDetailsModel.fromJson(jsonDecode(response.body)));
        } catch (e) {
          return Left(DataParsingException(e));
        }
      } else {
        return Left(FetchDataError("Failed to Fetch data"));
      }
    } else {
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}
