import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection_qr_flutter/data/repository/set_mpin_repository.dart';
import 'package:collection_qr_flutter/domain/model/mpin_set_model.dart';

class SetMpinProvider with ChangeNotifier{
  SetMpinRepository _mpinRepository;

  SetMpinProvider(this._mpinRepository);

  Future<Either<MpinSetResponse, MpinSetResponse>>setMpin(String mpin , String mobnum,
      String token) async{
    return _mpinRepository.setMpin(mpin, mobnum, token);
  }
}