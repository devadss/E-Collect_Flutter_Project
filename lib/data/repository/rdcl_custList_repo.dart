import 'dart:convert';

import 'package:collection_qr_flutter/domain/model/account_list_model.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../domain/interface/rdcl_customer_list_interface.dart';
import '../storage/shared_pref_helper.dart';

class RdclCustListRep implements RdclCustomerListInterface {
  Future<String> loadVendorUrl() async {
    return await SharedPref().getCustomerUnderAgentUrl();
  }

  @override
  Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
      String? agentID, String? branchID, int pgNo, int pgSize, String custName) async {
    print("Inside RdclCustListRep");
    final vendorUrl = await loadVendorUrl();
    final uri = Uri.parse(vendorUrl); //This is the live one
   // final uri = Uri.parse("https://doorstepclientuat.digicob.in/getRdclCustomerunderAgentList"); //This is the live one
    bool checkInternetConnection =
    await InternetConnectionChecker.createInstance().hasConnection;
    try{
      if(checkInternetConnection == true){
        final data = await http.post(
          uri,
          body: jsonEncode({
            "agent_id": agentID,
            "branch_id": branchID,
            "PageNumber": pgNo,
            "PageSize": pgSize,
            "cust_name":custName
          }),
          headers: {'Content-Type': 'application/json'},
        );
        print("vendorUrl $vendorUrl");
        print("Body ${{"agent_id": agentID, "branch_id": branchID, "PageNumber": pgNo,
          "PageSize": pgSize,"cust_name":custName}}");
        print(data.body);
        if (data.statusCode == 200) {
          return Right(RdclCustomerListModel.fromJson(jsonDecode(data.body)));
        } else {
          return Left(data.body);
        }
      }else{
        return const Left("Check Internet connection");
      }
    }catch(e){
      return const Left("Unable to fetch the data");
    }



  }
}
