import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/data/provider/cash_qr_provider.dart';
import 'package:collection_qr_flutter/data/provider/link_transcation_history_provider.dart';
import 'package:collection_qr_flutter/domain/model/all_trans_data.dart';
import 'package:collection_qr_flutter/domain/model/qr_cash_combined_response.dart';
import 'package:collection_qr_flutter/domain/model/transfer_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../core/utils.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/cash_transcation_history_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/qr_transcation_history_provider.dart';
import '../../data/provider/transfer_transaction_provider.dart';
import '../../domain/model/link_transaction_history_model.dart';
import '../../domain/model/qr_transaction_history_model.dart';
import '../trancstion/transction_history_page.dart';

class HomePage extends StatefulWidget {
  final String userType;

  const HomePage({super.key, required this.userType});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int test = 0;
  String? userName;
  String? entityId;
  String? token;
  String? fd;
  String? cashCollectionType;
  String? userType;
  String? corpCode;
  String? agentOriginId;
  String? mobNum;
  String? subAgentID;
  bool? isBannerAvailable;
  int _selectedTabIndex = 0;
  final List<String> bannerImages = [
    "assets/images/collection_splash_screen.jpg",
    "assets/images/collection_splash_screen.jpg",
    "assets/images/doodle.jpeg",
  ];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentBannerIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isFilterApplied = false;
  String _currentFilterPeriod = 'Today'; // Track current filter period
  String _currentFromDate = ''; // Track current from date
  String _currentToDate = ''; // Track current to date

