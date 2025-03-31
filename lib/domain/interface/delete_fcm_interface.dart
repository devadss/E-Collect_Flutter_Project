import 'package:dartz/dartz.dart';

abstract class DeleteFcmTokenInterface{
  Future<Either<String, String>>deleteFcmToken(String entityID, String token);
}