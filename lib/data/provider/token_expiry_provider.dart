import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchant_app_flutter/data/repository/token%20_repository.dart';
import 'package:merchant_app_flutter/domain/model/token_expiry_mode.dart';

class TokenExpiryProvider with ChangeNotifier{
  final TokenExpiryRepository  _tokenExpiryRepository;
  TokenExpiryProvider(this._tokenExpiryRepository);

  Future<Either<String , TokenExpireModel>>validateToken(String token)async{
    return _tokenExpiryRepository.validateToken(token);
  }
}