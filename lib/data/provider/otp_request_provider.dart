import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/otp_request_model.dart';
import '../repository/otp_request_repository.dart';


class OtpRequestProvider with ChangeNotifier{
  final OtpRequestRepository _otpRequestRepository;

  OtpRequestProvider(this._otpRequestRepository);

  Future<Either<String , OtpRequestResponse>>requestOtp(String mobnum)async{
    return _otpRequestRepository.requestOtp(mobnum);
  }
}