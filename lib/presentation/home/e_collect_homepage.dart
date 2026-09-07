import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';

class ECollectHomepage extends StatefulWidget {
  final String eCollectUserName;
  final String eCollectMerchantID;
  final String eCollectToken;

  const ECollectHomepage({
    super.key,
    required this.eCollectUserName,
    required this.eCollectMerchantID,
    required this.eCollectToken,
  });

  @override
  State<ECollectHomepage> createState() => ECollectHomepageState();
}

class ECollectHomepageState extends State<ECollectHomepage> {
  // ============================================================
  // FINTECH COLORS
  // ============================================================

  static const Color _pageBg = Color(0xFFF5F7FA);
  static const Color _cardBg = Colors.white;
  static const Color _ink = Color(0xFF17202A);
  static const Color _muted = Color(0xFF7A8491);
  static const Color _border = Color(0xFFE5E9EE);

  static const Color _navy = Color(0xFF14213D);
  static const Color _blue = Color(0xFF2563EB);
  static const Color _green = Color(0xFF16A34A);
  static const Color _orange = Color(0xFFF59E0B);
  static const Color _red = Color(0xFFDC2626);

  // ============================================================
  // DATA
  // ============================================================

  final List<Map<String, dynamic>> data = [
    {
      "label": "Successful",
      "value": 35.0,
      "color": _green,
    },
    {
      "label": "Pending",
      "value": 25.0,
      "color": _orange,
    },
    {
      "label": "Failed",
      "value": 20.0,
      "color": _red,
    },
  ];

  List<PaymentTransaction> transactionData = [];

  bool dialogStatus = false;

  // Fallback chart data.
  // Your actual transaction list is used when available.
  final List<FlSpot> spots = const [
    FlSpot(0, 3),
    FlSpot(1, 4.5),
    FlSpot(2, 3.8),
    FlSpot(3, 6),
    FlSpot(4, 5.2),
    FlSpot(5, 7.5),
    FlSpot(6, 6.8),
    FlSpot(7, 8.8),
    FlSpot(8, 15.8),
  ];

  final CarouselSliderController _carouselController =
  CarouselSliderController();

  int currentBannerIndex = 0;

  String merchantID = "";
  String selectedValue = "Today";
  String name = "";
  String formattedName = "";
  String eCollectToken = "";

  final List<String> filterItems = [
    "Today",
    "This Week",
    "This Month",
    "Last Month",
  ];

