import 'dart:convert';

import '../../core/constants.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/agent_trancstion_interface.dart';
import '../../domain/model/agent_transction_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

class AgentTransactionRepository implements IAgentTransactionRepository{
  @override
  Future<Either<ErrorHandler, AgentPaymentTransctionModel>>getTransactions(String token) async{
   final url = Uri.parse("${baseUrl}api/Cashfree/GetPaymentLinksQrTransactions");
   bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
   if(checkConnection){
     final response = await http.get(url,headers: {
       'Authorization': 'Bearer $token', // Add token here
       'Content-Type': 'application/json',
     },);
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         print("------------------------BODY AGENT PAYMENT TRANSCATION MODEL-------------------------");
         print(response.body);
         return Right(AgentPaymentTransctionModel.fromJson(jsonDecode(response.body)));
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