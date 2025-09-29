// import 'package:collection_qr_flutter/data/repository/collection_base_url_repo.dart';
// import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class CollectionBaseUrlProvider with ChangeNotifier{
//   final CollectionBaseUrlRepo _collectionBaseUrlRepo;
//   CollectionBaseUrlProvider(this._collectionBaseUrlRepo);
//
//   CollectionBaseUrlModel? _collectionBaseUrlModel;
//   CollectionBaseUrlModel? get collectionBaseUrlModel=>_collectionBaseUrlModel;
//
//   Future<Either<String, CollectionBaseUrlModel>> getCollectionUrl(
//       String? parentMobNum
//       ) async {
//     final result = await _collectionBaseUrlRepo.getCollectionUrl(parentMobNum);
//     result.fold((err){}, (success){
//       _collectionBaseUrlModel = success;
//     });
//     notifyListeners();
//     return result;
//   }
// }

import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/data/repository/collection_base_url_repo.dart';
import 'package:flutter/material.dart';

import '../../domain/model/collection_base_url_model.dart';

class CollectionBaseUrlProvider with ChangeNotifier{
  final CollectionBaseUrlRepo _collectionBaseUrlRepo;
  CollectionBaseUrlProvider(this._collectionBaseUrlRepo);
  CollectionBaseUrlModel? _collectionBaseUrlModel;
  CollectionBaseUrlModel? get collectionBaseUrlModel=>_collectionBaseUrlModel;
  Future<void> getCollectionUrl(String? parentMobNum)async{
    printLog("-------------------------------GET COLLECTION URL-------------------");
    printLog(collectionBaseUrlModel);
    final result = await _collectionBaseUrlRepo.getCollectionUrl(parentMobNum);
    result.fold(
        (error){
          printLog("-------------------------------GET COLLECTION URL ERROR-------------------");
          printLog(error);
        },
        (data){
          _collectionBaseUrlModel = data;
          printLog("-------------------------------GET COLLECTION URL DATA-------------------");
          printLog(data);
          notifyListeners();
        }
    );
  }


}
