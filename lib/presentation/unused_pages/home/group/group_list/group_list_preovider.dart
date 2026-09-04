// import 'package:e_Collect/data/repository/group/group_list/group_list_repository.dart';
// import 'package:e_Collect/domain/model/group/group_listing/group_list_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class GroupListProvider with ChangeNotifier{
//   final GroupListRepository _groupListRepository;
//    GroupListProvider(this._groupListRepository);
//
//    GroupListResponse? _groupListResponse;
//    GroupListResponse? get groupListResponse => _groupListResponse;
//
//    String? _groupListError;
//    String? get groupListError=> _groupListError;
//
//   Future<Either<String, GroupListResponse>> listGroupUnderUser() async {
//     final data = await _groupListRepository.listGroupUnderUser();
//     data.fold((err){
//       _groupListError = err;
//     }, (success){
//       _groupListResponse = success;
//     });
//     notifyListeners();
//     return data;
//   }
// }