import 'package:collection_qr_flutter/core/utils.dart';

import '../../core/general.dart';
import '../../data/repository/collection_summary_repository.dart';
import '../../domain/model/collection_summary_model.dart';
import 'package:flutter/material.dart';

class CollectionSummaryProvider with ChangeNotifier{
  final CollectionSummaryRepository _collectionSummaryRepository;
  CollectionSummaryProvider(this._collectionSummaryRepository);
  CollectionSummaryModel? _collectionSummaryModel;
  CollectionSummaryModel? get collectionSummaryModel =>_collectionSummaryModel;
  Future<void>getCollectionSummary(String agentId, String startDate, String endDate, String token) async{
    if(printStatementStatus){
      printLog("-----------------------COLLECTION SUMMARY MODEL--------------------------");
      printLog(collectionSummaryModel);
    }

    final result = await _collectionSummaryRepository.getCollectionSummary(agentId, startDate, endDate, token);
    result.fold(
        (error){
          _collectionSummaryModel = null;
          if(printStatementStatus){
            printLog("---------------ERROR----------------");
            printLog(error);
          }

        },
        (data){
          _collectionSummaryModel = data;
          if(printStatementStatus){
            printLog("--------------------DATA------------------");
            printLog(data);
          }

          notifyListeners();
        }
    );
  }
}