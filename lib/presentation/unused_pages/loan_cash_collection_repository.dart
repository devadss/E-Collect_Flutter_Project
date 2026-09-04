// import 'dart:convert';
// import 'package:e_Collect/core/constants.dart';
// import 'package:e_Collect/domain/interface/loan_cash_collection_interface.dart';
// import 'package:e_Collect/domain/model/loan_cash_collect_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// class LoanCashCollectionRepository implements LoanCashCollectionInterface {
//   @override
//   Future<Either<String, LoanCashCollectionResponse>> submitCashCollection(
//       String agentName,
//       String agentId,
//       String agentOriginId,
//       String agentPhone,
//       String agentEmail,
//       int subAgentId,
//       String subAgentBranch,
//       String subAgentBranchCode,
//       String customerName,
//       String customerPhone,
//       String customerAccNo,
//       String customerId,
//       String customerEmail,
//       double collectionAmount,
//       String note,
//       String corpCode,
//       String branchCode,
//       String cardRefNo,
//       String qrSource,
//       String paymentMode,
//       String utrNumber,
//       String collectionType,
//       ) async {
//     final uri = Uri.parse("${baseUrl}api/Cashfree/ReceiveCashLoan");
//    // final uri = Uri.parse("${baseUrl}api/Cashfree/dfdfdf");
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//     if (checkConnection == true) {
//       final request = await http.post(uri,
//           body: jsonEncode({
//             "agent_details": {
//               "agent_name": agentName,
//               "agent_id": agentId,
//               "agent_orginId": agentOriginId,
//               "agent_phone": agentPhone,
//               "agent_email": agentEmail,
//               "SubAgentId": subAgentId,
//               "SubAgentBranch": subAgentBranch,
//               "SubAgentBranchCode": subAgentBranchCode
//             },
//             "customer_details": {
//               "customer_name": customerName,
//               "customer_phone": customerPhone,
//               "customer_accno": customerAccNo,
//               "customer_id": customerId,
//               "customer_email": customerEmail
//             },
//             "CollectionType":collectionType,
//             "Amount": collectionAmount,
//             "note": "Loan collection payment",
//             "CorpCode": corpCode,
//             "BranchCode": branchCode,
//             "CardRefNum": cardRefNo,
//             "QrSource": "MOB",
//             "PaymentMode":paymentMode,
//             "UTRNumber":utrNumber
//           }),
//           headers: {'Content-Type': 'application/json'});
//       print(request.body);
//       print("caling cash colection");
//       print({
//         "agent_details": {
//           "agent_name": agentName,
//           "agent_id": agentId,
//           "agent_orginId": agentOriginId,
//           "agent_phone": agentPhone,
//           "agent_email": agentEmail,
//           "SubAgentId": subAgentId,
//           "SubAgentBranch": subAgentBranch,
//           "SubAgentBranchCode": subAgentBranchCode
//         },
//         "customer_details": {
//           "customer_name": customerName,
//           "customer_phone": customerPhone,
//           "customer_accno": customerAccNo,
//           "customer_id": customerId,
//           "customer_email": customerEmail
//         },
//         "CollectionType":collectionType,
//         "Amount": collectionAmount,
//         "note": "Loan collection payment",
//         "CorpCode": corpCode,
//         "BranchCode": branchCode,
//         "CardRefNum": cardRefNo,
//         "QrSource": "MOB",
//         "PaymentMode":paymentMode,
//         "UTRNumber":utrNumber
//       });
//       if (request.statusCode == 200) {
//         return Right(
//             LoanCashCollectionResponse.fromJson(jsonDecode(request.body)));
//       } else {
//         return Left(request.body);
//       }
//     } else {
//       return Left("No Internet Connection");
//     }
//   }
// }
