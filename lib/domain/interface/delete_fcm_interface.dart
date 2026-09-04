
import 'package:dartz/dartz.dart';


abstract class DeleteFcmTokenInterface{
  Future<Either<String, String>>deleteFcmToken(
      String entityID,
      String mobNum,
      String token,
      String bToken

      );
}