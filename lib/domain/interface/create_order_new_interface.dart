import 'package:dartz/dartz.dart';

import '../model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';
import '../model/order_create_fail.dart';

abstract class CreateOrderNewInterface{
  Future<Either<OrderCreateFailResponse, PaymentGatewayOrderResponseModel>>createOrderNew(
      String amount,
      String custMobNum,
      String entityId,
      String note,
      );
}