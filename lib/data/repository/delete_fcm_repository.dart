import 'dart:convert';

import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/delete_fcm_interface.dart';
import 'package:dartz/dartz.dart';
import "package:http/http.dart" as http;

class DeleteFcmTokenRepository extends DeleteFcmTokenInterface {
  @override
  Future<Either<String, String>> deleteFcmToken(String entityID, String token) async {
    try {
      final uri = Uri.parse("$baseUrl/api/DeleteToken");
      final request = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({"EntityId": entityID}));

      if(request.statusCode == 200){
        return Right(request.body);
      }else{
        return Left(request.body);
      }
    } catch (e) {

    }
    throw UnimplementedError();
  }
}
