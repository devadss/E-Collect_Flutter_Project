import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/all_trans_data.dart';
import '../repository/link_transaction_history_repository.dart';

class LinkTransactionHistoryProvider with ChangeNotifier{
  final LinkTransactionHistoryRepository _linkTransactionHistoryRepository;
  LinkTransactionHistoryProvider(this._linkTransactionHistoryRepository);
  String? _erResposne;
  String? get erResposne => _erResposne;
  AllTranscationHistoryModel? _linkTranscationHistoryModel;
  AllTranscationHistoryModel? get linkTranscationHistoryModel => _linkTranscationHistoryModel;
  bool? _showProgressDialog;
  bool? get showProgressDialog  => _showProgressDialog;
  Future<void>getLinkTransactionHistory(String filterType, String startDate, String endDate, String subAgentId,String corpCode,String agentOrginId) async{
    final result = await _linkTransactionHistoryRepository.getLinkTransactionHistory(filterType, startDate, endDate, subAgentId,corpCode,agentOrginId);
    printLog("---------------------------LINK TRABSACTION HISTORY MODEL------------------");
    printLog(linkTranscationHistoryModel);
    _showProgressDialog = true;
    notifyListeners();
    result.fold(
        (error){
          _linkTranscationHistoryModel = null;
          _erResposne = error.message;
          _showProgressDialog = false;
          printLog("---------------------------ERROR LINK------------------");
          printLog(error);
        },
        (data){
          _erResposne= null;
         _linkTranscationHistoryModel = data;
          printLog("-----------------------DATA---------------");
          printLog(data);
          _showProgressDialog = false;
        }

    );
    notifyListeners();
  }
}