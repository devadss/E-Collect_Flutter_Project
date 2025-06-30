import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/link_transaction_history_model.dart';
import '../repository/link_transaction_history_repository.dart';

class LinkTransactionHistoryProvider with ChangeNotifier{
  final LinkTransactionHistoryRepository _linkTransactionHistoryRepository;
  LinkTransactionHistoryProvider(this._linkTransactionHistoryRepository);
  String? _erResposne;
  String? get erResposne => _erResposne;
  LinkTranscationHistoryModel? _linkTranscationHistoryModel;
  LinkTranscationHistoryModel? get linkTranscationHistoryModel => _linkTranscationHistoryModel;
  Future<void>getLinkTransactionHistory(String filterType, String startDate, String endDate, String subAgentId) async{
    final result = await _linkTransactionHistoryRepository.getLinkTransactionHistory(filterType, startDate, endDate, subAgentId);
    printLog("---------------------------LINK TRABSACTION HISTORY MODEL------------------");
    printLog(linkTranscationHistoryModel);
    result.fold(
        (error){
          _linkTranscationHistoryModel = null;
          _erResposne = error.message;
          printLog("---------------------------ERROR LINK------------------");
          printLog(error);
        },
        (data){
          _erResposne= null;
         _linkTranscationHistoryModel = data;
          printLog("-----------------------DATA---------------");
          printLog(data);
          notifyListeners();
        }
    );
  }
}