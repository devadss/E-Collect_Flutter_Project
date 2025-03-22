import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchant_app_flutter/data/repository/auth_repository.dart';
import 'package:merchant_app_flutter/domain/model/auth_fail_model.dart';
import 'package:merchant_app_flutter/domain/model/auth_success_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  Future<Either<AuthFailtResponse, AuthSuccessResponse>> getAuthResult(
      String mobnum, String mpin) {
    return _authRepository.getAuthResult(mobnum, mpin);
  }
}
