import 'package:e_Collect/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/colors.dart';
import '../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import 'ecollect_transaction_detail.dart';

class EcollectTransactionReport extends StatefulWidget {
  final String eCollectMerchantID;
  final String eCollectMerchantName;
  final String eCollectToken;
  const EcollectTransactionReport(
      {super.key,
      required this.eCollectMerchantID,
      required this.eCollectMerchantName,
      required this.eCollectToken});

  @override
  State<EcollectTransactionReport> createState() =>
      EcollectTransactionReportState();
}

class EcollectTransactionReportState extends State<EcollectTransactionReport> {
  String selectedValue = "This Week";
  //String selectedDateFilter = "All";
  bool showProgress = false;
  String selectedStatusFilter = "All";
  bool sendIconVisibility = false;
  TextEditingController searchNameController = TextEditingController();
  int selectedIndex = 0;
  // ---- NEW: date-range filter state ----
  DateTimeRange? customRange; // used only when selectedValue == "Custom Range"
  final List<String> filterItems = [
    "Today",
    "This Week",
    "This Month",
    "Last Month",
    "Custom Range",
  ];

  final List<String> statusFilters = [
    "All",
    "Success",
    "Pending",
  ];

  // ---- NEW: payment mode / transaction type filter state ----
  String selectedPaymentModeFilter = "All";
  final List<String> paymentModeFilters = [
    "All",
    "RD",
    "Loan",
    "Cash",
    "UPI",
  ];

  // ---- NEW: search text kept in state for filtering ----
  String searchQuery = "";

