import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
import 'package:dartz/dartz.dart';

abstract class CollectionBaseUrlInterface{
  Future<Either<String, CollectionBaseUrlModel>>getCollectionUrl(
      String? parentMobNum
      );
}