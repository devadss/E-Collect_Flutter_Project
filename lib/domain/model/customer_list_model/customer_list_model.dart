import 'customer_list_fail_model.dart';
import 'customer_list_success.dart';

sealed class CustomerListModel {
  const CustomerListModel();
}

class CustomerListSuccessModel extends CustomerListModel{
  final CustomerListSuccessResponse customerListSuccessResponse;
  const CustomerListSuccessModel(this.customerListSuccessResponse);
}

class CustomerListFailModel extends CustomerListModel{
  final CustomerListFailResponse customerListFailResponse;
  const CustomerListFailModel(this.customerListFailResponse);
}