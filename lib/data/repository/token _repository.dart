import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/constants.dart';
import 'package:merchant_app_flutter/domain/interface/token_expiry_interface.dart';
import 'package:merchant_app_flutter/domain/model/token_expiry_mode.dart';
import 'package:http/http.dart' as http;

class TokenExpiryRepository implements TokenExpiryInterface {
  @override
  Future<Either<String, TokenExpireModel>> validateToken(String token) async {
    try {
      final uri = Uri.parse("${baseUrl}CheckExpiration?token=$token");
      final request = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      print(request.body);

      if (request.statusCode == 200) {
        TokenExpireModel tokenExpireModel =
            TokenExpireModel.fromJson(jsonDecode(request.body));
        return Right(tokenExpireModel);
      }
      if (request.statusCode == 400) {
        return Left("Invalid token");
      }
    } catch (e) {}
    throw UnimplementedError();
  }
}
