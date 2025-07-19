import 'package:dartz/dartz.dart';
import '../model/reg_cust_fail.dart';
import '../model/registered_cust_model.dart';

abstract class RegCustInterafce {
  Future<Either<RegCustFailResponse, RegistedCustomerModel>>checkRegCust(int mobileNumber);
}