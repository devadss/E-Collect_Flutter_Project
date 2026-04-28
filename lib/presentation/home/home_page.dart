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
  int todaysCount = 0;
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
  String? _customerRdUrl;
  bool? isBannerAvailable;
  bool _forceLogout = false;
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
      //print("Update check failed: $e");
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
  //  final linkProvider = context.read<LinkTransactionHistoryProvider>();
  // final transferProvider = context.read<TransferHistoryProvider>();

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
                            child:  Text('Today',
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
                            // userType,
                            "ALL",

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
                            //cashCollectionType,
                            "ALL",
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
    final forceLogout = await SharedPref().getForceLogout();
    final customerRdUrl = await SharedPref().getCustomerRdUrl();

    if (mounted) {
      setState(() {
        _forceLogout = forceLogout;
        //print("user type = ${widget.userType}");
        widget.userType == "AGENT_LOAN"
            ? userType = "LOAN_COLLECTION"
            : userType = "COLLECTION";

        widget.userType == "AGENT_LOAN"
            ? cashCollectionType = "LOAN_COLLECTION_CASH"
            : cashCollectionType = "COLLECTION_CASH";

        _customerRdUrl = customerRdUrl;
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
   // final fromDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
    final fromDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 7)));
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
        //"THIS_WEEK",
        "TODAY",
        fromDate,
        toDate,
        // userType!,
        'ALL',
        corpCode!,
        agentOriginId!,

      );

      // Load Link transactions (for AGENT_LOAN)
      if (userType == "LOAN_COLLECTION") {
        await linkProvider.getLinkTransactionHistory(
           // "THIS_WEEK",
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
       // "THIS_WEEK",
        "TODAY",
        fromDate,
        toDate,
        //cashCollectionType!,
        "ALL",
        subAgentID!,
        corpCode!,
        agentOriginId!,
      );

      // Load Transfer transactions (for AGENT_LOAN)
      if (userType == "LOAN_COLLECTION") {
        await transferProvider.getQrTranscationHistory(
         // "THIS_WEEK",
          "TODAY",
          fromDate,
          toDate,
          // userType!,
          "ALL",
          corpCode!,
          agentOriginId!,
        );
      }

      // Load Combined Cash+QR transactions (for regular AGENT)
      if (userType == "COLLECTION") {
        await cashQrProvider.getCombinedResponse(
         // "THIS_WEEK",
          "TODAY",
          toDate,
          fromDate,
          subAgentID!,
          corpCode!,
          agentOriginId!,
        );
      }
      setState(() {
        //print("Total count : ${cashQrProvider.cashQrCombinedResponse?.filteredCount}");
        todaysCount = cashQrProvider.cashQrCombinedResponse?.filteredCount ??0;

      });
      // Final tasks
      fetchTransaction();
      fetchCollection();

    } catch (e) {
      //print("Error loading transaction data: $e");
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
/*  Future<void> performLogout(BuildContext context) async {
    String entityId = await SharedPref.shared.getSubAgentId();
    String token = await SharedPref.shared.getTokenValue();

    final fcmProvider = Provider.of<DeleteFcmProvider>(context, listen: false);
    await fcmProvider.deleteFirebaseToken(entityId, token);

    await SharedPref.shared.setLogin(false);
    await SharedPref.shared.setCustId("");
    await SharedPref.shared.setAgentName("");
    await SharedPref.shared.setParentAgentName("");
    await SharedPref.shared.setParentAgentPassword("");
    await SharedPref.shared.setParentAgentMobNum("");
    await SharedPref.shared.setSubAgentId("");
    await SharedPref.shared.setSubAgentCode("");
    await SharedPref.shared.setUserType("");
    await SharedPref.shared.setRdclCustomerVendorUrl("");
    await SharedPref.shared.setDueListRdclUrl("");
    await SharedPref.shared.setCustomerRdUrl("");
    await SharedPref.shared.setDueListRdUrl("");
    await SharedPref.shared.setCustomerLoanUrl("");
    await SharedPref.shared.setDueListLoanUrl("");
    await SharedPref.shared.setLoanAccountHolderUrl("");
    await SharedPref.shared.setSubAgentName("");
    await SharedPref.shared.setSubAgentMobNum("");
    await SharedPref.shared.setSubAgentCodeNew("");
    await SharedPref.shared.setFcmToken("");
    await SharedPref.shared.setAgentId("");
    await SharedPref.shared.setPassword("");
    await SharedPref.shared.setMpinValue("");
    await SharedPref.shared.setMpinStatus("");
    await SharedPref.shared.setTokenValue("");
    await SharedPref.shared.setMobNum("");
    await SharedPref.shared.setBranchCode("");
    await SharedPref.shared.setAgentOriginId("");
    await SharedPref.shared.setCorpCode("");
    await SharedPref.shared.setCardRefNum("");
    await SharedPref.shared.setEmail("");
    await SharedPref.shared.setLoggedInUserType("");


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
    );
  }*/



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

  }

  Widget _buildAnimatedHeader(BuildContext context, Size size) {
    final formattedName = (userName != null && userName!.isNotEmpty)
        ? userName![0].toUpperCase() + userName!.substring(1)
        : "";

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [home1, home2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER TEXT
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// GREETING SMALL
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// USER NAME
                  Text(
                    "Hi, $formattedName ",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2),

                  const SizedBox(height: 6),

                  /// OPTIONAL SUBTEXT
                  Text(
                    "Here's your collection overview",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),



            /// BANNER / CAROUSEL
            _buildAnimatedBannerCarousel(size),

            const SizedBox(height: 10),
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
      if (!_isFilterApplied) return 'TODAY ';

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
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      child:
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Collection",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  /// TAG
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      // color: home1.withOpacity(0.08),
                      gradient: LinearGradient(
                        colors: [
                          home1.withOpacity(0.15),
                          home1.withOpacity(0.5),
                        ],begin: Alignment.topLeft,
                        end: Alignment.bottomRight,),

                      borderRadius: BorderRadius.circular(20),
                    ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              //const SizedBox(height: 10),

              /// AMOUNT
              Text(
                "₹${calculateTotalAmount().toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: home1,
                  letterSpacing: 0.5,
                ),
              ),

             // const SizedBox(height: 4),

              /// FILTER TEXT
              // Text(
              //   getFilterDisplayText(),
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.grey.shade600,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),

              const SizedBox(height: 8),

              /// COUNT TEXT
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: home1.withAlpha(30)),
                child: Text(
                  "${getFilterDisplayText()} : $todaysCount Nos",
                  style: TextStyle(
                    fontSize: 12,
                    color: home1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

             // const SizedBox(height: 14),

              Divider(color: home1.withAlpha(50)),

              //const SizedBox(height: 10),

              /// BUTTONS
              Row(
                children: [
                  if (_isFilterApplied)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearFilters,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Clear"),
                      ),
                    ),

                  if (_isFilterApplied)
                    const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: showDateRangeFilter,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: home1,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Filter",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
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
        // userType!,
        "ALL",
        corpCode!,
        agentOriginId!,
      );

      await cashTransProvider.getCashTranscationHistory(
        "TODAY",
        formattedFdate,
        formattedTdate,
        // cashCollectionType!,
        "ALL",
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
            //  userType!,
            "ALL",
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
      //print("Error clearing filters: $e");
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
        _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
        //  _buildAnimatedTabItem(3, Icons.account_balance_sharp, "Transfer"),
      ];
    } else {
      // Regular AGENT - Show only 3 tabs
      return [
        _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
        _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
        _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
      ];
    }
  }
  Widget _buildAnimatedTabItem(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _selectedTabIndex = index),
          child: AnimatedContainer(margin: EdgeInsets.all(7),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                gradient:
                isSelected ?LinearGradient(colors: [
                  home1.withOpacity(0.8),
                  home1.withOpacity(0.03),
                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ):LinearGradient(colors: [
                  Colors.transparent,
                  Colors.transparent,
                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              borderRadius: BorderRadius.circular(16),

              /// subtle border for inactive
              border: Border.all(
                color: isSelected
                    ? home1.withAlpha(100)
                    : Colors.grey.withOpacity(0.2),
              ),

              /// soft shadow when selected
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: home1.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
                  : [],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// ICON
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? Colors.white : home1,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 4),

                /// LABEL
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : home1,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
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
      paymentMode:  (t) => t.paymentMode.toString(),
      collectionType:  (t) => t.collectionType.toString(),
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
      getTnxType: (t) => t.source.toString(), paymentMode:(t)=> t.paymentMode.toString(), collectionType: (t)=> cashCollectionType.toString(),
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
        getTnxType: (t) => t.source.toString(), paymentMode: (t)=> t.paymentMode.toString(), collectionType: (t)=> t.collectionType.toString()
    );
  }

  Widget _buildCashWithQrTransactionContent(CashQrProvider cashQrProvider) {
    if (cashQrProvider.errResponse != null || cashQrProvider.cashQrCombinedResponse?.data.isEmpty== true) {
      return _buildEmptyState(
        icon: Icons.all_out,
        title: "No Transactions",
        message: "Your transactions will appear here",
      );
    } else if (cashQrProvider.cashQrCombinedResponse == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: cashQrProvider.cashQrCombinedResponse!.data,

      icon:
      Icons.all_out_rounded,
      iconColor: Colors.blue,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(), paymentMode: (t)=> t.paymentMode, collectionType: (t)=> t.collectionType.toString(),
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
      getTnxType: (t) => t.source.toString(), paymentMode: (t)=> t.paymentMode.toString(), collectionType: (t)=>t.collectionType.toString(),
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
        required String Function(T) getTnxType,
        required String Function(T) paymentMode,
        required String Function(T) collectionType,
      }) {
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
          tnxType: getTnxType(transaction), paymentMode:paymentMode(transaction), collectionType: collectionType(transaction),
        )
            .animate(delay: (100 * index).ms);
      }).toList(),
    );
  }

  Widget _buildAnimatedTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String date,
    required double amount,
    required String status,
    required String transferId,
    required String agentName,
    required String agentPhone,
    required String customerName,
    required String customerId,
    required String customerNumber,
    required String tnxType,
    required String paymentMode,
    required String collectionType,
  }) {
    //print("payment mode : $paymentMode");
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child:

      Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
                  paymentMode: paymentMode,
                  dat: date,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [

                /// ICON
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    paymentMode == "QR"
                        ? Icons.qr_code_rounded
                        : Icons.currency_rupee_rounded,
                    color: iconColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 14),

                /// LEFT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      /// DATE
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// COLLECTION TYPE TAG
                      if (collectionType.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: home1.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            collectionType,
                            style: TextStyle(
                              fontSize: 11,
                              color: home1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// RIGHT CONTENT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    /// AMOUNT
                    Text(
                      "₹${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: home1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// STATUS TAG
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.toLowerCase().contains("success") ||
                            status.toLowerCase().contains("paid") ||
                            status.toLowerCase().contains("completed")
                            ? Colors.green.withOpacity(0.08)
                            : Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status.toLowerCase().contains("success") ||
                              status.toLowerCase().contains("paid") ||
                              status.toLowerCase().contains("completed")
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontSize: 11,
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
      )
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
      //print("_getTransactionTitle ${transaction.customerPhone}");

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

  String _getTransactionDate(dynamic transaction) {
    if (transaction is QrTransaction) {
      return transaction.createdAt.toString().substring(0,16).toString()?? "";
    } else if (transaction is Order) {
      return transaction.createdAt.toString().substring(0,16).toString() ?? "";

    }
    return DateTime.now().toString();
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
            expandedHeight: size.height * 0.375,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildAnimatedHeader(context, size),
            ),
            bottom: PreferredSize(

              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
            padding: const EdgeInsets.only(top: 1, left: 16, right: 16),
            sliver: userType == "COLLECTION"
                ? _buildContentCollectionSection(qrProvider, cashTranProvider, cashQrProvider)
                : _buildContentSection(qrProvider, cashTranProvider, linkProvider,  transferProvider),
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
            total += cashQrProvider.cashQrCombinedResponse!.data.fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
            setState(() {
              todaysCount = cashQrProvider.cashQrCombinedResponse?.filteredCount ??0;

            });
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

