import 'dart:convert';
import 'package:e_Collect/core/utils.dart';
import 'package:dartz/dartz.dart';
import "package:http/http.dart" as http;
import '../../core/constants.dart';
import '../../domain/interface/delete_fcm_interface.dart';


class DeleteFcmTokenRepository extends DeleteFcmTokenInterface {
  @override
  Future<Either<String, String>> deleteFcmToken(
      String entityID,
      String mobNum,
      String token
      ) async {
    try {
      //final uri = Uri.parse("${baseUrl}api/DeleteToken");
      final uri = Uri.parse("${eCollectBaseUrl}api/device/unregister");
      final request = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
         // body: json.encode({"EntityId": entityID}));
          body: json.encode({
            "customerId": entityID,
            "mobileNumber": mobNum,
            "deviceType":"Android",
            "appVersion":"22.0.1",
            "deviceToken": token
          }));
if(printStatementStatus){
  print("Delete Fcm EntityId : ${entityID}");
  print("Delete Fcm Response : ${request.body}");
  print("Delete Fcm statusCode : ${request.statusCode}");
}

      if(request.statusCode == 200){
        return Right(request.body);
      }else{
        return Left(request.body);
      }
    } catch (e) {}
    throw UnimplementedError();
  }
}

// import 'dart:convert';
//
// import '../../data/service/error_handler.dart';
// import '../../domain/interface/delete_fcm_interface.dart';
// import '../../domain/model/default_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// import '../../core/constants.dart';
//
// class DeleteFcmTokenRepository implements DeleteFcmTokenInterface {
//   @override
//   Future<Either<ErrorHandler, DefaultModel>> deleteFcmToken(
//     String entityID,
//     String token,
//   ) async {
//     final url = Uri.parse("${baseUrl}api/DeleteToken");
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//     if (checkConnection) {
//       final response = await http.post(
//         url,
//         body: json.encode({"EntityId": entityID}),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       if(response.statusCode == 200 || response.statusCode == 201){
//         try{
//           return Right(DefaultModel.fromJson(jsonDecode(response.body)));
//         }catch(e){
//           return Left(DataParsingException(e));
//         }
//       }else{
//         return Left(FetchDataError("Failed TO Fetch Data"));
//       }
//     } else {
//       return Left(FetchDataError("No Internet Connection"));
//     }
//   }
// }
