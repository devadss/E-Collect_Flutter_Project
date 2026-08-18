// import 'dart:convert';
//
// import '../../data/service/error_handler.dart';
// import '../../domain/interface/update_dop_interface.dart';
// import '../../domain/model/update_password_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:http/http.dart'as http;
//
// class UpdateDopRepository implements IUpdateDopRepository{
//   @override
//   Future<Either<ErrorHandler, UpdatePasswordModel>> getUpdateDop(String entityID, String userName, String password,String token) async{
//     final url = Uri.parse("https://mydop.in/api/update/credentials");
//     bool checkConnection = await InternetConnectionChecker.createInstance().hasConnection;
//     final body ={
//       "entityId": entityID,
//       "username": userName,
//       "password": password
//     };
//     if(checkConnection){
//       final response = await http.post(
//           url,
//         body: body,
//         headers: {
//           'Authorization': 'Bearer $token', // Add token here
//           'Content-Type': 'application/json',
//         },
//       );
//       if(response.statusCode == 200 || response.statusCode == 201){
//         try{
//           return Right(UpdatePasswordModel.fromJson(jsonDecode(response.body)));
//         }catch(e){
//           return Left(DataParsingException(e));
//         }
//       }else{
//         return Left(FetchDataError("Failed To Fetch Data"));
//       }
//     }else{
//       return Left(FetchDataError("No Internet Connection"));
//     }
//   }
// }