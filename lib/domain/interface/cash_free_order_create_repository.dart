import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';

abstract class CashFreeOrderCreateInterface{
  Future<Either<ErrorHandler,PaymentGatewayOrderResponseModel>>createOrderId(String? orderID,double? amount,String? custId,String? custName,String? custEmail,String? custMobNumber);
}
