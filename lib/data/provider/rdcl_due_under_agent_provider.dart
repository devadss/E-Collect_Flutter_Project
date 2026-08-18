// import 'dart:async';
//
// import 'package:collection_qr_flutter/data/repository/rdcl_due_under_agent_repository.dart';
// import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/cupertino.dart';
// class RdclDueUnderAgentProvider with ChangeNotifier {
//   final RdclDueUnderAgentRepo _rdclDueUnderAgentRepo;
//
//   // Instance-based caching with pagination support
//   final Map<String, RdclDueUnderAgentModel> _cache = {};
//   final Map<String, DateTime> _cacheTimestamps = {};
//   final Map<String, bool> _loadingStates = {};
//   final Map<String, DateTime> _lastFetchTimes = {};
//
//   Timer? _debounceTimer;
//   String? _lastCustName;
//   String? _lastQuery; // Track last search query
//
//   // NEW: Track single customer data separately
//   RdclDueUnderAgentModel? _singleCustomerModel;
//   final Map<String, RdclDueUnderAgentModel> _singleCustomerCache = {};
//   final Map<String, DateTime> _singleCustomerCacheTimestamps = {};
//
//   // PAGINATION PROPERTIES
//   int _currentPage = 1;
//   int _pageSize = 10;
//   bool _hasMore = true;
//   bool _isLoadingMore = false;
//   final List<dynamic> _allDueItems = []; // Store all loaded items for pagination
//
//   // GETTERS
//   int get currentPage => _currentPage;
//   int get pageSize => _pageSize;
//   bool get hasMore => _hasMore;
//   bool get isLoadingMore => _isLoadingMore;
//   List<dynamic> get allDueItems => _allDueItems;
//   int get totalItemsCount => _allDueItems.length;
//
//   // NEW GETTER for single customer
//   RdclDueUnderAgentModel? get singleCustomerModel => _singleCustomerModel;
//
//   RdclDueUnderAgentModel? _rdclDueUnderAgentModel;
//   RdclDueUnderAgentModel? get rdclDueUnderAgentModel => _rdclDueUnderAgentModel;
//
//   String? _rdclDueUnderAgentError;
//   String? get rdclDueUnderAgentError => _rdclDueUnderAgentError;
//
//   bool _showDialog = false;
//   bool get showDialog => _showDialog;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   RdclDueUnderAgentProvider(this._rdclDueUnderAgentRepo);
//
//   void _notifyDebounced() {
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(const Duration(milliseconds: 50), () {
//       notifyListeners();
//     });
//   }
//
//   // Generate cache key WITH PAGE NUMBER for pagination
//   String _generateCacheKey(String agentId, String branchCode, String accNo,
//       int pageNo, String custName) {
//     return '$agentId-$branchCode-$accNo-$pageNo-$custName';
//   }
//
//   // NEW: Generate cache key for single customer
//   String _generateSingleCustomerCacheKey(
//       String agentId, String branchCode, String custName, String custAcNumber, String custId) {
//     return 'single-$agentId-$branchCode-$custName-$custAcNumber-$custId';
//   }
//
//   RdclDueUnderAgentModel? _getFromCache(String cacheKey) {
//     if (_cache.containsKey(cacheKey)) {
//       final timestamp = _cacheTimestamps[cacheKey];
//       if (timestamp != null &&
//           DateTime.now().difference(timestamp) < const Duration(minutes: 5)) {
//         return _cache[cacheKey];
//       } else {
//         _cache.remove(cacheKey);
//         _cacheTimestamps.remove(cacheKey);
//       }
//     }
//     return null;
//   }
//
//   // NEW: Get from single customer cache
//   RdclDueUnderAgentModel? _getFromSingleCustomerCache(String cacheKey) {
//     if (_singleCustomerCache.containsKey(cacheKey)) {
//       final timestamp = _singleCustomerCacheTimestamps[cacheKey];
//       if (timestamp != null &&
//           DateTime.now().difference(timestamp) < const Duration(minutes: 5)) {
//         return _singleCustomerCache[cacheKey];
//       } else {
//         _singleCustomerCache.remove(cacheKey);
//         _singleCustomerCacheTimestamps.remove(cacheKey);
//       }
//     }
//     return null;
//   }
//
//   // NEW METHOD: Update all items list for pagination
//   void _updateAllItems(RdclDueUnderAgentModel newModel, int pageNo) {
//     if (pageNo == 1) {
//       // First page - replace all data
//       _allDueItems.clear();
//       _allDueItems.addAll(newModel.data ?? []);
//     } else {
//       // Subsequent page - append new data
//       final newData = newModel.data ?? [];
//       for (var newItem in newData) {
//         // Avoid duplicates (check based on your data structure)
//         if (!_allDueItems.any((item) =>
//         item.accNo == newItem.accNo &&
//             item.custId == newItem.custId &&
//             item.openDate == newItem.openDate)) {
//           _allDueItems.add(newItem);
//         }
//       }
//     }
//
//     // Update pagination state
//     final itemsCount = newModel.data?.length ?? 0;
//     _hasMore = itemsCount >= _pageSize;
//     _currentPage = pageNo;
//   }
//
//   // ORIGINAL METHOD: Get paginated due list
//   Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
//       String agentId, String branchCode, String accNo,
//       int pageNo, int pageSize, String custName) async {
//
//     final cacheKey = _generateCacheKey(agentId, branchCode, accNo, pageNo, custName);
//
//     // Prevent duplicate requests
//     if (_loadingStates[cacheKey] == true) {
//       return Left("Request already in progress");
//     }
//
//     // Check if we need to force refresh
//     final cachedData = _getFromCache(cacheKey);
//     final shouldUseCache = cachedData != null &&
//         _lastCustName == custName &&
//         _lastQuery == custName &&
//         !_shouldForceRefresh(cacheKey);
//
//     if (shouldUseCache) {
//       _rdclDueUnderAgentModel = cachedData;
//       _updateAllItems(cachedData, pageNo);
//       _rdclDueUnderAgentError = null;
//       _showDialog = false;
//       _isLoading = false;
//       _isLoadingMore = false;
//       _notifyDebounced();
//       return Right(cachedData);
//     }
//
//     // Set loading state
//     _loadingStates[cacheKey] = true;
//     _showDialog = (pageNo == 1); // Only show dialog for first page
//     _isLoading = (pageNo == 1);
//     _isLoadingMore = (pageNo > 1);
//     _rdclDueUnderAgentError = null;
//     _lastQuery = custName; // Store the query
//     _notifyDebounced();
//
//     try {
//       final data = await _rdclDueUnderAgentRepo.getRdclDueList(
//           agentId, branchCode, accNo, pageNo, pageSize, custName);
//
//       data.fold(
//             (err) {
//           _rdclDueUnderAgentError = err;
//           if (pageNo == 1) {
//             _rdclDueUnderAgentModel = null;
//             _allDueItems.clear();
//           }
//           _showDialog = false;
//           _isLoading = false;
//           _isLoadingMore = false;
//           _hasMore = false;
//         },
//             (success) {
//           _rdclDueUnderAgentModel = success;
//           _updateAllItems(success, pageNo);
//           _lastCustName = custName;
//
//           // Cache successful response
//           _cache[cacheKey] = success;
//           _cacheTimestamps[cacheKey] = DateTime.now();
//           _lastFetchTimes[cacheKey] = DateTime.now();
//
//           _rdclDueUnderAgentError = null;
//           _showDialog = false;
//           _isLoading = false;
//           _isLoadingMore = false;
//         },
//       );
//
//       _loadingStates[cacheKey] = false;
//       _notifyDebounced();
//
//       return data;
//     } catch (e) {
//       _rdclDueUnderAgentError = "Unexpected error: $e";
//       _showDialog = false;
//       _isLoading = false;
//       _isLoadingMore = false;
//       _loadingStates[cacheKey] = false;
//       _notifyDebounced();
//       return Left("Unexpected error: $e");
//     }
//   }
//
//   // NEW METHOD: Get data for specific customer (not by index)
//   Future<Either<String, RdclDueUnderAgentModel>> getRdclDueForSingleCustomer(
//       String agentId,
//       String branchCode,
//       String custName,
//       String custAcNumber,
//       String custId) async {
//
//     final cacheKey = _generateSingleCustomerCacheKey(
//         agentId, branchCode, custName, custAcNumber, custId);
//
//     // Check cache first
//     final cachedData = _getFromSingleCustomerCache(cacheKey);
//     if (cachedData != null && !_shouldForceRefreshSingleCustomer(cacheKey)) {
//       _singleCustomerModel = cachedData;
//       _rdclDueUnderAgentError = null;
//       _notifyDebounced();
//       return Right(cachedData);
//     }
//
//     // Set loading state for single customer
//     _showDialog = true;
//     _isLoading = true;
//     _rdclDueUnderAgentError = null;
//     _notifyDebounced();
//
//     try {
//       // Use account number as filter to get specific customer data
//       final data = await _rdclDueUnderAgentRepo.getRdclDueList(
//           agentId,
//           branchCode,
//           custAcNumber, // Use account number as filter
//           1,
//           100, // Large page size to get all records
//           custName
//       );
//
//       data.fold(
//             (err) {
//           _rdclDueUnderAgentError = err;
//           _singleCustomerModel = null;
//           _showDialog = false;
//           _isLoading = false;
//         },
//             (success) {
//           _singleCustomerModel = success;
//
//           // Cache for this specific customer
//           _singleCustomerCache[cacheKey] = success;
//           _singleCustomerCacheTimestamps[cacheKey] = DateTime.now();
//
//           _rdclDueUnderAgentError = null;
//           _showDialog = false;
//           _isLoading = false;
//         },
//       );
//
//       _notifyDebounced();
//       return data;
//
//     } catch (e) {
//       _rdclDueUnderAgentError = "Unexpected error: $e";
//       _singleCustomerModel = null;
//       _showDialog = false;
//       _isLoading = false;
//       _notifyDebounced();
//       return Left("Unexpected error: $e");
//     }
//   }
//
//   // NEW METHOD: Get specific due item from the current list
// // NEW METHOD: Get specific due item from the current list
//   RDCLDueAccount? getDueByAccountNumber(String accNo, {bool useSingleCustomer = false}) {
//     if (useSingleCustomer) {
//       // Search in single customer data
//       if (_singleCustomerModel?.data == null) return null;
//
//       // Use try-catch or check for existence
//       for (var item in _singleCustomerModel!.data) {
//         if (item.accNo == accNo) {
//           return item;
//         }
//       }
//       return null;
//     } else {
//       // Search in paginated data
//       if (_rdclDueUnderAgentModel?.data == null) return null;
//
//       // Use try-catch or check for existence
//       for (var item in _rdclDueUnderAgentModel!.data) {
//         if (item.accNo == accNo) {
//           return item;
//         }
//       }
//       return null;
//     }
//   }
//
//   // NEW METHOD: Clear single customer data
//   void clearSingleCustomerData() {
//     _singleCustomerModel = null;
//     // Don't clear paginated data
//     _notifyDebounced();
//   }
//
//   // NEW: Check if we should force refresh for single customer
//   bool _shouldForceRefreshSingleCustomer(String cacheKey) {
//     final lastFetch = _singleCustomerCacheTimestamps[cacheKey];
//     if (lastFetch == null) return true;
//
//     return DateTime.now().difference(lastFetch) > const Duration(seconds: 30);
//   }
//
//   bool _shouldForceRefresh(String cacheKey) {
//     final lastFetch = _lastFetchTimes[cacheKey];
//     if (lastFetch == null) return true;
//
//     return DateTime.now().difference(lastFetch) > const Duration(seconds: 30);
//   }
//
//   // PAGINATION METHODS:
//
//   // 1. Load first page
//   Future<void> loadFirstPage(
//       String agentId, String branchCode, String custName) async {
//     _currentPage = 1;
//     _hasMore = true;
//     await getRdclDueList(agentId, branchCode, "", 1, _pageSize, custName);
//   }
//
//   // 2. Load next page
//   Future<void> loadNextPage(
//       String agentId, String branchCode, String custName) async {
//     if (!_hasMore || _isLoadingMore) return;
//
//     final nextPage = _currentPage + 1;
//     await getRdclDueList(agentId, branchCode, "", nextPage, _pageSize, custName);
//   }
//
//   // 3. Load specific page (for your pager widget)
//   Future<void> loadPage(
//       String agentId, String branchCode, String custName, int pageNo) async {
//     _currentPage = pageNo;
//     await getRdclDueList(agentId, branchCode, "", pageNo, _pageSize, custName);
//   }
//
//   // Optimized method for single due item (for list view)
//   Future<void> getRdclDueForCustomer(
//       String agentId, String branchCode, String custName) async {
//
//     final cacheKey = _generateCacheKey(agentId, branchCode, "", 1, custName);
//     final cachedData = _getFromCache(cacheKey);
//
//     // Only clear if completely different customer
//     if (_lastCustName != null && _lastCustName != custName) {
//       _rdclDueUnderAgentModel = null;
//       _allDueItems.clear();
//     }
//
//     // Show loading only if no cache or cache expired
//     if (cachedData == null || _shouldForceRefresh(cacheKey)) {
//       _showDialog = true;
//       _isLoading = true;
//     }
//
//     _rdclDueUnderAgentError = null;
//     _notifyDebounced();
//
//     await loadFirstPage(agentId, branchCode, custName);
//   }
//
//   // Refresh current data
//   Future<void> refreshCurrent() async {
//     if (_lastCustName == null) return;
//
//     // Clear cache for all pages of this customer
//     for (int i = 1; i <= _currentPage; i++) {
//       final cacheKey = _generateCacheKey("", "", "", i, _lastCustName!);
//       _cache.remove(cacheKey);
//       _cacheTimestamps.remove(cacheKey);
//       _lastFetchTimes.remove(cacheKey);
//       _loadingStates.remove(cacheKey);
//     }
//
//     // Reset pagination and reload
//     _allDueItems.clear();
//     _currentPage = 1;
//     _hasMore = true;
//
//     await loadFirstPage("", "", _lastCustName!);
//   }
//
//   // Clear cache for customer
//   void clearCacheForCustomer(String agentId, String branchCode, String custName) {
//     // Clear all pages for this customer
//     for (int i = 1; i <= _currentPage; i++) {
//       final cacheKey = _generateCacheKey(agentId, branchCode, "", i, custName);
//       _cache.remove(cacheKey);
//       _cacheTimestamps.remove(cacheKey);
//       _lastFetchTimes.remove(cacheKey);
//       _loadingStates.remove(cacheKey);
//     }
//
//     if (_lastCustName == custName) {
//       _lastCustName = null;
//       _allDueItems.clear();
//     }
//   }
//
//   // Clear all cache
//   void clearAllCache() {
//     _cache.clear();
//     _cacheTimestamps.clear();
//     _lastFetchTimes.clear();
//     _loadingStates.clear();
//     _singleCustomerCache.clear();
//     _singleCustomerCacheTimestamps.clear();
//     _lastCustName = null;
//     _lastQuery = null;
//     _rdclDueUnderAgentModel = null;
//     _singleCustomerModel = null;
//     _allDueItems.clear();
//     _currentPage = 1;
//     _hasMore = true;
//     _notifyDebounced();
//   }
//
//   // Check if data is available for customer
//   bool hasDataForCustomer(String custName) {
//     return _rdclDueUnderAgentModel != null && _lastCustName == custName;
//   }
//
//   // NEW: Check if single customer data is available
//   bool hasSingleCustomerData(String custName, String custAcNumber) {
//     if (_singleCustomerModel?.data == null) return false;
//
//     return _singleCustomerModel!.data.any((item) =>
//     item.name == custName && item.accNo == custAcNumber);
//   }
//
//   // Search in loaded items
//   List<dynamic> searchInLoaded(String query) {
//     if (query.isEmpty) return _allDueItems;
//
//     final lowercaseQuery = query.toLowerCase();
//     return _allDueItems.where((item) {
//       return (item.name?.toLowerCase() ?? '').contains(lowercaseQuery) ||
//           (item.accNo?.toLowerCase() ?? '').contains(lowercaseQuery) ||
//           (item.custId?.toLowerCase() ?? '').contains(lowercaseQuery);
//     }).toList();
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
// }
// /*
// class RdclDueUnderAgentProvider with ChangeNotifier {
//   final RdclDueUnderAgentRepo _rdclDueUnderAgentRepo;
//
//   RdclDueUnderAgentProvider(this._rdclDueUnderAgentRepo);
//
//   RdclDueUnderAgentModel? _rdclDueUnderAgentModel;
//   RdclDueUnderAgentModel? get rdclDueUnderAgentModel => _rdclDueUnderAgentModel;
//
//   String? _rdclDueUnderAgentError;
//   String? get rdclDueUnderAgentError => _rdclDueUnderAgentError;
//
//   bool? _showDialog;
//   bool? get showDialog => _showDialog;
//
//   Future<Either<String, RdclDueUnderAgentModel>> getRdclDueList(
//       String agentId,String branchCode, String accNo, int pageNo, int pageSize,String custName) async {
//     _rdclDueUnderAgentModel = null;
//     _showDialog = true;
//     notifyListeners();
//
//     final data = await _rdclDueUnderAgentRepo.getRdclDueList(agentId, branchCode,accNo, pageNo, pageSize,custName);
//
//     data.fold((err) {
//       _rdclDueUnderAgentError = err;
//       _rdclDueUnderAgentModel = null;
//       _showDialog = false;
//     }, (success) {
//       _rdclDueUnderAgentModel = success;
//       _rdclDueUnderAgentError =  null;
//       _showDialog = false;
//     });
//     notifyListeners();
//     return data;
//   }
// }
// */
