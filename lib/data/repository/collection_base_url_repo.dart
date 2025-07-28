import 'dart:convert';

import 'package:collection_qr_flutter/domain/interface/collection_base_url_interface.dart';
import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants.dart';

class CollectionBaseUrlRepo implements CollectionBaseUrlInterface {
  @override
  Future<Either<String, CollectionBaseUrlModel>> getCollectionUrl(
      String? parentMobNum) async {
    parentMobNum!.startsWith("+91")
        ? parentMobNum.replaceAll("+91", "")
        : parentMobNum;
    print("parentMobNum $parentMobNum");
    final uri = Uri.parse("$dopBaseUrl$parentMobNum");
    final request = await http.get(uri);
    print("CollectionBaseUrlRepo : $uri");
    print("CollectionBaseUrlRepo Body:${request.body}");
    if (request.statusCode == 200) {
      return Right(CollectionBaseUrlModel.fromJson(jsonDecode(request.body)));
    } else {
      return Left(request.body);
    }
  }
}
