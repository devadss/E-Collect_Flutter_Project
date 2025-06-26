import 'dart:convert';

import 'package:collection_qr_flutter/domain/interface/collection_base_url_interface.dart';
import 'package:collection_qr_flutter/domain/model/collection_base_url_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CollectionBaseUrlRepo implements CollectionBaseUrlInterface{
  @override
  Future<Either<String, CollectionBaseUrlModel>> getCollectionUrl(
      String? parentMobNum
      ) async {
    parentMobNum!.startsWith("+91")?
  parentMobNum.replaceAll("+91", ""):parentMobNum;
   final uri = Uri.parse("http://devops.mydop.in/api/fetch/vendor/urls/$parentMobNum");
   final request = await http.get(uri);
   print(request.body);
   if(request.statusCode == 200){
     return Right(CollectionBaseUrlModel.fromJson(jsonDecode(request.body)));
   }else{
     return Left(request.body);
   }

  }
  
}