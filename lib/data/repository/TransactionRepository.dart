import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:collection_qr_flutter/constants.dart';
import 'package:collection_qr_flutter/domain/interface/transaction_interface.dart';
import 'package:collection_qr_flutter/domain/model/transaction_fail_model.dart';
import 'package:collection_qr_flutter/domain/model/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TransactionRepository implements TransactionInterface {
  @override
  Future<Either<TransactionFailModel, TransactionModel>> fetchTransactions(
      String fDate, String tDate, String entityId, String token) async {
    try {
      final uri = Uri.parse("${baseUrl}api/Fetch_TXN");
      print("entityId = $entityId");
      print("token = $token");
      bool checkConnection = await InternetConnectionChecker().hasConnection;
if(checkConnection ==  true){
  final request = await http.post(
    uri,
    body: json
        .encode({"fromDate": fDate, "toDate": tDate, "entityId": entityId}),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("request.body = ${request.body}");
  print(request.statusCode);

  if (request.statusCode == 200) {
    TransactionModel transactionModel =
    TransactionModel.fromJson(json.decode(request.body));
    return Right(transactionModel);
  } else {
    TransactionFailModel transactionFailModel =
    TransactionFailModel.fromJson(json.decode(request.body));
    return Left(transactionFailModel);
  }
}else{

}

    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }
}
