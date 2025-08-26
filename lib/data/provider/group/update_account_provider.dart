// import 'package:collection_qr_flutter/data/repository/group/update_account_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:collection_qr_flutter/domain/model/group/default_model/default_model.dart';
// import 'package:fpdart/src/either.dart';
//
// import '../../service/error_handler.dart';
//
// class UpdateBankAccountDetailsProvider with ChangeNotifier{
//   final UpdateBankAccountDetailsRepository _updateBankAccountDetailsRepository;
//   UpdateBankAccountDetailsProvider(this._updateBankAccountDetailsRepository);
//   Future<Either<ErrorHandler, DefaultModel>> updateBankAccountDetails(String? accountId,String? userId, String? accountHolderName, String? accountNumber, String? ifsc, String? corpCode, String? branchCode, String? entityId) async{
//     return _updateBankAccountDetailsRepository.updateBankAccountDetails(accountId, userId, accountHolderName, accountNumber, ifsc, corpCode, branchCode, entityId);
//   }
// }