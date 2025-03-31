import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/update_password_model.dart';

abstract class IUpdatePasswordRepository{
  Future<Either<ErrorHandler,UpdatePasswordModel>>updatePassword(String userName,String password,String mobPassword,String mobileNumber,
      String token);
}