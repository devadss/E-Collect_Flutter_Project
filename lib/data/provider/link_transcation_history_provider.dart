import 'package:flutter/material.dart';
import '../../core/general.dart';
import '../../domain/model/all_trans_data.dart';
import '../../domain/model/link_transaction_history_model.dart';
import '../../domain/model/qr_transaction_history_model.dart';
import '../repository/link_transaction_history_repository.dart';

class LinkTransactionHistoryProvider with ChangeNotifier{
  final LinkTransactionHistoryRepository _linkTransactionHistoryRepository;
  LinkTransactionHistoryProvider(this._linkTransactionHistoryRepository);
  String? _erResposne;
  String? get erResposne => _erResposne;
  AllTranscationHistoryModel? _linkTranscationHistoryModel;
  AllTranscationHistoryModel? get linkTranscationHistoryModel => _linkTranscationHistoryModel;
  Future<void>getLinkTransactionHistory(String filterType, String startDate, String endDate, String subAgentId,String corpCode,String agentOrginId) async{
    final result = await _linkTransactionHistoryRepository.getLinkTransactionHistory(filterType, startDate, endDate, subAgentId,corpCode,agentOrginId);
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

        }

    );
    notifyListeners();
  }
}