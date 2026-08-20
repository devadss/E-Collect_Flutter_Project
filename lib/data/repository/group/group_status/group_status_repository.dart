import 'dart:convert';

import 'package:e_Collect/core/constants.dart';
import 'package:e_Collect/data/service/error_handler.dart';
import 'package:e_Collect/domain/interface/group/group_status/group_status_inteface.dart';
import 'package:e_Collect/domain/model/group/group_status/group_status_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class GroupStatusRepository implements IGroupStatusRepository{
  @override
  Future<Either<ErrorHandler, GroupStatusModel>> getGroupStatus(int? groupId) async{
   final url = Uri.parse("${baseUrl}api/ToggleGroupStatus/$groupId");
   bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
   if(checkConnection){


     
     final response = await http.post(url);
     if(response.statusCode == 200 || response.statusCode == 201){
       print("-------------------GROUP STS code---------------");
       print(url);
       print("-------------------GROUP STS STATUS CODE---------------");
       print(response.statusCode);
       print("-------------------GROUP STS BODY---------------");
       print(response.body);
       try{
         return Right(GroupStatusModel.fromJson(jsonDecode(response.body)));
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