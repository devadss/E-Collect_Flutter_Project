import 'dart:convert';
import 'package:collection_qr_flutter/core/general.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../domain/interface/rdcl_due_under_agent_interface.dart';
import '../storage/shared_pref_helper.dart';

class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface {
  // Cache the vendor URL to avoid repeated SharedPref calls
  static String? _cachedVendorUrl;

  // Cache for responses with pagination
  static final Map<String, RdclDueUnderAgentModel> _responseCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Single instance of InternetConnectionChecker
  static final _connectionChecker = InternetConnectionChecker.createInstance();

  Future<String> loadVendorUrl() async {
    if (_cachedVendorUrl != null) {
      return _cachedVendorUrl!;
    }
    final url = await SharedPref().getDueListRdclUrl();
    _cachedVendorUrl = url;
    return url;
  }

  // Generate cache key with pagination
  static String _generateCacheKey(String agentId, String branchCode,
      String accNo, int pageNo, int pageSize, String custName) {
    return '$agentId-$branchCode-$accNo-$pageNo-$pageSize-$custName';
  }

  // Get from cache
  static RdclDueUnderAgentModel? _getFromCache(String cacheKey) {
    if (_responseCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < const Duration(minutes: 2)) {
        return _responseCache[cacheKey];
      }
    }
    return null;
  }

  // Cache response
  static void _cacheResponse(String cacheKey, RdclDueUnderAgentModel model) {
    _responseCache[cacheKey] = model;
    _cacheTimestamps[cacheKey] = DateTime.now();

    // Clean up old cache (keep only last 20)
    if (_responseCache.length > 20) {
      // First, get and sort the entries
      final sortedEntries = _cacheTimestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      // Then take the oldest entries to remove
      final keysToRemove = sortedEntries
          .take(_responseCache.length - 20)
          .map((e) => e.key)
          .toList();

      for (var key in keysToRemove) {
        _responseCache.remove(key);
        _cacheTimestamps.remove(key);
      }
    }
  }

  @override
  Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
      String agentId,
      String branchCode,
      String accNo,
      int pageNo,
      int pageSize,
      String custName,
      ) async {

    // Generate cache key WITH page number
    final cacheKey = _generateCacheKey(agentId, branchCode, accNo, pageNo, pageSize, custName);

    // Check cache first
    final cached = _getFromCache(cacheKey);
    if (cached != null) {
      return Right(cached);
    }

    bool isDebug = false;
    assert(isDebug = true);

    try {
      final vendorUrl = await loadVendorUrl();
      final hasConnection = await _connectionChecker.hasConnection;

      if (isDebug) {
        print("Network connection: $hasConnection");
      }

      if (!hasConnection) {
        return const Left("Check internet connection");
      }

      // Build URI
      final uri = Uri.parse(
          "$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo"
              "&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName"
      );

    //  if (isDebug) {
        print("Making request to: ${uri.toString().split('?')[0]}");
        print("uri $uri");
     // }

      // Make HTTP request with timeout
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => http.Response('Timeout', 408),
      );

      if (isDebug) {
        print("Response status: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        try {
          final model = await compute(_parseResponse, response.body);
          // Cache the response
          _cacheResponse(cacheKey, model);
          return Right(model);
        } catch (e) {
          return Left("Failed to parse response: $e");
        }
      } else if (response.statusCode == 408) {
        return const Left("Request timeout");
      } else {
        return Left("Server error: ${response.statusCode}");
      }
    } catch (e) {
      if (isDebug) {
        print("Error in getRdclDueList: $e");
      }
      return const Left("Unable to fetch Due Under Agent");
    }
  }

  // Separate function for JSON parsing in isolate
  static RdclDueUnderAgentModel _parseResponse(String responseBody) {
    return RdclDueUnderAgentModel.fromJson(jsonDecode(responseBody));
  }

  // Clear cache methods
  static void clearCacheForAgent(String agentId, String branchCode) {
    final keysToRemove = _responseCache.keys.where((key) =>
        key.startsWith('$agentId-$branchCode')).toList();

    for (var key in keysToRemove) {
      _responseCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  static void clearAllCache() {
    _responseCache.clear();
    _cacheTimestamps.clear();
  }
}
/*class RdclDueUnderAgentRepo implements RdclDueUnderAgentModelInterface{
  Future<String> loadVendorUrl() async {
    return await SharedPref().getDueListRdclUrl();

  }

  @override
  Future<Either<String, RdclDueUnderAgentModel>>getRdclDueList(String agentId,
      String branchCode, String accNo, int pageNo, int pageSize,String custName) async {
    print("inside getRdclDueList");
    final vendorUrl = await loadVendorUrl();
    print("vendorUrl = $vendorUrl");
   final uri = Uri.parse("$vendorUrl?agent_id=$agentId&br_code=$branchCode&acc_no=$accNo&PageNumber=$pageNo&PageSize=$pageSize&CustName=$custName");
    print("uri = $uri");
    try{
      bool checkInternetConnection =
      await InternetConnectionChecker.createInstance().hasConnection;
      if(checkInternetConnection == true){
        print("Network connection success");
        final request = await  http.get(uri);
        print(request.statusCode);
        print("$vendorUrl?agent_id=$agentId");
        print("GetRdclDuesList ${request.body}");
        if(request.statusCode == 200){
          return Right(RdclDueUnderAgentModel.fromJson(jsonDecode(request.body)));

        }else{
          return Left(request.body);
        }
      }else{
        print("Network connection fail");
        return const Left("Check internet connection");
      }
    }catch(e){
      return const Left("Unable to fetch Due Under Agent");
    }


  }
  
}*/


