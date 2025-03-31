import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/domain/model/mpin_set_model.dart';

abstract class MpinSetInterface {
  Future<Either<MpinSetResponse, MpinSetResponse>>setMpin(String mpin , String mobnum, String token);
}
