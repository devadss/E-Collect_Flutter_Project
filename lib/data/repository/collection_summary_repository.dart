
import 'package:collection_qr_flutter/domain/model/no_transaction.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../domain/interface/collection_summary_interface.dart';
import '../../domain/model/collection_summary_model.dart';
import '../service/error_handler.dart';

class CollectionSummaryRepository implements ICollectionSummaryRepository {
  @override
  Future<Either<NoTransactionModel, CollectionSummaryModel>> getCollectionSummary(
      String agentId, String startDate, String endDate, String token) async {
    final url = Uri.parse(
        "${baseUrl}api/Cashfree/GetCollectionSummary?agentId=$agentId&startDate=$startDate&endDate=$endDate");

    bool checkConnection = await InternetConnectionChecker().hasConnection;
   if(checkConnection){
     final response = await http.get(
       url,
       headers: {
         "Authorization": "Bearer $token",
         "Content-Type": "application/json",
       },
     );
     if(response.statusCode == 200 || response.statusCode == 201){
       try{
         return Right(CollectionSummaryModel.fromJson(jsonDecode(response.body)));
       }catch(e){
         return Left(NoTransactionModel.fromJson(jsonDecode(response.body)));
       }
     }else{
       return Left(NoTransactionModel.fromJson(jsonDecode(response.body)));
     }
   }else{
     return Left(NoTransactionModel(message: "No Internet"));
   }
  }
}
