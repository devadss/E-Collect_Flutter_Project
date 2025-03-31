import 'package:collection_qr_flutter/data/repository/delete_fcm_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class DeleteFcmProvider with ChangeNotifier {
  final DeleteFcmTokenRepository _deleteFcmToken;

  DeleteFcmProvider(this._deleteFcmToken);

  String? tokenResults;

  Future<Either<String, String>> deleteFirebaseToken(
      String entityID, String token) async {
    final result = await _deleteFcmToken.deleteFcmToken(entityID, token);
    result.fold((error) {}, (success) {
      tokenResults = success;
      notifyListeners();
    });
    return result;
  }
}
