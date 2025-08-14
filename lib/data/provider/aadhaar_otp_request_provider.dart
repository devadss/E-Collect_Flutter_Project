import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/model/aadhaar_detail_otp_response.dart';
import '../../domain/model/aadhaar_otp_request_fail_model.dart';
import '../repository/aadhaar_otp_request_repository.dart';

class AadhaarOtpRequestProvider with ChangeNotifier {
  final AadhaarOtpRequestRepository _aadhaarOtpRequestRepository;

  AadhaarOtpRequestProvider(this._aadhaarOtpRequestRepository);

  AadhaarDetailOtpRequestModel? _aadhaarDetailOtpRequestModel;
  AadhaarOtpRequestFailModel? _aadhaarOtpRequestFailModel;
  bool _isLoad = false;
  bool get isLoad => _isLoad;

  AadhaarDetailOtpRequestModel? get aadhaarDetailOtpRequestModel => _aadhaarDetailOtpRequestModel;
  AadhaarOtpRequestFailModel? get aadhaarOtpRequestFailModel => _aadhaarOtpRequestFailModel;


  Future<Either<AadhaarOtpRequestFailModel, AadhaarDetailOtpRequestModel>> verifyAadhaarNumber(String aadhaarNumber) async {
    _isLoad = true;
    _aadhaarOtpRequestFailModel = null; // ✅ Clear previous error early
    _aadhaarDetailOtpRequestModel = null; // optional
    notifyListeners();

    final result = await _aadhaarOtpRequestRepository.verifyAadhaarNumber(aadhaarNumber);

    result.fold(
          (error) {
        _aadhaarDetailOtpRequestModel = null;
        _aadhaarOtpRequestFailModel = error;
      },
          (success) {
        _aadhaarOtpRequestFailModel = null;
        _aadhaarDetailOtpRequestModel = success;
      },
    );

    _isLoad = false;
    notifyListeners();
    return result;
  }

  void resetState() {
    _aadhaarDetailOtpRequestModel = null;
    _aadhaarOtpRequestFailModel = null;
    _isLoad = false;
    notifyListeners();
  }

  void resetSuccess() {
    _aadhaarDetailOtpRequestModel = null;
    notifyListeners();
  }

  void resetFail() {
    _aadhaarOtpRequestFailModel = null;
    notifyListeners();
  }
}


/*class AadhaarOtpRequestProvider with ChangeNotifier {
  final AadhaarOtpRequestRepository? _aadhaarOtpRequestRepository;

  AadhaarOtpRequestProvider(this._aadhaarOtpRequestRepository);

  AadhaarDetailOtpRequestModel? _aadhaarDetailOtpRequestModel;

  AadhaarDetailOtpRequestModel? get aadhaarDetailOtpRequestModel => _aadhaarDetailOtpRequestModel;


  AadhaarOtpRequestFailModel? _aadhaarOtpRequestFailModel;
  AadhaarOtpRequestFailModel? get aadhaarOtpRequestFailModel => _aadhaarOtpRequestFailModel;

  bool _isLoad= false;
  bool get isLoad => _isLoad;

  Future<Either<AadhaarOtpRequestFailModel, AadhaarDetailOtpRequestModel>?> verifyAadhaarNumber(
      String? aadhaarNumber) async {
    _isLoad == true?
    _isLoad = false:
    _isLoad = true;
    notifyListeners();
    final data =
        await _aadhaarOtpRequestRepository?.verifyAadhaarNumber(aadhaarNumber);
    data?.fold((error) {
      _aadhaarDetailOtpRequestModel = null;
      _aadhaarOtpRequestFailModel = error;

    }, (success) {
      _aadhaarOtpRequestFailModel = null;
      _aadhaarDetailOtpRequestModel = success;


    });

    _isLoad = false;
    notifyListeners();
    return data;
  }

  void resetState() {
    _isLoad = false;
    _aadhaarOtpRequestFailModel = null;
    _aadhaarDetailOtpRequestModel = null;
    notifyListeners();
  }

  void resetSuccess(){
    _aadhaarDetailOtpRequestModel = null;
    notifyListeners();
  }
  void resetFail(){
    _aadhaarOtpRequestFailModel = null;
    notifyListeners();
  }
}*/
