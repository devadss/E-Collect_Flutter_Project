// import 'package:e_Collect/data/repository/payment_link_repository.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../../data/service/error_handler.dart';
// import '../../../domain/model/payment_link_model.dart';
//
// class PaymentLinkProvider with ChangeNotifier {
//   final PaymentLinkRepository _paymentLinkRepository;
//
//   PaymentLinkProvider(this._paymentLinkRepository);
//
//   PaymentLinkModel? _paymentLinkModel;
//
//   Future<Either<ErrorHandler, PaymentLinkModel>> getPaymentLink(
//       {required String agentName,
//         required String agentId,
//         required String agentOriginId,
//         required String agentPhone,
//         required String agentEmail,
//         required String customerName,
//         required String customerPhone,
//         required String customerAccountNumber,
//         required String customerEmail,
//         required String customerId,
//         required num linkAmount,
//         required String note,
//         required String corpCode,
//         required String cardRefNum,
//         required String token,
//         required String subAgentId}) async {
//     var response = await _paymentLinkRepository.getPaymentLink(agentName: agentName,
//         agentId: agentId,
//         agentOriginId: agentOriginId,
//         agentPhone: agentPhone,
//         agentEmail: agentEmail,
//         customerName: customerName,
//         customerPhone: customerPhone,
//         customerAccountNumber: customerAccountNumber,
//         customerEmail: customerEmail,
//         customerId: customerId,
//         linkAmount: linkAmount,
//         note: note,
//         corpCode: corpCode,
//         cardRefNum: cardRefNum,
//         token: token,
//         subAgentId: subAgentId);
//     response.fold((err){
//       print(err);
//     }, (success){
//       _paymentLinkModel = success;
//     });
//     notifyListeners();
//     return response;
//   }
//
//
//
// }