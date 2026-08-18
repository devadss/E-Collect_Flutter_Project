// import 'dart:async';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../domain/model/account_list_model.dart';
// import '../repository/rdcl_custList_repo.dart';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:collection/collection.dart';
//
// import '../../domain/model/account_list_model.dart';
// import '../repository/rdcl_custList_repo.dart';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../domain/model/account_list_model.dart';
// import '../repository/rdcl_custList_repo.dart';
//
// class RdclCustListProvider with ChangeNotifier {
//   final RdclCustListRep _rdclCustListRep;
//
//   // Caching
//   static final Map<String, RdclCustomerListModel> _cache = {};
//   static final Map<String, DateTime> _cacheTimestamps = {};
//   static final Map<String, bool> _loadingStates = {};
//
//   Timer? _debounceTimer;
//
//   // Pagination
//   int _currentPage = 1;
//   final int _pageSize = 10;
//   bool _hasMore = true;
//   bool _isLoadingMore = false;
//   final List<CustomerData> _allCustomers = []; // Store all loaded customers
//
//   int get currentPage => _currentPage;
//   bool get hasMore => _hasMore;
//   bool get isLoadingMore => _isLoadingMore;
//   List<CustomerData> get allCustomers => _allCustomers;
//   int get totalCustomerCount => _rdclCustomerListModel?.customerList.totalCount ?? 0;
//
//   RdclCustListProvider(this._rdclCustListRep);
//
//   RdclCustomerListModel? _rdclCustomerListModel;
//   RdclCustomerListModel? get rdclCustomerListModel => _rdclCustomerListModel;
//
//   bool? _showDialog;
//   bool? get showDialog => _showDialog;
//
//   String? _rdclCustomerListError;
//   String? get rdclCustomerListError => _rdclCustomerListError;
//
//   // Debounced notifyListeners
//   void _notifyDebounced() {
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(const Duration(milliseconds: 50), () {
//       notifyListeners();
//     });
//   }
//
//   // Generate cache key
//   String _generateCacheKey(String? agentID, String? branchID, int pgNo, String custName) {
//     return '${agentID ?? ''}-${branchID ?? ''}-$pgNo-$custName';
//   }
//
//   // Get from cache with expiration (5 minutes)
//   RdclCustomerListModel? _getFromCache(String cacheKey) {
//     if (_cache.containsKey(cacheKey)) {
//       final timestamp = _cacheTimestamps[cacheKey];
//       if (timestamp != null &&
//           DateTime.now().difference(timestamp) < const Duration(minutes: 5)) {
//         return _cache[cacheKey];
//       } else {
//         // Remove expired cache
//         _cache.remove(cacheKey);
//         _cacheTimestamps.remove(cacheKey);
//       }
//     }
//     return null;
//   }
//
//   // Update the internal list of customers
//   void _updateCustomerList(RdclCustomerListModel newModel, int pageNo) {
//     if (pageNo == 1) {
//       // First page - replace all data
//       _allCustomers.clear();
//       _allCustomers.addAll(newModel.customerList.data);
//     } else {
//       // Subsequent page - append new data, avoid duplicates
//       for (var newCustomer in newModel.customerList.data) {
//         if (!_allCustomers.any((existing) =>
//         existing.custId == newCustomer.custId &&
//             existing.rdclGlobalAccNo == newCustomer.rdclGlobalAccNo)) {
//           _allCustomers.add(newCustomer);
//         }
//       }
//     }
//
//     // Update pagination state
//     final totalCount = newModel.customerList.totalCount;
//     _hasMore = _allCustomers.length < totalCount;
//     _currentPage = pageNo;
//   }
//
//   Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
//       String? agentID, String? branchID, int pgNo, int pgSize, String custName) async {
//
//     final cacheKey = _generateCacheKey(agentID, branchID, pgNo, custName);
//
//     // Prevent duplicate requests
//     if (_loadingStates[cacheKey] == true) {
//       return Left("Request already in progress");
//     }
//
//     // Check cache first
//     final cachedData = _getFromCache(cacheKey);
//     if (cachedData != null) {
//       _rdclCustomerListModel = cachedData;
//       _updateCustomerList(cachedData, pgNo);
//       _rdclCustomerListError = null;
//       _showDialog = false;
//       _notifyDebounced();
//       return Right(cachedData);
//     }
//
//     // Set loading state
//     _loadingStates[cacheKey] = true;
//     _showDialog = (pgNo == 1); // Only show dialog for first page
//     _rdclCustomerListError = null;
//
//     if (pgNo == 1) {
//       _currentPage = 1;
//       _hasMore = true;
//       _isLoadingMore = false;
//     } else {
//       _isLoadingMore = true;
//     }
//
//     _notifyDebounced();
//
//     try {
//       final data = await _rdclCustListRep.getRdclCustomerunderAgent(
//           agentID, branchID, pgNo, pgSize, custName);
//
//       data.fold(
//             (err) {
//           _rdclCustomerListError = err;
//           if (pgNo == 1) {
//             _rdclCustomerListModel = null;
//             _allCustomers.clear();
//           }
//           _showDialog = false;
//           _hasMore = false;
//           _isLoadingMore = false;
//         },
//             (success) {
//           _rdclCustomerListModel = success;
//           _updateCustomerList(success, pgNo);
//
//           // Cache the response
//           _cache[cacheKey] = success;
//           _cacheTimestamps[cacheKey] = DateTime.now();
//
//           _rdclCustomerListError = null;
//           _showDialog = false;
//           _isLoadingMore = false;
//         },
//       );
//
//       _loadingStates[cacheKey] = false;
//       _notifyDebounced();
//
//       return data;
//     } catch (e) {
//       _rdclCustomerListError = "Unexpected error: $e";
//       _showDialog = false;
//       _isLoadingMore = false;
//       _loadingStates[cacheKey] = false;
//       _notifyDebounced();
//       return Left("Unexpected error: $e");
//     }
//   }
//
//   // Convenience method for initial load
//   Future<void> loadFirstPage(
//       String? agentID, String? branchID, String custName) async {
//     await getRdclCustomerunderAgent(
//         agentID, branchID, 1, _pageSize, custName);
//   }
//
//   // Load more data for pagination
//   Future<void> loadMore(
//       String? agentID, String? branchID, String custName) async {
//     if (!_hasMore || _isLoadingMore) return;
//
//     final nextPage = _currentPage + 1;
//     await getRdclCustomerunderAgent(
//         agentID, branchID, nextPage, _pageSize, custName);
//   }
//
//   // Refresh data
//   Future<void> refresh(
//       String? agentID, String? branchID, String custName) async {
//     // Clear cache for this query
//     final cacheKey = _generateCacheKey(agentID, branchID, 1, custName);
//     _cache.remove(cacheKey);
//     _cacheTimestamps.remove(cacheKey);
//
//     // Also clear any subsequent page caches
//     for (int i = 2; i <= _currentPage; i++) {
//       final pageKey = _generateCacheKey(agentID, branchID, i, custName);
//       _cache.remove(pageKey);
//       _cacheTimestamps.remove(pageKey);
//     }
//
//     // Reset state
//     _allCustomers.clear();
//     _currentPage = 1;
//     _hasMore = true;
//
//     await loadFirstPage(agentID, branchID, custName);
//   }
//
//   // Search within loaded customers
//   List<CustomerData> searchCustomers(String query) {
//     if (query.isEmpty) return _allCustomers;
//
//     final lowercaseQuery = query.toLowerCase();
//     return _allCustomers.where((customer) {
//       return customer.custName.toLowerCase().contains(lowercaseQuery) ||
//           customer.custId.toLowerCase().contains(lowercaseQuery) ||
//           customer.rdclGlobalAccNo.toLowerCase().contains(lowercaseQuery) ||
//           customer.schName.toLowerCase().contains(lowercaseQuery);
//     }).toList();
//   }
//
//   // Get customer by ID
//   CustomerData? getCustomerById(String custId) {
//     return _allCustomers.firstWhereOrNull((customer) => customer.custId == custId);
//   }
//
//   // Filter customers by scheme
//   List<CustomerData> getCustomersByScheme(String schemeCode) {
//     return _allCustomers.where((customer) => customer.schCode == schemeCode).toList();
//   }
//
//   // Clear cache for specific agent
//   void clearCacheForAgent(String agentID, String branchID) {
//     final keysToRemove = _cache.keys.where((key) =>
//         key.startsWith('$agentID-$branchID')).toList();
//
//     for (var key in keysToRemove) {
//       _cache.remove(key);
//       _cacheTimestamps.remove(key);
//       _loadingStates.remove(key);
//     }
//   }
//
//   // Clear all cache and reset state
//   void clearAllCache() {
//     _cache.clear();
//     _cacheTimestamps.clear();
//     _loadingStates.clear();
//     _allCustomers.clear();
//     _rdclCustomerListModel = null;
//     _currentPage = 1;
//     _hasMore = true;
//     _notifyDebounced();
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
// }
//
// /*
//
// class RdclCustListProvider with ChangeNotifier {
//   final RdclCustListRep _rdclCustListRep;
//
//   RdclCustListProvider(this._rdclCustListRep);
//
//   RdclCustomerListModel? _rdclCustomerListModel;
//
//   RdclCustomerListModel? get rdclCustomerListModel => _rdclCustomerListModel;
//   bool? _showDialog;
//   bool? get showDialog => _showDialog;
//
//   String? _rdclCustomerListError;
//   String? get rdclCustomerListError =>_rdclCustomerListError;
//
//
//   Future<Either<String, RdclCustomerListModel>> getRdclCustomerunderAgent(
//       String? agentID, String? branchID,int pgNo, int pgSize,String custName) async {
//     final data =
//         await _rdclCustListRep.getRdclCustomerunderAgent(agentID, branchID,pgNo, pgSize,custName);
//     _showDialog = true;
//     notifyListeners();
//     data.fold((err) {
//       _rdclCustomerListError= err;
//       _rdclCustomerListModel = null;
//       _showDialog = false;
//     }, (success) {
//       _rdclCustomerListModel = success;
//       _rdclCustomerListError= null;
//       _showDialog = false;
//     });
//     notifyListeners();
//     return data;
//   }
// }
// */
