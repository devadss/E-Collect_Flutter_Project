import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchant_app_flutter/data/repository/otp_request_repository.dart';
import 'package:merchant_app_flutter/domain/model/otp_request_model.dart';

class OtpRequestProvider with ChangeNotifier{
  final OtpRequestRepository _otpRequestRepository;

  OtpRequestProvider(this._otpRequestRepository);

  Future<Either<String , OtpRequestResponse>>requestOtp(String mobnum)async{
    return _otpRequestRepository.requestOtp(mobnum);
  }
}