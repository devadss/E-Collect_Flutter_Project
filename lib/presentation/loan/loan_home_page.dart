import 'package:collection_qr_flutter/core/colors.dart';
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Datum> _filteredLoans = [];

  // Modern color scheme
  final Color _backgroundColor = const Color(0xFFF5F6FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2D3436);

  Future<void> loadSharedPrefs() async {
    final custID = await SharedPref().getSubAgentId();
    setState(() {
      agentId = custID;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
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
    });
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

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

    _searchController.addListener(() {
      _filterLoans(_searchController.text);
    });
  }

  void _filterLoans(String query) {
    final provider = Provider.of<GetLoanProvider>(context, listen: false);
    final allLoans = provider.collectionLoanModel?.data ?? [];

    if (query.isEmpty) {
      setState(() {
        _filteredLoans = allLoans;
      });
      return;
    }

    setState(() {
      _filteredLoans = allLoans.where((loan) {
        final name = loan.customerName?.toLowerCase() ?? '';
        final number = loan.loanNumber?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            number.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<GetLoanProvider>(context);
    final loans = loanProvider.collectionLoanModel?.data ?? [];

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
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
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

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSearchBar(),
              ),
            ),
          ),

          /*   SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _buildStatsOverview(loans),
            ),
          ),
*/
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Active Loans",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ),
          ),

          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: home1)))
              : _filteredLoans.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? "No loans available"
                              : "No results found",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final loan = _filteredLoans[index];
                          return _buildLoanItem(loan, index);
                        },
                        childCount: _filteredLoans.length,
                      ),
                    )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search loans...',
          prefixIcon: const Icon(Icons.search, color: home1),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: home1),
                  onPressed: () {
                    _searchController.clear();
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

  Widget _buildStatsOverview(List<Datum> loans) {
    final activeCount = _countLoansByStatus(loans, "Active");
    final pendingCount = _countLoansByStatus(loans, "Pending");
    final closedCount = _countLoansByStatus(loans, "Closed");
    final totalAmount = loans.fold<double>(
        0, (sum, loan) => sum + (loan.outstandingAmount ?? 0));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _cardColor,
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
  }

  Widget _buildStatItem(String title, int count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: home1.withOpacity(0.1),
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
            color: _textColor,
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

  Widget _buildLoanItem(Datum loan, int index) {
    final statusColor = _getStatusColor(loan.status);
    final formattedAmount =
        '₹${loan.outstandingAmount?.toStringAsFixed(2) ?? '0.00'}';
    final formattedDate = loan.createdAt?.toString().substring(0, 10) ?? 'N/A';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, (0.5 + index * 0.1).clamp(0, 0.5)),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutQuart,
        )),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              var loanSchm = "";
              if (loan.collectionFrequency?.toLowerCase().toString() ==
                  "daily") {
                loanSchm = "days";
              } else if (loan.collectionFrequency?.toLowerCase().toString() ==
                  "monthly") {
                loanSchm = "months";
              } else if (loan.collectionFrequency?.toLowerCase().toString() ==
                  "weekly") {
                loanSchm = "weeks";
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanDetailsPage(
                    customerName: loan.customerName ?? "Name",
                    loanNumber: loan.accountNo ?? "Loan Number",
                    emiAmount: loan.collectionAmount ?? 0,
                    loanTerm: loan.tenorDays ?? 0,
                    loanStatus: loan.status ?? "",
                    loanAmount: loan.outstandingAmount ?? 0,
                    scheme: loan.scheme ?? "",
                    paymentDate: loan.lastRepaymentDate.toString() ?? "",
                    collectionFrequency: loanSchm,
                    email: loan.customerEmail ?? "",
                    customerPhoneNumber: loan.phoneNumber ?? "",
                    custId: loan.loanId.toString() ?? "",
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            loan.customerName ?? 'Customer Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
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
                      '${capitalizeFirstLetter(loan.scheme ?? 'Loan')} Loan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildLoanDetail("Loan #",
                            (loan.loanNumber ?? 'N/A').replaceAll("LOAN-", "")),
                        const Spacer(),
                        _buildLoanDetail("Date", formattedDate),
                        const Spacer(),
                        _buildLoanDetail("Amount", formattedAmount),
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

  Widget _buildLoanDetail(String label, String value) {
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
        return home1;
    }
  }
}
