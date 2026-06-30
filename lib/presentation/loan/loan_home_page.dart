import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../data/provider/get_loan_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../domain/model/loan_model.dart';
import 'loan_details_page.dart';

class LoanHomePage extends StatefulWidget {
  const LoanHomePage({super.key});

  @override
  State<LoanHomePage> createState() => _LoanHomePageState();
}

class _LoanHomePageState extends State<LoanHomePage>
    with TickerProviderStateMixin {
  String? agentId;
  String? _corpCode;
  bool isLoading = true;
  List<Datum> filteredLoans = [];
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  final TextEditingController searchController = TextEditingController();


  Future<void> loadSharedPrefs() async {
    final custID = await SharedPref().getSubAgentId();
    final corpCode = await SharedPref().getBranchCode();
    if(printStatementStatus){
      print("corpCode =$corpCode");
    }

    setState(() {
      agentId = custID;
      _corpCode = corpCode;
    });
    LoanRequestModel loanRequestModel = LoanRequestModel(customerName: '', accountNo: '', status: '', scheme: '', agent: agentId, corpCode: _corpCode, page: 1, pageSize: 10);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
      final provider = Provider.of<GetLoanProvider>(context, listen: false);

      provider.getLoans(loanRequestModel).then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
            filteredLoans = provider.collectionLoanModel?.data ?? [];
          });
        }
      });
    });
  }