  void checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate(); // or .startFlexibleUpdate()
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    loadSharedPrefs(context);
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

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void showDateRangeFilter() {
    final cashQrProvider = context.read<CashQrProvider>();
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();
    final transferProvider = context.read<TransferHistoryProvider>();

    DateTime? fromDate;
    DateTime? toDate;
    int selectedIndex = 0; // 0=Today,1=This Week,...4=Custom

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, modalSetState) {
              Widget buildDatePickers() {
                String fmt(DateTime d) => DateFormat.yMMMd().format(d);
                return Row(
                  children: [
                    Expanded(
                      child: _DatePickerButton(
                        label: fromDate != null ? fmt(fromDate!) : 'From',
                        icon: Icons.calendar_today_outlined,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fromDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            modalSetState(() => fromDate = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerButton(
                        label: toDate != null ? fmt(toDate!) : 'To',
                        icon: Icons.calendar_today_outlined,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: toDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            modalSetState(() => toDate = picked);
                          }
                        },
                      ),
                    ),
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedIndex == 4
                          ? 'Select Date Range'
                          : 'Select Filter Type',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Filter Options
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        hoverColor: home2,
                        splashColor: home1.withOpacity(0.7),
                        fillColor: home1.withOpacity(0.1),
                        selectedBorderColor: home1,
                        isSelected: List.generate(5, (i) => i == selectedIndex),
                        onPressed: (i) => modalSetState(() {
                          selectedIndex = i;
                          if (i != 4) {
                            fromDate = null;
                            toDate = null;
                          }
                        }),
                        borderRadius: BorderRadius.circular(8),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Today',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('This Week',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('This Month',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Last Month',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Custom',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Show date pickers for custom range
                    if (selectedIndex == 4) buildDatePickers(),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: home1,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () async {
                        //  Navigator.pop(context);

                        // Variables
                        late String period;
                        String from = '', to = '';
                        final now = DateTime.now();

                        switch (selectedIndex) {
                          case 0: // Today
                            period = 'TODAY';
                            from = to = DateFormat('yyyy-MM-dd').format(now);
                            break;
                          case 1: // This Week
                            period = 'THIS_WEEK';
                            final end = now.add(const Duration(days: 7));
                            from = DateFormat('yyyy-MM-dd').format(now);
                            to = DateFormat('yyyy-MM-dd').format(end);
                            break;
                          case 2: // This Month (last 30 days)
                            period = 'THIS_MONTH';
                            from = DateFormat('yyyy-MM-dd')
                                .format(now.subtract(const Duration(days: 30)));
                            to = DateFormat('yyyy-MM-dd').format(now);
                            break;
                          case 3: // Last Month
                            period = 'LAST_MONTH';
                            final firstDayLastMonth =
                                DateTime(now.year, now.month - 1, 1);
                            final lastDayLastMonth =
                                DateTime(now.year, now.month, 1)
                                    .subtract(const Duration(days: 1));
                            from = DateFormat('yyyy-MM-dd')
                                .format(firstDayLastMonth);
                            to = DateFormat('yyyy-MM-dd')
                                .format(lastDayLastMonth);
                            break;
                          case 4: // Custom
                            period = 'CUSTOM';
                            from = DateFormat('yyyy-MM-dd').format(fromDate!);
                            to = DateFormat('yyyy-MM-dd').format(toDate!);
                            break;
                        }
                        showProgressDialog(context);
                        // Call providers
                        await qrProvider.getQrTranscationHistory(
                            period,
                            from,
                            to,
                            userType,
                            //'COLLECTION',
                            corpCode,
                            agentOriginId);
                        // await transferProvider.getQrTranscationHistory(
                        //     period,
                        //     from,
                        //     to,
                        //     userType,
                        //     //'COLLECTION',
                        //     corpCode,
                        //     agentOriginId);

                        await cashTransProvider.getCashTranscationHistory(
                            period,
                            from,
                            to,
                            //'COLLECTION_CASH',
                            cashCollectionType,
                            subAgentID,
                            corpCode,
                            agentOriginId);
                        // await linkProvider.getLinkTransactionHistory(period,
                        //     from, to, subAgentID!, corpCode!, agentOriginId!);
                        await cashQrProvider.getCombinedResponse(period, from,
                            to, subAgentID!, corpCode!, agentOriginId!);

                        await cashTransProvider.getCashTranscationHistory(
                            period,
                            from,
                            to,
                            "ALL",
                            subAgentID!,
                            corpCode,
                            agentOriginId);

                        // ✅ Update parent state
                        setState(() {
                          _isFilterApplied = true;
                          _currentFilterPeriod = period;
                          _currentFromDate = from;
                          _currentToDate = to;
                        });
                        if (qrProvider.showProgressDialog == false) {
                          if (mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        }
                      },
                      child:
                          Text(selectedIndex == 4 ? 'Apply Filter' : 'Apply'),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Future<void> fetchBalance() async {
  //   final fetchBalanceProvider = Provider.of<BalanceProvider>(
  //     context,
  //     listen: false,
  //   );
  //   await fetchBalanceProvider.getFetchBalance(
  //     entityId.toString(),
  //     token.toString(),
  //   );
  // }

  Future<void> fetchTransaction() async {
    if (!mounted) return;
    final provider = Provider.of<AgentTransactionProvider>(
      context,
      listen: false,
    );
    await provider.getTransactions(token.toString());
  }



  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Invalid Date";
    return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
  }

  Future<void> loadSharedPrefs(BuildContext context) async {
    final name = await SharedPref().getSubAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getParentAgentMobNum();
    final subAgID = await SharedPref().getSubAgentId();
    final crpCode = await SharedPref().getCorpCode();

    if (mounted) {
      setState(() {
        print("user type = ${widget.userType}");
        widget.userType == "AGENT_LOAN"
            ? userType = "LOAN_COLLECTION"
            : userType = "COLLECTION";

        widget.userType == "AGENT_LOAN"
            ? cashCollectionType = "LOAN_COLLECTION_CASH"
            : cashCollectionType = "COLLECTION_CASH";

        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
        subAgentID = subAgID;
        corpCode = crpCode;
      });
    }

    final now = DateTime.now();
    final fromDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
    final toDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      // Load data for ALL providers, not just QR transactions
      final qrProvider = Provider.of<QRTransactionHistoryProvider>(context, listen: false);
      final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
      final cashQrProvider = Provider.of<CashQrProvider>(context, listen: false);
      final cashProvider = Provider.of<CashTransactionHistoryProvider>(context, listen: false);
      final transferProvider = Provider.of<TransferHistoryProvider>(context, listen: false);

      // Load QR transactions
      await qrProvider.getQrTranscationHistory(
        "TODAY",
        fromDate,
        toDate,
        userType!,
        corpCode!,
        agentOriginId!,
      );

      // Load Link transactions (for AGENT_LOAN)
      if (userType == "LOAN_COLLECTION") {
        await linkProvider.getLinkTransactionHistory(
            "TODAY",
            fromDate,
            toDate,
            subAgentID!,
            corpCode!,
            agentOriginId!
        );
      }

      // Load Cash transactions
      await cashProvider.getCashTranscationHistory(
        "TODAY",
        fromDate,
        toDate,
        cashCollectionType!,
        subAgentID!,
        corpCode!,
        agentOriginId!,
      );

      // Load Transfer transactions (for AGENT_LOAN)
      if (userType == "LOAN_COLLECTION") {
        await transferProvider.getQrTranscationHistory(
          "TODAY",
          fromDate,
          toDate,
          userType!,
          corpCode!,
          agentOriginId!,
        );
      }

      // Load Combined Cash+QR transactions (for regular AGENT)
      if (userType == "COLLECTION") {
        await cashQrProvider.getCombinedResponse(
          "TODAY",
          fromDate,
          toDate,
          subAgentID!,
          corpCode!,
          agentOriginId!,
        );
      }

      // Final tasks
      fetchTransaction();
      fetchCollection();

    } catch (e) {
      print("Error loading transaction data: $e");
      if (mounted) {
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load transactions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Ensure any loading dialog is dismissed
      if (mounted) {
        // Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }



  Widget _buildShimmerSummaryCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 24, height: 24, color: white),
          const SizedBox(height: 8),
          Container(width: 80, height: 16, color: white),
          const SizedBox(height: 4),
          Container(width: 60, height: 16, color: white),
        ],
      ),
    );
  }

  Future<void> fetchCollection() async {
    if (!mounted) return;
    final provider = Provider.of<CollectionSummaryProvider>(
      context,
      listen: false,
    );
    provider.getCollectionSummary("AGT12345", "$startDate", "$endDate", token!);
    // if(provider.collectionSummaryModel != null){
    //   Navigator.pop(context);
    // }else{
    //   Navigator.pop(context);
    // }
  }

  Widget _buildAnimatedHeader(BuildContext context, Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [home1, home2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Hello,",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     color: white.withOpacity(0.9),
                  //   ),
                  // ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Hi , ${userName?.replaceFirst(
                            userName![0],
                            userName![0].toUpperCase(),
                          )}" ??
                          "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                  ),
                ],
              ),
            ),
            _buildAnimatedBannerCarousel(size),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBannerCarousel(Size size) {
    return SizedBox(
      height: size.height * 0.15,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: size.height * 0.15,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              autoPlayInterval: 2.seconds,
              autoPlayAnimationDuration: 800.ms,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
            ),
            items: bannerImages.map((imagePath) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.fitWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ).animate().scale(
                    begin: const Offset(0.9, 0.9),
                    duration: 500.ms,
                  );
            }).toList(),
          ),
          Positioned(
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: 300.ms,
                  width: _currentBannerIndex == entry.key ? 20 : 8,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _currentBannerIndex == entry.key
                        ? Colors.red
                        : Colors.red.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCollectionCard() {
    // Helper function to format the filter period for display
    String getFilterDisplayText() {
      if (!_isFilterApplied) return 'Today ';

      switch (_currentFilterPeriod) {
        case 'TODAY':
          return 'Today';
        case 'THIS_WEEK':
          return 'This Week';
        case 'THIS_MONTH':
          return 'Last 30 Days';
        case 'LAST_MONTH':
          return 'Last Month';
        case 'CUSTOM':
          return 'Custom ($_currentFromDate to $_currentToDate)';
        default:
          return 'Filtered';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row: Total Collection Label and Transaction Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: const Text(
                      "Total Collection",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: home1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _selectedTabIndex == 0
                            ? userType == "COLLECTION"
                                ? "All"
                                : 'Link'
                            : _selectedTabIndex == 1
                                ? 'QR Code'
                                : _selectedTabIndex == 2
                                    ? 'Cash'
                                    : "Transfer",
                        style: const TextStyle(
                          color: home1,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Second Row: Amount and Filter Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "₹${calculateTotalAmount().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: home1,
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                  ),
                  Text(
                    getFilterDisplayText(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Filter Buttons Row
              Row(
                children: [
                  if (_isFilterApplied)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton.icon(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.clear, size: 18),
                          label: const Text('Clear Filter'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: showDateRangeFilter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: home1,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.filter_alt, size: 18),
                      label: const Text('Filter'),
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

  Future<void> _clearFilters() async {
    showProgressDialog(context);

    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();
    final cashQrProvider = context.read<CashQrProvider>();
    final transferProvider = context.read<TransferHistoryProvider>();

    // Reset to default period
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));
    final toDate = now;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    try {
      // Load data for ALL transaction types
      await qrProvider.getQrTranscationHistory(
        "TODAY",
        formattedFdate,
        formattedTdate,
        userType!,
        corpCode!,
        agentOriginId!,
      );

      await cashTransProvider.getCashTranscationHistory(
        "TODAY",
        formattedFdate,
        formattedTdate,
        cashCollectionType!,
        subAgentID!,
        corpCode!,
        agentOriginId!,
      );

      // Load additional data based on user type
      if (userType == "LOAN_COLLECTION") {
        await transferProvider.getQrTranscationHistory(
            "TODAY",
            formattedFdate,
            formattedTdate,
            userType!,
            corpCode!,
            agentOriginId!
        );

        await linkProvider.getLinkTransactionHistory(
            "TODAY",
            formattedFdate,
            formattedTdate,
            subAgentID!,
            corpCode!,
            agentOriginId!
        );
      } else {
        await cashQrProvider.getCombinedResponse(
            "TODAY",
            formattedFdate,
            formattedTdate,
            subAgentID!,
            corpCode!,
            agentOriginId!
        );
      }

      setState(() {
        _isFilterApplied = false;
        _currentFilterPeriod = 'TODAY';
        _currentFromDate = '';
        _currentToDate = '';
      });

    } catch (e) {
      print("Error clearing filters: $e");
    } finally {
      if (mounted && qrProvider.showProgressDialog == false) {
        Navigator.pop(context);
      }
    }
  }



  Widget _buildTabBar() {
    // Determine the actual user type - use widget.userType directly since it's more reliable
    final isAgentLoan = widget.userType == "AGENT_LOAN";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: home1, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: _buildTabItems(isAgentLoan),
        ),
      ),
    );
  }



  List<Widget> _buildTabItems(bool isAgentLoan) {
    if (isAgentLoan) {
      // AGENT_LOAN - Show all 4 tabs
      return [
        _buildAnimatedTabItem(0, Icons.link_outlined, "Link"),
        _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
        _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
      //  _buildAnimatedTabItem(3, Icons.account_balance_sharp, "Transfer"),
      ];
    } else {
      // Regular AGENT - Show only 3 tabs
      return [
        _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
        _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
        _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
      ];
    }
  }


  Widget _buildAnimatedTabItem(int index, IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: 300.ms,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _selectedTabIndex == index ? home1 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: _selectedTabIndex == index ? white : home1,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: _selectedTabIndex == index ? white : home1,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCollectionSection(
    QRTransactionHistoryProvider qrProvider,
    CashTransactionHistoryProvider cashTranProvider,
    CashQrProvider cashQrProvider,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          switch (_selectedTabIndex) {
            case 0:
              return _buildCashWithQrTransactionContent(cashQrProvider);
            case 1:
              return _buildQRTransactionContent(qrProvider);
            case 2:
              return _buildCashTransactionContent(cashTranProvider);
            default:
              return const SizedBox();
          }
        },
        childCount: 1,
      ),
    );
  }

  Widget _buildContentSection(
    QRTransactionHistoryProvider qrProvider,
    CashTransactionHistoryProvider cashTranProvider,
    LinkTransactionHistoryProvider linkProvider,
    TransferHistoryProvider transferHistoryProvider,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          switch (_selectedTabIndex) {
            case 0:
              return _buildLinkTransactionContent(linkProvider);
            case 1:
              return _buildQRTransactionContent(qrProvider);
            case 2:
              return _buildCashTransactionContent(cashTranProvider);
            case 3:
              return _buildAccTransTransactionContent(transferHistoryProvider);

            default:
              return const SizedBox();
          }
        },
        childCount: 1,
      ),
    );
  }

  Widget _buildQRTransactionContent(QRTransactionHistoryProvider qrProvider) {
    if (qrProvider.errResponse != null) {
      return _buildEmptyState(
        icon: Icons.qr_code,
        title: "No QR Transactions",
        message: "Your QR payment transactions will appear here",
      );
    } else if (qrProvider.qrTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: qrProvider.qrTranscationHistoryModel!.data!,
      icon: Icons.qr_code,
      iconColor: Colors.pink,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
    );
  }

  Widget _buildAccTransTransactionContent(
      TransferHistoryProvider cashProvider) {
    if (cashProvider.errResponse != null) {
      return _buildEmptyState(
        icon: Icons.account_balance_sharp,
        title: "No Account Transactions",
        message: "Your Account payment transactions will appear here",
      );
    } else if (cashProvider.qrTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: cashProvider.qrTranscationHistoryModel!.data!,
      icon: Icons.account_balance,
      iconColor: Colors.orange,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
    );
  }

  Widget _buildCashTransactionContent(
      CashTransactionHistoryProvider cashProvider) {
    if (cashProvider.errResponse != null) {
      return _buildEmptyState(
        icon: Icons.monetization_on_outlined,
        title: "No Cash Transactions",
        message: "Your cash payment transactions will appear here",
      );
    } else if (cashProvider.qrTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: cashProvider.qrTranscationHistoryModel!.data!,
      icon: Icons.monetization_on,
      iconColor: Colors.orange,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
    );
  }

  Widget _buildCashWithQrTransactionContent(CashQrProvider cashQrProvider) {
    if (cashQrProvider.errResponse != null) {
      return _buildEmptyState(
        icon: Icons.link_outlined,
        title: "No Transactions",
        message: "Your transactions will appear here",
      );
    } else if (cashQrProvider.cashQrCombinedResponse == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: cashQrProvider.cashQrCombinedResponse!.data,
      icon: Icons.all_out_rounded,
      iconColor: Colors.blue,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
    );
  }

  Widget _buildLinkTransactionContent(
      LinkTransactionHistoryProvider linkProvider) {
    if (linkProvider.erResposne != null) {
      return _buildEmptyState(
        icon: Icons.link_outlined,
        title: "No Link Transactions",
        message: "Your link transactions will appear here",
      );
    } else if (linkProvider.linkTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: linkProvider.linkTranscationHistoryModel!.data!,
      icon: Icons.link_outlined,
      iconColor: Colors.blue,
      getAmount: (t) => t.linkAmount ?? 0,
      getStatus: (t) => t.linkStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
    );
  }

  Widget _buildTransactionList<T>(
      {required List<T> transactions,
      required IconData icon,
      required Color iconColor,
      required double Function(T) getAmount,
      required String Function(T) getStatus,
      required String Function(T) getOrderId,
      required String Function(T) getCustName,
      required String Function(T) getCustId,
      required String Function(T) getCustPhone,
      required String Function(T) getTnxType}) {
    return Column(
      children: transactions.asMap().entries.map((entry) {
        final index = entry.key;
        final transaction = entry.value;

        return _buildAnimatedTransactionCard(
                icon: icon,
                iconColor: iconColor,
                title: _getTransactionTitle(transaction),
                date: _getTransactionDate(transaction),
                amount: getAmount(transaction),
                status: getStatus(transaction),
                agentPhone: mobNum ?? "agentPhone",
                customerName: getCustName(transaction),
                agentName: userName ?? "agent name",
                customerId: getCustId(transaction),
                transferId: getOrderId(transaction),
                customerNumber: getCustPhone(transaction),
                tnxType: getTnxType(transaction))
            .animate(delay: (100 * index).ms);
      }).toList(),
    );
  }

  Widget _buildAnimatedTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required DateTime date,
    required double amount,
    required String status,
    required String transferId,
    required String agentName,
    required String agentPhone,
    required String customerName,
    required String customerId,
    required String customerNumber,
    required String tnxType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(
                          paymentStatus: status,
                          amount: amount,
                          transferId: transferId,
                          agentName: agentName,
                          agentPhone: agentPhone,
                          customerName: customerName,
                          customerId: customerId,
                          customerNumber: customerNumber,
                          corpCode: corpCode ?? "",
                          tnxType: tnxType,
                          //agentTransaction: agentPaymentTransctionModel
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: home1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.toLowerCase().contains("success") ||
                                status.toLowerCase().contains("paid") ||
                                status.toLowerCase().contains("completed")
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status.toLowerCase().contains("success") ||
                                  status.toLowerCase().contains("paid") ||
                                  status.toLowerCase().contains("completed")
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
  }

  Widget _buildLoadingList() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildShimmerSummaryCard(),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[300],
          ).animate().shake(duration: 600.ms),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to get transaction details
  String _getTransactionTitle(dynamic transaction) {
    //print("_getTransactionTitle $transaction");
    if (transaction is QrTransaction) {
      print("_getTransactionTitle ${transaction.customerPhone}");

      return transaction.customerName.toString();
    }
    if (transaction is AllTransactionHistoryModel) {
      return transaction.customerName.toString();
    } else if (transaction is TransferTransaction) {
      return transaction.customerName.toString();
    } else if (transaction is Order) {
      return transaction.customerName.toString();
    } else if (transaction is LinkTransactions) {
      return transaction.customerName
          .toString()
          .replaceAll("CustomerName.", "");
    }
    return "";
  }

  DateTime _getTransactionDate(dynamic transaction) {
    if (transaction is QrTransaction) {
      return transaction.createdAt ?? DateTime.now();
    } else if (transaction is AllTransactionHistoryModel) {
      //  return  transaction.createdAt ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final qrProvider = Provider.of<QRTransactionHistoryProvider>(context);
    final cashTranProvider = Provider.of<CashTransactionHistoryProvider>(context);
    final cashQrProvider = Provider.of<CashQrProvider>(context);
    final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context);
    final transferProvider = Provider.of<TransferHistoryProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.32,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildAnimatedHeader(context, size),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _buildTabBar(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTotalCollectionCard().animate(
              effects: [
                FadeEffect(duration: 400.ms),
                SlideEffect(
                  begin: const Offset(0, 0.2),
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            sliver: userType == "COLLECTION"
                ? _buildContentCollectionSection(qrProvider, cashTranProvider,
                     cashQrProvider)
                : _buildContentSection(qrProvider, cashTranProvider,
                    linkProvider,  transferProvider),
          ),
        ],
      ),
    );
  }

  double calculateTotalAmount() {
    double total = 0;

    // Calculate based on selected tab
    switch (_selectedTabIndex) {
      case 0: // All Code tab
        final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
        final cashQrProvider = Provider.of<CashQrProvider>(context, listen: false);
        if(userType != "COLLECTION"){
          if (linkProvider.linkTranscationHistoryModel != null) {
            total += linkProvider.linkTranscationHistoryModel!.data!
                .fold(0, (sum, item) => sum + (item.linkAmount ?? 0));
          }
        }else{
          if (cashQrProvider.cashQrCombinedResponse != null) {
            total += cashQrProvider.cashQrCombinedResponse!.data
                .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
          }
        }


        break;

      case 1: // Qr tab
        final qrProvider =
            Provider.of<QRTransactionHistoryProvider>(context, listen: false);
        if (qrProvider.qrTranscationHistoryModel != null) {
          total = qrProvider.qrTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        }
        break;

      case 2: // Cash tab
        // Cash transactions
        final cashProvider =
            Provider.of<CashTransactionHistoryProvider>(context, listen: false);
        if (cashProvider.qrTranscationHistoryModel != null) {
          total = cashProvider.qrTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        }

        break;

      case 3: // Cash tab
        // Cash transactions
        final transferProvider =
            Provider.of<TransferHistoryProvider>(context, listen: false);
        if (transferProvider.qrTranscationHistoryModel != null) {
          total = transferProvider.qrTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        }

        break;
    }

    return total;
  }
}

