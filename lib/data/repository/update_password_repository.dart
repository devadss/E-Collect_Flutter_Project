import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;

import '../../constants.dart';
import '../../domain/interface/update_password_interface.dart';
import '../../domain/model/update_password_model.dart';
import '../service/error_handler.dart';

class UpdatePasswordRepository implements IUpdatePasswordRepository{
  @override
  Future<Either<ErrorHandler, UpdatePasswordModel>> updatePassword(String userName,
      String password,String mobPassword,String mobileNumber, String token) async{
    final url = Uri.parse("${baseUrl}api/UpdatePassword");
    final body = json.encode({
      "UserName": userName,
      "Password": password,
      "MobPassword": mobPassword,
      "PhoneNumber": "+91$mobileNumber"
    });
    print("UserName : $userName");
    print("Password : $password");
    print("MobPassword : $mobPassword");
    print("PhoneNumber : $mobileNumber");

    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if(checkConnection){
      final response = await http.post(
        url,
        body: body,
          headers: {'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      print(response.statusCode);
      print((response.body));
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