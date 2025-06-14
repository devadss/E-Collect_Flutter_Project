import '../../data/service/error_handler.dart';
import '../../domain/model/update_password_model.dart';
import 'package:dartz/dartz.dart';

abstract class IUpdateDopRepository{
  Future<Either<ErrorHandler,UpdatePasswordModel>>getUpdateDop(String entityID,String userName,String password,String token);
}