void animatorMethod(){
  animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInOut,
  ),);
  searchController.addListener(() {_filterLoans(searchController.text);});
}


  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    animatorMethod();
  }

  void _filterLoans(String query) {
    final provider = Provider.of<GetLoanProvider>(context, listen: false);
    final allLoans = provider.collectionLoanModel?.data ?? [];

    if (query.isEmpty) {
      setState(() {
        filteredLoans = allLoans;
      });
      return;
    }

    setState(() {
      filteredLoans = allLoans.where((loan) {
        final name = loan.customerName?.toLowerCase() ?? '';
        final number = loan.loanNumber?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) || number.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final loanProvider = Provider.of<GetLoanProvider>(context);
    // final loans = loanProvider.collectionLoanModel?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Loans",
          style: TextStyle(
            color: home2,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: _buildSearchBar(),
              ),
            ),
          ),


          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Active Loans",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),

          isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: home1)))
              : filteredLoans.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          searchController.text.isEmpty
                              ? "No loans available"
                              : "No results found",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final loan = filteredLoans[index];
                          return _buildLoanItem(loan, index);
                        },
                        childCount: filteredLoans.length,
                      ),
                    )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search loans...',
          prefixIcon: const Icon(Icons.search, color: home1),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: home1),
                  onPressed: () {
                    searchController.clear();
                    _filterLoans('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }



  Widget _buildLoanItem(Datum loan, int index) {
    final statusColor = _getStatusColor(loan.status);
    final formattedAmount =
        '₹${loan.outstandingAmount?.toStringAsFixed(2) ?? '0.00'}';
    final formattedDate = loan.createdAt?.toString().substring(0, 10) ?? 'N/A';

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              var loanSchm = "";
              if (loan.collectionFrequency?.toLowerCase() == "daily") {
                loanSchm = "days";
              } else if (loan.collectionFrequency?.toLowerCase() == "monthly") {
                loanSchm = "months";
              } else if (loan.collectionFrequency?.toLowerCase() == "weekly") {
                loanSchm = "weeks";
              }

              LoanDetailsModel loanModel = LoanDetailsModel(
                customerName: loan.customerName ?? "Name",
                loanNumber: loan.accountNo ?? "Loan Number",
                emiAmount: loan.collectionAmount ?? 0,
                loanTerm: loan.tenorDays ?? 0,
                loanStatus: loan.status ?? "",
                loanAmount: loan.outstandingAmount ?? 0,
                scheme: loan.scheme ?? "",
                paymentDate: loan.lastRepaymentDate.toString(),
                collectionFrequency: loanSchm,
                email: loan.customerEmail ?? "",
                customerPhoneNumber: loan.phoneNumber ?? "",
                custId: loan.loanId.toString(),
                dueDate: loan.lastRepaymentDate.toString(),
                assignedAgent: loan.assignedAgent.toString(),
                createdAt: loan.createdAt.toString(), dueAmount: loan.dueAmount ?? 0,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanDetailsPage(
                    loanDetailsModel: loanModel,
                  ),
                ),
              );
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TOP ROW
                    Row(
                      children: [
                        /// Avatar
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: home1.withValues(alpha:0.15),
                          child: Text(
                            (loan.customerName ?? "C")[0].toUpperCase(),
                            style: TextStyle(
                              color: home1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// Name + scheme
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.customerName ?? 'Customer Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${capitalizeFirstLetter(loan.scheme ?? 'Loan')} Loan',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Status Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha:0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            loan.status ?? 'Unknown',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// AMOUNT (highlight)
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// DETAILS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _modernDetail(
                          icon: Icons.confirmation_number_outlined,
                          label: "Loan #",
                          value: (loan.loanNumber ?? 'N/A')
                              .replaceAll("LOAN-", ""),
                        ),
                        _modernDetail(
                          icon: Icons.calendar_today_outlined,
                          label: "Date",
                          value: formattedDate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
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
        return home1;
    }
  }
}

/*   SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _buildStatsOverview(loans),
            ),
          ),
*/
// SliverAppBar(
//   expandedHeight: 180,
//   floating: false,
//   pinned: true,
//   backgroundColor: home1,
//   flexibleSpace: FlexibleSpaceBar(
//     title: Text(
//       "Loan Portfolio",
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 22,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//     centerTitle: true,
//     background: Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [home1, home2],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//     ),
//   ),
// ),

// int _countLoansByStatus(List<Datum> loans, String status) {
//   return loans
//       .where((loan) => loan.status?.toLowerCase() == status.toLowerCase())
//       .length;
// }

/*  Widget _buildStatsOverview(List<Datum> loans) {
    final activeCount = _countLoansByStatus(loans, "Active");
    final pendingCount = _countLoansByStatus(loans, "Pending");
    final closedCount = _countLoansByStatus(loans, "Closed");
    final totalAmount = loans.fold<double>(
        0, (sum, loan) => sum + (loan.outstandingAmount ?? 0));

    return FadeTransition(
      opacity: fadeAnimation,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("Active", activeCount, Icons.trending_up),
                  _buildStatItem("Pending", pendingCount, Icons.pending),
                  _buildStatItem("Closed", closedCount, Icons.check_circle),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Portfolio",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: home1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }*/
/*  Widget _buildStatItem(String title, int count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: home1.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: home1, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
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
  }*/

// Widget _buildLoanItem(Datum loan, int index) {
//   final statusColor = _getStatusColor(loan.status);
//   final formattedAmount = '₹${loan.outstandingAmount?.toStringAsFixed(2) ?? '0.00'}';
//   final formattedDate = loan.createdAt?.toString().substring(0, 10) ?? 'N/A';
//
//   return FadeTransition(
//     opacity: _fadeAnimation,
//     child: SlideTransition(
//       position: Tween<Offset>(
//         begin: Offset(0, (0.5 + index * 0.1).clamp(0, 0.5)),
//         end: Offset.zero,
//       ).animate(CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOutQuart,
//       )),
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () {
//             var loanSchm = "";
//             if (loan.collectionFrequency?.toLowerCase().toString() ==
//                 "daily") {
//               loanSchm = "days";
//             } else if (loan.collectionFrequency?.toLowerCase().toString() ==
//                 "monthly") {
//               loanSchm = "months";
//             } else if (loan.collectionFrequency?.toLowerCase().toString() ==
//                 "weekly") {
//               loanSchm = "weeks";
//             }
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => LoanDetailsPage(
//                   customerName: loan.customerName ?? "Name",
//                   loanNumber: loan.accountNo ?? "Loan Number",
//                   emiAmount: loan.collectionAmount ?? 0,
//                   loanTerm: loan.tenorDays ?? 0,
//                   loanStatus: loan.status ?? "",
//                   loanAmount: loan.outstandingAmount ?? 0,
//                   scheme: loan.scheme ?? "",
//                   paymentDate: loan.lastRepaymentDate.toString() ?? "",
//                   collectionFrequency: loanSchm,
//                   email: loan.customerEmail ?? "",
//                   customerPhoneNumber: loan.phoneNumber ?? "",
//                   custId: loan.loanId.toString() ?? "",
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           loan.customerName ?? 'Customer Name',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: _textColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: statusColor.withValues(alpha:0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           loan.status ?? 'Unknown',
//                           style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${capitalizeFirstLetter(loan.scheme ?? 'Loan')} Loan',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       _buildLoanDetail("Loan #",
//                           (loan.loanNumber ?? 'N/A').replaceAll("LOAN-", "")),
//                       const Spacer(),
//                       _buildLoanDetail("Date", formattedDate),
//                       const Spacer(),
//                       _buildLoanDetail("Amount", formattedAmount),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

/*  Widget _buildLoanDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ],
    );
  }*/

/* SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      final provider = Provider.of<GetLoanProvider>(context, listen: false);
      provider.getLoans("", "", "", "", agentId, 1, 58).then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _filteredLoans = provider.collectionLoanModel?.data ?? [];
          });
        }
      });
    });*/
