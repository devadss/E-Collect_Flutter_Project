// import 'package:collection_qr_flutter/data/repository/parent_agent/fetch_parent_crentials/parent_agent_credential_repository.dart';
// import 'package:collection_qr_flutter/domain/model/subagent/fetch_parent_credentials/parent_agent_credentials.dart';
// import 'package:collection_qr_flutter/domain/model/subagent/fetch_parent_credentials/parent_agent_credentila_fail.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class ParentAgentCredentialProvider with ChangeNotifier {
//   final ParentAgentCredentialRepository _parentAgentCredentialRepository;
//
//   ParentAgentCredentialProvider(this._parentAgentCredentialRepository);
//
//   ParentAgentCredentialModel? _parentAgentCredentialModel;
//
//   ParentAgentCredentialModel? get parentAgentCredentialModel =>
//       _parentAgentCredentialModel;
//
//   ParentAgentCredentialFailResponse? _parentAgentCredentialFailResponse;
//
//   ParentAgentCredentialFailResponse? get parentAgentCredentialFailResponse =>
//       _parentAgentCredentialFailResponse;
//
//   Future<Either<ParentAgentCredentialFailResponse, ParentAgentCredentialModel>>
//       fetchParentAgentCredentials(String mobileNumber) async {
//     final data = await _parentAgentCredentialRepository
//         .fetchParentAgentCredentials(mobileNumber);
//     data.fold((err) {
//       _parentAgentCredentialFailResponse = err;
//       _parentAgentCredentialModel = null;
//     }, (success) {
//       _parentAgentCredentialFailResponse = null;
//       _parentAgentCredentialModel = success;
//     });
//     notifyListeners();
//     return data;
//   }
// }
