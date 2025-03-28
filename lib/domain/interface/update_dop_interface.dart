import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/update_password_model.dart';

abstract class IUpdateDopRepository{
  Future<Either<ErrorHandler,UpdatePasswordModel>>getUpdateDop(String entityID,String userName,String password);
}