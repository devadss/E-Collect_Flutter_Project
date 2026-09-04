// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../../domain/model/group/update_group/group_update_model.dart';
// import '../../repository/group/update_account_repository.dart';
//
// class UpdateGroupProvider with ChangeNotifier {
//   final UpdateBankAccountRepository _updateBankAccountRepository;
//
//   UpdateGroupProvider(this._updateBankAccountRepository);
//
//   GroupUpdateResponse? _groupUpdateResponse;
//
//   GroupUpdateResponse? get groupUpdateResponse => _groupUpdateResponse;
//
//   Future<Either<String, GroupUpdateResponse>> updateBankDetails(
//     int groupId,
//     String userId,
//     String accountHolderName,
//     String accountNumber,
//     String ifsc,
//     String corpCode,
//     String branchCode,
//     String entityId,
//   ) async {
//     final data = await _updateBankAccountRepository.updateBankDetails(
//         groupId,
//         userId,
//         accountHolderName,
//         accountNumber,
//         ifsc,
//         corpCode,
//         branchCode,
//         entityId);
//     data.fold((err) {}, (success) {
//       _groupUpdateResponse = success;
//     });
//     notifyListeners();
//     return data;
//   }
// }
