import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/data/provider/link_transcation_history_provider.dart';
import 'package:collection_qr_flutter/domain/model/all_trans_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/cash_transcation_history_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/fetch_account_balance_provider.dart';
import '../../data/provider/qr_transcation_history_provider.dart';
import '../../data/repository/cust_reg_repository.dart';
import '../../domain/model/link_transaction_history_model.dart';
import '../../domain/model/qr_transaction_history_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int test = 0;
  String? userName;
  String? entityId;
  String? token;
  String? fd;
  String? td;
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
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();

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
                          if (picked != null) modalSetState(() => fromDate = picked);
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
                          if (picked != null) modalSetState(() => toDate = picked);
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
                      selectedIndex == 4 ? 'Select Date Range' : 'Select Filter Type',
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
                            child: Text('Today', style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('This Week', style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('This Month', style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Last Month', style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Custom', style: TextStyle(color: Colors.black)),
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
                        Navigator.pop(context);

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
                            from = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
                            to = DateFormat('yyyy-MM-dd').format(now);
                            break;
                          case 3: // Last Month
                            period = 'LAST_MONTH';
                            final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
                            final lastDayLastMonth = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
                            from = DateFormat('yyyy-MM-dd').format(firstDayLastMonth);
                            to = DateFormat('yyyy-MM-dd').format(lastDayLastMonth);
                            break;
                          case 4: // Custom
                            period = 'CUSTOM';
                            from = DateFormat('yyyy-MM-dd').format(fromDate!);
                            to = DateFormat('yyyy-MM-dd').format(toDate!);
                            break;
                        }

                        // Call providers
                        await qrProvider.getQrTranscationHistory(period, from, to, 'COLLECTION', corpCode, agentOriginId);
                        await cashTransProvider.getCashTranscationHistory(period, from, to, 'COLLECTION_CASH', subAgentID, corpCode, agentOriginId);
                        await linkProvider.getLinkTransactionHistory(period, from, to, subAgentID!,corpCode!, agentOriginId!);

                        // ✅ Update parent state
                        setState(() {
                          _isFilterApplied = true;
                          _currentFilterPeriod = period;
                          _currentFromDate = from;
                          _currentToDate = to;
                        });
                      },
                      child: Text(selectedIndex == 4 ? 'Apply Filter' : 'Apply'),
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
  Future<void> fetchBalance() async {
    final fetchBalanceProvider = Provider.of<BalanceProvider>(
      context,
      listen: false,
    );
    await fetchBalanceProvider.getFetchBalance(
      entityId.toString(),
      token.toString(),
    );
  }

  Future<void> fetchTransaction() async {
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
        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
        subAgentID = subAgID;
        corpCode = crpCode;
      });
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
  }

  Future<void> fetchBannerImages() async {
    final images = await CustRegRepository().checkRegCust(int.parse(mobNum!));
    images.fold(
          (error) {
        print("NO BANNER IMAGE IS FOUND");
        isBannerAvailable = false;
      },
          (image) {
        final data = image.response?.images;
        if (data != null) {
          print("BANNER IMAGE IS FOUND");
          bannerImages.add(data.banner1.toString());
          bannerImages.add(data.banner2.toString());
          bannerImages.add(data.banner3.toString());
          bannerImages.add(data.banner4.toString());
          setState(() {
            isBannerAvailable = true;
          });
        }
      },
    );
  }

  String addCommasToNumber(num number) {
    final formatter = NumberFormat('#,##0.##');
    String formattedNumber = formatter.format(number);

    if (number is double) {
      formattedNumber = number.toStringAsFixed(2);
      if (formattedNumber.endsWith('.00')) {
        formattedNumber = formattedNumber.substring(
          0,
          formattedNumber.length - 3,
        );
      } else if (formattedNumber.endsWith('0')) {
        formattedNumber = formattedNumber.substring(
          0,
          formattedNumber.length - 1,
        );
      }
    }

    return formattedNumber;
  }

  Widget buildShimmerText({
    String text = "Loading Balance.....",
    double fontSize = 16,
  }) {
    return Shimmer.fromColors(
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: grey[300],
        ),
      ),
    );
  }

  Widget buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 180, height: 20, color: white),
                Container(width: 24, height: 24, color: white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildShimmerSummaryCard(), _buildShimmerSummaryCard()],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Container(width: 120, height: 16, color: white),
                  subtitle: Container(width: 80, height: 12, color: white),
                  trailing: Container(width: 60, height: 16, color: white),
                );
              },
            ),
          ),
        ],
      ),
    );
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
    final provider = Provider.of<CollectionSummaryProvider>(
      context,
      listen: false,
    );
    provider.getCollectionSummary("AGT12345", "$startDate", "$endDate", token!);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: white.withOpacity(0.9),
                  ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                const SizedBox(height: 4),
                Text(
                  userName?.replaceFirst(
                    userName![0],
                    userName![0].toUpperCase(),
                  ) ??
                      "",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: white,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
              ],
            ),
          ),
          _buildAnimatedBannerCarousel(size),
        ],
      ),
    );
  }

  Widget _buildAnimatedBannerCarousel(Size size) {
    return SizedBox(
      height: size.height * 0.18,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: size.height * 0.18,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: 4.seconds,
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
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
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
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerImages.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: 300.ms,
                  width: _currentBannerIndex == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentBannerIndex == entry.key
                        ? white
                        : white.withOpacity(0.5),
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
                  const Text(
                    "Total Collection",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: home1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedTabIndex == 0 ? 'All Transactions'
                          : _selectedTabIndex == 1 ? 'QR Code'
                          : 'Cash',
                      style: const TextStyle(
                        color: home1,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              // Second Row: Amount and Filter Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${calculateTotalAmount().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: home1,
                    ),
                  ),
                  Text(
                    getFilterDisplayText(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
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


  // Widget _buildTotalCollectionCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     child: Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Total Collection",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "₹${calculateTotalAmount().toStringAsFixed(2)}",
  //                   style: const TextStyle(
  //                     fontSize: 22,
  //                     fontWeight: FontWeight.bold,
  //                     color: home1,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 if (_isFilterApplied)
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 8),
  //                     child: InkWell(
  //                       onTap: _clearFilters,
  //                       borderRadius: BorderRadius.circular(12),
  //                       child: Container(
  //                         padding: const EdgeInsets.all(12),
  //                         decoration: BoxDecoration(
  //                           color: Colors.red.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: const Row(
  //                           children: [
  //                             Icon(Icons.clear, color: Colors.red, size: 20),
  //                             SizedBox(width: 8),
  //                             Text(
  //                               "Clear Filters",
  //                               style: TextStyle(
  //                                 color: Colors.red,
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 InkWell(
  //                   onTap: showDateRangeFilter,
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: home1.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: const Row(
  //                       children: [
  //                         Icon(Icons.filter_alt_rounded, color: home1, size: 20),
  //                         SizedBox(width: 8),
  //                         Text(
  //                           "Filter",
  //                           style: TextStyle(
  //                             color: home1,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> _clearFilters() async {
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();

    // Reset to default period (THIS_MONTH)
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));
    final toDate = now;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    await qrProvider.getQrTranscationHistory(
        "TODAY", formattedFdate, formattedTdate, "COLLECTION", corpCode, agentOriginId);

    await cashTransProvider.getCashTranscationHistory(
        "TODAY", formattedFdate, formattedTdate, "COLLECTION_CASH", subAgentID!, corpCode, agentOriginId);

    await linkProvider.getLinkTransactionHistory(
        "TODAY", formattedFdate, formattedTdate, subAgentID!,corpCode!, agentOriginId!);

    setState(() {
      _isFilterApplied = false;
      _currentFilterPeriod = 'TODAY';
      _currentFromDate = '';
      _currentToDate = '';
    });
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: home1,width: 1),
          borderRadius:  BorderRadius.circular(20),
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
            _buildAnimatedTabItem(0, Icons.select_all_rounded, "All"),
            _buildAnimatedTabItem(1, Icons.qr_code, "QR Code"),
            _buildAnimatedTabItem(2, Icons.monetization_on, "Cash"),
          ],
        ),
      ),
    );
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

  Widget _buildContentSection(
      QRTransactionHistoryProvider qrProvider,
      CashTransactionHistoryProvider cashTranProvider,
      LinkTransactionHistoryProvider linkProvider,
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
    );
  }

  Widget _buildCashTransactionContent(CashTransactionHistoryProvider cashProvider) {
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
      transactions:

      cashProvider.qrTranscationHistoryModel!.data!,
      icon: Icons.monetization_on,
      iconColor: Colors.orange,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
    );
  }



  Widget _buildLinkTransactionContent(LinkTransactionHistoryProvider linkProvider) {
    if (linkProvider.erResposne != null) {
      return _buildEmptyState(
        icon: Icons.select_all_rounded,
        title: "No Transactions",
        message: "Your payment transactions will appear here",
      );
    } else if (linkProvider.linkTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
      transactions: linkProvider.linkTranscationHistoryModel!.data!,
      icon: Icons.select_all_rounded,
      iconColor: Colors.blue,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
    );
  }

  Widget _buildTransactionList<T>({
    required List<T> transactions,
    required IconData icon,
    required Color iconColor,
    required double Function(T) getAmount,
    required String Function(T) getStatus,
  }) {
    return Column(
      children: transactions
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final transaction = entry.value;

        return _buildAnimatedTransactionCard(
          icon: icon,
          iconColor: iconColor,
          title: _getTransactionTitle(transaction),
          date: _getTransactionDate(transaction),
          amount: getAmount(transaction),
          status: getStatus(transaction),
        ).animate(delay: (100 * index).ms);
      })
          .toList(),
    );
  }


  Widget _buildAnimatedTransactionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required DateTime date,
    required double amount,
    required String status,
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
            // Handle transaction tap
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.toLowerCase().contains("success")
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status.toLowerCase().contains("success")
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),
        ],
      ),
    );
  }

  // Helper methods to get transaction details
  String _getTransactionTitle(dynamic transaction) {
    if (transaction is QrTransaction) {
      return transaction.customerName.toString();
    }
    if (transaction is AllQrTransaction) {
      return transaction.customerName .toString();
    }

    else if (transaction is LinkTransactions) {
      return transaction.customerName.toString().replaceAll("CustomerName.", "");
    }
    return "";
  }

  DateTime _getTransactionDate(dynamic transaction) {
    if (transaction is QrTransaction) {
      return transaction.createdAt ?? DateTime.now();
    } else if (transaction is AllQrTransaction) {
      return transaction.createdAt ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final qrProvider = Provider.of<QRTransactionHistoryProvider>(context);
    final cashTranProvider = Provider.of<CashTransactionHistoryProvider>(context);
    final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context);
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
                padding: const EdgeInsets.symmetric(vertical: 5),
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
            sliver: _buildContentSection(qrProvider, cashTranProvider, linkProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildQRTransactionList(
      QrTranscationHistoryModel? qrTransactions, String? error) {
    if (qrTransactions == null && error == "") {
      return const Center(child: CircularProgressIndicator());
    } else if (qrTransactions == null && error == "ERROR") {
      return _buildEmptyState(
        icon: Icons.qr_code,
        title: "No QR Transactions",
        message: "Your payment Qr transactions will appear here",
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: qrTransactions?.data!.length,
        itemBuilder: (context, index) {
          final transaction = qrTransactions!.data![index];
          return _buildQRTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildCashTransactionList(
      QrTranscationHistoryModel? qrTransactions, String? error) {
    if (qrTransactions == null && error == "") {
      return const Center(child: CircularProgressIndicator());
    } else if (qrTransactions == null && error == "ERROR") {
      return _buildEmptyState(
        icon: Icons.monetization_on_outlined,
        title: "No Cash Transactions",
        message: "Your payment Cash transactions will appear here",
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: qrTransactions?.data!.length,
        itemBuilder: (context, index) {
          final transaction = qrTransactions!.data![index];
          return _buildQRTransactionItem(transaction);
        },
      ),
    );
  }



  Widget _buildQRTransactionItem(QrTransaction transaction) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: home1, width: 1),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.25))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.qr_code, color: Colors.pink),
        title: Text(
          // transaction.customerName.toString().replaceAll("CustomerName.", ""),
          transaction.customerName.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a')
              .format(transaction.createdAt ?? DateTime.now()),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${transaction.orderAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text(
              transaction.orderStatus.toString(),
              // transaction.orderStatus
              //   .toString()
              //   .replaceAll("OrderStatus.", ""),
              style: const TextStyle(
                fontSize: 12,
                color: green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // CURRENTLY TRANSACTION DETAIL PAGE IS COMMENTED.......
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>
          //  TransactionDetailsPage(
          //    amountValue: transaction.orderAmount.toString(),
          //    custName: transaction.customerName,
          //    orderid: transaction.orderId,
          //    tranStatus:transaction.orderStatus,
          //    brCode: transaction.branchCode.toString(),
          //    corpName: transaction.corpName.toString(),
          //  )));
          // Navigate to transaction details
        },
      ),
    );
  }

  Widget _buildLinkTransactionItem(LinkTransactions transaction) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: home1, width: 1),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.25))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.link, color: Colors.blue),
        title: Text(
          transaction.customerName!.toString().replaceAll("CustomerName.", ""),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a')
              .format(transaction.createdAt ?? DateTime.now()),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${transaction.linkAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text(
              transaction.linkStatus!.toString().replaceAll("OrderStatus.", ""),
              style: const TextStyle(
                fontSize: 12,
                color: green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to transaction details
        },
      ),
    );
  }

  double calculateTotalAmount() {
    double total = 0;

    // Calculate based on selected tab
    switch (_selectedTabIndex) {
      case 0: // All Code tab
        final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
        if (linkProvider.linkTranscationHistoryModel != null) {
          total += linkProvider.linkTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        }

        break;

      case 1: // Qr tab
        final qrProvider = Provider.of<QRTransactionHistoryProvider>(context, listen: false);
        if (qrProvider.qrTranscationHistoryModel != null) {
          total = qrProvider.qrTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        }
        break;

      case 2: // Cash tab
      // Cash transactions
        final cashProvider = Provider.of<CashTransactionHistoryProvider>(context, listen: false);
        if (cashProvider.qrTranscationHistoryModel != null) {
          total = cashProvider.qrTranscationHistoryModel!.data!
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