// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../../core/constants.dart';
// import '../../domain/interface/auth_interface.dart';
// import '../../domain/model/auth_fail_model.dart';
// import '../../domain/model/auth_success_model.dart';
//
//
// class AuthRepository implements AuthInterface {
//   @override
//   Future<Either<AuthFailtResponse, AuthSuccessResponse>> getAuthResult(
//       String mobnum, String mpin, String token) async {
//     try {
//       bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//       final uri = Uri.parse("${baseUrl}api/MobLogin");
//
//       if (checkConnection) {
//         final response = await http.post(
//           uri,
//           body: json.encode({
//             "MobileNo": mobnum,
//             "MPIN": mpin,
//           }),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         );
//
//         print("mobnum = $mobnum");
//         print("token = $token");
//         print("MPIN = $mpin");
//         print("response = ${response.body}");
//
//         if (response.statusCode == 200) {
//           final success = AuthSuccessResponse.fromJson(jsonDecode(response.body));
//           return Right(success);
//         } else if (response.statusCode == 401) {
//           final failure = AuthFailtResponse.fromJson(jsonDecode(response.body));
//           return Left(failure);
//         } else {
//           // Handle other non-200/401 status codes
//           final failure = AuthFailtResponse(message: "Unexpected error: ${response.statusCode}");
//           return Left(failure);
//         }
//       } else {
//         return Left(AuthFailtResponse(message: "No internet connection"));
//       }
//     } catch (e) {
//       print("Exception: $e");
//       return Left(AuthFailtResponse(message: "Error: ${e.toString()}"));
//     }
//   }
// }