class _DatePickerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

/*
  void showProgressDialog(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
*/
/*
  Future<void> loadSharedPrefs(BuildContext context) async {
    final name = await SharedPref().getSubAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getParentAgentMobNum();
    final subAgID = await SharedPref().getSubAgentId();
    final crpCode = await SharedPref().getCorpCode();
    // var loggedInUserType = await SharedPref.shared.getLoggedInUserType();

    if (mounted) {
      setState(() {
        print("user type = ${widget.userType}");
        widget.userType == "AGENT_LOAN"
            ? userType = "LOAN_COLLECTION"
            : userType = "COLLECTION";

        widget.userType == "AGENT_LOAN"
            ? cashCollectionType = "LOAN_COLLECTION_CASH"
            : cashCollectionType = "LOAN_COLLECTION";

        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
        subAgentID = subAgID;
        corpCode = crpCode;
      });

      // showProgressDialog(context); // <- Show loading
    }

    final provider =
        Provider.of<QRTransactionHistoryProvider>(context, listen: false);
    final now = DateTime.now();
    final fromDate =
        DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
    final toDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      await provider.getQrTranscationHistory(
        "TODAY",
        fromDate,
        toDate,

        ///  "COLLECTION",
        userType,
        corpCode,
        agentOriginId,
      );

      // showProgressDialog(context);

      final linkProvider =
          Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
      final cashQrProvider =
          Provider.of<CashQrProvider>(context, listen: false);
      final cashProvider =
          Provider.of<CashTransactionHistoryProvider>(context, listen: false);
      final transfer =
          Provider.of<TransferHistoryProvider>(context, listen: false);

      await linkProvider.getLinkTransactionHistory(
          "TODAY", fromDate, toDate, subAgID!, crpCode!, agentOrgID!);
      await cashQrProvider.getCombinedResponse(
          "TODAY", fromDate, toDate, subAgID!, crpCode!, agentOrgID!);
      await cashProvider.getCashTranscationHistory(
          "TODAY",
          fromDate,
          toDate,
          cashCollectionType,
          // "COLLECTION_CASH",
          subAgID,
          crpCode,
          agentOrgID);
      await transfer.getQrTranscationHistory(
          "TODAY",
          fromDate,
          toDate,
          cashCollectionType,
          // "COLLECTION_CASH",

          crpCode,
          agentOrgID);

      // Final tasks
      fetchTransaction();
      fetchCollection();
      //if (provider.showProgressDialog == false) {
      // Navigator.pop(context);
      // }
    } finally {
      //Navigator.pop(context);

      // Always dismiss the dialog, even on error
      // if (mounted) Navigator.pop(context);
    }
  }
*/
// List<Widget> _buildTabItems(bool isAgentLoan) {
//   if (isAgentLoan) {
//     // AGENT_LOAN - Show only 3 tabs: Link, QR, Cash
//     return [
//       _buildAnimatedTabItem(0, Icons.link_outlined, "Link"),
//       _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
//       _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
//     ];
//   } else {
//     // Regular AGENT - Show 3 tabs: All, QR, Cash
//     return [
//       _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
//       _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
//       _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
//     ];
//   }
// }

