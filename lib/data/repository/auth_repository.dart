import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/constants.dart';
import 'package:merchant_app_flutter/domain/interface/auth_interface.dart';
import 'package:merchant_app_flutter/domain/model/auth_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/auth_success_model.dart';
import 'package:http/http.dart' as http;


class AuthRepository implements AuthInterface{
  @override
  Future<Either<AuthFailtResponse, AuthSuccessResponse>> getAuthResult(String mobnum, String mpin) async {
try{
  final uri = Uri.parse("${baseUrl}api/MobLogin");
  final request = await http.post(
    uri,
    body: json.encode({
      "MobileNo":mobnum,
      "MPIN":mpin,

    }),
    headers: {'Content-Type': 'application/json'}
  );
  print("response = ${request.body}");
  if( request.statusCode ==  200){
  AuthSuccessResponse authSuccessResponse = AuthSuccessResponse.fromJson(jsonDecode(request.body));
    return Right(authSuccessResponse);
  }
  if(request.statusCode == 401){
    AuthFailtResponse authFailtResponse = AuthFailtResponse.fromJson(jsonDecode(request.body));
    return Left(authFailtResponse);
  }
}catch(e){
  
}
    throw UnimplementedError();
  }
  
}