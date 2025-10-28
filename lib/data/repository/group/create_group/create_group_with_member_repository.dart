import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/interface/group/group_creation/create_group_with_member_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/group_creation/group_with_member.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CreateGroupWithMemberRepository
    implements CreateGroupWithMemberInterface {
  @override
  Future<Either<ErrorHandler, CreateGroupWithMemberResponse>>
      createGroupWitMember(
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse("${baseUrl}api/CreateGroupWithMembers");
    bool checkInternetConnection =
        await InternetConnectionChecker.createInstance().hasConnection;
    if (checkInternetConnection == true) {

        final response = await http.post(
          uri,
          body: jsonEncode(payload),
          headers: {'Content-Type': 'application/json'},
        );

        print("Payload Sent: $payload");
        print("Response: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          try{
            final data =
            CreateGroupWithMemberResponse.fromJson(jsonDecode(response.body));
            return Right(data);
          }catch(e){
            return Left(DataParsingException(response.body));
          }
        } else {
          return Left(FetchDataError("Failed To Fetch Data"));
        }

    }else{
      return Left(FetchDataError("No internet connection"));
    }
  }
}

// class CreateGroupWithMemberRepository
//     implements CreateGroupWithMemberInterface {
//   @override
//   Future<Either<String, CreateGroupWithMemberResponse>> createGroupWitMember(
//       String groupName,
//       String corpCode,
//       double defaultAmount,
//       String defaultDueDate,
//       String entityId,
//       String memberName,
//       String mobileNumber,
//       double amount,
//       String dueDate,
//       String feeCollectionStartDate) async {
//     //final uri = Uri.parse("${baseUrl}api/CreateGroupWithMembers");
//     final uri = Uri.parse("${baseUrl}api/dsdsd");
//     final request = await http.post(
//       uri,
//       body: jsonEncode({
//         "groupName": groupName,
//         "corpCode": corpCode,
//         "defaultAmount": defaultAmount,
//         "defaultDueDate": defaultDueDate,
//         "members": [
//           {
//             "entityId": entityId,
//             "memberName": memberName,
//             "mobileNumber": mobileNumber,
//             "amount": amount,
//             "dueDate": dueDate,
//             "feeCollectionStartDate": feeCollectionStartDate
//           }
//         ]
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );
// print({
//   "groupName": groupName,
//   "corpCode": corpCode,
//   "defaultAmount": defaultAmount,
//   "defaultDueDate": defaultDueDate,
//   "members": [
//     {
//       "entityId": entityId,
//       "memberName": memberName,
//       "mobileNumber": mobileNumber,
//       "amount": amount,
//       "dueDate": dueDate,
//       "feeCollectionStartDate": feeCollectionStartDate
//     }
//   ]
// });
//     if (request.statusCode == 200) {
//       return Right(
//           CreateGroupWithMemberResponse.fromJson(jsonDecode(request.body)));
//     } else {
//       return Left(jsonDecode(request.body));
//     }
//   }
// }
