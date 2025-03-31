import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/domain/interface/token_request_interface.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../constants.dart';

class TokenRequestRepository implements TokenRequestInterface {
  @override
  Future<Either<String, String>> requestToken(
      String userName, String password, String mobNum, String type) async {
    try {
      final uri = Uri.parse("${baseUrl}api/APILogin");
      print("UserName = $userName");
      print("Password = $password");
      print("PhoneNumber = $mobNum");
      bool checkConnection = await InternetConnectionChecker().hasConnection;

      final data = {
        'UserName': userName,
        "Password": password,
        'PhoneNumber': '+91${mobNum.replaceAll("+91", "")}',
        'Type': 'Mob'
      };
if(checkConnection ==  true){
  final response = await http.post(
    uri,
    body: json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );
  print("token body = ${response.body}");
  if (response.statusCode == 200) {
    final responseBody = response.body;
    if (responseBody.isNotEmpty) {
      return Right(responseBody);
    }else{
      return Left(responseBody);
    }
  }else{
    return const Left("User not found");
  }
}else{
  return const Left("CHECK NETWORK CONNECTION");
}

    } catch (e) {
      return Left("UNABLE TO FETCH TOKEN :$e");
    }

  }
}
