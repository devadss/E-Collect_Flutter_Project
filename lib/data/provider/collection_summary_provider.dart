import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/collection_summary_model.dart';
import '../repository/collection_summary_repository.dart';

class CollectionSummaryProvider with ChangeNotifier{
  final CollectionSummaryRepository _collectionSummaryRepository;
  CollectionSummaryProvider(this._collectionSummaryRepository);
  CollectionSummaryModel? _collectionSummaryModel;
  CollectionSummaryModel? get collectionSummaryModel =>_collectionSummaryModel;
  Future<void>getCollectionSummary(String agentId, String startDate, String endDate, String token) async{
    printLog("-----------------------COLLECTION SUMMARY MODEL--------------------------");
    printLog(collectionSummaryModel);
    final result = await _collectionSummaryRepository.getCollectionSummary(agentId, startDate, endDate, token);
    result.fold(
        (error){
          printLog("---------------ERROR----------------");
          printLog(error);
        },
        (data){
          _collectionSummaryModel = data;
          printLog("--------------------DATA------------------");
          printLog(data);
          notifyListeners();
        }
    );
  }
}