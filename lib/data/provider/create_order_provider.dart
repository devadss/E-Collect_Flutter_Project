import 'package:flutter/cupertino.dart';

import '../../domain/model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';
import '../repository/order_create_repository.dart';

class CreateOrderProvider extends ChangeNotifier{
  final OrderCreateRepository _orderCreateRepository;
  CreateOrderProvider(this._orderCreateRepository);
  PaymentGatewayOrderResponseModel? _paymentGatewayOrderResponseModel;
  PaymentGatewayOrderResponseModel? get paymentGatewayOrderResponseModel => _paymentGatewayOrderResponseModel;
  Future<void> createOrderId(String? orderID,double? amount,String? custId,String? custName,String? custEmail,String? custMobNumber)async{
    print("--------------------CreateOrderProvider MODEL---------------------");
    print(paymentGatewayOrderResponseModel);
    final result = await _orderCreateRepository.createOrderId(orderID, amount, custId, custName, custEmail, custMobNumber);
    result.fold(
          (failure){
        print("failure");
        print(failure);
        print(failure.message);

      },
          (data){
        _paymentGatewayOrderResponseModel = data;
        print("notifyListeners");
        print(data);
        notifyListeners();
      },
    );
  }
}