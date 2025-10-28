import 'dart:convert';
import '../../core/constants.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/update_password_interface.dart';
import '../../domain/model/update_password_model.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

class UpdatePasswordRepository implements IUpdatePasswordRepository{
  @override
  Future<Either<ErrorHandler, UpdatePasswordModel>> updatePassword(String userName,String password,String mobPassword,String mobileNumber,String token) async{
    final url = Uri.parse("${baseUrl}api/UpdatePassword");
    final body = {
      "UserName": userName,
      "Password": password,
      "MobPassword": mobPassword,
      "PhoneNumber": "+91$mobileNumber"
    };
    bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
    if(checkConnection){
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Authorization': 'Bearer $token', // Add token here
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          return Right(UpdatePasswordModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed to fetch data"));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}