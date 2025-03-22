import 'package:dartz/dartz.dart';

abstract class TokenRequestInterface{
  Future<Either<String, String>>requestToken(String userName ,
      String password , String mobNum , String type);
}