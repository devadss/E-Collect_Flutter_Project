// import 'dart:convert';
// import 'package:e_Collect/core/constants.dart';
// import 'package:e_Collect/data/service/error_handler.dart';
// import 'package:e_Collect/domain/interface/group/member_update/member_update_interface.dart';
// import 'package:e_Collect/domain/model/group/member_updation/member_update_response_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// class MemberUpdateRepository implements MemberUpdateInterface {
//   @override
//   Future<Either<ErrorHandler, UpdateMemberResponse>> updateMember(
//       int memberId,
//       int groupId,
//       String memberName,
//       String memberNumber,
//       double amount,
//       String dueDate,
//       String collectionStartDate,
//       String corpCode,
//       String branchCode,
//       String entityId) async {
//     final uri = Uri.parse("${baseUrl}api/UpdateMember/$memberId");
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//     if(checkConnection== true){
//       final request = await http.put(uri,
//           body: jsonEncode({
//             "groupId": groupId,
//             "memberName": memberName,
//             "mobileNumber": memberNumber,
//             "amount": amount,
//             "dueDate": dueDate,
//             "feeCollectionStartDate": dueDate,
//             "CorpCode": corpCode,
//             "BranchCode": branchCode,
//             "EntityId": entityId
//           }),
//       headers: {'Content-Type': 'application/json'});
//       print({
//         "meberid":memberId,
//         "groupId": groupId,
//         "memberName": memberName,
//         "mobileNumber": memberNumber,
//         "amount": amount,
//         "dueDate": dueDate.toString(),
//         "feeCollectionStartDate": dueDate.toString(),
//         "CorpCode": corpCode,
//         "BranchCode": branchCode,
//         "EntityId": entityId
//       });
//       print(request.body);
//       if(request.statusCode == 200){
//         return Right(UpdateMemberResponse.fromJson(jsonDecode(request.body)));
//       }else{
//         return Left(FetchDataError(request.body));
//       }
//     }else{
//       return Left(FetchDataError("Failed to fetch data"));
//     }
//
//   }
// }
