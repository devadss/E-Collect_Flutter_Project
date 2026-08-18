
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../repository/delete_fcm_repository.dart';


class DeleteFcmProvider with ChangeNotifier {
  final DeleteFcmTokenRepository _deleteFcmToken;

  DeleteFcmProvider(this._deleteFcmToken);

  String? tokenResults;

  Future<Either<String, String>> deleteFirebaseToken(
      String entityID,
      String mobNum,
      String token) async {
    return _deleteFcmToken.deleteFcmToken(entityID,mobNum,  token);
    // final result = await _deleteFcmToken.deleteFcmToken(entityID, token);
    // result.fold((error) {}, (success) {
    //   tokenResults = success;
    //   notifyListeners();
    // });
    // return result;
  }
}
