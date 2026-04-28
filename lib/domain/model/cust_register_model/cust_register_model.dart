

import '../registered_cust_model.dart';
import 'cust_register_success_model.dart';

sealed class CustRegisterModel {}

class CustRegisterSuccess extends CustRegisterModel{
  final RegistedCustomer registedCustomerModel;
  CustRegisterSuccess(this.registedCustomerModel);
}

class CustRegisterFail extends CustRegisterModel{
  final String error;
  CustRegisterFail(this.error);
}