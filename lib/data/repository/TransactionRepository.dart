import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../domain/interface/transaction_interface.dart';
import '../../domain/model/transaction_fail_model.dart';
import '../../domain/model/transaction_model.dart';
import '../storage/shared_pref_helper.dart';

class TransactionRepository implements TransactionInterface {
  @override
  Future<Either<TransactionFailModel, TransactionModel>> fetchTransactions(
      String fDate, String tDate, String entityId, String token) async {

    try {
      final uri = Uri.parse("${baseUrl}api/Fetch_TXN");
      print("entityId = $entityId");
      print("token = $token");


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
        TransactionFailModel transactionFailModel = TransactionFailModel.fromJson(json.decode(request.body));
        return Left(transactionFailModel);
      }
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }


  Future<void> getSharedData() async {

    final mobNum = await SharedPref().getMobNum();

  }
}
