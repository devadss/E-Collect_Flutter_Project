// import 'dart:convert';
//
// import 'package:collection_qr_flutter/domain/interface/whatsapp_share_interface.dart';
// import 'package:collection_qr_flutter/domain/model/whatsapp_response_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
//
// class WhatsAppShareRepository implements WhatsAppShareInterface {
//   @override
//   Future<Either<String, WhatsAppApiResponse>> sendPaymentLinkViaWhatsApp(
//       String mobNumber,
//       String name,
//       String loanNumber,
//       String amount,
//       String paymentLink) async {
//     final uri =
//         Uri.parse("https://adsspayweb.digicob.in/api/whatsapp/SendMessage");
//     final request = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "to": "+91$mobNumber",
//         "templateName": "loan_adss",
//         "languageCode": "en",
//         "parameters": [
//           {"type": "text", "text": name},
//           {"type": "text", "text": loanNumber},
//           {"type": "text", "text": amount},
//           {"type": "text", "text": paymentLink}
//         ]
//       }),
//     );
//     print({
//       "to": "+91$mobNumber",
//       "templateName": "loan_adss",
//       "languageCode": "en",
//       "parameters": [
//         {"type": "text", "text": name},
//         {"type": "text", "text": loanNumber},
//         {"type": "text", "text": amount},
//         {"type": "text", "text": paymentLink}
//       ]
//     });
// print("whats app => ${request.body}");
//     try {
//       if (request.statusCode == 200) {
//         return Right(WhatsAppApiResponse.fromJson(jsonDecode(request.body)));
//       }else{
//         return Left(jsonDecode(request.body));
//       }
//     } catch (e) {
//       return const Left("Error");
//     }
//
//   }
// }
