// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:http/http.dart' as http;
//
// import '../../core/constants.dart';
// import '../../domain/interface/fetch_account_balance_interface.dart';
// import '../../domain/model/fetch_account_balance_model.dart';
// import '../service/error_handler.dart';
//
//
// class FetchAccountBalanceRepository implements IFetchAccountBalanceRepository {
//   @override
//   Future<Either<ErrorHandler, FetchBalanceModel>> getFetchBalance(
//       String? entityId, String? token) async {
//     // final url = Uri.parse('https://adsspay.aanvinsolutions.com:8444/api/Fetchbalance');
//     final url = Uri.parse('${baseUrl}api/Fetchbalance');
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//
//     if (checkConnection) {
//       final body = {"entityId": entityId};
//
//       //  try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token'
//         },
//         body: jsonEncode(body),
//       );
//
//       print("---------------------------FetchAccountBalanceRepository----------------------");
//       print("---------------------------entityId : $entityId----------------------");
//       print("---------------------------token : $token----------------------");
//       print("---------------------------Response Status Code: ${response.statusCode}----------------------");
//
//       if (response.statusCode == 200) {
//         print("---------------------------response.body: ${response.body}----------------------");
//
//         try {
//           final fetchBalanceModel = FetchBalanceModel.fromJson(jsonDecode(response.body));
//           return Right(fetchBalanceModel);
//         } catch (e) {
//           print("Error parsing response body: $e");
//           return Left(DataParsingException('Failed to parse data'));
//         }
//       } else {
//         print("Request failed with status: ${response.statusCode}");
//         return Left(FetchDataError('Failed to fetch data with status code: ${response.statusCode}'));
//       }
//       // } catch (e) {
//       //   print("Request failed: $e");
//       //   return Left(FetchDataError('Failed to fetch data'));
//       // }
//     } else {
//       print("No Internet Connection");
//       return Left(FetchDataError('No Internet Connection'));
//     }
//   }
// }
