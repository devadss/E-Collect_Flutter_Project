import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/token_expiry_interface.dart';
import 'package:collection_qr_flutter/domain/model/token_expiry_mode.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TokenExpiryRepository implements TokenExpiryInterface {
  @override
  Future<Either<String, TokenExpireModel>> validateToken(String token) async {
    try {
      final uri = Uri.parse("${baseUrl}CheckExpiration?token=$token");
      bool checkConnection = await InternetConnectionChecker().hasConnection;
      if (checkConnection == true) {
        final request = await http.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        );

        print(request.body);
        print(token);

        if (request.statusCode == 200) {
          TokenExpireModel tokenExpireModel =
              TokenExpireModel.fromJson(jsonDecode(request.body));
          return Right(tokenExpireModel);
        }
        if (request.statusCode == 400) {
          return const Left("Invalid token");
        }
      }else{
        return const Left("CHECK INTERNET CONNECTION");
      }
    } catch (e) {}
    throw UnimplementedError();
  }
}
