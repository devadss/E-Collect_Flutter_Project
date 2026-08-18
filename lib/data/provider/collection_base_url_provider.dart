

// import 'package:collection_qr_flutter/core/general.dart';
// import 'package:collection_qr_flutter/core/utils.dart';
// import 'package:collection_qr_flutter/data/repository/collection_base_url_repo.dart';
// import 'package:flutter/material.dart';
//
// import '../../domain/model/collection_base_url_model.dart';
//
// class CollectionBaseUrlProvider with ChangeNotifier{
//   final CollectionBaseUrlRepo _collectionBaseUrlRepo;
//   CollectionBaseUrlProvider(this._collectionBaseUrlRepo);
//   CollectionBaseUrlModel? _collectionBaseUrlModel;
//   CollectionBaseUrlModel? get collectionBaseUrlModel=>_collectionBaseUrlModel;
//
//   void clearData(){
//     _collectionBaseUrlModel = null;
//   }
//
//
//   Future<void> getCollectionUrl(String? parentMobNum)async{
//     if(printStatementStatus){
//       printLog("-------------------------------GET COLLECTION URL-------------------");
//       printLog(collectionBaseUrlModel);
//     }
//
//     final result = await _collectionBaseUrlRepo.getCollectionUrl(parentMobNum);
//     result.fold(
//         (error){
//           if(printStatementStatus){
//             printLog("-------------------------------GET COLLECTION URL ERROR-------------------");
//             printLog(error);
//           }
//
//         },
//         (data){
//           _collectionBaseUrlModel = data;
//           if(printStatementStatus){
//             printLog("-------------------------------GET COLLECTION URL DATA-------------------");
//             printLog(data);
//           }
//
//           notifyListeners();
//         }
//     );
//   }
//
//
// }
