import 'package:dartz/dartz.dart';

import '../model/whatsapp_response_model.dart';

abstract class WhatsAppShareInterface {
  Future<Either<String, WhatsAppApiResponse>> sendPaymentLinkViaWhatsApp(
      String mobNumber,
      String name,
      String loanNumber,
      String amount,
      String paymentLink,

      );
}
