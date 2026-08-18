// import 'package:flutter/material.dart';
// import '../../domain/model/create_order_model.dart';
// import '../repository/create_order_repository.dart';
//
// class CreateOrderProvider extends ChangeNotifier {
//   final OrderCreateRepository _orderCreateRepository;
//   CreateOrderProvider(this._orderCreateRepository);
//   PaymentGatewayOrderResponseModel? _paymentGatewayOrderResponseModel;
//   PaymentGatewayOrderResponseModel? get paymentGatewayOrderResponseModel =>
//       _paymentGatewayOrderResponseModel;
//   Future<void> createOrderId(String? orderID, double? amount, String? custId,
//       String? custName, String? custEmail, String? custMobNumber,String token) async {
//     print("--------------------CreateOrderProvider MODEL---------------------");
//     print(paymentGatewayOrderResponseModel);
//     final result = await _orderCreateRepository.createOrderId(
//         orderID, amount, custId, custName, custEmail, custMobNumber,token);
//     result.fold(
//       (failure) {
//         print("failure");
//         print(failure);
//         print(failure.message);
//       },
//       (data) {
//         _paymentGatewayOrderResponseModel = data;
//         print("notifyListeners");
//         print(data);
//         notifyListeners();
//       },
//     );
//   }
// }
