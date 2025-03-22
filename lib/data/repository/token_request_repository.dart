import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/interface/token_request_interface.dart';
import 'package:http/http.dart' as http;
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
      final data = {
        'UserName': userName,
        "Password": password,
        'PhoneNumber': '+91$mobNum',
        'Type': 'Mob'
      };

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
        return Left("UNABLE TO FETCH TOKEN");
      }
    } catch (e) {
      return Left("UNABLE TO FETCH TOKEN :$e");
    }

  }
}
