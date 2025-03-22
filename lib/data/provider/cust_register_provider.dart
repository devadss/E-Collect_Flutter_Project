import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/reg_cust_fail.dart';
import '../../domain/model/registered_cust_model.dart';
import '../repository/cust_reg_repository.dart';
import '../service/error_handler.dart';

class CustRegisterProvider with ChangeNotifier {
  final CustRegRepository _custRegRepository;

  CustRegisterProvider(this._custRegRepository);

  Future<Either<RegCustFailResponse, RegistedCustomerModel>> checkRegCust(
      int mobileNumber) async {
    return _custRegRepository.checkRegCust(mobileNumber);
  }
}
