import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/provider/agent_transaction_provider.dart';
import 'package:collection_qr_flutter/data/provider/balance_provider.dart';
import 'package:collection_qr_flutter/data/provider/collection_summary_provider.dart';
import 'package:collection_qr_flutter/presentation/screens/home/transction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection_qr_flutter/data/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../core/general.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final bool _isCardDetailsVisible = false;
  int test = 0;

  //bool _isCvvVisible = false;
  String? userName;
  String? entityId;
  String? token;
  String? agentOriginId;
  final List<String> bannerImages = [
    "assets/images/collection_splash_screen.jpg",
    "assets/images/collection_splash_screen.jpg",
    "assets/images/doodle.jpeg",
  ];

  // List<Result> result = [];
  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

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
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: deepTeal),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: GoogleFonts.inter(
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

  Future<void> fetchBalance() async {
    final fetchBalanceProvider =
        Provider.of<BalanceProvider>(context, listen: false);
    await fetchBalanceProvider.getchBalance(
        entityId.toString(), token.toString());
  }

  Future<void> fetchTransaction() async {
    final transProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    await transProvider.fetchTransaction(
        "", "", entityId.toString(), token.toString());
    final provider =
        Provider.of<AgentTransactionProvider>(context, listen: false);
    await provider.getTransactions(token.toString());
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Invalid Date";
    return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    printLog("-------------------USERNAME---------------");
    print(name);

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
      });
    }
    fetchBalance();
    fetchTransaction();
    fetchCollection();
  }

  String addCommasToNumber(num number) {
    final formatter = NumberFormat('#,##0.##');
    String formattedNumber = formatter.format(number);

    // Truncate instead of rounding
    if (number is double) {
      formattedNumber = number.toStringAsFixed(2);
      if (formattedNumber.endsWith('.00')) {
        formattedNumber =
            formattedNumber.substring(0, formattedNumber.length - 3);
      } else if (formattedNumber.endsWith('0')) {
        formattedNumber =
            formattedNumber.substring(0, formattedNumber.length - 1);
      }
    }

    return formattedNumber;
  }
  Widget buildShimmerText({String text = "Loading Balance.....", double fontSize = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!, // Darker base color
      highlightColor: Colors.grey[100]!, // Lighter highlight color
      child: Text(
        textAlign: TextAlign.start,
        text,
        style:GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey[300],
        )
      ),
    );
  }

  Widget buildShimmerList(){
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard(
                  image: "assets/images/money_initated.png",
                  title: "Total Initiated",
                  amount: "",
                ),
                _buildSummaryCard(
                  image: "assets/images/salary.png",
                  title: "Total Received",
                  amount: "",
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) =>
                const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: lightGreen.shade200,
                        shape: BoxShape.circle,
                        border: Border.all(color: black),
                      ),
                      child: Image.asset(
                        "assets/images/payment_recived.png",
                        scale: 20,
                        color: black,
                      ),
                    ),
                    title: Text(
                      "Please wait....",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                        "Please wait....",
                      style: GoogleFonts.inter(
                          fontSize: 10, color: grey),
                    ),
                    trailing: Text(
                      "₹....",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

Future<void> fetchCollection() async {
    final provider = Provider.of<CollectionSummaryProvider>(context , listen: false);
   // await provider.getCollectionSummary(agentOriginId.toString(), startDate, endDate, token)
    provider.getCollectionSummary("AGT12345", "2025-03-01", "2025-03-31", token!);
}

  @override
  Widget build(BuildContext context) {
    final fetchBalanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);
    final provider =
        Provider.of<AgentTransactionProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [deepTeal, yellowGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${userName?.replaceFirst(userName![0], userName![0].toUpperCase())}",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  provider.agentPaymentTransctionModel == null
                      ?  buildShimmerText()
                      : Text(
                          "Your Balance: ₹ ${fetchBalanceProvider.balanceModel?.result?.isNotEmpty == true ? addCommasToNumber(fetchBalanceProvider.balanceModel!.result![0].balance!.toDouble()) : ' '}",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// **Agent Card**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.20,
                  // Same height as previous container
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  // Ensure full width
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
                items: bannerImages.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            /// **Transaction History Title**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Transaction History",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// **Transaction History List**
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: provider.agentPaymentTransctionModel == null
                    ?
               // CircularProgressIndicator(color: deepTeal)
                buildShimmerList()
                    :
                Column(
                        children: [
                          Consumer<CollectionSummaryProvider>(
                              builder: (context,provider,child){
                                return  Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSummaryCard(
                                      image: "assets/images/money_initated.png",
                                      title: "Total Initiated",
                                      amount: "Rs. ${provider.collectionSummaryModel?.data?[0].pendingCollections}",
                                    ),
                                    _buildSummaryCard(
                                      image: "assets/images/salary.png",
                                      title: "Total Received",
                                      amount: "Rs. ${provider.collectionSummaryModel?.data?[0].totalCollected}",
                                    ),
                                  ],
                                );
                              }
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: ListView.separated(
                              itemCount: provider
                                  .agentPaymentTransctionModel!.data!.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(thickness: 1),
                              itemBuilder: (context, index) {
                                final transaction = provider
                                    .agentPaymentTransctionModel!.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionHistoryPage(
                                                    agentTransaction: provider
                                                        .agentPaymentTransctionModel!
                                                        .data![index])));
                                  },
                                  child: ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: lightGreen.shade200,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: black),
                                      ),
                                      child: Image.asset(
                                        "assets/images/payment_recived.png",
                                        scale: 20,
                                        color: black,
                                      ),
                                    ),
                                    title: Text(
                                      "Payment Received from ${provider.agentPaymentTransctionModel?.data?[index].customerName ?? "Unknown"}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      formatTimestamp(transaction.createdAt),
                                      style: GoogleFonts.inter(
                                          fontSize: 10, color: grey),
                                    ),
                                    trailing: Text(
                                      "₹ ${transaction.linkAmount}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: green,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required String image, required String title, required String amount}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: deepTeal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: black, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(image,scale: 15,),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              ),
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
