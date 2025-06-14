
import 'package:dartz/dartz.dart';

import '../model/token_expiry_mode.dart';

abstract class TokenExpiryInterface{
  Future<Either<String , TokenExpireModel>>validateToken(String token);
}
