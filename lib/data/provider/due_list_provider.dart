
import 'package:flutter/material.dart';

import '../../core/general.dart';
import '../../domain/model/due_list_model.dart';
import '../repository/due_list_repository.dart';


class DueListProvider with ChangeNotifier{
  final DueListRepository _dueListRepository;
  DueListProvider(this._dueListRepository);
   DueListModel? _dueListModel;
   DueListModel? get dueListModel => _dueListModel;
   Future<void>getDueList(
       String accountNumber, String onDate) async{
     printLog("-----------------------------GET DUE LIST MODEL---------------------");
     printLog(dueListModel);
     final result = await _dueListRepository.getDueList(accountNumber, onDate);
     result.fold(
         (error){
           printLog("----------------------ERROR-------------------");
           printLog(error);
         },
         (data){
           _dueListModel = data;
           printLog("--------------------------DATA-----------------");
           printLog(data);
           notifyListeners();
         }
     );
   }
}