import 'dart:convert';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/qr_genertaion_interface_new.dart';
import 'package:collection_qr_flutter/domain/model/qr_response_data.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class QrGenerationRepositoryNew implements QrGenerateInterfaceNew {
  @override
  Future<Either<String, QrResponseData>> generateQrCode(
      String paymentSessionId) async {
    final uri = Uri.parse("${baseUrl}api/Cashfree/QRGenerator");
    final request = await http.post(uri,
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "payment_session_id": paymentSessionId,
          "payment_method": {
            "upi": {
              "channel": "qrcode"
            }
          }
        })
    );
    print({
      "payment_session_id": paymentSessionId,
      "payment_method": {
        "upi": {
          "channel": "qrcode"
        }
      }
    });
    if(request.statusCode == 200){
      return Right(QrResponseData.fromJson(jsonDecode(request.body)));
    }
    else{
      return Left(request.body);
    }
  }

}