import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../core/shared_pref_helper.dart';
import '../core/general.dart';

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

  @override
  void initState() {

    super.initState();
    loadSharedPrefs();

  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getUserName();
    printLog("-------------------USERNAME---------------");
    print(name);

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Your Balance: ₹50,000",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
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
                                  Clipboard.setData(
                                      const ClipboardData(text: "123456789012"));
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
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (_, __) => const Divider(thickness: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: green.shade100,
                        child: const Icon(Icons.account_balance_wallet,
                            color: green),
                      ),
                      title: Text(
                        "Payment Received",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "March 20, 2025 • 3:30 PM",
                        style: GoogleFonts.inter(fontSize: 14, color: grey),
                      ),
                      trailing: Text(
                        "+₹5,000",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: green,
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
