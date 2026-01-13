import 'customer_list_fail_model.dart';
import 'customer_list_success.dart';

sealed class CustomerListModel {}

class CustomerListSuccessModel extends CustomerListModel{
  final CustomerListSuccessResponse customerListSuccessResponse;
  CustomerListSuccessModel(this.customerListSuccessResponse);
}

class CustomerListFailModel extends CustomerListModel{
  final CustomerListFailResponse customerListFailResponse;
  CustomerListFailModel(this.customerListFailResponse);
}