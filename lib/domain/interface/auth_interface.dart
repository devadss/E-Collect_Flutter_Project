import 'package:dartz/dartz.dart';

import '../model/auth_fail_model.dart';
import '../model/auth_success_model.dart';


abstract class AuthInterface{
  Future<Either<AuthFailtResponse, AuthSuccessResponse>>getAuthResult(
      String mobnum, String mpin,String token
      );
}