import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../domain/interface/mpin_set_interface.dart';
import '../../domain/model/mpin_set_model.dart';

class SetMpinRepository implements MpinSetInterface {
  @override
  Future<Either<MpinSetResponse, MpinSetResponse>> setMpin(
      String mpin, String mobnum,String token) async {
    try {
      final uri = Uri.parse("${baseUrl}api/SetMPIN");
      final request = await http.post(uri,
          headers: {
            'Authorization': 'Bearer $token', // Add token here
            'Content-Type': 'application/json',
          },
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
    } catch (e) {
      return Left(e as MpinSetResponse);
    }
  }
}
