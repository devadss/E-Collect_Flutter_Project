import 'package:e_Collect/domain/model/e_collect/fcm/unregister_fail.dart';
import 'package:e_Collect/domain/model/e_collect/fcm/unregister_success.dart';

sealed class FcmUnregister {
  const FcmUnregister();
}

class FcmUnregisterSuccess extends FcmUnregister{
  final UnregisterDeviceSuccessResponse unregisterDeviceSuccessResponse;
  FcmUnregisterSuccess(this.unregisterDeviceSuccessResponse);
}

class FcmUnregisterFail  extends FcmUnregister{
  final DeviceUnregisterFailResponse deviceUnregisterFailResponse;
  FcmUnregisterFail(this.deviceUnregisterFailResponse);
}