
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;
import '../../constants.dart';
import '../../domain/interface/cash_free_order_create_repository.dart';
import '../../domain/model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';
import '../service/error_handler.dart';

class OrderCreateRepository implements CashFreeOrderCreateInterface{
  @override
  Future<Either<ErrorHandler, PaymentGatewayOrderResponseModel>>createOrderId(String? orderID,double? amount,String? custId,String? custName,String? custEmail,String? custMobNumber,
      String token) async{

    final uri = Uri.parse("${baseUrl}api/Cashfree/CashfeeOrder");


    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if(checkConnection == true){
      final body ={
        "order_id": orderID,
        "order_amount": amount,
        "order_currency": "INR",
        "customer_details": {
          "customer_id": custId,
          "customer_name": custName,
          "customer_email": custEmail,
          "customer_phone": custMobNumber
        },
        "order_meta": {
          "return_url": "${baseUrl}?order_id={order_id}",
          "notify_url": "https://adsspayweb.digicob.in/api/Cashfree/CashfreeWebhook"


        }
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      print("OrderCreateRepository");
      print("body : $body");
      print("-----------------------------------------");
      print("response body : ${response.body}" );
      print("-----------------------------------------");
      if(response.statusCode == 200){
        try{
          return Right(PaymentGatewayOrderResponseModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError('Failed to catch data'));
      }
    }else{
      return Left(FetchDataError('No Internet Connection'));
    }
  }
}