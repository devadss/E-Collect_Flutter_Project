import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../data/storage/shared_pref_helper.dart';

class ECollectHomepage extends StatefulWidget {

  const ECollectHomepage({super.key});

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
  String name = "Today";
  final List<String> filterItems = [
    "Today",
    "This Week",
    "This Month",
    "Last Month"
  ];

  Future<void> refresh() async => context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(merchantID));

  Future<void> getSharedData() async {
    final result =  await Future.wait([
    SharedPref.shared.getECollectMerchantID(),
    SharedPref.shared.getECollectMerchantName(),
    ]);
    merchantID = result[0];
    name = result[1];

    if (!mounted) return;

    context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(merchantID));
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
              transactionDataCard("Total Transaction Amount", "₹ 48000"),
              Row(
                children: [
                  Expanded(
                      child: transactionDataCard("Total Transactions", "1500")),
                  Expanded(child: transactionDataCard("Successful", "1000")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: transactionDataCard("Pending", "10")),
                  Expanded(child: transactionDataCard("Failed", "3")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildAnimatedBannerCarousel(MediaQuery.of(context).size),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 1)
                  ]),
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: BlocBuilder<PaymentTransactionBloc, TransactionState>(
                      builder: (BuildContext context, TransactionState state) {
                        if (state is TransactionReportSuccessState) {
                           transactionData = state.transactionSuccessModel.transactionOkReport.data;
                          if(transactionData.isNotEmpty){
                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 5, top: 10, left: 5),
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

                          }else{
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

  Padding transactionDataCard(String label, String totalTransactionAmount) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: label == "Pending"
                ? Colors.orange.shade50
                : label == "Successful"
                    ? Colors.green.shade50
                    : label == "Failed"
                        ? Colors.red.shade50
                        :
            label == "Total Transactions"?Colors.blue.shade50:
            Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            // label == "Total Transaction Amount"?
            //     SizedBox.shrink():
            CircleAvatar(
              backgroundColor: label == "Total Transactions"
                  ? Colors.blue.shade100
                  : label == "Successful"
                      ? Colors.green.shade100
                      : label == "Pending"
                          ? Colors.orange.shade100
                          : label == "Failed"
                              ? Colors.red.shade100
                              :
              label== "Total Transaction Amount"?
                  Colors.yellow.shade100:
              Colors.white,
              child:
              label == "Total Transactions"?
              Icon(
                Icons.list_alt_rounded,
                color: Colors.blue,
              ):
              label == "Successful"?
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ):
              label == "Pending"?
              Icon(
                Icons.timelapse,
                color: Colors.orange,
              ):
              label == "Total Transaction Amount"?
              Icon(
                Icons.currency_rupee_outlined,
                color: Colors.orange,
              )
                  :label == "Failed"?
              Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
              ):SizedBox.shrink(),
            ),
            SizedBox(width: 5,),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12),),
                  BlocBuilder<PaymentTransactionBloc, TransactionState>(
                    builder: (BuildContext context, TransactionState state) {
                      if (state is TransactionReportSuccessState) {
                        return label == "Total Transaction Amount"
                            ? Text(
                                state.finalTotal.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 17),
                              )
                            : label == "Total Transactions"
                                ? Text(
                          overflow: TextOverflow.ellipsis,
                                    state.transactionSuccessModel
                                        .transactionOkReport.pagination.pageSize
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  )
                                : label == "Pending"
                                    ? Text(
                                        state.pendingCount.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      )
                                    : label == "Successful"
                                        ? Text(
                                            state.successCount.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          )
                                        : Text(
                                            state.failCount.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 17),
                                          );
                      }
                      return Text(
                        "0.0",
                        style:
                            TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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

  Widget _buildAnimatedHeader(BuildContext context, Size size) {
    final formattedName = (name != null && name.isNotEmpty)
        ? name[0].toUpperCase() + name.substring(1)
        : "";
    // SAFE COLOR
    // final headerColor = bannerImagesColorPallet.isNotEmpty &&
    //     index < bannerImagesColorPallet.length
    //     ? bannerImagesColorPallet[index]
    //     : Colors.white; // fallback color
    final headerColor =Colors.white;
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
                      ).animate().fadeIn(duration: 900.ms).slideX(begin: -0.9),

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
}


