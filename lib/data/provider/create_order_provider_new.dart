import 'package:collection_qr_flutter/data/repository/create_order_repository_new.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/cash_free_pg/ordercreate_response_model/pg_order_create_response_model.dart';
import '../../domain/model/order_create_fail.dart';

class CreateOrderProviderNew with ChangeNotifier {
  final CreateOrderRepositoryNew _createOrderRepositoryNew;

  CreateOrderProviderNew(this._createOrderRepositoryNew);

  PaymentGatewayOrderResponseModel? _paymentGatewayOrderResponseModel;

  PaymentGatewayOrderResponseModel? get paymentGatewayOrderResponseModel =>
      _paymentGatewayOrderResponseModel;

  OrderCreateFailResponse? _createFailResponse;

  OrderCreateFailResponse? get createFailResponse => _createFailResponse;

  Future<Either<OrderCreateFailResponse, PaymentGatewayOrderResponseModel>>
      createOrderNew(String amount, String custMobNum, String entityId,
          String note) async {
    final data = await _createOrderRepositoryNew.createOrderNew(
        amount, custMobNum, entityId, note);
    data.fold((fail) {
      _createFailResponse = fail;
      _paymentGatewayOrderResponseModel = null;
    }, (success) {
      _createFailResponse = null;
      _paymentGatewayOrderResponseModel = success;
    });
    notifyListeners();
    return data;
  }
}
