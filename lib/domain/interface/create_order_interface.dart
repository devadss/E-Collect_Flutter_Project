import 'package:dartz/dartz.dart';
import '../../data/service/error_handler.dart';
import '../model/create_order_model.dart';


abstract class CashFreeOrderCreateInterface{
  Future<Either<ErrorHandler,PaymentGatewayOrderResponseModel>>createOrderId(String? orderID,double? amount,String? custId,String? custName,String? custEmail,String? custMobNumber,String token);
}
