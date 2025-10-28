import 'dart:convert';

import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/domain/interface/cash_qr_combined_interface.dart';
import 'package:collection_qr_flutter/domain/model/qr_cash_combined_response.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CashQrRepository implements CashQrCombinedInterface {
  @override
  Future<Either<String, CashQrCombinedResponse>> getCombinedResponse(
      String filterType,
      String startDate,
      String endDate,
      String subAgentId,
      String corpCode,
      String agentOrginId) async {
    final uri = Uri.parse(
        "${baseUrl}api/GetMerchantOrders?dateFilterType=$filterType&startDate=$startDate&endDate=$endDate&Source=ALL&CorpCode=$corpCode&agentOrginId=$agentOrginId");
    final request = await http.get(uri);

    if (request.statusCode == 200) {
      return Right(CashQrCombinedResponse.fromJson(jsonDecode(request.body)));
    } else {
      return Left(request.body);
    }
  }
}
