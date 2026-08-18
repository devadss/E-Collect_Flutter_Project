// import '../../data/repository/update_dop_repository.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import '../../domain/model/update_password_model.dart';
// import '../service/error_handler.dart';
//
//
// class UpdateDopProvider with ChangeNotifier{
//   final UpdateDopRepository _updateDopRepository;
//   UpdateDopProvider(this._updateDopRepository);
//   Future<Either<ErrorHandler, UpdatePasswordModel>> getUpdateDop(String entityID, String userName, String password,String token) async{
//     return _updateDopRepository.getUpdateDop(entityID, userName, password,token);
//   }
// }