// import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
// import 'package:dartz/dartz.dart';
//
// abstract class CollectionBaseUrlInterface{
//   Future<Either<String, CollectionBaseUrlModel>>getCollectionUrl(
//       String? parentMobNum
//       );
// }



import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:fpdart/fpdart.dart';
import '../model/collection_base_url_model.dart';

abstract class CollectionBaseUrlInterface{
  Future<Either<ErrorHandler,CollectionBaseUrlModel>>getCollectionUrl(String? parentMobNum);
}