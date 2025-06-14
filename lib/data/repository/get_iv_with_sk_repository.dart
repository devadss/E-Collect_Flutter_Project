import 'dart:convert';
import '../../data/service/error_handler.dart';
import '../../domain/interface/get_iv_with_sk_interface.dart';
import '../../domain/model/get_iv_with_sk_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/constants.dart';
import 'package:http/http.dart'as http;

class GetIvWithSkRepository implements IGetIvWithSkRepository{
  @override
  Future<Either<ErrorHandler, GetIvWithSkModel>> getIvWithSk() async{
   final url =Uri.parse("${baseUrl}api/Appdata");
   bool checkConnection = await InternetConnectionChecker().hasConnection;
   if(checkConnection){
     final response = await http.get(url);
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         return Right(GetIvWithSkModel.fromJson(jsonDecode(response.body)));
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