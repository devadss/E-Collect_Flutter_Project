// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../domain/model/customer_list_model/customer_list_fail_model.dart';
// import '../domain/model/customer_list_model/customer_list_success.dart';
//
// class LoginModel {
//   String userName;
//   String password;
//
//   LoginModel(this.userName, this.password);
// }
//
// sealed class CustomerListModel {
//   const CustomerListModel();
// }
//
// class CustomerListSuccessModel extends CustomerListModel {
//   final CustomerListSuccessResponse customerListSuccessResponse;
//   const CustomerListSuccessModel(this.customerListSuccessResponse);
// }
//
// class CustomerListFailModel extends CustomerListModel {
//   final CustomerListFailResponse customerListFailResponse;
//   const CustomerListFailModel(this.customerListFailResponse);
// }
//
// class MainRepository<T> {
//   String baseUrl;
//   String endPont;
//   T requestBody;
//
//   MainRepository(this.baseUrl, this.endPont, this.requestBody);
//
//   Future<CustomerListModel> mainFetchRequest() async {
//     final uri = Uri.parse(baseUrl + endPont);
//     var body = jsonEncode({requestBody});
//     final request = await http.post(uri, body: body);
//
//     if (request.statusCode == 200) {
//       return CustomerListSuccessModel(
//           CustomerListSuccessResponse.fromJson(jsonDecode(request.body)));
//     } else {
//       return CustomerListFailModel(
//           CustomerListFailResponse.fromJson(jsonDecode(request.body)));
//     }
//   }
// }
//
// class LoginRepositort extends MainRepository {
//   LoginRepositort(super.baseUrl, super.endPont, super.requestBody);
// }
//
// class ItemRepositort extends MainRepository {
//   ItemRepositort(super.baseUrl, super.endPont, super.requestBody);
// }
//
// void main() {
//   var selectedValue = {
//     "listUrl": {
//       "LOAN": [
//         "https://mftctest.digicob.in/RDLoanAgentlist",
//         "https://mftctest.digicob.in/getLoanCustUnderAgent",
//         "https://mftctest.digicob.in/loan/due-list",
//         "https://mftctest.digicob.in/LoanReceiptCash"
//       ],
//       "RD": [
//         "https://mftctest.digicob.in/RDLoanAgentlist",
//         "https://mftctest.digicob.in/getRDCustomerunderAgentList",
//         "https://mftctest.digicob.in/rd/due-list",
//         "https://mftctest.digicob.in/cashDeposit"
//       ]
//     }
//   };
//   for (var x in selectedValue["listUrl"]!.keys) {
//     print(x);
//   }
// }
