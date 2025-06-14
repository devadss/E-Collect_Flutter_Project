import 'package:collection_qr_flutter/domain/model/qr_response_data.dart';
import 'package:dartz/dartz.dart';

abstract class QrGenerateInterfaceNew{
  Future<Either<String , QrResponseData>>generateQrCode(
      String paymentSessionId
      );
}