import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../domain/interface/reg_cust_interface.dart';
import '../../domain/model/reg_cust_fail.dart';
import '../../domain/model/registered_cust_model.dart';

class CustRegRepository implements RegCustInterafce {
  @override
  Future<Either<RegCustFailResponse, RegistedCustomerModel>> checkRegCust(
      int mobileNumber) async {
    try {
      final uri = Uri.parse("${baseUrl}api/RegisteredCust");
      final data = {'MobileNo': '+91$mobileNumber'};

      final response = await http.post(
        uri,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (response.body.contains("data")) {
          final registeredCustomer =
              RegistedCustomerModel.fromJson(responseBody);
          return Right(registeredCustomer);
        } else {
          // Handle unexpected 200 response without "data"
          return Left(
              RegCustFailResponse(message: "Unexpected response format"));
        }
      } else if (response.statusCode == 401) {
        // Handle 401 as "Customer Not Registered"
        final responseBody = jsonDecode(response.body);
        final failResponse = RegCustFailResponse.fromJson(responseBody);
        return Left(failResponse);
      } else {
        // Handle other non-200 errors
        return Left(
            RegCustFailResponse(message: "Error: ${response.statusCode}"));
      }
    } catch (e) {
      // Catch network or parsing errors
      return Left(RegCustFailResponse(message: "Exception: $e"));
    }
  }
}

// class CustRegRepository implements RegCustInterafce {
//   @override
//   Future<Either<RegCustFailResponse, RegistedCustomerModel>>checkRegCust(int mobileNumber)async {
//     final uri = Uri.parse("${baseUrl}api/RegisteredCust");
//     final data = {'MobileNo': '+91$mobileNumber'};
//     final response = await http.post(
//       uri,
//       body: json.encode(data),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     if (response.statusCode == 200) {
//       if(response.body.contains("data")){
//         RegistedCustomerModel registedCustomerModel = RegistedCustomerModel.fromJson(jsonDecode(response.body));
//         try {
//           return Right(registedCustomerModel);
//         } catch (e) {
//           return Left();
//         }
//       }else{
//
//         RegCustFailResponse regCustFailResponse = RegCustFailResponse.fromJson(jsonDecode(response.body));
//         try {
//           return Right(regCustFailResponse);
//         } catch (e) {
//           return Left(DataParsingException(e));
//         }
//       }
//
//
//     }else{
//       return Left(DataParsingException(e));
//     }
//   }
// }
