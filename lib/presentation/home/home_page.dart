import 'dart:async';
import 'package:collection_qr_flutter/data/provider/cash_qr_provider.dart';
import 'package:collection_qr_flutter/domain/model/all_trans_data.dart';
import 'package:collection_qr_flutter/domain/model/qr_cash_combined_response.dart';
import 'package:collection_qr_flutter/domain/model/transfer_history_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../core/utils.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/cash_transcation_history_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/link_transcation_history_provider.dart';
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
  static const Color whiteColor = Colors.white;
  int todaysCount = 0;
  String? userName;
  String? entityId;
  String? token;
  String? cashCollectionType;
  String? userType;
  String? corpCode;
  String? agentOriginId;
  String? mobNum;
  String? subAgentID;
  String? customerRdUrl;
  bool forceLogout = false;
  int selectedTabIndex = 0;
  bool isFilterApplied = false;
  String currentFilterPeriod = 'Today'; // Track current filter period
  String currentFromDate = ''; // Track current from date
  String currentToDate = ''; // Track current to date
  int currentBannerIndex = 0;
  Color? dominantColor;
  int touchedIndex = -1;
  final List<Map<String, dynamic>> data = [
    {"label": "Food", "value": 35.0, "color": const Color(0xFF6C5CE7)},
    {"label": "Rent", "value": 25.0, "color": const Color(0xFF00CEC9)},
    {"label": "Travel", "value": 20.0, "color": const Color(0xFFFF7675)},
    {"label": "Other", "value": 20.0, "color": const Color(0xFFFDCB6E)},
    {"label": "Other", "value": 20.0, "color": const Color(0xFFFDCB6E)},
  ];
  final spots = [
    const FlSpot(0, 3),
    const FlSpot(1, 4.5),
    const FlSpot(2, 3.8),
    const FlSpot(3, 6),
    const FlSpot(4, 5.2),
    const FlSpot(5, 7.5),
    const FlSpot(6, 6.8),
    const FlSpot(7, 8.8),
    const FlSpot(8, 15.8),
  ];
  // final List<String> bannerImages = [
  //   "assets/images/cq1.webp",
  //   "assets/images/cq2.webp",
  //   "assets/images/cq3.webp",
  //   "assets/images/cq4.webp",
  //   "assets/images/cq5.webp",
  //   "assets/images/cq6.webp",
  //   "assets/images/cq7.webp",
  // ];

  var bannerImagesColorPallet = [];

  // final CarouselSliderController _carouselController =
  //     CarouselSliderController();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  // late AnimationController _animationController;
  // late Animation<double> fadeAnimation;
  // late Animation<double> scaleAnimation;
  int index = 0;


  @override
  void initState() {
    super.initState();
    checkForUpdate();
    loadSharedPrefs(context);


  }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  void showDateRangeFilter() {
    final cashQrProvider = context.read<CashQrProvider>();
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
   // final linkProvider = context.read<LinkTransactionHistoryProvider>();
    //final transferProvider = context.read<TransferHistoryProvider>();

    DateTime? fromDate;
    DateTime? toDate;
    int selectedIndex = 0;
    // 0=Today,1=This Week,...4=Custom

    showModalBottomSheet(
      backgroundColor: whiteColor,
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
                padding: const EdgeInsets.all(5),
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
                        splashColor: home1.withValues(alpha: 0.7),
                        fillColor: home1.withValues(alpha: 0.1),
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
                            child: Text('This\nWeek',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('This\nMonth',
                                style: TextStyle(color: Colors.black)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Last\nMonth',
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

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: home1,
                          foregroundColor: whiteColor,
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
                              from = DateFormat('yyyy-MM-dd').format(
                                  now.subtract(const Duration(days: 30)));
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
                          // await qrProvider.getQrTranscationHistory(
                          //     period,
                          //     from,
                          //     to,
                          //     // userType,
                          //     "ALL",
                          //
                          //     corpCode,
                          //     agentOriginId);
                          // await linkProvider.getLinkTransactionHistory(period,
                          //     from, to, subAgentID!, corpCode!, agentOriginId!);
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
                            isFilterApplied = true;
                            currentFilterPeriod = period;
                            currentFromDate = from;
                            currentToDate = to;
                          });
                          if (qrProvider.showProgressDialog == false ||
                              cashTransProvider.showProgressDialog == false ) {
                            if (mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          }
                        },
                        child:
                            Text(selectedIndex == 4 ? 'Apply Filter' : 'Apply'),
                      ),
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

  Future<void> loadSharedPrefs(BuildContext context) async {
    final name = await SharedPref().getECollectMerchantName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getECollectUserNumber();
    final subAgID = await SharedPref().getSubAgentId();
    final crpCode = await SharedPref().getCorpCode();
    final forceLogout = await SharedPref().getForceLogout();
    final customerRdUrl = await SharedPref().getCustomerRdUrl();
    final subAgentmobnum = await SharedPref.shared.getSubAgentMobNum();

    isRunningLiveBaseUrl(true, subAgentmobnum);
    isRunningLiveDopBaseUrl(true, subAgentmobnum);
print("widget.userType : ${widget.userType}");
    if (mounted) {
      setState(() {
        this.forceLogout = forceLogout;
        widget.userType == "AGENT_LOAN"
            ? userType = "LOAN_COLLECTION"
            : userType = "COLLECTION";

        widget.userType == "AGENT_LOAN"
            ? cashCollectionType = "LOAN_COLLECTION_CASH"
            : cashCollectionType = "COLLECTION_CASH";

        this.customerRdUrl = customerRdUrl;
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
    final fromDate =
        DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 7)));
    final toDate = DateFormat('yyyy-MM-dd').format(now);

    try {

      final cashQrProvider =
          Provider.of<CashQrProvider>(context, listen: false);
      final cashProvider =
          Provider.of<CashTransactionHistoryProvider>(context, listen: false);
      // final linkProvider =
      //     Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
      // Load data for ALL providers, not just QR transactions
      // final qrProvider =
      //     Provider.of<QRTransactionHistoryProvider>(context, listen: false);
      if (printStatementStatus) {
        print("userType : $userType");
      }

      if (userType == "LOAN_COLLECTION") {
        // await linkProvider.getLinkTransactionHistory(
        //     // "THIS_WEEK",
        //     "TODAY",
        //     fromDate,
        //     toDate,
        //     subAgentID!,
        //     corpCode!,
        //     agentOriginId!);
      } else if (userType == "COLLECTION") {
        // await linkProvider.getLinkTransactionHistory(
        //     // "THIS_WEEK",
        //     "TODAY",
        //     fromDate,
        //     toDate,
        //     subAgentID!,
        //     corpCode!,
        //     agentOriginId!);
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
        await cashQrProvider.getCombinedResponse(
          // "THIS_WEEK",
          "TODAY",
          toDate,
          fromDate,
          subAgentID!,
          corpCode!,
          agentOriginId!,
        );
        /*  await transferProvider.getQrTranscationHistory(
         // "THIS_WEEK",
          "TODAY",
          fromDate,
          toDate,
          // userType!,
          "ALL",
          corpCode!,
          agentOriginId!,
        );*/
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
      if (mounted) return;
      setState(() {
        //print("Total count : ${cashQrProvider.cashQrCombinedResponse?.filteredCount}");
        todaysCount = cashQrProvider.cashQrCombinedResponse?.filteredCount ?? 0;
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
      }else{
        return;
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
  }

  Widget _buildAnimatedHeader(BuildContext context, Size size) {
    final formattedName = (userName != null && userName!.isNotEmpty)
        ? userName![0].toUpperCase() + userName!.substring(1)
        : "";
    // SAFE COLOR
    final headerColor = bannerImagesColorPallet.isNotEmpty &&
            index < bannerImagesColorPallet.length
        ? bannerImagesColorPallet[index]
        : Colors.white; // fallback color

    return AnimatedContainer(
      duration: 500.ms,
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: headerColor,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// GREETING SMALL

                      Text(
                        "Welcome back",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// USER NAME

                      Text(
                        "Hi, $formattedName ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.3,
                        ),
                      ).animate().fadeIn(duration: 900.ms).slideX(begin: -0.9),

                      const SizedBox(height: 6),

                      /// OPTIONAL SUBTEXT
                      Text(
                        "Here's your collection overview",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// GREETING SMALL

                      Text(
                        "Total collection",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// USER NAME

                      Text(
                        "₹${calculateTotalAmount().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEA307B),
                          letterSpacing: 0.3,
                        ),
                      ).animate().fadeIn(duration: 900.ms).slideX(begin: -0.9),

                      const SizedBox(height: 6),

                      /// OPTIONAL SUBTEXT
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade100
                      ),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          "${getFilterDisplayText()} : \n$todaysCount Nos",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,

                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(isFilterApplied?"Clear":"Filter"),
                          IconButton(onPressed: (){
                            isFilterApplied?_clearFilters():
                            showDateRangeFilter();
                          }, icon: Icon(
                              isFilterApplied?Icons.filter_alt_outlined:
                              Icons.filter_list)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

            /// BANNER / CAROUSEL
            // _buildAnimatedBannerCarousel(size),

        AspectRatio(
          aspectRatio: 1.8,
          child: Padding(
            padding: const EdgeInsets.only(right: 5, top: 10, left: 5),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1.3,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', "sda"];
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) return const SizedBox();
                        return Text(days[i],
                            style: const TextStyle(fontSize: 10, color: Colors.grey));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFEA307B)],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFEA307B).withValues(alpha: 0.25),
                          const Color(0xFF8609A8).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        Colors.black.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),
        ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: data.map((d) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(

                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: d["color"],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(d["label"], style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  // Widget _buildAnimatedBannerCarousel(Size size) {
  //   return SizedBox(
  //     height: size.height * 0.15,
  //     child: Stack(
  //       alignment: Alignment.bottomCenter,
  //       children: [
  //         CarouselSlider(
  //           carouselController: _carouselController,
  //           options: CarouselOptions(
  //             height: size.height * 0.15,
  //             autoPlay: true,
  //             enlargeCenterPage: true,
  //             viewportFraction: 0.8,
  //             autoPlayInterval: 3.seconds,
  //             autoPlayAnimationDuration: 1200.ms,
  //             onPageChanged: (index, reason) {
  //               setState(() {
  //                 currentBannerIndex = index;
  //               });
  //             },
  //           ),
  //           items: bannerImages.map((imagePath) {
  //             return Container(
  //               margin: const EdgeInsets.symmetric(horizontal: 4),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 image: DecorationImage(
  //                   image: AssetImage(imagePath),
  //                   fit: BoxFit.fitWidth,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withValues(alpha: 0.2),
  //                     blurRadius: 5,
  //                     spreadRadius: 2,
  //                   ),
  //                 ],
  //               ),
  //             ).animate().scale(
  //                   begin: const Offset(0.9, 0.9),
  //                   duration: 500.ms,
  //                 );
  //           }).toList(),
  //         ),
  //         Positioned(
  //           bottom: 5,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: bannerImages.asMap().entries.map((entry) {
  //               return AnimatedContainer(
  //                 duration: 300.ms,
  //                 width: currentBannerIndex == entry.key ? 20 : 8,
  //                 height: 15,
  //                 margin: const EdgeInsets.symmetric(horizontal: 4),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(50),
  //                   color: currentBannerIndex == entry.key
  //                       ? Colors.red
  //                       : Colors.red.withValues(alpha: 0.5),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  String getFilterDisplayText() {
    if (!isFilterApplied) return 'TODAY ';

    switch (currentFilterPeriod) {
      case 'TODAY':
        return 'Today';
      case 'THIS_WEEK':
        return 'This Week';
      case 'THIS_MONTH':
        return 'Last 30 Days';
      case 'LAST_MONTH':
        return 'Last Month';
      case 'CUSTOM':
        return '$currentFromDate -\n$currentToDate)';
      default:
        return 'Filtered';
    }
  }
  Widget _buildTotalCollectionCard() {
    // Helper function to format the filter period for display
    String getFilterDisplayText() {
      if (!isFilterApplied) return 'TODAY ';

      switch (currentFilterPeriod) {
        case 'TODAY':
          return 'Today';
        case 'THIS_WEEK':
          return 'This Week';
        case 'THIS_MONTH':
          return 'Last 30 Days';
        case 'LAST_MONTH':
          return 'Last Month';
        case 'CUSTOM':
          return 'Custom ($currentFromDate to $currentToDate)';
        default:
          return 'Filtered';
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.08),
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
                        // color: home1.withValues(alpha:0.08),
                        gradient: LinearGradient(
                          colors: [
                            home1.withValues(alpha: 0.15),
                            home1.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        selectedTabIndex == 0
                            ? userType == "COLLECTION"
                                ? "All"
                                //: 'Link'
                                : 'All'
                            : selectedTabIndex == 1
                                //? 'QR Code'
                                ? 'Link'
                                : selectedTabIndex == 2
                                    ? 'Cash'
                                    : "Transfer",
                        style: TextStyle(
                          color: whiteColor,
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: home1.withAlpha(30)),
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
                    if (isFilterApplied)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Clear"),
                        ),
                      ),
                    if (isFilterApplied) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: showDateRangeFilter,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: whiteColor,
                          backgroundColor: home1,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
        ));
  }

  Future<void> _clearFilters() async {
    showProgressDialog(context);
    if (printStatementStatus) {
      print("_clearFilters 1");
    }

    //final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final cashQrProvider = context.read<CashQrProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();
    // final transferProvider = context.read<TransferHistoryProvider>();

    // Reset to default period
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));
    final toDate = now;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    try {
      // Load data for ALL transaction types
      // await qrProvider.getQrTranscationHistory(
      //   "TODAY",
      //   formattedFdate,
      //   formattedTdate,
      //   // userType!,
      //   "ALL",
      //   corpCode!,
      //   agentOriginId!,
      // );

      await linkProvider.getLinkTransactionHistory("TODAY", formattedFdate,
          formattedTdate, subAgentID!, corpCode!, agentOriginId!);

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
        await cashQrProvider.getCombinedResponse("TODAY", formattedFdate,
            formattedTdate, subAgentID!, corpCode!, agentOriginId!);
        // await transferProvider.getQrTranscationHistory(
        //     "TODAY",
        //     formattedFdate,
        //     formattedTdate,
        //     //  userType!,
        //     "ALL",
        //     corpCode!,
        //     agentOriginId!
        // );
        //
        // await linkProvider.getLinkTransactionHistory(
        //     "TODAY",
        //     formattedFdate,
        //     formattedTdate,
        //     subAgentID!,
        //     corpCode!,
        //     agentOriginId!
        // );
      } else {
        await cashQrProvider.getCombinedResponse("TODAY", formattedFdate,
            formattedTdate, subAgentID!, corpCode!, agentOriginId!);
      }

      setState(() {
        isFilterApplied = false;
        currentFilterPeriod = 'TODAY';
        currentFromDate = '';
        currentToDate = '';
      });
    } catch (e) {
      //print("Error clearing filters: $e");
    } finally {
      if (printStatementStatus) {
        print("_clearFilters 2");
      }

      if (mounted &&
          cashTransProvider.showProgressDialog == false ||
          linkProvider.showProgressDialog == false) {
        if (printStatementStatus) {
          print("_clearFilters 3");
        }

        Navigator.pop(context);
      } else {
        if (printStatementStatus) {
          print("_clearFilters 4");
        }
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
          color: whiteColor,
          border: Border.all(color: home1, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
        _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
        //_buildAnimatedTabItem(1, Icons.qr_code, "QR"),
        //_buildAnimatedTabItem(1, Icons.link_outlined, "Link"),
        _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
        // _buildAnimatedTabItem(0, Icons.link_outlined, "Link"),
        //  _buildAnimatedTabItem(3, Icons.account_balance_sharp, "Transfer"),
      ];
    } else {
      // Regular AGENT - Show only 3 tabs
      return [
        _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
        // _buildAnimatedTabItem(1, Icons.qr_code, "QR"),
        // _buildAnimatedTabItem(1, Icons.link_outlined, "Link"),
        _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
      ];
    }
  }

  Widget _buildAnimatedTabItem(int index, IconData icon, String label) {
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => selectedTabIndex = index),
          child: AnimatedContainer(
            margin: EdgeInsets.all(7),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        home1.withValues(alpha: 0.8),
                        home1.withValues(alpha: 0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
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
                    : Colors.grey.withValues(alpha: 0.2),
              ),

              /// soft shadow when selected
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: home1.withValues(alpha: 0.25),
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
                    color: isSelected ? whiteColor : home1,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 4),

                /// LABEL
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? whiteColor : home1,
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
    //QRTransactionHistoryProvider qrProvider,
    CashQrProvider cashQrProvider,
    CashTransactionHistoryProvider cashTranProvider,
   // LinkTransactionHistoryProvider linkProvider,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          switch (selectedTabIndex) {
            case 0:
              return _buildCashWithQrTransactionContent(cashQrProvider);
            case 1:
              return _buildCashTransactionContent(cashTranProvider);
             // return _buildLinkTransactionContent(linkProvider);
            // case 2:
            //   return _buildCashTransactionContent(cashTranProvider);
            default:
              return const SizedBox();
          }
        },
        childCount: 1,
      ),
    );
  }

  /* Widget _buildQRTransactionContent(QRTransactionHistoryProvider qrProvider) {
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
      collectionType:  (t) => t.collectionType.toString(), getAccNo:
        (t) => t.customerAccNo.toString(), getTranType:(t) =>t.paymentMode.toString(), getCustAccNo: (t) => t.customerAccNo.toString(),
    );
  }*/

  // Widget _buildLinkTransactionContent(
  //     LinkTransactionHistoryProvider linkProvider)
  // {
  //   if (linkProvider.erResposne != null) {
  //     return _buildEmptyState(
  //       icon: Icons.link,
  //       title: "No Link Transactions",
  //       message: "Your Link payment transactions will appear here",
  //     );
  //   } else if (linkProvider.linkTranscationHistoryModel == null) {
  //     return _buildLoadingList();
  //   }
  //
  //   return _buildTransactionList(
  //     transactions: linkProvider.linkTranscationHistoryModel!.data!,
  //     icon: Icons.link_outlined,
  //     iconColor: Colors.blue,
  //     getAmount: (t) => t.linkAmount ?? 0,
  //     getStatus: (t) => t.linkStatus.toString(),
  //     getOrderId: (t) => t.orderId.toString(),
  //     getCustName: (t) => t.customerName.toString(),
  //     getCustId: (t) => t.customerId.toString(),
  //     getCustPhone: (t) => t.customerPhone.toString(),
  //     getTnxType: (t) => t.source.toString(),
  //     paymentMode: (t) => t.paymentMode.toString(),
  //     collectionType: (t) => t.collectionType.toString(),
  //     getAccNo: (t) => t.customerAcctno.toString(),
  //     getTranType: (t) => t.source.toString(),
  //     getCustAccNo: (t) => t.customerAcctno.toString(),
  //   );
  // }

  Widget _buildCashTransactionContent(
      CashTransactionHistoryProvider cashProvider) {
    if (cashProvider.errResponse != null) {
      return _buildEmptyState(
        icon: Icons.currency_rupee_rounded,
        title: "No Cash Transactions",
        message: "Your cash payment transactions will appear here",
      );
    } else if (cashProvider.qrTranscationHistoryModel == null) {
      return _buildLoadingList();
    }
    return _buildTransactionList(
        transactions: cashProvider.qrTranscationHistoryModel!.data!,
        icon: Icons.dangerous_outlined,
        iconColor: Colors.orange,
        getAmount: (t) => t.orderAmount ?? 0,
        getStatus: (t) => t.orderStatus.toString(),
        getOrderId: (t) => t.orderId.toString(),
        getCustName: (t) => t.customerName.toString(),
        getCustId: (t) => t.customerId.toString(),
        getCustPhone: (t) => t.customerPhone.toString(),
        getTnxType: (t) => t.source.toString(),
        paymentMode: (t) => t.paymentMode.toString(),
        collectionType: (t) => t.collectionType.toString(),
        getAccNo: (t) => t.customerAccNo.toString(),
        getTranType: (t) => t.source.toString(),
        getCustAccNo: (t) => t.customerAccNo.toString());
  }

  Widget _buildCashWithQrTransactionContent(CashQrProvider cashQrProvider) {
    if (cashQrProvider.errResponse != null ||
        cashQrProvider.cashQrCombinedResponse?.data.isEmpty == true) {
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
      icon: Icons.all_out_rounded,
      iconColor: Colors.blue,
      getAmount: (t) => t.orderAmount ?? 0,
      getStatus: (t) => t.orderStatus.toString(),
      getOrderId: (t) => t.orderId.toString(),
      getCustName: (t) => t.customerName.toString(),
      getCustId: (t) => t.customerId.toString(),
      getCustPhone: (t) => t.customerPhone.toString(),
      getTnxType: (t) => t.source.toString(),
      paymentMode: (t) => t.paymentMode,
      collectionType: (t) => t.collectionType.toString(),
      getAccNo: (t) => t.customerAccNo.toString(),
      getTranType: (t) => t.source.toString(),
      getCustAccNo: (t) => t.customerAccNo.toString(),
    );
  }

  Widget _buildTransactionList<T>({
    required List<T> transactions,
    required IconData icon,
    required Color iconColor,
    required double Function(T) getAmount,
    required String Function(T) getStatus,
    required String Function(T) getAccNo,
    required String Function(T) getTranType,
    required String Function(T) getOrderId,
    required String Function(T) getCustName,
    required String Function(T) getCustAccNo,
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
          tnxType: getTnxType(transaction),
          paymentMode: paymentMode(transaction),
          collectionType: collectionType(transaction),
          accountNumber: getCustAccNo(transaction),
          transactionType: paymentMode(transaction),
        ).animate(delay: (100 * index).ms);
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
    required String accountNumber,
    required String transactionType,
    required String agentPhone,
    required String customerName,
    required String customerId,
    required String customerNumber,
    required String tnxType,
    required String paymentMode,
    required String collectionType,
  }) {
    // print("payment mode : $paymentMode");
    // print("collectionType : $collectionType");
    //print("status : $status");
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              var transModel = TransactionHistoryModel(
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
                accountNumber: accountNumber,
                transactionType: transactionType,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistoryPage(
                    transactionHistoryModel: transModel,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  /// ICON
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      paymentMode == "PAYMENTLINK"
                          ? Icons.link
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
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
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
                            fontSize: 8,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// COLLECTION TYPE TAG
                        if (collectionType.isNotEmpty &&
                            !collectionType.contains("null"))
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              color: home1.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              collectionType,
                              style: TextStyle(
                                fontSize: 10,
                                color: home1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// AMOUNT
                      Text(
                        "₹${amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: home1,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status.toLowerCase().contains("success") ||
                                  status.toLowerCase().contains("paid") ||
                                  status.toLowerCase().contains("completed")
                              ? Colors.green.withValues(alpha: 0.08)
                              : Colors.orange.withValues(alpha: 0.08),
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
        ));
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
    if (transaction is QrTransaction) {
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
      return transaction.createdAt.toString().substring(0, 16).toString() ?? "";
    } else if (transaction is Order) {
      return transaction.createdAt.toString().substring(0, 16).toString() ?? "";
    } else if (transaction is LinkTransactions) {
      return transaction.createdAt.toString().substring(0, 16).toString() ?? "";
    }

    return transaction.createdAt.toString().substring(0, 10).toString() ?? "";
    //return DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    final cashTranProvider = Provider.of<CashTransactionHistoryProvider>(context);
    final cashQrProvider = Provider.of<CashQrProvider>(context);
  //  final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context);
    //final transferProvider = Provider.of<TransferHistoryProvider>(context);
    //_buildLoadingList
    // final qrProvider = Provider.of<QRTransactionHistoryProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.550,
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
          // SliverToBoxAdapter(
          //   child: _buildTotalCollectionCard().animate(
          //     effects: [
          //       FadeEffect(duration: 400.ms),
          //       SlideEffect(
          //         begin: const Offset(0, 0.2),
          //         duration: 500.ms,
          //         curve: Curves.easeOutCubic,
          //       ),
          //     ],
          //   ),
          // ),
          SliverPadding(
              padding: const EdgeInsets.only(top: 1, left: 16, right: 16),
              sliver: userType == "COLLECTION"
                  // ? _buildContentCollectionSection(qrProvider, cashTranProvider, cashQrProvider)
                  ? _buildContentCollectionSection(
                     // cashQrProvider, cashTranProvider, linkProvider)
                      cashQrProvider, cashTranProvider)
                  : _buildContentCollectionSection(
                     // cashQrProvider, cashTranProvider, linkProvider)),
                      cashQrProvider, cashTranProvider)),
        ],
      ),
    );
  }

  double calculateTotalAmount() {
    double total = 0;

    // Calculate based on selected tab
    switch (selectedTabIndex) {
      case 0: // All Code tab
        final linkProvider =
            Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
        final cashQrProvider =
            Provider.of<CashQrProvider>(context, listen: false);
        if (userType != "COLLECTION") {
          if (cashQrProvider.cashQrCombinedResponse != null) {
            total += cashQrProvider.cashQrCombinedResponse!.data
                .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
            setState(() {
              todaysCount =
                  cashQrProvider.cashQrCombinedResponse?.filteredCount ?? 0;
            });
          }
          // if (linkProvider.linkTranscationHistoryModel != null) {
          //   total += linkProvider.linkTranscationHistoryModel!.data!
          //       .fold(0, (sum, item) => sum + (item.linkAmount ?? 0));
          // }
        } else {
          if (cashQrProvider.cashQrCombinedResponse != null) {
            total += cashQrProvider.cashQrCombinedResponse!.data
                .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
            setState(() {
              todaysCount =
                  cashQrProvider.cashQrCombinedResponse?.filteredCount ?? 0;
            });
          }
        }

        break;

      case 1: // Qr tab
        // final qrProvider =
        // Provider.of<QRTransactionHistoryProvider>(context, listen: false);
        // if (qrProvider.qrTranscationHistoryModel != null) {
        //   total = qrProvider.qrTranscationHistoryModel!.data!
        //       .fold(0, (sum, item) => sum + (item.orderAmount ?? 0));
        final linkProvider =
            Provider.of<LinkTransactionHistoryProvider>(context, listen: false);
        if (linkProvider.linkTranscationHistoryModel != null) {
          total = linkProvider.linkTranscationHistoryModel!.data!
              .fold(0, (sum, item) => sum + (item.linkAmount ?? 0));
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

//final transferProvider = Provider.of<TransferHistoryProvider>(context, listen: false);

// Load QR transactions
// await qrProvider.getQrTranscationHistory(
//   //"THIS_WEEK",
//   "TODAY",
//   fromDate,
//   toDate,
//   // userType!,
//   'ALL',
//   corpCode!,
//   agentOriginId!,
//
// );

// Load Link transactions (for AGENT_LOAN)
