import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

import '../../domain/interface/agent_customer_details_interface.dart';
import '../../domain/model/agent_customer_details_model.dart';
import '../service/error_handler.dart';

class AgentCustomerDetailsRepository implements IAgentCustomerDetailsRepository{
  @override
  Future<Either<ErrorHandler, AgentCustomerDetailsModel>> getAgentCustomerDetails(String agentId) async{
   final url = Uri.parse("https://doorstepmftctest.digicob.in/getCustomerlist");
   bool checkConnection = await InternetConnectionChecker().hasConnection;

   final body = {
     "agent_id": agentId
   };
   if(checkConnection){
     final response = await http.post(
         url,
       body: body
     );
     print("AgentCustomerDetailsRepository : ${response.body}");
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         return Right(AgentCustomerDetailsModel.fromJson(jsonDecode(response.body)));
       }catch(e){
         return Left(DataParsingException(e));
       }
     }else{
       return Left(FetchDataError("Failed to Fetch data"));
     }
   }else{
     return Left(FetchDataError("No Internet Connection"));
   }
  }
}