  final List<String> bannerImages = [
    "assets/images/cq1.webp",
    "assets/images/cq2.webp",
    "assets/images/cq3.webp",
    "assets/images/cq4.webp",
    "assets/images/cq5.webp",
    "assets/images/cq6.webp",
    "assets/images/cq7.webp",
  ];

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();
    getSharedData();
  }

  // ============================================================
  // API / BLOC
  // ============================================================

  void getSharedData() {
    if (!mounted) return;

    setState(() {
      name = widget.eCollectUserName;

      if (name.isNotEmpty) {
        formattedName = name[0].toUpperCase() + name.substring(1).toLowerCase();
      }
    });

    merchantID = widget.eCollectMerchantID;
    eCollectToken = widget.eCollectToken;

    getTransactionReport();
  }

  void getTransactionReport() {
    if (merchantID.isEmpty || eCollectToken.isEmpty) {
      return;
    }

    context.read<PaymentTransactionBloc>().add(
      GetTransactionByMerchant(
        merchantID,
        eCollectToken,
      ),
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning";
    }

    if (hour < 17) {
      return "Good afternoon";
    }

    return "Good evening";
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            getTransactionReport();

            await Future.delayed(
              const Duration(milliseconds: 500),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------

                _buildFintechHeader(context),

                const SizedBox(height: 4),

                // ------------------------------------------------
                // MERCHANT COLLECTION CARD
                // ------------------------------------------------

                _buildCollectionCard(),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // PERIOD FILTER
                // ------------------------------------------------

                _buildPeriodSelector(),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // TRANSACTION SUMMARY
                // ------------------------------------------------

                _buildTransactionSummary(),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // TREND
                // ------------------------------------------------

                _buildCollectionTrend(),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // STATUS BREAKDOWN
                // ------------------------------------------------

                _buildStatusBreakdown(),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // PROMOTIONAL BANNER
                // ------------------------------------------------

                if (bannerImages.isNotEmpty)
                  _buildSmallBanner(size),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FINTECH HEADER
  // ============================================================

  Widget _buildFintechHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: _border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Merchant avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: home1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                formattedName.isNotEmpty
                    ? formattedName[0].toUpperCase()
                    : "M",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Merchant information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formattedName.isEmpty ? "Merchant" : formattedName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    letterSpacing: -0.2,
                  ),
                ),
                if (merchantID.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    "MID: $merchantID",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: _muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Notification
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("No new notifications"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _border,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: _ink,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COLLECTION CARD
  // ============================================================

  Widget _buildCollectionCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
        builder: (context, state) {
          String amount = "₹0.00";
          String transactionCount = "0";

          if (state is TransactionReportSuccessState) {
            amount = NumberFormat.currency(
              locale: 'en_IN',
              symbol: '₹',
              decimalDigits: 2,
            ).format(state.finalTotal);

            transactionCount = state
                .transactionSuccessModel
                .transactionOkReport
                .pagination
                .pageSize
                .toString();
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _navy.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "COLLECTION VALUE",
                        style: TextStyle(
                          color: Color(0xFFB9C3D3),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "LIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.10),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFFAEB9CA),
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      "Transactions",
                      style: TextStyle(
                        color: Color(0xFFAEB9CA),
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      transactionCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PERIOD SELECTOR
  // ============================================================

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            "Overview",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),

          const Spacer(),

          PopupMenuButton<String>(
            initialValue: selectedValue,
            onSelected: (value) {
              setState(() {
                selectedValue = value;
              });

              // If your API supports period filtering,
              // call it here.
              //
              // getTransactionReport();
            },
            offset: const Offset(0, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) {
              return filterItems.map(
                    (item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        if (selectedValue == item)
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: _blue,
                          )
                        else
                          const SizedBox(width: 16),
                        const SizedBox(width: 7),
                        Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: _border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedValue,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                    color: _muted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRANSACTION SUMMARY
  // ============================================================

  Widget _buildTransactionSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
        builder: (context, state) {
          String totalTransactions = "0";
          String successful = "0";
          String pending = "0";
          String failed = "0";

          if (state is TransactionReportSuccessState) {
            totalTransactions = state
                .transactionSuccessModel
                .transactionOkReport
                .pagination
                .pageSize
                .toString();

            successful = state.successCount.toString();
            pending = state.pendingCount.toString();
            failed = state.failCount.toString();
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      title: "TOTAL",
                      value: totalTransactions,
                      icon: Icons.receipt_long_outlined,
                      iconColor: _blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metricCard(
                      title: "SUCCESSFUL",
                      value: successful,
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: _green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      title: "PENDING",
                      value: pending,
                      icon: Icons.schedule_outlined,
                      iconColor: _orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metricCard(
                      title: "FAILED",
                      value: failed,
                      icon: Icons.cancel_outlined,
                      iconColor: _red,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // METRIC CARD
  // ============================================================

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 17,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COLLECTION TREND
  // ============================================================

  Widget _buildCollectionTrend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 15, 10, 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: _border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TRANSACTION TREND",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: _muted,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Collection activity",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.show_chart_rounded,
                  size: 19,
                  color: home1,
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 210,
              child: BlocConsumer<PaymentTransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionReportLoaderState) {
                    if (!dialogStatus) {
                      dialogStatus = true;
                    //  showProgressDialog(context);
                    }
                  }

                  if (state is TransactionReportSuccessState ||
                      state is TransactionReportFailureState) {
                    if (dialogStatus) {
                      dialogStatus = false;

                      if (Navigator.canPop(context)) {
                      //  Navigator.pop(context);
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (state is TransactionReportSuccessState) {
                    transactionData = state
                        .transactionSuccessModel
                        .transactionOkReport
                        .data;

                    if (transactionData.isEmpty) {
                      return _emptyChartCard();
                    }

                    return _buildActualChart();
                  }

                  if (state is TransactionReportFailureState) {
                    return _emptyChartCard(
                      message: "Unable to load transaction data",
                    );
                  }

                  return _emptyChartCard(
                    message: "Loading transaction data...",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTUAL CHART
  // ============================================================

  Widget _buildActualChart() {
    final List<FlSpot> chartSpots = [];

    final int count = transactionData.length > 10
        ? 10
        : transactionData.length;

    for (int i = 0; i < count; i++) {
      chartSpots.add(
        FlSpot(
          i.toDouble(),
          (i + 1).toDouble(),
        ),
      );
    }

    if (chartSpots.isEmpty) {
      return _emptyChartCard();
    }

    double maxY = 0;

    for (final spot in chartSpots) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }

    if (maxY < 5) {
      maxY = 5;
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: chartSpots.length > 1
            ? (chartSpots.length - 1).toDouble()
            : 1,
        minY: 0,
        maxY: maxY + 1,

        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 10 ? 5 : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: _border,
              strokeWidth: 1,
            );
          },
        ),

        borderData: FlBorderData(
          show: false,
        ),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: maxY > 10 ? 5 : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: _muted,
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();

                if (index < 0 || index >= transactionData.length) {
                  return const SizedBox();
                }

                String label = "";

                try {
                  final createdAt =
                  transactionData[index].createdAt.toString();

                  if (createdAt.length >= 10) {
                    label = createdAt.substring(5, 10);
                  } else {
                    label = createdAt;
                  }
                } catch (_) {
                  label = "${index + 1}";
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 8.5,
                      color: _muted,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) {
              return _navy;
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: chartSpots,
            isCurved: true,
            curveSmoothness: 0.25,
            barWidth: 2.5,
            color: home1.withValues(alpha: 0.6),
            isStrokeCapRound: true,

            dotData: const FlDotData(
              show: false,
            ),

            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  home1.withValues(alpha: 0.15),
                  home1.withValues(alpha: 0.01),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY CHART
  // ============================================================

  Widget _emptyChartCard({
    String message = "No transaction data available",
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: _blue,
              size: 20,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BREAKDOWN
  // ============================================================

  Widget _buildStatusBreakdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
        builder: (context, state) {
          int successful = 0;
          int pending = 0;
          int failed = 0;

          if (state is TransactionReportSuccessState) {
            successful = state.successCount;
            pending = state.pendingCount;
            failed = state.failCount;
          }

          final int total = successful + pending + failed;

          double successPercentage = 0;
          double pendingPercentage = 0;
          double failedPercentage = 0;

          if (total > 0) {
            successPercentage = successful / total;
            pendingPercentage = pending / total;
            failedPercentage = failed / total;
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: _border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PAYMENT STATUS",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: _muted,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Transaction health",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 7,
                    child: Row(
                      children: [
                        Expanded(
                          flex: successful > 0 ? successful : 1,
                          child: Container(
                            color: _green,
                          ),
                        ),
                        Expanded(
                          flex: pending > 0 ? pending : 1,
                          child: Container(
                            color: _orange,
                          ),
                        ),
                        Expanded(
                          flex: failed > 0 ? failed : 1,
                          child: Container(
                            color: _red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _statusRow(
                  label: "Successful",
                  count: successful,
                  percentage: successPercentage,
                  color: _green,
                  icon: Icons.check_circle_outline_rounded,
                ),

                const SizedBox(height: 12),

                _statusRow(
                  label: "Pending",
                  count: pending,
                  percentage: pendingPercentage,
                  color: _orange,
                  icon: Icons.schedule_outlined,
                ),

                const SizedBox(height: 12),

                _statusRow(
                  label: "Failed",
                  count: failed,
                  percentage: failedPercentage,
                  color: _red,
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // STATUS ROW
  // ============================================================

  Widget _statusRow({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    final String percentageText =
        "${(percentage * 100).toStringAsFixed(0)}%";

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                percentageText,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SMALL BANNER
  // ============================================================

  Widget _buildSmallBanner(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: bannerImages.length,
            options: CarouselOptions(
              height: size.height * 0.13,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration:
              const Duration(milliseconds: 600),
              autoPlayCurve: Curves.easeOutCubic,
              viewportFraction: 1,
              enlargeCenterPage: false,
              padEnds: false,
              onPageChanged: (index, reason) {
                if (!mounted) return;

                setState(() {
                  currentBannerIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _border,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    bannerImages[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF0F3F6),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: _muted,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerImages.length,
                  (index) {
                final bool isActive =
                    currentBannerIndex == index;

                return AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2.5,
                  ),
                  width: isActive ? 16 : 5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _blue
                        : const Color(0xFFD5DAE0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*class ECollectHomepage extends StatefulWidget {
  final String eCollectUserName;
  final String eCollectMerchantID;
  final String eCollectToken;
  const ECollectHomepage(
      {super.key,
      required this.eCollectUserName,
      required this.eCollectMerchantID,
      required this.eCollectToken});

  @override
  State<ECollectHomepage> createState() => ECollectHomepageState();
}

class ECollectHomepageState extends State<ECollectHomepage> {
  final List<Map<String, dynamic>> data = [
    {"label": "Successful", "value": 35.0, "color": Colors.green},
    {"label": "Pending", "value": 25.0, "color": Colors.orange},
    {"label": "Failed", "value": 20.0, "color": Colors.red},
  ];
  List<PaymentTransaction> transactionData = [];
bool dialogStatus = false;
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
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentBannerIndex = 0;
  String merchantID = "";
  String selectedValue = "Today";
  String name = "";
  String formattedName = "";
  String eCollectToken = "";
  final List<String> filterItems = [
    "Today",
    "This Week",
    "This Month",
    "Last Month"
  ];

  void getSharedData() {
    if (!mounted) return;
    setState(() {
      name = widget.eCollectUserName;
      if (name.isNotEmpty) {
        formattedName = name[0].toUpperCase() + name.substring(1);
      }
    });

    if (!mounted) return;

    merchantID = widget.eCollectMerchantID;
    eCollectToken = widget.eCollectToken;

    getTransactionReport();
  }

  void getTransactionReport() {
    context
        .read<PaymentTransactionBloc>()
        .add(GetTransactionByMerchant(merchantID, eCollectToken));
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedHeader(context, MediaQuery.of(context).size),
              InkWell(
                onTap: () {
                  //_showSuccessMessage("Success");
                },
                child: transactionDataCard(
                  "Total Transaction Amount",
                  "₹ 48,000",
                  icon: Icons.currency_rupee_rounded,
                  accentColor: Colors.indigo,
                  isPrimary: true,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Expanded(
                    child: transactionDataCard(
                      "Total Transactions",
                      "1500",
                      icon: Icons.receipt_long_rounded,
                      accentColor: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: transactionDataCard(
                      "Successful",
                      "1000",
                      icon: Icons.check_rounded,
                      accentColor: Colors.green,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: transactionDataCard(
                      "Pending",
                      "10",
                      icon: Icons.schedule_rounded,
                      accentColor: Colors.orange,
                    ),
                  ),
                  // Expanded(
                  //   child: transactionDataCard(
                  //     "Failed",
                  //     "3",
                  //     icon: Icons.close_rounded,
                  //     accentColor: Colors.red,
                  //   ),
                  // ),
                ],
              ),

              SizedBox(
                height: 10,
              ),
              _buildAnimatedBannerCarousel(MediaQuery.of(context).size),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Transaction Overview",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),

              /// The below is a line graph with dummy data.....////////////

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 1)
                      ]),
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child:
                        BlocConsumer<PaymentTransactionBloc, TransactionState>(
                          builder: (BuildContext context, TransactionState state) {
                            if (state is TransactionReportSuccessState) {
                              transactionData = state
                                  .transactionSuccessModel.transactionOkReport.data;
                              if (transactionData.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5, top: 10, left: 5),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        horizontalInterval: 1.3,
                                        getDrawingHorizontalLine: (value) => FlLine(
                                          color:
                                          Colors.black.withValues(alpha: 0.15),
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
                                            interval: 2,
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              var days = [];
                                              for (var d in transactionData) {
                                                days.add(d.createdAt
                                                    .toString()
                                                    .replaceRange(10, null, ""));
                                              }

                                              final i = value.toInt();
                                              if (i < 0 || i >= 2) {
                                                return const SizedBox();
                                              }
                                              return Center(
                                                child: Text(
                                                    textAlign: TextAlign.center,
                                                    days[i],
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey)),
                                              );
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
                                              style: const TextStyle(
                                                  fontSize: 12, color: Colors.grey),
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
                                            colors: [
                                              Color(0xFF6C5CE7),
                                              Color(0xFFEA307B)
                                            ],
                                          ),
                                          barWidth: 2,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFFEA307B)
                                                    .withValues(alpha: 0.25),
                                                const Color(0xFF8609A8)
                                                    .withValues(alpha: 0.0),
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
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                            return SizedBox.shrink();
                          },
                          listener: (BuildContext context, TransactionState state) {
                            if(state is TransactionReportLoaderState){
                              dialogStatus = true;
                              showProgressDialog(context);
                            }

                            if(state is TransactionReportSuccessState){
                              if(dialogStatus ==true){
                                dialogStatus = false;
                                Navigator.pop(context);
                              }
                            }
                            else if(state is TransactionReportFailureState){
                              if(dialogStatus ==true){
                                dialogStatus = false;
                                Navigator.pop(context);
                              }
                            }else{
                              if(dialogStatus ==true){
                                dialogStatus = false;
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 1,
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
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(d["label"],
                              style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget transactionDataCard(
    String label,
    String value, {
    required IconData icon,
    required Color accentColor,
    bool isPrimary = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: isPrimary ? 15 : 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7E9EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Small status/icon indicator
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 18,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                BlocBuilder<PaymentTransactionBloc, TransactionState>(
                  builder: (context, state) {
                    String displayValue = "0";

                    if (state is TransactionReportSuccessState) {
                      if (label == "Total Transaction Amount") {
                        displayValue = NumberFormat.currency(
                          locale: 'en_IN',
                          symbol: '₹',
                          decimalDigits: 2,
                        ).format(state.finalTotal);
                      } else if (label == "Total Transactions") {
                        displayValue = state.transactionSuccessModel
                            .transactionOkReport.pagination.pageSize
                            .toString();
                      } else if (label == "Successful") {
                        displayValue = state.successCount.toString();
                      } else if (label == "Pending") {
                        displayValue = state.pendingCount.toString();
                      } else if (label == "Failed") {
                        displayValue = state.failCount.toString();
                      }
                    }

                    return Text(
                      displayValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isPrimary ? 20 : 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF20252B),
                        letterSpacing: -0.2,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

*//*  Widget transactionDataCard(
      String label,
      String value, {
        required IconData icon,
        required Color accentColor,
        bool isPrimary = false,
      }) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                BlocBuilder<PaymentTransactionBloc, TransactionState>(
                  builder: (context, state) {
                    String displayValue = "0";

                    if (state is TransactionReportSuccessState) {
                      if (label == "Total Transaction Amount") {
                        displayValue = state.finalTotal.toString();
                      } else if (label == "Total Transactions") {
                        displayValue = state.transactionSuccessModel
                            .transactionOkReport.pagination.pageSize
                            .toString();
                      } else if (label == "Successful") {
                        displayValue = state.successCount.toString();
                      } else if (label == "Pending") {
                        displayValue = state.pendingCount.toString();
                      } else if (label == "Failed") {
                        displayValue = state.failCount.toString();
                      }
                    }

                    return Text(
                      displayValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isPrimary ? 24 : 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade900,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*//*

  final List<String> bannerImages = [
    "assets/images/cq1.webp",
    "assets/images/cq2.webp",
    "assets/images/cq3.webp",
    "assets/images/cq4.webp",
    "assets/images/cq5.webp",
    "assets/images/cq6.webp",
    "assets/images/cq7.webp",
  ];





  Widget _buildAnimatedBannerCarousel(Size size) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: bannerImages.length,
          options: CarouselOptions(
            height: size.height * 0.17,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 700),
            autoPlayCurve: Curves.easeOutCubic,
            viewportFraction: 0.94,
            enlargeCenterPage: false,
            padEnds: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentBannerIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.045),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  bannerImages[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 9),

        // =========================================================
        // PAGE INDICATOR
        // =========================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerImages.length,
            (index) {
              final isActive = currentBannerIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width: isActive ? 18 : 6,
                height: 5,
                decoration: BoxDecoration(
                  color: isActive ? home1 : const Color(0xFFD9DDE2),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  Widget _buildAnimatedHeader(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =====================================================
            // PROFILE
            // =====================================================
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: home1.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: home1,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // =====================================================
            // USER INFORMATION
            // =====================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formattedName.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.25,
                      color: Color(0xFF171A1F),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Manage your collections & accounts",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // =====================================================
            // NOTIFICATION
            // =====================================================
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No notifications"),
                    ),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 22,
                        color: Color(0xFF30363D),
                      ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: home1,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 350),
        )
        .slideY(
          begin: -0.04,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }

  *//* Widget _buildAnimatedHeader(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFFCE7F1),
              ),
              child: Center(
                child:
                Icon(Icons.person, color: home1,)

              ),
            ),

            const SizedBox(width: 13),

            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formattedName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: Color(0xFF171717),
                    ),
                  ),
                ],
              ),
            ),

            // Notification button
            InkWell(
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No notifications")));
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 23,
                      color: Colors.grey.shade800,
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEA307B),
                          shape: BoxShape.circle,
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
    )
        .animate()
        .fadeIn(
      duration: const Duration(milliseconds: 400),
    )
        .slideY(
      begin: -0.08,
      end: 0,
      curve: Curves.easeOutCubic,
    );
  }*//*
}*/


