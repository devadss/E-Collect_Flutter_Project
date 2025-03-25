import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/token_expiry_mode.dart';

abstract class TokenExpiryInterface{
  Future<Either<String , TokenExpireModel>>validateToken(String token);
}