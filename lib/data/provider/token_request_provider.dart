import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:merchant_app_flutter/data/repository/token_request_repository.dart';

class TokenRequestProvider with ChangeNotifier{
  final TokenRequestRepository _tokenRequestRepository;
  TokenRequestProvider(this._tokenRequestRepository);

  Future<Either<String , String>>requestToken(String userName, String password, String mobNum, String type )async{
    return _tokenRequestRepository.requestToken(userName, password, mobNum, type);

  }
}