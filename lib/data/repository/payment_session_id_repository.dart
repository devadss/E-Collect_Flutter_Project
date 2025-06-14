import 'dart:convert';

import '../../core/constants.dart';
import '../../data/service/error_handler.dart';
import '../../domain/interface/payment_session_id_interface.dart';
import '../../domain/model/paymet_session_id_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CreatePaymentSessionIdRepository implements ICreatePaymentSessionIdRepository{
  @override
  Future<Either<ErrorHandler, PaymentSessionIdModel>> getPaymentSessionId(String? token, String? amount, String? phoneNumber, String? entityId, String? note) async{
   final url = Uri.parse("${baseUrl}api/Cashfree/MerchantOrderCreate");
   final body = {

       "Amount": amount,
       "CustomerMobNo": phoneNumber,
       "EntityId": entityId,
       "Note": note,
   };
   bool checkConnection = await InternetConnectionChecker().hasConnection;
   if(checkConnection){
     final response = await http.post(
       url,
       body: json.encode(body),
         headers: {
           'Authorization': 'Bearer $token',
           'Content-Type': 'application/json',
         }
     );
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         return Right(PaymentSessionIdModel.fromJson(jsonDecode(response.body)));
       }catch(e){
         return Left(DataParsingException(e));
       }
     }else{
       return Left(FetchDataError("Failed To Fetch Data"));
     }
   }else{
     return Left(FetchDataError("No Internet Connection"));
   }
  }
}