import 'dart:convert';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/create_order_new_interface.dart';
import 'package:collection_qr_flutter/domain/model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';
import 'package:collection_qr_flutter/domain/model/order_create_fail.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CreateOrderRepositoryNew implements CreateOrderNewInterface {
  @override
  Future<Either<OrderCreateFailResponse,
      PaymentGatewayOrderResponseModel>> createOrderNew(String amount,
      String custMobNum, String entityId, String note) async {
    final uri = Uri.parse("${baseUrl}api/Cashfree/MerchantOrderCreate");
    final request = await http.post(uri,
        body: jsonEncode({
          "Amount": "1",
          "CustomerMobNo": "+91$custMobNum",
          "EntityId": entityId,
          "Note": ""
        }),
      headers: {
        'Content-Type': 'application/json'
      },
    );
    
    if(request.statusCode == 200){
      return Right(PaymentGatewayOrderResponseModel.fromJson(jsonDecode(request.body)));
    }else{
      return Left(OrderCreateFailResponse.fromJson(jsonDecode(request.body)));
    }
  }

}