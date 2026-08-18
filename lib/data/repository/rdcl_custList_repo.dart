// import 'dart:convert';
// import 'dart:async';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../../domain/interface/rdcl_customer_list_interface.dart';
// import '../../domain/model/account_list_model.dart';
// import '../storage/shared_pref_helper.dart';
//
//
// class RdclCustListRep implements RdclCustomerListInterface {
//   // Cache for vendor URL to avoid repeated SharedPref calls
//   static String? _cachedVendorUrl;
//   static DateTime? _urlCacheTimestamp;
//
//   // Single instance of InternetConnectionChecker
//   static final _connectionChecker = InternetConnectionChecker.createInstance();
//
//   // Cache for successful responses (short-term)
//   static final _responseCache = <String, RdclCustomerListModel>{};
//   static final _cacheTimestamps = <String, DateTime>{};
//
//   // Active requests tracking to prevent duplicates
//   static final _activeRequests = <String, Completer<Either<String, RdclCustomerListModel>>>{};
//
//   Future<String> loadVendorUrl() async {
//     // Return cached URL if available and not expired (5 minutes)
//     if (_cachedVendorUrl != null &&
//         _urlCacheTimestamp != null &&
//         DateTime.now().difference(_urlCacheTimestamp!) < const Duration(minutes: 5)) {
//       return _cachedVendorUrl!;
//     }
//
//     final url = await SharedPref().getRdclCustomerVendorUrl();
//
//     // Cache the URL
//     _cachedVendorUrl = url;
//     _urlCacheTimestamp = DateTime.now();
//
//     return url;
//   }
//
//   // Generate cache key for this request
//   String _generateCacheKey(String? agentID, String? branchID, int pgNo, int pgSize, String custName) {
//     return '${agentID ?? ''}-${branchID ?? ''}-$pgNo-$pgSize-${custName.toLowerCase()}';
//   }
//
//   @override
//   Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
//       String? agentID, String? branchID, int pgNo, int pgSize, String custName) async {
//
//     final cacheKey = _generateCacheKey(agentID, branchID, pgNo, pgSize, custName);
//
//     // 1. Check response cache first (2 minute cache)
//     final cachedResponse = _getCachedResponse(cacheKey);
//     if (cachedResponse != null) {
//       return Right(cachedResponse);
//     }
//
//     // 2. Check if same request is already in progress
//     if (_activeRequests.containsKey(cacheKey)) {
//       return await _activeRequests[cacheKey]!.future;
//     }
//
//     // 3. Create new request completer
//     final completer = Completer<Either<String, RdclCustomerListModel>>();
//     _activeRequests[cacheKey] = completer;
//
//     try {
//       // Debug only in development
//       bool isDebug = false;
//       assert(isDebug = true);
//
//       // Load vendor URL in parallel with network check
//       final vendorUrlFuture = loadVendorUrl();
//       final networkCheckFuture = _connectionChecker.hasConnection;
//
//       // Wait for both concurrently
//       final results = await Future.wait([vendorUrlFuture, networkCheckFuture]);
//       final vendorUrl = results[0] as String;
//       final hasConnection = results[1] as bool;
//
//       if (!hasConnection) {
//         final error = const Left<String, RdclCustomerListModel>("Check Internet connection");
//         completer.complete(error);
//         _activeRequests.remove(cacheKey);
//         return error;
//       }
//
//       // Prepare request data
//       final requestBody = {
//         "agent_id": agentID,
//         "branch_id": branchID,
//         "PageNumber": pgNo,
//         "PageSize": pgSize,
//         "cust_name": custName
//       };
//
//      // if (isDebug) {
//         print("Making request to: ${vendorUrl.split('?')[0]}");
//        // print("Page: $pgNo, Size: $pgSize, Customer: $custName");
//         print(requestBody);
//      // }
//
//       // Make HTTP request with timeout
//       final response = await http.post(
//         Uri.parse(vendorUrl),
//         body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       ).timeout(
//         const Duration(seconds: 30),
//         onTimeout: () => http.Response('Request Timeout', 408),
//       );
//
//      // if (isDebug) {
//         print("Response status: ${response.statusCode}");
//         print("vendorUrl: ${vendorUrl}");
//         // Only print partial response for debugging (first 200 chars)
//         if (response.body.length > 0 && response.body.length < 500) {
//           print("Response: ${response.body}");
//         } else if (response.body.length >= 500) {
//           print("Response length: ${response.body.length} characters");
//         }
//      // }
//
//       if (response.statusCode == 200) {
//         try {
//           // Parse JSON in compute/island for large responses
//           RdclCustomerListModel model;
//           if (response.body.length > 10000) {
//             // Large response - parse in isolate
//             model = await compute(_parseJsonResponse, response.body);
//           } else {
//             // Small response - parse inline
//             model = RdclCustomerListModel.fromJson(jsonDecode(response.body));
//           }
//
//           // Cache successful response for 2 minutes
//           _cacheResponse(cacheKey, model);
//
//           final result = Right<String, RdclCustomerListModel>(model);
//           completer.complete(result);
//           _activeRequests.remove(cacheKey);
//           return result;
//
//         } catch (e) {
//          // if (isDebug) {
//             print("JSON parsing error: $e");
//         //  }
//           final error = Left<String, RdclCustomerListModel>("Failed to parse response");
//           completer.complete(error);
//           _activeRequests.remove(cacheKey);
//           return error;
//         }
//       } else if (response.statusCode == 408) {
//         final error = Left<String, RdclCustomerListModel>("Request timeout");
//         completer.complete(error);
//         _activeRequests.remove(cacheKey);
//         return error;
//       } else {
//         final error = Left<String, RdclCustomerListModel>(
//             "Server error: ${response.statusCode} - ${response.body.length > 100 ? response.body.substring(0, 100) + '...' : response.body}"
//         );
//         completer.complete(error);
//         _activeRequests.remove(cacheKey);
//         return error;
//       }
//     } catch (e) {
//       if (e is TimeoutException) {
//         final error = Left<String, RdclCustomerListModel>("Request timeout");
//         completer.complete(error);
//         _activeRequests.remove(cacheKey);
//         return error;
//       }
//
//       final error = Left<String, RdclCustomerListModel>("Unable to fetch the data: $e");
//       completer.complete(error);
//       _activeRequests.remove(cacheKey);
//       return error;
//     }
//   }
//
//   // Helper method to get cached response
//   RdclCustomerListModel? _getCachedResponse(String cacheKey) {
//     if (_responseCache.containsKey(cacheKey)) {
//       final timestamp = _cacheTimestamps[cacheKey];
//       if (timestamp != null &&
//           DateTime.now().difference(timestamp) < const Duration(minutes: 2)) {
//         return _responseCache[cacheKey];
//       } else {
//         // Remove expired cache
//         _responseCache.remove(cacheKey);
//         _cacheTimestamps.remove(cacheKey);
//       }
//     }
//     return null;
//   }
//
//   // Helper method to cache response
//   void _cacheResponse(String cacheKey, RdclCustomerListModel model) {
//     _responseCache[cacheKey] = model;
//     _cacheTimestamps[cacheKey] = DateTime.now();
//
//     // Clean up old cache entries (keep only last 50)
//     if (_responseCache.length > 50) {
//       // Sort entries by timestamp (oldest first)
//       final sortedEntries = _cacheTimestamps.entries.toList()
//         ..sort((a, b) => a.value.compareTo(b.value));
//
//       // Take the oldest entries to remove (all except last 50)
//       final keysToRemove = sortedEntries
//           .take(_responseCache.length - 50)
//           .map((e) => e.key)
//           .toList();
//
//       for (var key in keysToRemove) {
//         _responseCache.remove(key);
//         _cacheTimestamps.remove(key);
//       }
//     }
//   }
//
//   // Clear specific cache
//   void clearCacheForAgent(String agentID, String branchID) {
//     final keysToRemove = _responseCache.keys.where((key) =>
//         key.startsWith('$agentID-$branchID')).toList();
//
//     for (var key in keysToRemove) {
//       _responseCache.remove(key);
//       _cacheTimestamps.remove(key);
//     }
//   }
//
//   // Clear all cache
//   void clearAllCache() {
//     _responseCache.clear();
//     _cacheTimestamps.clear();
//     _cachedVendorUrl = null;
//     _urlCacheTimestamp = null;
//   }
//
//   // Parse JSON in isolate for large responses
//   static RdclCustomerListModel _parseJsonResponse(String responseBody) {
//     return RdclCustomerListModel.fromJson(jsonDecode(responseBody));
//   }
// }
//
// /*
// import 'dart:convert';
//
// import 'package:collection_qr_flutter/domain/model/account_list_model.dart';
//
// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../../domain/interface/rdcl_customer_list_interface.dart';
// import '../storage/shared_pref_helper.dart';
//
// class RdclCustListRep implements RdclCustomerListInterface {
//   Future<String> loadVendorUrl() async {
//     return await SharedPref().getRdclCustomerVendorUrl();
//   }
//
//   @override
//   Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
//       String? agentID, String? branchID, int pgNo, int pgSize, String custName) async {
//     print("Inside RdclCustListRep");
//     final vendorUrl = await loadVendorUrl();
//     final uri = Uri.parse(vendorUrl); //This is the live one
//    // final uri = Uri.parse("https://doorstepclientuat.digicob.in/getRdclCustomerunderAgentList"); //This is the live one
//     bool checkInternetConnection =
//     await InternetConnectionChecker.createInstance().hasConnection;
//     try{
//       if(checkInternetConnection == true){
//         final data = await http.post(
//           uri,
//           body: jsonEncode({
//             "agent_id": agentID,
//             "branch_id": branchID,
//             "PageNumber": pgNo,
//             "PageSize": pgSize,
//             "cust_name":custName
//           }),
//           headers: {'Content-Type': 'application/json'},
//         );
//         print("vendorUrl $vendorUrl");
//         print("getRdclCustomerunderAgent $uri");
//         print("Body ${{"agent_id": agentID, "branch_id": branchID, "PageNumber": pgNo,
//           "PageSize": pgSize,"cust_name":custName}}");
//         print(data.body);
//         if (data.statusCode == 200) {
//           return Right(RdclCustomerListModel.fromJson(jsonDecode(data.body)));
//         } else {
//           return Left(data.body);
//         }
//       }else{
//         return const Left("Check Internet connection");
//       }
//     }catch(e){
//       return const Left("Unable to fetch the data");
//     }
//
//
//
//   }
// }
// */
