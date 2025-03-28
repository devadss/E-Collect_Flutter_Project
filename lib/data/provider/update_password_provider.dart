import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/model/update_password_model.dart';
import '../repository/update_password_repository.dart';
import '../service/error_handler.dart';

class UpdatePasswordProvider with ChangeNotifier{
  final UpdatePasswordRepository _updatePasswordRepository;
  UpdatePasswordProvider(this._updatePasswordRepository);
  Future<Either<ErrorHandler, UpdatePasswordModel>> updatePassword(String userName,String password,String mobPassword,String mobileNumber) async{
    return _updatePasswordRepository.updatePassword(userName, password, mobPassword, mobileNumber);
  }
}