import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

import '../../domain/interface/due_under_agent_inteface.dart';
import '../../domain/model/due_under_agent_model.dart';
import '../service/error_handler.dart';

class DueUnderAgentRepository implements IDueUnderAgentRepository{
  @override
  Future<Either<ErrorHandler, DueUnderAgentModel>> getDuesUnderAgent(String? agentId) async{
    final url = Uri.parse("https://doorstepmftctest.digicob.in/GetDuesListunderAgent?agent_id=$agentId");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if(checkConnection){
      final response = await http.get(url);
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          return Right(DueUnderAgentModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed To fetch Data"));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}