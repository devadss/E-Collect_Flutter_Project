import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/domain/model/token_expiry_mode.dart';

abstract class TokenExpiryInterface{
  Future<Either<String , TokenExpireModel>>validateToken(String token);
}