import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants.dart';
import '../../domain/interface/new_qr_code_interface.dart';
import '../../domain/model/new_qr_code_model.dart';
import '../service/error_handler.dart';

class NewQrCodeRepository implements INewQrCodeRepository {
  @override
  Future<Either<ErrorHandler, NewQrCodeModel>> getQrCode(
      String? paymentSessionId,String? token
  ) async {
    final url = Uri.parse("${baseUrl}api/Cashfree/QRGenerator");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    final body = {
      "payment_session_id": paymentSessionId,
      "payment_method": {
        "upi": {"channel": "qrcode"},
      },
    };
    if(checkConnection){
      final response = await http.post(
        url,
          body: json.encode(body),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          return Right(NewQrCodeModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed to Fetch data"));
      }
    }else{
      return Left(FetchDataError("NO Internet Connection"));
    }
  }
}
