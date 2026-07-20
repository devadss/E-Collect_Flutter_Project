import 'package:http/http.dart' as http;
import 'package:collection_qr_flutter/core/constants.dart';

class AuthenticationRepository {
  final uri = Uri.parse(baseUrl);
  Future<void> mobLoginRepository() async {}
  Future<void> mobOtpRequestRepository() async {}
  Future<void> mobOtpVerificationRepository() async {}
  Future<void> merchantOnboardingRepository() async {}
  Future<void> merchantOnboardingStatusRepository() async {}
}