// Widget _buildQRTransactionList(
//     QrTranscationHistoryModel? qrTransactions, String? error)
// {
//   if (qrTransactions == null && error == "") {
//     return const Center(child: CircularProgressIndicator());
//   } else if (qrTransactions == null && error == "ERROR") {
//     return _buildEmptyState(
//       icon: Icons.qr_code,
//       title: "No QR Transactions",
//       message: "Your payment Qr transactions will appear here",
//     );
//   }
//   return SizedBox(
//     height: MediaQuery.of(context).size.height * 0.8,
//     child: ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: qrTransactions?.data!.length,
//       itemBuilder: (context, index) {
//         final transaction = qrTransactions!.data![index];
//         return _buildQRTransactionItem(transaction);
//       },
//     ),
//   );
// }
//
// Widget _buildCashTransactionList(
//     QrTranscationHistoryModel? qrTransactions, String? error)
// {
//   if (qrTransactions == null && error == "") {
//     return const Center(child: CircularProgressIndicator());
//   } else if (qrTransactions == null && error == "ERROR") {
//     return _buildEmptyState(
//       icon: Icons.monetization_on_outlined,
//       title: "No Cash Transactions",
//       message: "Your payment Cash transactions will appear here",
//     );
//   }
//   return SizedBox(
//     height: MediaQuery.of(context).size.height * 0.8,
//     child: ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: qrTransactions?.data!.length,
//       itemBuilder: (context, index) {
//         final transaction = qrTransactions!.data![index];
//         return _buildQRTransactionItem(transaction);
//       },
//     ),
//   );
// }

