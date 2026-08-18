// import 'package:collection_qr_flutter/data/repository/whats_app_share_repository.dart';
// import 'package:collection_qr_flutter/domain/model/whatsapp_response_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// class WhatsAppShareProvider with ChangeNotifier {
//   final WhatsAppShareRepository _whatsAppShareRepository;
//   WhatsAppShareProvider(this._whatsAppShareRepository);
//
//   WhatsAppApiResponse? _whatsAppResponse;
//   WhatsAppApiResponse? get whatsAppResponse => _whatsAppResponse;
//
//   String? _errResponse;
//   String? get errResponse => _errResponse;
//
//   Future<Either<String, WhatsAppApiResponse>> sendPaymentLinkViaWhatsApp(
//       String mobNumber,
//       String name,
//       String loanNumber,
//       String amount,
//       String paymentLink,
//
//       ) async {
//     final data = await _whatsAppShareRepository.sendPaymentLinkViaWhatsApp(mobNumber,
//         name, loanNumber, amount, paymentLink);
//     data.fold((err){
//       _errResponse = err;
//     }, (success){
//       _whatsAppResponse = success;
//     });
//     notifyListeners();
//     return data;
//
//   }
// }
