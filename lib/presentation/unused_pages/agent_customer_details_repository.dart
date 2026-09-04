// import 'dart:convert';
// import '../../core/general.dart';
// import '../../core/utils.dart';
// import '../../data/service/error_handler.dart';
// import '../../domain/interface/agent_customer_details_interface.dart';
// import '../../domain/model/agent_customer_details_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
//
// class AgentCustomerDetailsRepository
//     implements IAgentCustomerDetailsRepository {
//
//
//   @override
//   Future<Either<ErrorHandler, AgentCustomerDetailsModel>>
//       getAgentCustomerDetails(
//       String requestUrl,
//       String agentId,
//       String branchId
//
//       ) async {
//     final url = Uri.parse(requestUrl);
//     print(
//         "--------------------------AGENT CUSTOMER DETAILS URL------------------");
//     print(url);
//     print("agentId : $agentId");
//
//     final response = await http.post(
//       url,
//       body:json.encode({
//         "agent_id": agentId,
//         "branch_id":   branchId,
//         "PageNumber": 0,
//         "PageSize": 0,
//         "cust_name": ""
//       }),
//         headers: {"Content-Type":"application/json"}
//
//     );
//     if (printStatementStatus) {
//       printLog(
//           "------------------------AGENT CUSTOMER DETAILS STATUSCODE-------------------");
//       printLog(response.statusCode);
//       printLog(
//           "------------------------AGENT CUSTOMER DETAILS BODY RD--------------------------");
//       printLog(response.body);
//     }
//
//     if (response.statusCode == 200) {
//       try {
//         return Right(
//             AgentCustomerDetailsModel.fromJson(jsonDecode(response.body)));
//       } catch (e) {
//         return Left(DataParsingException(e));
//       }
//     } else {
//       return Left(FetchDataError("Failed to Fetch data"));
//     }
//   }
// }
