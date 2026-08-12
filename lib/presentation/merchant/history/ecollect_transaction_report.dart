import 'package:collection_qr_flutter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import 'ecollect_transaction_detail.dart';

class EcollectTransactionReport extends StatefulWidget {
  const EcollectTransactionReport({super.key});

  @override
  State<EcollectTransactionReport> createState() =>
      EcollectTransactionReportState();
}

class EcollectTransactionReportState extends State<EcollectTransactionReport> {
  String selectedValue = "This Week";
  String merchantID = "";
  String name = "Select";
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

  // ---- NEW: search text kept in state for filtering ----
  String searchQuery = "";

  Future<void> refresh() async {
    print("caeeld  this week");
    setState(() {
      selectedValue = "This Week";
    });
  }

  Future<void> getSharedData() async {
    final _merchantID = await SharedPref.shared.getECollectMerchantID();
    final _name = await SharedPref().getECollectMerchantName();

    if (!mounted) return;
    setState(() {
      merchantID = _merchantID;
      name = _name;
    });
    context
        .read<PaymentTransactionBloc>()
        .add(GetTransactionByMerchant(merchantID));
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
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
          transaction.customerName.toString().toLowerCase().contains(query);
      return matchesName;
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter by date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...filterItems.map((item) {
                  final isSelected = item == selectedValue;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                          )
                        : null,
                    onTap: () async {
                      DateTimeRange? range;

                      if (item == "Custom Range") {
                        final now = DateTime.now();

                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(now.year - 2),
                          lastDate: now,
                          initialDateRange: customRange ??
                              DateTimeRange(
                                start: now,
                                end: now,
                              ),
                        );

                        if (picked == null) return;

                        range = DateTimeRange(
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
                      } else {
                        // Temporarily change selectedValue so
                        // _resolveDateRange() calculates this selection.
                        setState(() {
                          selectedValue = item;
                        });

                        range = _resolveDateRange();
                      }

                      if (range == null) return;

                      setState(() {
                        selectedValue = item;
                        customRange = item == "Custom Range" ? range : null;
                      });

                      // Close filter sheet
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                      context.read<PaymentTransactionBloc>().add(
                          GetTransactionByMerchantDateRange(
                              merchantID,
                              range.start.toIso8601String(),
                              range.end.toIso8601String()));
                      // --------------------------------------------------
                      // API CALL
                      // --------------------------------------------------
                      // context.read<PaymentTransactionBloc>().add(
                      //   GetTransactionByMerchant(
                      //     merchantID,
                      //     fromDate: range.start.toIso8601String(),
                      //     toDate: range.end.toIso8601String(),
                      //   ),
                      // );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _runSearch() {
    setState(() {
      searchQuery = searchNameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: buildAppBar(),
      body: Column(
        children: [
          // Search + Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchNameController,
                      onChanged: (value) {
                        setState(() {
                          sendIconVisibility = value.trim().length > 2;
                          // live-filter as the user types
                          searchQuery = value;
                        });
                      },
                      onSubmitted: (_) => _runSearch(),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search by name",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade600,
                          size: 21,
                        ),
                        suffixIcon: sendIconVisibility
                            ? IconButton(
                                onPressed: _runSearch,
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 4,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Filter Button
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    tooltip: "Filter",
                    onPressed: _openFilterSheet,
                    icon: const Icon(
                      Icons.tune_rounded,
                      size: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filter chip (shows what's currently applied)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(Icons.date_range),
                    label: Text(
                      selectedValue == "Custom Range" && customRange != null
                          ? "${_formatDate(customRange!.start)} - ${_formatDate(customRange!.end)}"
                          : selectedValue,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              selectedValue != "This Week"
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          selectedValue = "This Week";
                        });

                        context
                            .read<PaymentTransactionBloc>()
                            .add(GetTransactionByMerchant(merchantID));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Chip(
                            avatar: Icon(Icons.clear),
                            label: Text(
                              "Clear",
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Colors.grey.shade100,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    SizedBox(width: 16,),
  ChoiceChip(
    //selectedColor: Colors.green.shade100,
    label: Text("All", style: TextStyle(fontSize: 11),), selected: selectedIndex==0,
    onSelected: (selected){
      setState(() {
        selectedIndex = 0;
      });
    },),
    SizedBox(width: 16,),
  ChoiceChip(
    selectedColor: Colors.green.shade100,
    label: Text("Success",style: TextStyle(fontSize: 11)), selected: selectedIndex==1,
    onSelected: (selected){
      setState(() {
        selectedIndex = 1;
      });
    },),
    SizedBox(width: 16,),
  ChoiceChip(
    selectedColor: Colors.orange.shade100,

    label: Text("Pending",style: TextStyle(fontSize: 11)), selected: selectedIndex == 2,
    onSelected: (selected){
      setState(() {
        selectedIndex = 2;
      });
    },),
    Spacer(flex: 1,)
],),
          const SizedBox(height: 6),

          // Transaction List
          SizedBox(
            child: BlocListener<PaymentTransactionBloc, TransactionState>(
              listener: (BuildContext context, TransactionState state) {
                if (state is TransactionReportLoaderState) {
                  showProgressDialog(context)     ;   }
                if (state is TransactionReportSuccessState) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }              } else if (state is TransactionReportFailureState) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }              }
              },
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
              builder: (
                BuildContext context,
                TransactionState state,
              ) {
                if (state is TransactionReportSuccessState) {
                  final rawData =
                      state.transactionSuccessModel.transactionOkReport.data;

                  // apply name + date filters client-side
                  final data = _applyFilters(rawData);

                  if (data.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        Text(
                          "No transactions found",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ],
                    ));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 20,
                      ),
                      itemCount: data.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        final transaction = data[index];

                        final status = transaction.status.toLowerCase();

                        final bool isPending = status.startsWith("pending");

                        final bool isSuccess = status.startsWith("success");

                        final Color statusColor = isPending
                            ? Colors.orange
                            : isSuccess
                                ? Colors.green
                                : Colors.red;

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EcollectTransactionDetail(
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
                                    responseMessage:
                                        transaction.responseMessage,
                                    createdAt: transaction.createdAt,
                                    completedAt: transaction.completedAt,
                                    merchantId: transaction.merchantId,
                                    merchantName: transaction.merchantName,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.025),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Top section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Customer avatar
                                    Container(
                                      height: 42,
                                      width: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          transaction.customerName.isNotEmpty
                                              ? transaction.customerName[0]
                                                  .toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Customer details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction.customerName
                                                .toUpperCase(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            transaction.createdAt.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    // Amount
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "₹ ${transaction.amount}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: statusColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(
                                                alpha: 0.10),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            transaction.status,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Divider
                                Divider(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),

                                const SizedBox(height: 12),

                                // Bottom section
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Transaction type",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        transaction.paymentMode.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 20,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Transaction History",
        style: TextStyle(
          color: home1,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// import 'package:collection_qr_flutter/domain/model/e_collect/transaction_report/transaction_ok_report.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/colors.dart';
// import '../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
// import '../../../data/storage/shared_pref_helper.dart';
// import 'ecollect_transaction_detail.dart';
//
// class EcollectTransactionReport extends StatefulWidget {
//   const EcollectTransactionReport({super.key});
//
//   @override
//   State<EcollectTransactionReport> createState() => _EcollectTransactionReportState();
// }
//
// class _EcollectTransactionReportState extends State<EcollectTransactionReport> {
//   String selectedValue = "Today";
//   String merchantID = "";
//   String name = "Select";
//   bool sendIconVisibility = false;
//   TextEditingController searchNameController = TextEditingController();
//   final List<String> filterItems = [
//     "Today",
//     "This Week",
//     "This Month",
//     "Last Month"
//   ];
//
//   Future<void> getSharedData() async {
//     final _merchantID = await SharedPref.shared.getECollectMerchantID();
//     final _name = await SharedPref().getECollectMerchantName();
//
//     if (!mounted) return;
//     setState(() {
//       merchantID = _merchantID;
//       name = _name;
//     });
//     context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(merchantID));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getSharedData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: buildAppBar(),
//       body: Column(
//         children: [
//           // Search + Filter
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: Colors.grey.shade200,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.03),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: searchNameController,
//                       onChanged: (value) {
//                         setState(() {
//                           sendIconVisibility =
//                               searchNameController.text.trim().length > 2;
//                         });
//                       },
//                       textInputAction: TextInputAction.search,
//                       decoration: InputDecoration(
//                         hintText: "Search by name",
//                         hintStyle: TextStyle(
//                           color: Colors.grey.shade500,
//                           fontSize: 13,
//                         ),
//                         prefixIcon: Icon(
//                           Icons.search_rounded,
//                           color: Colors.grey.shade600,
//                           size: 21,
//                         ),
//                         suffixIcon: sendIconVisibility
//                             ? IconButton(
//                           onPressed: () {
//                             // Search action
//                           },
//                           icon: const Icon(
//                             Icons.arrow_forward_rounded,
//                             size: 20,
//                           ),
//                         )
//                             : null,
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 14,
//                           horizontal: 4,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 // Filter Button
//                 Container(
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
//                   child: IconButton(
//                     tooltip: "Filter",
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.tune_rounded,
//                       size: 21,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Transaction List
//           Expanded(
//             child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
//               builder: (
//                   BuildContext context,
//                   TransactionState state,
//                   ) {
//                 if (state is TransactionReportSuccessState) {
//                   var data =
//                       state.transactionSuccessModel.transactionOkReport;
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: ListView.builder(
//                       padding: const EdgeInsets.only(
//                         top: 4,
//                         bottom: 20,
//                       ),
//                       itemCount: data.data.length,
//                       itemBuilder: (
//                           BuildContext context,
//                           int index,
//                           ) {
//                         final transaction = data.data[index];
//
//                         final status =
//                         transaction.status.toLowerCase();
//
//                         final bool isPending =
//                         status.startsWith("pending");
//
//                         final bool isSuccess =
//                         status.startsWith("success");
//
//                         final Color statusColor = isPending
//                             ? Colors.orange
//                             : isSuccess
//                             ? Colors.green
//                             : Colors.red;
//
//                         return InkWell(
//                           borderRadius: BorderRadius.circular(18),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     EcollectTransactionDetail(
//                                       paymentTransaction: PaymentTransaction(
//                                         id: transaction.id,
//                                         orderId: transaction.orderId,
//                                         transactionId:
//                                         transaction.transactionId,
//                                         paymentGatewayTransactionId:
//                                         transaction
//                                             .paymentGatewayTransactionId,
//                                         amount: transaction.amount,
//                                         currency: transaction.currency,
//                                         description: transaction.description,
//                                         customerName:
//                                         transaction.customerName,
//                                         customerEmail:
//                                         transaction.customerEmail,
//                                         customerPhone:
//                                         transaction.customerPhone,
//                                         paymentMode:
//                                         transaction.paymentMode,
//                                         paymentChannel:
//                                         transaction.paymentChannel,
//                                         status: transaction.status,
//                                         responseCode:
//                                         transaction.responseCode,
//                                         responseMessage:
//                                         transaction.responseMessage,
//                                         createdAt: transaction.createdAt,
//                                         completedAt:
//                                         transaction.completedAt,
//                                         merchantId: transaction.merchantId,
//                                         merchantName:
//                                         transaction.merchantName,
//                                       ),
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(bottom: 10),
//                             padding: const EdgeInsets.all(15),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(18),
//                               border: Border.all(
//                                 color: Colors.grey.shade200,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withValues(alpha: 0.025),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 // Top section
//                                 Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     // Customer avatar
//                                     Container(
//                                       height: 42,
//                                       width: 42,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade100,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           transaction.customerName
//                                               .isNotEmpty
//                                               ? transaction.customerName[0]
//                                               .toUpperCase()
//                                               : "?",
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     const SizedBox(width: 12),
//
//                                     // Customer details
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             transaction.customerName
//                                                 .toUpperCase(),
//                                             maxLines: 1,
//                                             overflow:
//                                             TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             transaction.createdAt
//                                                 .toString(),
//                                             maxLines: 1,
//                                             overflow:
//                                             TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: Colors.grey.shade500,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//                                     const SizedBox(width: 10),
//
//                                     // Amount
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           "₹ ${transaction.amount}",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w800,
//                                             fontSize: 16,
//                                             color: statusColor,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Container(
//                                           padding:
//                                           const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 3,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: statusColor
//                                                 .withValues(alpha: 0.10),
//                                             borderRadius:
//                                             BorderRadius.circular(20),
//                                           ),
//                                           child: Text(
//                                             transaction.status,
//                                             style: TextStyle(
//                                               color: statusColor,
//                                               fontWeight:
//                                               FontWeight.w700,
//                                               fontSize: 9,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: 14),
//
//                                 // Divider
//                                 Divider(
//                                   height: 1,
//                                   color: Colors.grey.shade100,
//                                 ),
//
//                                 const SizedBox(height: 12),
//
//                                 // Bottom section
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.account_balance_wallet_outlined,
//                                       size: 16,
//                                       color: Colors.grey.shade500,
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       "Transaction type",
//                                       style: TextStyle(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 11,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 5,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade100,
//                                         borderRadius:
//                                         BorderRadius.circular(8),
//                                       ),
//                                       child: Text(
//                                         transaction.paymentMode
//                                             .toUpperCase(),
//                                         style: const TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Icon(
//                                       Icons.chevron_right_rounded,
//                                       size: 20,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   AppBar buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       centerTitle: true,
//       title: Text(
//         "Transaction History",
//         style: TextStyle(
//           color: home1,
//           fontWeight: FontWeight.w700,
//           fontSize: 24,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
// }
