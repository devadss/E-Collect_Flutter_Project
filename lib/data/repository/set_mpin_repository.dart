import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/mpin_set_interface.dart';
import 'package:collection_qr_flutter/domain/model/mpin_set_model.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SetMpinRepository implements MpinSetInterface {
  @override
  Future<Either<MpinSetResponse, MpinSetResponse>> setMpin(
      String mpin, String mobnum, String token) async {
    try {
      bool checkConnection = await InternetConnectionChecker().hasConnection;

      final uri = Uri.parse("${baseUrl}api/SetMPIN");
      if(checkConnection == true){
        final request = await http.post(uri,
            headers: {'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',},

            body: json.encode({"MPIN": mpin, "MobileNo": "+91$mobnum"}));
        print("mpin :$mpin");
        print("mobnum :$mobnum");
        print(request.body);
        if (request.statusCode == 200) {
          MpinSetResponse mpinSetResponse =
          MpinSetResponse.fromJson(jsonDecode(request.body));
          return Right(mpinSetResponse);
        } else {
          MpinSetResponse mpinSetResponse =
          MpinSetResponse.fromJson(jsonDecode(request.body));
          return Left(mpinSetResponse);
        }
      }else{ MpinSetResponse mpinSetResponse =
        MpinSetResponse(
          message: "CHECK INTERNET CONNECION", status: "N"
        );
        return Left(mpinSetResponse);
      }

    } catch (e) {
      return Left(e as MpinSetResponse);
    }
  }
}
