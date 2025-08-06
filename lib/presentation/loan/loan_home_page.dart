import 'dart:async';

import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants.dart';
import '../../data/provider/get_loan_provider.dart';
import '../../domain/model/loan_model.dart';
import '../dues/rdcl_due_home_page.dart';
import 'loan_details_page.dart';

class LoanHomePage extends StatefulWidget {
  const LoanHomePage({super.key});

  @override
  State<LoanHomePage> createState() => _LoanHomePageState();
}

class _LoanHomePageState extends State<LoanHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true;
  String? agentBranchCode;
  String? selectedFilterType;
  final GlobalKey _filterIconKey = GlobalKey();
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  Timer? _debounce; // Declare this at the class level
  late AnimationController _scaleController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Datum> _visibleLoans = [];
  List<Datum> _allLoans = [];
  // List<Datum> _visibleCustomers = []; // currently shown list
  // List<Datum> _allCustomers = []; // original data

  // New color theme
  final Color primaryColor = const Color(0xFFEA307B);
  final Color secondaryColor = const Color(0xFF470952);
  final Color backgroundColor = Colors.grey[50]!;
  final Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _allLoans = [];
    _visibleLoans = [];
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      // Fetch loans when screen loads
      final provider = Provider.of<GetLoanProvider>(context, listen: false);
      provider.getLoans("", "", "", "", "", 1, 10).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    });
    _searchController.addListener(() {
      final provider = Provider.of<GetLoanProvider>(context, listen: false);
      final allLoans = provider.collectionLoanModel?.data ?? [];
      _applyFilter(_searchController.text);
    });

    // Wait for initial data load and apply initial list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GetLoanProvider>(context, listen: false);
      final allLoans = provider.collectionLoanModel?.data ?? [];
      _applyFilter(''); // show full list on first build
    });

  }

  // void _onSearchChanged() {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () {
  //     _applyFilter(_searchController.text);
  //   });
  // }
  // void _loadInitialCustomers(List<Datum> newCustomers) {
  //   _visibleCustomers = [];
  //   _allCustomers = newCustomers;
  //   for (int i = 0; i < _allCustomers.length; i++) {
  //     _visibleCustomers.add(_allCustomers[i]);
  //     _listKey.currentState?.insertItem(i);
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  void _applyFilter(String query) {
    if (_allLoans.isEmpty) return;

    final lowerQuery = query.toLowerCase();
    final filtered = _allLoans.where((loan) {
      final accNo = loan.loanNumber?.toLowerCase() ?? '';
      final name = loan.customerName?.toLowerCase() ?? '';
      return accNo.contains(lowerQuery) || name.contains(lowerQuery);
    }).toList();

    // Calculate differences between current and new list
    final currentIds = _visibleLoans.map((e) => e.loanNumber).toSet();
    final newIds = filtered.map((e) => e.loanNumber).toSet();

    // Remove items not in new list
    for (var i = _visibleLoans.length - 1; i >= 0; i--) {
      if (!newIds.contains(_visibleLoans[i].loanNumber)) {
        final removed = _visibleLoans.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
              (context, animation) => _buildLoanCard(removed, animation),
        );
      }
    }

    // Add new items
    for (var i = 0; i < filtered.length; i++) {
      if (!currentIds.contains(filtered[i].loanNumber)) {
        _visibleLoans.insert(i, filtered[i]);
        _listKey.currentState?.insertItem(i);
      }
    }
  }

  // void _applyFilter(String query, List<Datum> allLoans) {
  //   final filtered = _filterCustomers(allLoans, query);
  //
  //   // Step 1: Remove old items (with animation)
  //   for (int i = _visibleLoans.length - 1; i >= 0; i--) {
  //     final removedItem = _visibleLoans.removeAt(i);
  //     _listKey.currentState?.removeItem(
  //       i,
  //           (context, animation) => _buildLoanCard(removedItem, animation),
  //       duration: const Duration(milliseconds: 300),
  //     );
  //   }
  //
  //   // Step 2: Insert new filtered items (with animation)
  //   for (int i = 0; i < filtered.length; i++) {
  //     _visibleLoans.insert(i, filtered[i]);
  //     _listKey.currentState?.insertItem(
  //       i,
  //       duration: const Duration(milliseconds: 300),
  //     );
  //   }
  // }

  List<Datum> _filterCustomers(List<Datum> allCustomers, String query) {
    if (query.isEmpty) return allCustomers;

    final lowerCaseQuery = query.toLowerCase();

    return allCustomers.where((customer) {
      final accNo = customer.loanNumber?.toLowerCase() ?? '';
      final name = customer.customerName?.toLowerCase() ?? '';
      return accNo.contains(lowerCaseQuery) || name.contains(lowerCaseQuery);
    }).toList();
  }

  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: white,
                border: Border.all(color: grey[300]!, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: black45,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(height: 10),
                    buildShimmerText(width: 100), // Customer ID
                    const SizedBox(height: 10),
                    buildShimmerText(width: 180), // Account Number
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildShimmerText(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500), // Ensures smooth animation
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<GetLoanProvider>(context);
   // var loans = loanProvider.collectionLoanModel?.data ?? [];
    if (loanProvider.collectionLoanModel != null &&
        _allLoans != loanProvider.collectionLoanModel!.data) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _allLoans = loanProvider.collectionLoanModel!.data ?? [];
          _isLoading = false;
          _applyFilter(_searchController.text); // Reapply filter with new data
        });
      });
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Loans",
          style: TextStyle(
            fontSize: 23,
            color: secondaryColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: home2.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: home2.withOpacity(0.2)),
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isSearchFocused = hasFocus;
                    });
                  },
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      hintStyle: TextStyle(
                        color: grey[600],
                        fontSize: 14,
                      ),
                      prefixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isSearchFocused
                            ? const Icon(Icons.search, color: home2, size: 24)
                            : ShakeTransition(
                          duration: const Duration(milliseconds: 1500),
                          child: Icon(
                            Icons.search_rounded,
                            color: home2.withOpacity(0.7),
                            size: 24,
                          ),
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: home2),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                        ),
                      )
                          : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isSearchFocused
                            ? IconButton(
                          key: _filterIconKey,
                          icon: const Icon(Icons.tune_rounded,
                              color: home2),
                          onPressed: () {
                            final RenderBox renderBox =
                            _filterIconKey.currentContext!
                                .findRenderObject()
                            as RenderBox;
                            final Offset offset = renderBox
                                .localToGlobal(Offset.zero);
                            final Size size = renderBox.size;

                            showMenu<String>(
                              color: Colors.white,
                              shadowColor: home1,
                              requestFocus: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              menuPadding: const EdgeInsets.all(10),
                              context: context,
                              position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy + size.height + 10,
                                offset.dx + size.width,
                                offset.dy,
                              ),
                              items: [
                                PopupMenuItem<String>(
                                  value: 'agent',
                                  child: Text(
                                    'Filter by Agent',
                                    style: TextStyle(
                                        color: selectedFilterType !=
                                            "agentid"
                                            ? Colors.black
                                            : home1),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'branch',
                                  child: Text('Filter by Branch',
                                      style: TextStyle(
                                          color:
                                          selectedFilterType !=
                                              "branchid"
                                              ? Colors.black
                                              : home1)),
                                ),
                              ],
                            ).then((value) async {
                              if (value == 'agent') {
                               // showProgressDialog(context);
                                setState(() {
                                  selectedFilterType = "agentid";
                                });
                                // await provider
                                //     .getRdclCustomerunderAgent(
                                //     agentId,
                                //     "",
                                //     _currentPage,
                                //     itemPerPage,
                                //     "");
                                print("Filter by Agent ID");

                                Navigator.pop(context);
                              } else if (value == 'branch') {
                               // showProgressDialog(context);
                               //  await provider
                               //      .getRdclCustomerunderAgent(
                               //      "",
                               //      agentBranchCode,
                               //      _currentPage,
                               //      itemPerPage,
                               //      "");
                                setState(() {
                                  selectedFilterType = "branchid";
                                });
                                print("Filter by Branch ID");
                                Navigator.pop(context);
                              }
                            });
                          },
                        )
                        // BounceTransition(
                        //         duration:
                        //             const Duration(milliseconds: 1000),
                        //         child: IconButton(
                        //           icon: const Icon(Icons.tune_rounded,
                        //               color: home2),
                        //           onPressed: () {},
                        //         ),
                        //       )
                            : const SizedBox.shrink(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    style: const TextStyle(
                      color: black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _applyFilter(value);

                      });
                    },
                  ),
                ),
              ),
            ),
            // Header with summary
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                    child: Consumer<GetLoanProvider>(
                      builder: (context, provider, _) {
                        final loanData = provider.collectionLoanModel?.data ?? [];

                        // 🔍 Apply search filter
                        final filteredCustomers =
                        _filterCustomers(loanData, _searchController.text);

                        // ✅ Use filtered list for UI metrics
                        final activeCount = _countLoansByStatus(filteredCustomers, "Active");
                        final pendingCount = _countLoansByStatus(filteredCustomers, "Pending");
                        final closedCount = _countLoansByStatus(filteredCustomers, "Closed");

                        if (provider.collectionLoanModel == null) {
                          return buildShimmerList();
                        } else if (filteredCustomers.isEmpty) {
                          return Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? "No customers found"
                                  : "No results found for '${_searchController.text}'",
                              style: TextStyle(color: grey[600]),
                            ),
                          );
                        }

                        // ✅ UI based on filteredCustomers
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem("Active", activeCount.toString(), Icons.receipt),
                            _buildSummaryItem("Pending", pendingCount.toString(), Icons.pending),
                            _buildSummaryItem("Closed", closedCount.toString(), Icons.check_circle),
                          ],
                        );
                      },
                    ),

                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Recent Loans",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : Consumer<GetLoanProvider>(
                builder: (context, provider, _) {
                  final loanData = provider.collectionLoanModel?.data ?? [];

                  // Ensure _visibleLoans is always in sync with filtered data
                  if (_allLoans.isEmpty && loanData.isNotEmpty) {
                    _allLoans = loanData;
                    _visibleLoans =
                        _filterCustomers(loanData, _searchController.text);
                  }

                  if (_visibleLoans.isEmpty) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? "No loans available"
                            : "No results found for '${_searchController
                            .text}'",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _visibleLoans.length,
                    itemBuilder: (context, index, animation) {
                      // Add bounds checking
                      if (index >= _visibleLoans.length) {
                        return const SizedBox.shrink();
                      }
                      final loan = _visibleLoans[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoanDetailsPage(
                                    customerName: loan.customerName ?? "Name",
                                    loanNumber: loan.loanNumber ??
                                        "Loan Number",
                                    emiAmount: loan.emi ?? 0,
                                    loanTerm: loan.tenorDays ?? 0,
                                    loanStatus: loan.status ?? "",
                                    loanAmount: loan.outstandingAmount ?? 0,
                                  ),
                            ),
                          );
                        },
                        child: _buildLoanCard(loan, animation),
                      );
                    },
                  );
                }
              )
        ),
      ])
    ));
  }

  int _countLoansByStatus(List<Datum> loans, String status) {
    return loans
        .where((loan) => loan.status?.toLowerCase() == status.toLowerCase())
        .length;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.grey;
      default:
        return primaryColor; // Use primary color for unknown status
    }
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoanCard(Datum loan, Animation<double> animation) {
    final statusColor = _getStatusColor(loan.status);
    final formattedDate = loan.createdAt?.toString().substring(0, 10) ?? 'N/A';
    final formattedAmount =
        '₹${loan.outstandingAmount?.toStringAsFixed(2) ?? '0.00'}';

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      )),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: black, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Loan #${(loan.loanNumber ?? 'N/A').replaceAll("LOAN-", "")}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      loan.status ?? 'Unknown',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                loan.customerName ?? 'NAME',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${capitalizeFirstLetter(loan.scheme ?? 'Loan')} Loan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        formattedAmount,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor, // Using primary color for amount
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
