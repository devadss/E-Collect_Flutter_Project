import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/aadhaar_otp_request_fail_model.dart';
import '../../domain/model/verify_aadhaar_model.dart';
import '../repository/verify_aadhaar_detail_repository.dart';


class VerifyAadhaarDetailProvider with ChangeNotifier {
  final VerifyAadhaarDetailRepository _verifyAadhaarDetailRepository;

  VerifyAadhaarDetailProvider(this._verifyAadhaarDetailRepository);

  VerifyAadhaarDetailsModel? _verifyAadhaarDetailsModel;

  VerifyAadhaarDetailsModel? get verifyAadhaarDetailsModel =>
      _verifyAadhaarDetailsModel;

  AadhaarOtpRequestFailModel? _aadhaarOtpRequestFailModel;

  AadhaarOtpRequestFailModel? get aadhaarOtpRequestFailModel =>
      _aadhaarOtpRequestFailModel;

  bool _isLoad = false;

  bool get isload => _isLoad;

  Future<Either<AadhaarOtpRequestFailModel, VerifyAadhaarDetailsModel>>
      getAadhaarDetails(
          String otp, String refId, String vendorCode, String custId) async {
    _isLoad = true;
    notifyListeners();
    final data = await _verifyAadhaarDetailRepository.getAadhaarDetails(
        otp, refId, vendorCode, custId);
    data.fold((error) {
      _verifyAadhaarDetailsModel = null;
      _aadhaarOtpRequestFailModel = error;
    }, (success) {
      _aadhaarOtpRequestFailModel = null;
      _verifyAadhaarDetailsModel = success;
    });
    _isLoad = false;
    notifyListeners();
    return data;
  }

  void resetState() {
    _isLoad = false;
    _aadhaarOtpRequestFailModel = null;
    _verifyAadhaarDetailsModel = null;
    notifyListeners();
  }
}