// Widget _buildQRTransactionItem(QrTransaction transaction) {
//   return Container(
//     decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: home1, width: 1),
//         boxShadow: [
//           BoxShadow(
//               blurRadius: 10,
//               spreadRadius: 0,
//               offset: const Offset(0, 2),
//               color: Colors.black.withOpacity(0.25))
//         ]),
//     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//     child: ListTile(
//       leading: const Icon(Icons.qr_code, color: Colors.pink),
//       title: Text(
//         // transaction.customerName.toString().replaceAll("CustomerName.", ""),
//         transaction.customerName.toString(),
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         DateFormat('MMM dd, yyyy - hh:mm a')
//             .format(transaction.createdAt ?? DateTime.now()),
//       ),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "₹${transaction.orderAmount}",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.pink,
//             ),
//           ),
//           Text(
//             transaction.orderStatus.toString(),
//             // transaction.orderStatus
//             //   .toString()
//             //   .replaceAll("OrderStatus.", ""),
//             style: const TextStyle(
//               fontSize: 12,
//               color: green,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         // CURRENTLY TRANSACTION DETAIL PAGE IS COMMENTED.......
//         // Navigator.push(context, MaterialPageRoute(builder: (context)=>
//         //  TransactionDetailsPage(
//         //    amountValue: transaction.orderAmount.toString(),
//         //    custName: transaction.customerName,
//         //    orderid: transaction.orderId,
//         //    tranStatus:transaction.orderStatus,
//         //    brCode: transaction.branchCode.toString(),
//         //    corpName: transaction.corpName.toString(),
//         //  )));
//         // Navigate to transaction details
//       },
//     ),
//   );
// }
//
// Widget _buildLinkTransactionItem(LinkTransactions transaction) {
//   return Container(
//     decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: home1, width: 1),
//         boxShadow: [
//           BoxShadow(
//               blurRadius: 10,
//               spreadRadius: 0,
//               offset: const Offset(0, 2),
//               color: Colors.black.withOpacity(0.25))
//         ]),
//     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//     child: ListTile(
//       leading: const Icon(Icons.link, color: Colors.blue),
//       title: Text(
//         transaction.customerName!.toString().replaceAll("CustomerName.", ""),
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         DateFormat('MMM dd, yyyy - hh:mm a')
//             .format(transaction.createdAt ?? DateTime.now()),
//       ),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "₹${transaction.linkAmount}",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.pink,
//             ),
//           ),
//           Text(
//             transaction.linkStatus!.toString().replaceAll("OrderStatus.", ""),
//             style: const TextStyle(
//               fontSize: 12,
//               color: green,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         // Navigate to transaction details
//       },
//     ),
//   );
// }
/*  Future<void> loadSharedPrefs(BuildContext context) async {

    final name = await SharedPref().getSubAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getParentAgentMobNum();
    final subAgID = await SharedPref().getSubAgentId();
    final crpCode = await SharedPref().getCorpCode();

    if (mounted) {
      setState(() {
        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
        subAgentID = subAgID;
        corpCode = crpCode;
      });
      showProgressDialog(context);
    }
    final provider =
    Provider.of<QRTransactionHistoryProvider>(context, listen: false);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // midnight today

    final fromDate = today.subtract(const Duration(days: 30));
    final toDate = today;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    await provider.getQrTranscationHistory(
        "TODAY", formattedFdate, formattedTdate, "COLLECTION", corpCode, agentOriginId);

    if(provider.showProgressDialog == false){
      if(mounted){
        Navigator.pop(context);
      }
    }

    final linkProvider = Provider.of<LinkTransactionHistoryProvider>(
      context,
      listen: false,
    );
    final cashTransProvider = Provider.of<CashTransactionHistoryProvider>(
      context,
      listen: false,
    );
    await linkProvider.getLinkTransactionHistory(
        "TODAY", formattedFdate, formattedTdate, subAgentID!,corpCode!, agentOriginId!);
    await cashTransProvider.getCashTranscationHistory("TODAY", formattedFdate,
        formattedTdate, "COLLECTION_CASH", subAgentID!, corpCode, agentOriginId);

    // fetchBalance();
    fetchTransaction();
    fetchCollection();
    // fetchBannerImages();
  }*/
/* Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: home1, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            userType == "COLLECTION"
                ? _buildAnimatedTabItem(0, Icons.all_out_rounded, "All")
                : _buildAnimatedTabItem(0, Icons.link_outlined, "Link"),
            _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
            _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
            userType == "COLLECTION"
                ? const SizedBox()
                : _buildAnimatedTabItem(
                    3, Icons.account_balance_sharp, "Transfer"),
          ],
        ),
      ),
    );
  }*/
/*
  Future<void> _clearFilters() async {
    showProgressDialog(context);
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();
    final cashQrProvider = context.read<CashQrProvider>();
    final transferProvider = context.read<TransferHistoryProvider>();

    // Reset to default period (THIS_MONTH)
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));
    final toDate = now;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    await qrProvider.getQrTranscationHistory(
        "TODAY",
        formattedFdate,
        formattedTdate,
        //"COLLECTION",
        userType,
        corpCode,
        agentOriginId);

    await cashTransProvider.getCashTranscationHistory(
        "TODAY",
        formattedFdate,
        formattedTdate,
        //  "COLLECTION_CASH",
        cashCollectionType,
        subAgentID!,
        corpCode,
        agentOriginId);
    await transferProvider.getQrTranscationHistory("TODAY", formattedFdate,
        formattedTdate, cashCollectionType, corpCode, agentOriginId);

    await linkProvider.getLinkTransactionHistory("TODAY", formattedFdate,
        formattedTdate, subAgentID!, corpCode!, agentOriginId!);
    await cashQrProvider.getCombinedResponse("TODAY", formattedFdate,
        formattedTdate, subAgentID!, corpCode!, agentOriginId!);
    if (qrProvider.showProgressDialog == false) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
    setState(() {
      _isFilterApplied = false;
      _currentFilterPeriod = 'TODAY';
      _currentFromDate = '';
      _currentToDate = '';
    });
  }
*/