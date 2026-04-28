import 'package:collection_qr_flutter/domain/model/vendor_model/vendor_model_success.dart';

sealed class VendorModel {}

class VendorSuccessModel extends VendorModel{
  final VendorSuccessResponse vendorSuccessResponse;
  VendorSuccessModel(this.vendorSuccessResponse);
}

class VendorFailModel extends VendorModel{
  final String error;
  VendorFailModel(this.error);
}