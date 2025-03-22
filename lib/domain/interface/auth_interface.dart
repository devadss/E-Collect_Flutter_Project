import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/auth_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/auth_success_model.dart';

abstract class AuthInterface{
  Future<Either<AuthFailtResponse, AuthSuccessResponse>>getAuthResult(
      String mobnum, String mpin
      );
}