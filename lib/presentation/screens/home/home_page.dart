import 'package:collection_qr_flutter/data/provider/agent_transaction_provider.dart';
import 'package:collection_qr_flutter/presentation/screens/home/transction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection_qr_flutter/data/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../../core/shared_pref_helper.dart';
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
                      const CircularProgressIndicator(),
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

  void exitAlertDialog(BuildContext context) {
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
  }


  Future<void> fetchTransaction() async {
    final transProvider = Provider.of<TransactionProvider>(context, listen: false);
     await transProvider.fetchTransaction(
        "", "", entityId.toString(), token.toString());
    final provider =  Provider.of<AgentTransactionProvider>(context , listen: false);
    await provider.getTransactions();

  }
  @override

  String formatTimestamp(int timestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format).format(dateTime);
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getUserName();
    final entId = await SharedPref().getCustId();
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
                      const Center(child: CircularProgressIndicator(),):
                  Text(
                    "Your Balance: ₹ ${
                        transProvider.transactions?.result?.isNotEmpty == true
                      //  provider.agentPaymentTransctionModel?.data?.isNotEmpty == true
                            ? addCommasToNumber(transProvider.transactions!.result![0].transaction!.balance!.toDouble())
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
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Image.asset("assets/images/card_agent.png"),
                    if (_isCardDetailsVisible) ...[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Row(
                          children: [
                            Text(
                              test == 2 // Check if test == 2 to mask all values
                                  ? '•••• •••• •••• ••••'
                                  : (_isCvvVisible
                                      ? '•••• •••• •••• ••••'
                                      : "123456789012"),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (test != 2 &&
                                !_isCvvVisible) // Allow copying only if test != 2
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(const ClipboardData(
                                      text: "123456789012"));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Card number copied to clipboard!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.copy_all_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.14,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Text(
                          test == 2
                              ? "Expiry ••/••"
                              : (_isCvvVisible
                                  ? "Expiry ••/••"
                                  : "Expiry 07/29"),
                          style: GoogleFonts.inter(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.14,
                        right: MediaQuery.of(context).size.width * 0.20,
                        child: Text(
                          test == 2
                              ? "CVV •••"
                              : "CVV ${_isCvvVisible ? "321" : '•••'}",
                          style: GoogleFonts.inter(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.08,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Text(
                          test == 2
                              ? '•••• ••••'
                              : (_isCvvVisible ? '•••• ••••' : "John Doe"),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ] else ...[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Row(
                          children: [
                            Text(
                              '•••• •••• •••• ••••',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.14,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Text(
                          "Expiry ••/••",
                          style: GoogleFonts.inter(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.14,
                        right: MediaQuery.of(context).size.width * 0.20,
                        child: Text(
                          "CVV •••",
                          style: GoogleFonts.inter(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.08,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Text(
                          '•••• ••••',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.13,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: IconButton(
                        icon: Icon(
                          _isCvvVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              if (test == 2) {
                                // If test is 2, no need to show CVV field immediately
                                _isCvvVisible = false;
                              } else {
                                // Toggle the CVV visibility normally
                                _isCvvVisible = !_isCvvVisible;
                              }
                              // Update test value to switch between masked/unmasked state
                              if (test <= 2) {
                                ++test;
                              } else {
                                test = 0;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                        const Center(child: CircularProgressIndicator(),):
                ListView.separated(
                 // itemCount: provider.transactions!.result!.length,
                  itemCount: provider.agentPaymentTransctionModel!.data!.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 1),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        TransactionHistoryPage(agentTransaction: provider.agentPaymentTransctionModel!.data![index])));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: green.shade100,
                          child:
                            Image.asset("assets/images/payment_recived.png", scale: 20,)
                          // const Icon(Icons.account_balance_wallet,
                          //     color: green),
                        ),
                        title: Text(
                          "Payment Received",
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                         // formatTimestamp(provider.transactions!.result![index].transaction!.time!.toInt()),
                          //formatTimestamp(provider.agentPaymentTransctionModel!.data![index].createdAt.toString()),
                      //    "March 20, 2025 • 3:30 PM",
                            provider.agentPaymentTransctionModel!.data![index].createdAt.toString(),
                          style: GoogleFonts.inter(fontSize: 14, color: grey),
                        ),
                        trailing: Text(
                         // "₹ ${provider.transactions!.result![index].transaction!.amount.toString()}",
                          "₹ ${provider.agentPaymentTransctionModel!.data![index].linkAmount.toString()}",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
