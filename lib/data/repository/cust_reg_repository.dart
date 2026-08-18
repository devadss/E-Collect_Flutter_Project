//
//
// import 'dart:convert';
// import '../../core/constants.dart';
// import '../../core/general.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import '../../core/utils.dart';
// import '../../domain/interface/reg_cust_interface.dart';
// import '../../domain/model/reg_cust_fail.dart';
// import '../../domain/model/registered_cust_model.dart';
//
// class CustRegRepository implements RegCustInterafce {
//   @override
//   Future<Either<RegCustFailResponse, RegistedCustomerModel>> checkRegCust(
//       int mobileNumber) async {
//     try {
//       final uri = Uri.parse("${baseUrl}api/RegisteredCust");
//       final data = {'MobileNo': '+91$mobileNumber'};
//
//       final response = await http.post(
//         uri,
//         body: json.encode(data),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//
//         if (responseBody is Map<String, dynamic> && responseBody.containsKey("Response")) {
//           final registeredCustomer = RegistedCustomerModel.fromJson(responseBody);
//           if(printStatementStatus){
//             printLog("uri = $uri");
//             printLog("body = $data");
//             printLog("-------------------BODY---------------------");
//             printLog(responseBody);
//           }
//
//           return Right(registeredCustomer);
//         } else {
//           return Left(RegCustFailResponse(
//               message: "Invalid response format: Missing 'Response' key"));
//         }
//       } else {
//         // Handle error responses, including 401
//         final responseBody = jsonDecode(response.body);
//         final failResponse = RegCustFailResponse.fromJson(responseBody);
//         return Left(failResponse);
//       }
//     } catch (e) {
//       return Left(RegCustFailResponse(message: "Exception: $e"));
//     }
//   }
// }
