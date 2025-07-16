import 'package:collection_qr_flutter/data/repository/cash_transcation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../domain/model/cash_transcation_model.dart';
import '../service/error_handler.dart';

class CashTranscationProvider with ChangeNotifier {
  final CashTranscationRepository _cashTranscationRepository;
  CashTranscationProvider(this._cashTranscationRepository);
  Future<Either<ErrorHandler, CashTranscation>> getTranscations(
      {required String? agentName,
     required String? agentId,
     required String? agentOriginId,
     required String? agentPhone,
     required String? agentEmail,
     required String? subAgentId,
     required String? customerName,
     required String? customerPhone,
     required String? customerAccNo,
     required String? customerId,
     required String? customerEmail,
     required String? amount,
     required String? note,
     required String? corpCode,
     required String? cardRefNum,
     required String? token,
     required String? subagentBranchCode,
     required String? branchCode,


      }) {
    return _cashTranscationRepository.getTranscations(
       agentName:  agentName,
       agentId:  agentId,
       agentOriginId:  agentOriginId,
       agentPhone:  agentPhone,
       agentEmail:  agentEmail,
       subAgentId:  subAgentId,
       customerName:  customerName,
       customerPhone:  customerPhone,
       customerAccNo:  customerAccNo,
       customerId:  customerId,
       customerEmail:  customerEmail,
       amount:  amount,
        note: note,
        corpCode: corpCode,
       cardRefNum:  cardRefNum,
       token:  token,
    subagentBranchCode: subagentBranchCode, branchCode: branchCode);
  }
}
