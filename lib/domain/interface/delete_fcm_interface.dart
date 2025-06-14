import '../../data/service/error_handler.dart';
import '../../domain/model/default_model.dart';
import 'package:dartz/dartz.dart';

// abstract class DeleteFcmTokenInterface{
//   Future<Either<ErrorHandler,DefaultModel>>deleteFcmToken(String entityID, String token);
// }

abstract class DeleteFcmTokenInterface{
  Future<Either<String, String>>deleteFcmToken(String entityID, String token);
}