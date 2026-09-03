import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';

class ECollectHomepage extends StatefulWidget {
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
                        BlocBuilder<PaymentTransactionBloc, TransactionState>(
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

/*  Widget transactionDataCard(
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
  }*/

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

  /* Widget _buildAnimatedHeader(BuildContext context, Size size) {
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
  }*/
}

/*
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
              autoPlayInterval: 3.seconds,
              autoPlayAnimationDuration: 1200.ms,
              onPageChanged: (index, reason) {
                setState(() {
                  currentBannerIndex = index;
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
                      color: Colors.black.withValues(alpha: 0.2),
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
                  width: currentBannerIndex == entry.key ? 20 : 8,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: currentBannerIndex == entry.key
                        ? Colors.red
                        : Colors.red.withValues(alpha: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
*/
/*
  Widget _buildAnimatedHeader(BuildContext context, Size size) {

    final headerColor =Colors.white;
    return AnimatedContainer(
      duration: 100.ms,
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
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
                          color: Color(0xFFEA307B),
                          letterSpacing: 0.3,
                        ),
                      ).animate().fadeIn(duration: 100.ms).slideX(begin: -0.9),

                      const SizedBox(height: 4),

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

              ],
            ),

          ],
        ),
      ),
    );
  }
*/
