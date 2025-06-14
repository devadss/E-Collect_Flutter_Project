import '../../data/service/error_handler.dart';
import '../../domain/model/update_password_model.dart';
import 'package:dartz/dartz.dart';

abstract class IUpdatePasswordRepository{
  Future<Either<ErrorHandler,UpdatePasswordModel>>updatePassword(String userName,String password,String mobPassword,String mobileNumber,String token);
}