  void getTransactionReport() {
    if (!mounted) return;
    context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(
        widget.eCollectMerchantID, widget.eCollectToken));
  }

  @override
  void initState() {
    super.initState();
    getTransactionReport();
  }

  @override
  void dispose() {
    searchNameController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // FILTER HELPERS
  // ---------------------------------------------------------------------

  /// Returns the (start, end) DateTime bounds for the currently selected
  /// quick filter, or the custom range the user picked.
  DateTimeRange _resolveDateRange() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    print("selectedValue $selectedValue");
    setState(() {
      selectedValue = selectedValue;
    });
    switch (selectedValue) {
      case "Today":
        return DateTimeRange(start: todayStart, end: todayEnd);

      case "This Week":
        // Week starts on Monday
        final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        return DateTimeRange(start: weekStart, end: weekEnd);

      case "This Month":
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(milliseconds: 1));
        return DateTimeRange(start: monthStart, end: monthEnd);

      case "Last Month":
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);
        final lastMonthEnd = DateTime(now.year, now.month, 1)
            .subtract(const Duration(milliseconds: 1));
        return DateTimeRange(start: lastMonthStart, end: lastMonthEnd);

      case "Custom Range":
        if (customRange != null) return customRange!;
        return DateTimeRange(start: todayStart, end: todayEnd);

      default:
        return DateTimeRange(start: todayStart, end: todayEnd);
    }
  }

  /// transaction list coming from the bloc.
  List<dynamic> _applyFilters(List<PaymentTransaction> data) {
    final query = searchQuery.trim().toLowerCase();
    return data.where((transaction) {
      final matchesName = query.isEmpty ||
          transaction.customerName.toString().toLowerCase().contains(query) ||
          transaction.status.toLowerCase().contains(query);

      final matchesPaymentMode = selectedPaymentModeFilter == "All" ||
          transaction.paymentMode.toUpperCase() ==
              selectedPaymentModeFilter.toUpperCase();

      return matchesName && matchesPaymentMode;
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: home1.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: home1,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Filter Transactions",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Refine your transaction history",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              selectedValue = "This Week";
                              selectedStatusFilter = "All";
                              selectedPaymentModeFilter = "All";
                              customRange = null;
                            });
                            setState(() {
                              selectedPaymentModeFilter = "All";
                            });
                            context.read<PaymentTransactionBloc>().add(
                                GetTransactionByMerchant(
                                    widget.eCollectMerchantID,
                                    widget.eCollectToken));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 8,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200),
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Divider(),
                    // Date section
                    const Text(
                      "Date range",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: filterItems.map((item) {
                        final isSelected = selectedValue == item;

                        return ChoiceChip(
                          label: Text(item),
                          selected: isSelected,
                          showCheckmark: false,
                          side: BorderSide(
                            color: isSelected ? home1 : Colors.grey.shade200,
                          ),
                          backgroundColor: Colors.grey.shade50,
                          selectedColor: home1.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? home1 : Colors.grey.shade700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          onSelected: (_) async {
                            if (item == "Custom Range") {
                              final now = DateTime.now();

                              final picked = await showDateRangePicker(
                                context: sheetContext,
                                firstDate: DateTime(now.year - 2),
                                lastDate: now,
                                initialDateRange: customRange ??
                                    DateTimeRange(
                                      start: now,
                                      end: now,
                                    ),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.blue.shade700,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked == null) return;

                              setSheetState(() {
                                selectedValue = "Custom Range";

                                customRange = DateTimeRange(
                                  start: DateTime(
                                    picked.start.year,
                                    picked.start.month,
                                    picked.start.day,
                                  ),
                                  end: DateTime(
                                    picked.end.year,
                                    picked.end.month,
                                    picked.end.day,
                                    23,
                                    59,
                                    59,
                                  ),
                                );
                              });
                            } else {
                              setSheetState(() {
                                selectedValue = item;
                                customRange = null;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),

                    // Custom range preview
                    if (selectedValue == "Custom Range" &&
                        customRange != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: home1.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: home1.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.date_range_rounded,
                                size: 18, color: home1),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${_formatDate(customRange!.start)}"
                                "  –  "
                                "${_formatDate(customRange!.end)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: home1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Divider(),
                    // Status section
                    const Text(
                      "Transaction status",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: statusFilters.map((status) {
                        final isSelected = selectedStatusFilter == status;

                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          showCheckmark: false,
                          side: BorderSide(
                            color: isSelected ? home1 : Colors.grey.shade200,
                          ),
                          backgroundColor: Colors.grey.shade50,
                          selectedColor: home1.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? home1 : Colors.grey.shade700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          onSelected: (_) {
                            setSheetState(() {
                              selectedStatusFilter = status;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    Divider(),
                    // Transaction type section
                    const Text(
                      "Transaction type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: paymentModeFilters.map((mode) {
                        final isSelected = selectedPaymentModeFilter == mode;

                        return ChoiceChip(
                          label: Text(mode),
                          selected: isSelected,
                          showCheckmark: false,
                          side: BorderSide(
                            color: isSelected ? home1 : Colors.grey.shade200,
                          ),
                          backgroundColor: Colors.grey.shade50,
                          selectedColor: home1.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? home1 : Colors.grey.shade700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          onSelected: (_) {
                            setSheetState(() {
                              selectedPaymentModeFilter = mode;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);

                          if (!mounted) return;

                          final range = _resolveDateRange();

                          if (range == null) return;
                          context.read<PaymentTransactionBloc>().add(
                                GetTransactionByMerchantDateWithStatus(
                                    widget.eCollectMerchantID,
                                    range.start
                                        .toIso8601String()
                                        .replaceRange(10, null, "")
                                        .toString(),
                                    range.end
                                        .toIso8601String()
                                        .replaceRange(10, null, "")
                                        .toString(),
                                    selectedStatusFilter == "All"
                                        ? ""
                                        : selectedStatusFilter,
                                    widget.eCollectToken),
                              );
                        },
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 19,
                        ),
                        label: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: home1.withValues(alpha: 0.79),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // void _runSearch() {
  //   setState(() {
  //     searchQuery = searchNameController.text;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: buildAppBar(),
      body: Column(
        children: [
          // ─────────────────────────────────────────────
          // SEARCH + FILTER
          // ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: searchNameController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          sendIconVisibility = value.trim().isNotEmpty;
                        });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search transactions",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade500,
                          size: 21,
                        ),
                        suffixIcon: sendIconVisibility
                            ? IconButton(
                                onPressed: () {
                                  searchNameController.clear();
                                  setState(() {
                                    searchQuery = "";
                                    sendIconVisibility = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Colors.grey.shade500,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Filter button
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _openFilterSheet,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: home1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                        if (_activeFilterCount() > 0)
                          Positioned(
                            right: -2,
                            top: -4,
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF5F7FA),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${_activeFilterCount()}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─────────────────────────────────────────────
          // ACTIVE FILTERS
          // ─────────────────────────────────────────────
          SizedBox(
            height: 42,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _filterPill(
                  icon: Icons.calendar_today_rounded,
                  text: selectedValue == "Custom Range" && customRange != null
                      ? "${_formatDate(customRange!.start)} - "
                          "${_formatDate(customRange!.end)}"
                      : selectedValue,
                  selected: true,
                ),
                if (selectedStatusFilter != "All")
                  _filterPill(
                    icon: Icons.check_circle_outline_rounded,
                    text: selectedStatusFilter,
                    selected: true,
                  ),
                if (selectedPaymentModeFilter != "All")
                  _filterPill(
                    icon: Icons.account_balance_wallet_outlined,
                    text: selectedPaymentModeFilter,
                    selected: true,
                  ),
                if (_activeFilterCount() > 0)
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Clear",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // ─────────────────────────────────────────────
          // TRANSACTIONS
          // ─────────────────────────────────────────────
          /*  Expanded(
            child: BlocListener<PaymentTransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionReportLoaderState) {
                  print("ONE");
                  showProgressDialog(context);
                }

                if (state is TransactionReportSuccessState ||
                    state is TransactionReportFailureState) {
                  print("TWO");
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionReportSuccessState) {
                    print("THREE");
                    final rawData =
                        state.transactionSuccessModel
                            .transactionOkReport.data;

                    final data = _applyFilters(rawData);

                    if (data.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _transactionCard(
                          context,
                          data[index],
                        );
                      },
                    );
                  }
else{
                    if (Navigator.of(context).canPop()) {
                      print("FOUR");
                      Navigator.of(context).pop();
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),*/

          Expanded(
            child: BlocListener<PaymentTransactionBloc, TransactionState>(
              listener: (context, state) {

                if (state is TransactionReportLoaderState) {
                  // if (showProgress == false) {
                  //   showProgressDialog(context);
                  //   showProgress = true;
                  // }
                }

                if (state is TransactionReportSuccessState ||
                    state is TransactionReportFailureState) {
                  print("TWO");
                  // if (showProgress == true) {
                  //
                  //     Navigator.of(context).pop();
                  //
                  //   showProgress = false;
                  // }
                }
              },
              child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionReportSuccessState) {
                    print("THREE");

                    final rawData =
                        state.transactionSuccessModel.transactionOkReport.data;

                    final data = _applyFilters(rawData);

                    if (data.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _transactionCard(
                          context,
                          data[index],
                        );
                      },
                    );
                  }

                  // Don't pop here.
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// ═════════════════════════════════════════════════════
// MODERN APP BAR
// ═════════════════════════════════════════════════════

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5F7FA),
      elevation: 0,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: const Text(
        "Transactions",
        style: TextStyle(
          color: home1,
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

// ═════════════════════════════════════════════════════
// FILTER COUNT
// ═════════════════════════════════════════════════════

  int _activeFilterCount() {
    int count = 0;

    if (selectedValue != "This Week") count++;
    if (selectedStatusFilter != "All") count++;
    if (selectedPaymentModeFilter != "All") count++;

    return count;
  }

// ═════════════════════════════════════════════════════
// FILTER PILL
// ═════════════════════════════════════════════════════

  Widget _filterPill({
    required IconData icon,
    required String text,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: selected ? home1.withValues(alpha: 0.10) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? home1.withValues(alpha: 0.15) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: selected ? home1 : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: selected ? home1 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

// ═════════════════════════════════════════════════════
// TRANSACTION CARD
// ═════════════════════════════════════════════════════
  Widget _transactionCard(
    BuildContext context,
    dynamic transaction,
  ) {
    final status = transaction.status.toString().toLowerCase();

    final bool isPending = status.startsWith("pending");
    final bool isSuccess = status.startsWith("success");

    final Color statusColor = isPending
        ? const Color(0xFFD97706)
        : isSuccess
            ? const Color(0xFF16A34A)
            : const Color(0xFFDC2626);

    final Color statusBg = isPending
        ? const Color(0xFFFFF7ED)
        : isSuccess
            ? const Color(0xFFF0FDF4)
            : const Color(0xFFFEF2F2);

    final String customerName =
        transaction.customerName?.toString() ?? "Unknown Customer";

    final String initial = customerName.trim().isNotEmpty
        ? customerName.trim()[0].toUpperCase()
        : "?";

    final String orderId = transaction.orderId?.toString() ?? "N/A";

    final String paymentMode =
        transaction.paymentMode?.toString().toUpperCase() ?? "N/A";

    final String paymentChannel =
        transaction.paymentChannel?.toString().toUpperCase() ?? "N/A";

    final String transactionStatus =
        transaction.status?.toString() ?? "Unknown";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE9E9ED),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EcollectTransactionDetail(
                  paymentTransaction: PaymentTransaction(
                    id: transaction.id,
                    orderId: transaction.orderId,
                    transactionId: transaction.transactionId,
                    paymentGatewayTransactionId:
                        transaction.paymentGatewayTransactionId,
                    amount: transaction.amount,
                    currency: transaction.currency,
                    description: transaction.description,
                    customerName: transaction.customerName,
                    customerEmail: transaction.customerEmail,
                    customerPhone: transaction.customerPhone,
                    paymentMode: transaction.paymentMode,
                    paymentChannel: transaction.paymentChannel,
                    status: transaction.status,
                    responseCode: transaction.responseCode,
                    responseMessage: transaction.responseMessage,
                    createdAt: transaction.createdAt,
                    completedAt: transaction.completedAt,
                    merchantId: transaction.merchantId,
                    merchantName: transaction.merchantName,
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 13, 13),
            child: Column(
              children: [
                // =====================================================
                // MAIN TRANSACTION ROW
                // =====================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F5),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Color(0xFF3F3F46),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 11),

                    // Customer information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF18181B),
                              letterSpacing: -0.15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "#$orderId",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF71717A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  "•",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFD4D4D8),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  DateFormat(
                                    'dd MMM, hh:mm a',
                                  ).format(
                                    transaction.createdAt,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF71717A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Amount + status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${transaction.amount}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                transactionStatus,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 13),

                // =====================================================
                // BOTTOM METADATA
                // =====================================================

                Row(
                  children: [
                    const SizedBox(width: 53),

                    // Payment mode
                    _transactionMeta(
                      paymentMode,
                      Icons.account_balance_wallet_outlined,
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4D4D8),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        paymentChannel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF71717A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Arrow
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Color(0xFFA1A1AA),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
/*  Widget _transactionCard(
      BuildContext context,
      dynamic transaction,
      )
  {
    final status = transaction.status.toLowerCase();

    final bool isPending = status.startsWith("pending");
    final bool isSuccess = status.startsWith("success");

    final Color statusColor = isPending
        ? Colors.orange.shade700
        : isSuccess
        ? Colors.green.shade600
        : Colors.red.shade600;

    final String customerName =
    transaction.customerName.toString();

    final String initial = customerName.isNotEmpty
        ? customerName[0].toUpperCase()
        : "?";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EcollectTransactionDetail(
                  paymentTransaction: PaymentTransaction(
                    id: transaction.id,
                    orderId: transaction.orderId,
                    transactionId: transaction.transactionId,
                    paymentGatewayTransactionId:
                    transaction.paymentGatewayTransactionId,
                    amount: transaction.amount,
                    currency: transaction.currency,
                    description: transaction.description,
                    customerName: transaction.customerName,
                    customerEmail: transaction.customerEmail,
                    customerPhone: transaction.customerPhone,
                    paymentMode: transaction.paymentMode,
                    paymentChannel: transaction.paymentChannel,
                    status: transaction.status,
                    responseCode: transaction.responseCode,
                    responseMessage: transaction.responseMessage,
                    createdAt: transaction.createdAt,
                    completedAt: transaction.completedAt,
                    merchantId: transaction.merchantId,
                    merchantName: transaction.merchantName,
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ─────────────────────────────
                // TOP
                // ─────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: home1.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: home1,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF171A1F),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade100
                            ),
                            child: Text(
                              "ORDER ID :- ${transaction.orderId.toString()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            DateFormat('dd MMM yyyy, hh:mm a')
                                .format(transaction.createdAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${transaction.amount}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: statusColor,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            transaction.status.toString(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Divider(color: Colors.grey.shade300,),
                ),
                // ─────────────────────────────
                // BOTTOM INFO
                // ─────────────────────────────

                Row(
                  children: [
                   SizedBox(width: 55,),
                    _transactionMeta(
                      transaction.paymentMode
                          .toString()
                          .toUpperCase(),
                      Icons.account_balance_wallet_outlined,
                    ),

                    const SizedBox(width: 10),

                    Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Transaction Type :- ${transaction.paymentChannel.toString().toUpperCase()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade100
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

// ═════════════════════════════════════════════════════
// TRANSACTION META
// ═════════════════════════════════════════════════════
  Widget _transactionMeta(
    String text,
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF71717A),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF52525B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
  // Widget _transactionMeta(
  //     String text,
  //     IconData icon,
  //     ) {
  //   return Row(
  //     children: [
  //       Icon(
  //         icon,
  //         size: 15,
  //         color: home1,
  //       ),
  //       const SizedBox(width: 5),
  //       Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 10,
  //           color: Colors.blueGrey.shade500,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //     ],
  //   );
  // }

// ═════════════════════════════════════════════════════
// EMPTY STATE
// ═════════════════════════════════════════════════════

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: home1.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 34,
                color: home1,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "No transactions found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Try changing your filters or search.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

// ═════════════════════════════════════════════════════
// CLEAR FILTERS
// ═════════════════════════════════════════════════════

  void _clearFilters() {
    setState(() {
      selectedValue = "This Week";
      selectedStatusFilter = "All";
      selectedPaymentModeFilter = "All";
      customRange = null;
    });

    context.read<PaymentTransactionBloc>().add(
          GetTransactionByMerchant(
            widget.eCollectMerchantID,
            widget.eCollectToken,
          ),
        );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF7F8FA),
  //     appBar: buildAppBar(),
  //     body: Column(
  //       children: [
  //         // Search + Filter
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Container(
  //                   height: 48,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(14),
  //                     border: Border.all(
  //                       color: Colors.grey.shade200,
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withValues(alpha: 0.03),
  //                         blurRadius: 8,
  //                         offset: const Offset(0, 2),
  //                       ),
  //                     ],
  //                   ),
  //                   child: TextField(
  //                     controller: searchNameController,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         sendIconVisibility = value.trim().length > 2;
  //                         // live-filter as the user types
  //                         searchQuery = value;
  //                       });
  //                     },
  //                     onSubmitted: (_) => _runSearch(),
  //                     textInputAction: TextInputAction.search,
  //                     decoration: InputDecoration(
  //                       hintText: "Search by name",
  //                       hintStyle: TextStyle(
  //                         color: Colors.grey.shade500,
  //                         fontSize: 13,
  //                       ),
  //                       prefixIcon: Icon(
  //                         Icons.search_rounded,
  //                         color: home1.withValues(alpha: 0.5),
  //                         size: 21,
  //                       ),
  //                       suffixIcon: sendIconVisibility
  //                           ? IconButton(
  //                         onPressed: _runSearch,
  //                         icon: Icon(
  //                           color: home1.withValues(alpha: 0.5),
  //                           Icons.arrow_forward_rounded,
  //                           size: 20,
  //                         ),
  //                       )
  //                           : null,
  //                       border: InputBorder.none,
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         vertical: 14,
  //                         horizontal: 4,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(width: 10),
  //
  //               // Filter Button
  //               Container(
  //                 height: 48,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(14),
  //                   border: Border.all(
  //                     color: home1.withValues(alpha: 0.5),
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: home1.withValues(alpha: 0.1),
  //                       blurRadius: 2,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //                 child: IconButton(
  //                   tooltip: "Filter",
  //                   onPressed: _openFilterSheet,
  //                   icon: const Icon(
  //                     color: home1,
  //                     Icons.tune_rounded,
  //                     size: 21,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         // Active filter chips (shows what's currently applied)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(left: 16, right: 8),
  //                 child: Wrap(
  //                   alignment: WrapAlignment.start,
  //                   spacing: 8,
  //                   runSpacing: 8,
  //                   children: [
  //                     Chip(
  //                       avatar: Icon(Icons.date_range),
  //                       label: Text(
  //                         selectedValue == "Custom Range" &&
  //                             customRange != null
  //                             ? "${_formatDate(customRange!.start)} - ${_formatDate(customRange!.end)}"
  //                             : selectedValue,
  //                         style: const TextStyle(
  //                             fontSize: 11, fontWeight: FontWeight.w600),
  //                       ),
  //                       backgroundColor: Colors.grey.shade100,
  //                       visualDensity: VisualDensity.compact,
  //                       materialTapTargetSize:
  //                       MaterialTapTargetSize.shrinkWrap,
  //                     ),
  //                     if (selectedStatusFilter != "All")
  //                       Chip(
  //                         avatar: Icon(Icons.verified_outlined),
  //                         label: Text(
  //                           selectedStatusFilter,
  //                           style: const TextStyle(
  //                               fontSize: 11, fontWeight: FontWeight.w600),
  //                         ),
  //                         backgroundColor: Colors.grey.shade100,
  //                         visualDensity: VisualDensity.compact,
  //                         materialTapTargetSize:
  //                         MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                     if (selectedPaymentModeFilter != "All")
  //                       Chip(
  //                         avatar: Icon(Icons.account_balance_wallet_outlined),
  //                         label: Text(
  //                           selectedPaymentModeFilter,
  //                           style: const TextStyle(
  //                               fontSize: 11, fontWeight: FontWeight.w600),
  //                         ),
  //                         backgroundColor: Colors.grey.shade100,
  //                         visualDensity: VisualDensity.compact,
  //                         materialTapTargetSize:
  //                         MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             (selectedValue != "This Week" ||
  //                 selectedStatusFilter != "All" ||
  //                 selectedPaymentModeFilter != "All")
  //                 ? InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   selectedValue = "This Week";
  //                   selectedStatusFilter = "All";
  //                   selectedPaymentModeFilter = "All";
  //                   customRange = null;
  //                 });
  //                 context
  //                     .read<PaymentTransactionBloc>()
  //                     .add(GetTransactionByMerchant(widget.eCollectMerchantID, widget.eCollectToken));
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16),
  //                 child: Align(
  //                   alignment: Alignment.centerRight,
  //                   child: Chip(
  //                     avatar: Icon(Icons.clear),
  //                     label: Text(
  //                       "Clear",
  //                       style: const TextStyle(
  //                           fontSize: 11, fontWeight: FontWeight.w600),
  //                     ),
  //                     backgroundColor: Colors.grey.shade100,
  //                     visualDensity: VisualDensity.compact,
  //                     materialTapTargetSize:
  //                     MaterialTapTargetSize.shrinkWrap,
  //                   ),
  //                 ),
  //               ),
  //             )
  //                 : SizedBox.shrink(),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 6),
  //
  //         // Transaction List
  //         SizedBox(
  //           child: BlocListener<PaymentTransactionBloc, TransactionState>(
  //             listener: (BuildContext context, TransactionState state) {
  //               print("STATE IS : $state");
  //               if (state is TransactionReportLoaderState) {
  //                 showProgressDialog(context);
  //               }
  //
  //               if (state is TransactionReportSuccessState) {
  //                 if (Navigator.of(context).canPop()) {
  //                   Navigator.of(context).pop();
  //                 }
  //               } else if (state is TransactionReportFailureState) {
  //                 if (Navigator.of(context).canPop()) {
  //                   Navigator.of(context).pop();
  //                 }
  //               }
  //             },
  //             child: SizedBox.shrink(),
  //           ),
  //         ),
  //         Expanded(
  //           child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
  //             builder: (
  //                 BuildContext context,
  //                 TransactionState state,
  //                 ) {
  //               if (state is TransactionReportSuccessState) {
  //                 final rawData =
  //                     state.transactionSuccessModel.transactionOkReport.data;
  //
  //                 // apply name + date filters client-side
  //                 final data = _applyFilters(rawData);
  //
  //                 if (data.isEmpty) {
  //                   return Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                             Icons.error_outline_outlined,
  //                             size: 80,
  //                             color: Colors.grey.shade400,
  //                           ),
  //                           Text(
  //                             "No transactions found",
  //                             style: TextStyle(
  //                                 color: Colors.grey.shade500, fontSize: 13),
  //                           ),
  //                         ],
  //                       ));
  //                 }
  //
  //                 return Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 12),
  //                   child: ListView.builder(
  //                     padding: const EdgeInsets.only(
  //                       top: 4,
  //                       bottom: 20,
  //                     ),
  //                     itemCount: data.length,
  //                     itemBuilder: (
  //                         BuildContext context,
  //                         int index,
  //                         ) {
  //                       final transaction = data[index];
  //
  //                       final status = transaction.status.toLowerCase();
  //
  //                       final bool isPending = status.startsWith("pending");
  //
  //                       final bool isSuccess = status.startsWith("success");
  //
  //                       final Color statusColor = isPending
  //                           ? Colors.orange
  //                           : isSuccess
  //                           ? Colors.green
  //                           : Colors.red;
  //
  //                       return InkWell(
  //                         borderRadius: BorderRadius.circular(18),
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (BuildContext context) =>
  //                                   EcollectTransactionDetail(
  //                                     paymentTransaction: PaymentTransaction(
  //                                       id: transaction.id,
  //                                       orderId: transaction.orderId,
  //                                       transactionId: transaction.transactionId,
  //                                       paymentGatewayTransactionId:
  //                                       transaction.paymentGatewayTransactionId,
  //                                       amount: transaction.amount,
  //                                       currency: transaction.currency,
  //                                       description: transaction.description,
  //                                       customerName: transaction.customerName,
  //                                       customerEmail: transaction.customerEmail,
  //                                       customerPhone: transaction.customerPhone,
  //                                       paymentMode: transaction.paymentMode,
  //                                       paymentChannel: transaction.paymentChannel,
  //                                       status: transaction.status,
  //                                       responseCode: transaction.responseCode,
  //                                       responseMessage:
  //                                       transaction.responseMessage,
  //                                       createdAt: transaction.createdAt,
  //                                       completedAt: transaction.completedAt,
  //                                       merchantId: transaction.merchantId,
  //                                       merchantName: transaction.merchantName,
  //                                     ),
  //                                   ),
  //                             ),
  //                           );
  //                         },
  //                         child: Container(
  //                           margin: const EdgeInsets.only(bottom: 10),
  //                           padding: const EdgeInsets.all(15),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(18),
  //                             border: Border.all(
  //                               color: Colors.grey.shade200,
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black.withValues(alpha: 0.025),
  //                                 blurRadius: 8,
  //                                 offset: const Offset(0, 3),
  //                               ),
  //                             ],
  //                           ),
  //                           child: Column(
  //                             children: [
  //                               // Top section
  //                               Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   // Customer avatar
  //                                   Container(
  //                                     height: 42,
  //                                     width: 42,
  //                                     decoration: BoxDecoration(
  //                                       color: Colors.blueGrey.shade50,
  //                                       shape: BoxShape.circle,
  //                                     ),
  //                                     child: Center(
  //                                       child: Text(
  //                                         transaction.customerName.isNotEmpty
  //                                             ? transaction.customerName[0]
  //                                             .toUpperCase()
  //                                             : "?",
  //                                         style: const TextStyle(
  //                                           fontSize: 16,
  //                                           color: Colors.grey,
  //                                           fontWeight: FontWeight.w700,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //
  //                                   const SizedBox(width: 12),
  //
  //                                   // Customer details
  //                                   Expanded(
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           transaction.customerName
  //                                               .toUpperCase(),
  //                                           maxLines: 1,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           style: const TextStyle(
  //                                             fontSize: 14,
  //                                             fontWeight: FontWeight.w700,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 4),
  //                                         Text(
  //                                           transaction.createdAt.toString(),
  //                                           maxLines: 1,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           style: TextStyle(
  //                                             color: Colors.grey.shade500,
  //                                             fontSize: 11,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //
  //                                   const SizedBox(width: 10),
  //
  //                                   // Amount
  //                                   Column(
  //                                     crossAxisAlignment:
  //                                     CrossAxisAlignment.end,
  //                                     children: [
  //                                       Text(
  //                                         "₹ ${transaction.amount}",
  //                                         style: TextStyle(
  //                                           fontWeight: FontWeight.w800,
  //                                           fontSize: 16,
  //                                           color: statusColor,
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 4),
  //                                       Container(
  //                                         padding: const EdgeInsets.symmetric(
  //                                           horizontal: 8,
  //                                           vertical: 3,
  //                                         ),
  //                                         decoration: BoxDecoration(
  //                                           color: statusColor.withValues(
  //                                               alpha: 0.10),
  //                                           borderRadius:
  //                                           BorderRadius.circular(20),
  //                                         ),
  //                                         child: Text(
  //                                           transaction.status,
  //                                           style: TextStyle(
  //                                             color: statusColor,
  //                                             fontWeight: FontWeight.w700,
  //                                             fontSize: 9,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //
  //                               const SizedBox(height: 14),
  //
  //                               // Divider
  //                               Divider(
  //                                 height: 1,
  //                                 color: Colors.grey.shade100,
  //                               ),
  //
  //                               const SizedBox(height: 12),
  //
  //                               // Bottom section
  //                               Row(
  //                                 children: [
  //                                   Icon(
  //                                       transaction.paymentMode.toUpperCase() == "LOAN"?
  //                                       Icons.account_balance:
  //                                       Icons.account_balance_wallet_outlined
  //                                       ,
  //                                       size: 16,
  //                                       color:
  //                                       transaction.paymentMode.toUpperCase() == "LOAN"?
  //                                       Colors.red.shade500:Colors.green.shade500
  //                                   ),
  //                                   const SizedBox(width: 6),
  //                                   Text(
  //                                     transaction.paymentMode.toUpperCase(),
  //                                     style: TextStyle(
  //                                       color: Colors.grey.shade500,
  //                                       fontSize: 11,
  //                                     ),
  //                                   ),
  //                                   const Spacer(),
  //                                   Container(
  //                                     padding: const EdgeInsets.symmetric(
  //                                       horizontal: 10,
  //                                       vertical: 5,
  //                                     ),
  //                                     decoration: BoxDecoration(
  //                                       color: Colors.grey.shade100,
  //                                       borderRadius: BorderRadius.circular(8),
  //                                     ),
  //                                     child: Text(
  //
  //                                       // transaction.paymentMode.toUpperCase(),
  //                                       transaction.paymentChannel.toUpperCase(),
  //                                       style: const TextStyle(
  //
  //                                         fontSize: 10,
  //                                         fontWeight: FontWeight.w700,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 4),
  //                                   Icon(
  //                                     Icons.chevron_right_rounded,
  //                                     size: 20,
  //                                     color: Colors.grey.shade400,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 );
  //               }
  //
  //               return const SizedBox.shrink();
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     automaticallyImplyLeading: false,
  //     centerTitle: true,
  //     title: const Text(
  //       "Transaction History",
  //       style: TextStyle(
  //         color: home1,
  //         fontWeight: FontWeight.w700,
  //         fontSize: 24,
  //         letterSpacing: 0.5,
  //       ),
  //     ),
  //   );
  // }
}
