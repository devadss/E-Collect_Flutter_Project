import '../../data/service/error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../repository/delete_fcm_repository.dart';
//
// import '../../domain/model/default_model.dart';
// import '../repository/delete_fcm_repository.dart';
//
// class DeleteFcmProvider with ChangeNotifier{
//   final DeleteFcmTokenRepository _deleteFcmToken;
//   DeleteFcmProvider(this._deleteFcmToken);
//   Future<Either<ErrorHandler,DefaultModel>>deleteFcmToken(
//       String entityID,
//       String token,
//       ) async{
//     return _deleteFcmToken.deleteFcmToken(entityID, token);
//   }
// }

class DeleteFcmProvider with ChangeNotifier {
  final DeleteFcmTokenRepository _deleteFcmToken;

  DeleteFcmProvider(this._deleteFcmToken);

  String? tokenResults;

  Future<Either<String, String>> deleteFirebaseToken(
      String entityID, String token) async {
    return _deleteFcmToken.deleteFcmToken(entityID, token);
    // final result = await _deleteFcmToken.deleteFcmToken(entityID, token);
    // result.fold((error) {}, (success) {
    //   tokenResults = success;
    //   notifyListeners();
    // });
    // return result;
  }
}
