import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/data/provider/agent_transaction_provider.dart';
import 'package:collection_qr_flutter/data/provider/balance_provider.dart';
import 'package:collection_qr_flutter/presentation/screens/home/transction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection_qr_flutter/data/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../core/general.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isCardDetailsVisible = false;
  int test = 0;
  bool _isCvvVisible = false;
  String? userName;
  String? entityId;
  String? token;
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

  Future<void> fetchBalance()async{
    final fetchBalanceProvider = Provider.of<BalanceProvider>(context , listen: false);
   await fetchBalanceProvider.getchBalance(entityId.toString(), token.toString());
}


  Future<void> fetchTransaction() async {
    final transProvider = Provider.of<TransactionProvider>(context, listen: false);
     await transProvider.fetchTransaction(
        "", "", entityId.toString(), token.toString());
    final provider =  Provider.of<AgentTransactionProvider>(context , listen: false);
    await provider.getTransactions();

  }
  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Invalid Date";
    return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    printLog("-------------------USERNAME---------------");
    print(name);

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        userName = name;
        entityId = entId;
        token = tok;
      });
    }
    fetchBalance();
     fetchTransaction();
  }
  String addCommasToNumber(num number) {
    final formatter = NumberFormat('#,##0.##');
    String formattedNumber = formatter.format(number);

    // Truncate instead of rounding
    if (number is double) {
      formattedNumber = number.toStringAsFixed(2);
      if (formattedNumber.endsWith('.00')) {
        formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
      } else if (formattedNumber.endsWith('0')) {
        formattedNumber = formattedNumber.substring(0, formattedNumber.length - 1);
      }
    }

    return formattedNumber;
  }
  @override
  Widget build(BuildContext context) {
     final transProvider = Provider.of<TransactionProvider>(context, listen: true);
    final fetchBalanceProvider = Provider.of<BalanceProvider>(context , listen: true);
    final provider = Provider.of<AgentTransactionProvider>(context, listen: true);

    // if (provider.transactions == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }
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
                    "Hello, $userName",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                  const SizedBox(height: 5),
                 // provider.transactions== null?
                  provider.agentPaymentTransctionModel == null?
                      const Center(child: CircularProgressIndicator(color: deepTeal),):
                  Text(
                    "Your Balance: ₹ ${
                        fetchBalanceProvider.balanceModel?.result?.isNotEmpty == true
                      //  provider.agentPaymentTransctionModel?.data?.isNotEmpty == true
                            ? addCommasToNumber(fetchBalanceProvider.balanceModel!.result![0].balance!.toDouble())
                            : ' '
                    }"
                    ,
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
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height *
                      0.25, // Same height as previous container
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1, // Ensure full width
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration:
                  const Duration(milliseconds: 800),
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
                child:
                  //  provider.transactions == null?
                    provider.agentPaymentTransctionModel == null?
                        const Center(child: CircularProgressIndicator(color: deepTeal),):
                Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryCard(
                          icon: Icons.attach_money,
                          title: "Total Initiated",
                          amount: "Rs. 10,000",
                        ),
                        _buildSummaryCard(
                          icon: Icons.account_balance_wallet,
                          title: "Total Received",
                          amount: "Rs. 10,000",
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.separated(
                       // itemCount: provider.transactions!.result!.length,
                        itemCount: provider.agentPaymentTransctionModel!.data!.length,
                        separatorBuilder: (_, __) => const Divider(thickness: 1),
                        itemBuilder: (context, index) {
                          final transaction = provider
                              .agentPaymentTransctionModel!
                              .data![index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              TransactionHistoryPage(agentTransaction: provider.agentPaymentTransctionModel!.data![index])));
                            },
                            child:
                            // ListTile(
                            //   leading: CircleAvatar(
                            //     backgroundColor: green.shade100,
                            //     child:
                            //       Image.asset("assets/images/payment_recived.png", scale: 20,)
                            //     // const Icon(Icons.account_balance_wallet,
                            //     //     color: green),
                            //   ),
                            //   title: Text(
                            //     "Payment Received",
                            //     style: GoogleFonts.inter(
                            //         fontSize: 16, fontWeight: FontWeight.w600),
                            //   ),
                            //   subtitle: Text(
                            //    // formatTimestamp(provider.transactions!.result![index].transaction!.time!.toInt()),
                            //     //formatTimestamp(provider.agentPaymentTransctionModel!.data![index].createdAt.toString()),
                            // //    "March 20, 2025 • 3:30 PM",
                            //       provider.agentPaymentTransctionModel!.data![index].createdAt.toString(),
                            //     style: GoogleFonts.inter(fontSize: 14, color: grey),
                            //   ),
                            //   trailing: Text(
                            //   "₹ ${provider.transactions!.result![index].transaction!.amount.toString()}",
                            //     "₹ ${provider.agentPaymentTransctionModel!.data![index].linkAmount.toString()}",
                            //     style: GoogleFonts.inter(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w800,
                            //       color: green,
                            //     ),
                            //   ),
                            // ),
                            ListTile(
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
                                formatTimestamp(
                                    transaction.createdAt),
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
      {required IconData icon, required String title, required String amount}) {
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
          Icon(icon, color: white, size: 24),
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

/*  void exitAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Color(0xFFEA307B),
                  size: 40.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Are you sure?',
                  style: GoogleFonts.inter(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF404040),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Do you really want to exit Collection Qr ?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF404040).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog first
                        SystemNavigator.pop(); // Exit app

                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        // backgroundColor: const Color(0xFFEA307B),
                        backgroundColor:   deepTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF404040),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        // backgroundColor: const Color(0xFFEDEDED),
                        backgroundColor: deepTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'No',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/