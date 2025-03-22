import 'package:dartz/dartz.dart';
import 'package:merchant_app_flutter/domain/model/mpin_set_model.dart';

abstract class MpinSetInterface {
  Future<Either<MpinSetResponse, MpinSetResponse>>setMpin(String mpin , String mobnum);
}
