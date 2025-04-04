import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/model/reg_cust_fail.dart';
import '../../domain/model/registered_cust_model.dart';
import '../repository/cust_reg_repository.dart';

class CustRegisterProvider with ChangeNotifier {
  final CustRegRepository _custRegRepository;

  CustRegisterProvider(this._custRegRepository);

  RegistedCustomerModel? _registedCustomerModel;
  RegistedCustomerModel? get registedCustomerModel => _registedCustomerModel;

  Future<Either<RegCustFailResponse, RegistedCustomerModel>> checkRegCust(
      int mobileNumber) async {
    final response = await _custRegRepository.checkRegCust(mobileNumber);
    response.fold((fail){

    }, (success){
      notifyListeners();
      _registedCustomerModel = success;
    });

    return response;
  }
}
