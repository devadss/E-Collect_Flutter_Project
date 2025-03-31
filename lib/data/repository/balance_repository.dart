import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/balance_interface.dart';
import 'package:collection_qr_flutter/domain/model/balance_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/fetch_balance_model.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class BalanceRepository extends BalanceInterface {
  @override
  Future<Either<BalanceFailModel, BalanceModel>> getBalance(
      String entityID, String token) async {
    final uri = Uri.parse("${baseUrl}api/Fetchbalance");
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if (checkConnection == true) {
      final request = await http
          .post(uri, body: json.encode({"entityId": entityID}), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (request.statusCode == 200) {
        BalanceModel balanceModel =
            BalanceModel.fromJson(json.decode(request.body));
        return Right(balanceModel);
      } else {
        BalanceFailModel balanceFailModel =
            BalanceFailModel.fromJson(json.decode(request.body));
        return Left(balanceFailModel);
      }
    }
    BalanceFailModel balanceFailModel =
        BalanceFailModel(message: "CHECK NETWORK CONNECTION", status: "N");
    return Left(balanceFailModel);
  }
}
