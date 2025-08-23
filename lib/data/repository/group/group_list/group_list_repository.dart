import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/model/group/group_listing/group_list_model.dart';
import 'package:http/http.dart'as http;
import 'package:dartz/dartz.dart';

import '../../../../domain/interface/group/group_list/group_list_interface.dart';

class GroupListRepository implements GroupListInterface{
  @override
  Future<Either<String, GroupListResponse>> listGroupUnderUser() async {
   final uri = Uri.parse("${baseUrl}api/GetAllGroups");
   final request = await http.get(uri);
   print("GroupListRepository = ${request.body}");
   if(request.statusCode == 200){
     return Right(GroupListResponse.fromJson(jsonDecode(request.body)));
   }else{
     return Left(jsonDecode(request.body));
   }
  }
  
}