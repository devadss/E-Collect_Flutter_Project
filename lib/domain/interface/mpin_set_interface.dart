import 'package:dartz/dartz.dart';

import '../model/mpin_set_model.dart';

abstract class MpinSetInterface {
  Future<Either<MpinSetResponse, MpinSetResponse>>setMpin(String mpin , String mobnum,String token);
}
