// import 'package:collection_qr_flutter/core/utils.dart';
//
// import '../../core/general.dart';
// import '../../data/repository/due_list_repository.dart';
// import '../../domain/model/due_list_model.dart';
// import 'package:flutter/material.dart';
//
//
// class DueListProvider with ChangeNotifier{
//   final DueListRepository _dueListRepository;
//   DueListProvider(this._dueListRepository);
//    DueListModel? _dueListModel;
//    DueListModel? get dueListModel => _dueListModel;
//    Future<void>getDueList(
//        String accountNumber, String onDate) async{
//      if(printStatementStatus){
//        printLog("-----------------------------GET DUE LIST MODEL---------------------");
//        printLog(dueListModel);
//      }
//
//      final result = await _dueListRepository.getDueList(accountNumber, onDate);
//      result.fold(
//          (error){
//            if(printStatementStatus){
//              printLog("----------------------ERROR-------------------");
//              printLog(error);
//            }
//
//          },
//          (data){
//            _dueListModel = data;
//            if(printStatementStatus){
//              printLog("--------------------------DATA-----------------");
//              printLog(data);
//              notifyListeners();
//            }
//
//          }
//      );
//    }
// }