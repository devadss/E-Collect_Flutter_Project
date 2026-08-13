import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../profile/widgets/recipect_page.dart';


class NewQrCodePage extends StatefulWidget {
  final String paymentSessionId;
  final String amount;
  final String custName;
  final String custPhone;
  final String custId;

  const NewQrCodePage({
    super.key,
    required this.paymentSessionId,
    required this.amount,
    required this.custName,
    required this.custPhone,
    required this.custId,
  });

  @override
  State<NewQrCodePage> createState() => _NewQrCodePageState();
}

class _NewQrCodePageState extends State<NewQrCodePage>
    with SingleTickerProviderStateMixin {
  // ---- Timer / UI state ----
  late Timer _timer;
  int _start = 180; // 3 minutes in seconds
  String _timeString = "03:00";
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // ---- QR image + agent/bank display data (populated externally) ----
  Uint8List? qrCodeImageBytes;
  String? agentName;
  String? agentPhoneNumber;
  String? bankName;

  // ---- Firebase messaging state ----
  bool _isFirebaseListenerInitialized = false; // ✅ Prevent duplicate listeners
  StreamSubscription<RemoteMessage>? _firebaseMessageSubscription;

  // =================================================================
  // FIREBASE MESSAGING
  // =================================================================
  void _listenForFirebaseMessages() {
    print("_listenForFirebaseMessages");
    _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener

    _firebaseMessageSubscription = FirebaseMessaging.onMessage.listen((
        RemoteMessage message,
        ) {
      if (message.notification != null) {
        final String? notificationTitle = message.notification?.title;
        final String? notificationBody = message.notification?.body;

        if (notificationTitle == "Wallet Load Successful 🎉"
            || notificationTitle == "Amount Collected Successfully"
        || notificationTitle?.isNotEmpty == true
        ) {
          if (mounted) {
            _showSuccessMessage(notificationBody);
          }
        }
      }
    });

    // ✅ Handle background notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handle background tap
    });

    // ✅ Handle terminated app notification taps
    FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? message,
        ) {
      if (message != null) {
        // handle cold-start tap
      }
    });
  }

  // =================================================================
  // LIFECYCLE
  // =================================================================
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _startTimer();

    if (!_isFirebaseListenerInitialized) {
      _listenForFirebaseMessages();
      _isFirebaseListenerInitialized = true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _firebaseMessageSubscription?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_start == 0) {
        _timer.cancel();
        Navigator.pop(context);
      } else {
        setState(() {
          _start--;
          _timeString = _formatTime(_start);
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  // =================================================================
  // DIALOGS (UI)
  // =================================================================
  void showWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Center(
            child: Text(
              "⚠️ WARNING",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          content: const Text(
            softWrap: true,
            "Are you sure you want to go back ?",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: home1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    setState(() {
                      _timeString = "00:00";
                      _timer.cancel();
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: home1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String? message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message ?? "Your wallet has been loaded successfully!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close this dialog
                          var receiptModel = ReceiptDataModel(
                            amount: widget.amount,
                            bankName: bankName ?? "XYZ BANK",
                            agentName: agentName ?? "Name",
                            agentPhone: agentPhoneNumber ?? "agentPhone",
                            custName: widget.custName,
                            custPhone: widget.custPhone,
                            custId: widget.custId,
                            txnId: "",
                            txnType: "QR",
                            dat: '',
                            tranType: '',
                            accNo: '',
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReceiptPage(
                                    receiptDataModel: receiptModel,
                                  )));
                        },
                        child: const Text(
                          "Show Receipt",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (mounted) {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context, "fetch_balance");
                          }
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

  void showCustomCircularProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(360),
                ),
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                height: 70,
                width: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        color: deepTeal,
                        strokeWidth: 4.0,
                      ),
                    ),
                    Image.asset(
                      "assets/images/logo_cut.png",
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        );
      },
    );
  }

  // =================================================================
  // BUILD / WIDGET TREE (UI)
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_timeString != "00:00") showWarning();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              children: [
                _buildAppBar(),
                Transform.translate(
                  offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildAmountCard(),
                  ),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildQrCodeSection(),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildActionButtons(),
                  ),
                ),
                _buildTimerSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Scan To Pay",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: home2,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: home2, size: 28),
        onPressed: () {
          if (_timeString != "00:00") showWarning();
        },
      ),
    );
  }

  Widget _buildAmountCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [home1, home2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: deepTeal.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_rupee_rounded,
                  color: Colors.white, size: 32),
              const SizedBox(width: 8),
              Text(
                widget.amount,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 50,
          left: 30,
          child: AnimatedContainer(
            duration: const Duration(seconds: 8),
            curve: Curves.easeInOut,
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: home1.withValues(alpha: 0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 40,
          child: AnimatedContainer(
            duration: const Duration(seconds: 6),
            curve: Curves.easeInOut,
            width: 160,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: home2.withValues(alpha: 0.05),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: widget.paymentSessionId == null
                    ? const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: deepTeal,
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : QrImageView(data: widget.paymentSessionId, version: QrVersions.auto,size: 200,
                backgroundColor: Colors.white,)
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Scan the QR code to make payment",
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAnimatedButton(
            icon: Icons.download_rounded,
            label: "Save",
            color: black,
            onTap: () {
              // hook up download/save action here
            },
          ),
          _buildAnimatedButton(
            icon: Icons.share_rounded,
            label: "Share",
            color: black,
            onTap: () {
              // hook up share action here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Time remaining",
            style: GoogleFonts.poppins(
              color: black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1 + (0.1 * sin(value * 2 * pi)), // Pulsing effect
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Text(
              _timeString,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 38,
                color: home1,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _start / 180, // 3 minutes = 180 seconds
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(home2),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
// class NewQrCodePage extends StatefulWidget {
//   final String paymentSessionId;
//   final String amount;
//   final String token;
//   final String custName;
//   final String custPhone;
//   final String custId;
//   const NewQrCodePage({
//     super.key,
//     required this.paymentSessionId,
//     required this.amount,
//     required this.token,
//     required this.custName,
//     required this.custPhone,
//     required this.custId,
//   });
//
//   @override
//   State<NewQrCodePage> createState() => _NewQrCodePageState();
// }
//
// class _NewQrCodePageState extends State<NewQrCodePage>
//     with SingleTickerProviderStateMixin {
//   late Timer _timer;
//   bool _isFirebaseListenerInitialized = false; // ✅ Prevent duplicate listeners
//   int _start = 180; // 3 minutes in seconds
//   //int _start = 30; // 30 seconds
//   String _timeString = "03:00";
//   final ScreenshotController _screenshotController = ScreenshotController();
//   StreamSubscription<RemoteMessage>? _firebaseMessageSubscription;
//   String? agentId;
//   String? agentOriginId;
//   String? agentPhoneNumber;
//   String? agentName;
//   String? agentEmail;
//   String? corpCode;
//   Uint8List? qrCodeImageBytes;
//   String? qrCodeBase64;
//   bool generatedQrStatus = false;
//   static const String secretKey =
//       "770A8A65DA156D24EE2A093277530142"; // Must be 32 characters for AES-256
//   static const String initialVector =
//       "1234567890123456"; // Must be 16 characters for AES
//   StreamSubscription<RemoteMessage>? messageSubscription;
//   Timer? _paymentVerificationTimer; // Timer for payment verification
//   bool isPaymentVerified = false; // Flag to check payment status
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   String? bankName;
//
//
//  /* void cashDepositDialog(CashDepositModel? cashDepositModel) {
//     //print("INSIDE DEPOSIT CASH DIALOG");
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(textAlign: TextAlign.center, "Cash Deposit Status"),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text("BANK NAME : $bankName"), // Display bank name
//                 const SizedBox(height: 10),
//                 Text("ACCOUNT NO : ${cashDepositModel?.receipt?.data?.accNo}"),
//                 const SizedBox(height: 10),
//                 Text("TRAN ID : ${cashDepositModel?.receipt?.data?.tranId}"),
//                 const SizedBox(height: 10),
//                 Text("NAME : ${cashDepositModel?.receipt?.data?.name}"),
//                 const SizedBox(height: 10),
//                 Text(
//                   "DEPOSIT AMOUNT : ${cashDepositModel?.receipt?.data?.depositAmount}",
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "CURRENT BALANCE : ${cashDepositModel?.receipt?.data?.currentBalance}",
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "DEPOSIT DATE : ${cashDepositModel?.receipt?.data?.depositDate}",
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // _fetchBalance();
//                 Navigator.pop(context);
//                 Navigator.pop(context, "fetch_balance");
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }*/
//
// //9745228327
//   void _listenForFirebaseMessages() {
//     print("_listenForFirebaseMessages");
//     _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener
//
//     _firebaseMessageSubscription = FirebaseMessaging.onMessage.listen((
//         RemoteMessage message,
//         ) {
//       if (message.notification != null) {
//         final String? notificationTitle = message.notification?.title;
//         final String? notificationBody = message.notification?.body;
//
//         //print("📩 Foreground Notification: $notificationTitle");
//
//         if (notificationTitle == "Wallet Load Successful 🎉"||notificationTitle == "Amount Collected Successfully") {
//           if (mounted) {
//            // print("✅ Showing Success Message");
//             _showSuccessMessage(notificationBody);
//           }
//         }
//       } else {
//        // print("⚠️ Empty Message Received: ${message.data}");
//       }
//     });
//
//     // ✅ Handle background notification clicks
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//      // print("🚀 Background Notification Clicked: ${message.data}");
//     });
//
//     // ✅ Handle terminated app notification taps
//     FirebaseMessaging.instance.getInitialMessage().then((
//         RemoteMessage? message,
//         ) {
//       if (message != null) {
//         //print("📱 App Launched via Notification: ${message.data}");
//       }
//     });
//   }
//
//   void showWarning() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           title: const Center(
//             child: Text(
//               "⚠️ WARNING",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//             ),
//           ),
//           content: const Text(
//             softWrap: true,
//             "Are you sure you want to go back ?",
//             style: TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   style: TextButton.styleFrom(
//                       side: const BorderSide(color: home1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                   onPressed: () {
//                     setState(() {
//                       _timeString = "00:00";
//                       _timer.cancel();
//                     });
//                     Navigator.pop(
//                       context,
//                     );
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const BottomNavScreen()));
//                   },
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: home1,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "No",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   void _showSuccessMessage(String? message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha:0.1),
//                   blurRadius: 24,
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Success icon
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withValues(alpha:0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 48,
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Title
//                 const Text(
//                   "Success",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Content
//                 Text(
//                   message ?? "Your wallet has been loaded successfully!",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                     height: 1.4,
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Buttons Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Show Receipt Button (only if we have receipt data)
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           elevation: 0,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context); // Close this dialog
//                           var receiptModel = ReceiptDataModel(
//                             amount: widget.amount,
//                             bankName: bankName ?? "XYZ BANK",
//                             agentName: agentName ?? "Name",
//                             agentPhone:
//                             agentPhoneNumber ?? "agentPhone",
//                             custName: widget.custName,
//                             custPhone: widget.custPhone,
//                             custId: widget.custId, txnId: "", txnType: "QR", dat: '', tranType: '', accNo: '',
//                           );
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ReceiptPage(
//                         receiptDataModel: receiptModel,
//                                   )));
//                         },
//                         child: const Text(
//                           "Show Receipt",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 10),
//
//                     // OK Button
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           elevation: 0,
//                         ),
//                         onPressed: () {
//                           if (mounted) {
//                             Navigator.pop(context); // Close the dialog
//                             Navigator.pop(context, "fetch_balance");
//                           }
//                         },
//                         child: const Text(
//                           "OK",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void showCustomCircularProgressDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//           // Reduced horizontal padding
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: white,
//                   borderRadius: BorderRadius.circular(360),
//                 ),
//                 padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
//                 height: 70,
//                 width: 70,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const SizedBox(
//                       width: 60, // Small CircularProgressIndicator size
//                       height: 60,
//                       child: CircularProgressIndicator(
//                         color: deepTeal,
//                         strokeWidth: 4.0, // Reduced stroke width
//                       ),
//                     ),
//                     Image.asset(
//                       "assets/images/logo_cut.png",
//                       // Replace with your image asset
//                       width: 40, // Small image size
//                       height: 40,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8.0), // Reduced space between elements
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (_start == 0) {
//         _timer.cancel();
//         Navigator.pop(
//           context,
//         ); // Navigate back to the previous page when time is up
//       } else {
//         setState(() {
//           _start--;
//           _timeString = _formatTime(_start);
//         });
//       }
//     });
//   }
//
//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _paymentVerificationTimer
//         ?.cancel(); // Cancel the payment verification timer
//     super.dispose();
//   }
//
//   Future<void> _downloadPdf() async {
//     final pdf = pw.Document();
//
//     try {
//       // Load the asset image using rootBundle
//       final logoBytes = await rootBundle.load(
//         "assets/images/adsspay_logo_1.png",
//       );
//
//       pdf.addPage(
//         pw.Page(
//           build: (context) => pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Image(
//                 pw.MemoryImage(logoBytes.buffer.asUint8List()),
//                 height: 100,
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text(
//                 "Amount: ₹${widget.amount}",
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                   color: PdfColors.teal,
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Center(
//                 child: pw.BarcodeWidget(
//                   barcode: pw.Barcode.qrCode(),
//                   data: "Amount: ₹${widget.amount}",
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//
//       // Save the PDF to the device's application documents directory
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/QR_Code.pdf');
//       await file.writeAsBytes(await pdf.save());
//
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("PDF saved to ${file.path}")));
//
//       // Open the generated PDF file
//       // await OpenFile.open(file.path);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error generating PDF: $e")));
//     }
//   }
//
//   Future<void> _shareScreenshot() async {
//     try {
//       final Uint8List? imageBytes = await _screenshotController.capture();
//
//       if (imageBytes != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         final imagePath = File('${directory.path}/screenshot.png');
//         await imagePath.writeAsBytes(imageBytes);
//
//         await Share.shareXFiles([
//           XFile(imagePath.path),
//         ], text: 'Here is the QR code with amount ₹${widget.amount}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error sharing screenshot: $e")));
//     }
//   }
//
//   Future<void> generateQr(
//       String amount, String paymentSessionId, String token) async {
//     final generateQr =
//     await NewQrCodeRepository().getQrCode(paymentSessionId, token);
//     generateQr.fold((error) {
//       //print("---------------------ERROR---------------");
//      // print(error);
//     }, (newQrCode) {
//       if (newQrCode.data!.payload!.qrcode != null &&
//           newQrCode.data!.payload!.qrcode!.isNotEmpty &&
//           newQrCode.data!.payload!.qrcode != "") {
//         final base64Data = newQrCode.data!.payload!.qrcode!
//             .replaceFirst("data:image/png;base64,", "");
//         qrCodeImageBytes = base64Decode(base64Data);
//         setState(() {
//           qrCodeBase64 = newQrCode.data!.payload!.qrcode!;
//           generatedQrStatus = true;
//         });
//       } else {
//         showMessage(context, "UNABLE TO GENERATE QR", "RED");
//       }
//     });
//   }
//
//   String encryptData(String plainText) {
//     final key = encrypt.Key.fromUtf8(secretKey);
//     final iv = encrypt.IV.fromUtf8(initialVector);
//     final encrypter = encrypt.Encrypter(
//       encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
//     );
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return encrypted.base64;
//   }
//
//   @override
//   void initState() {
//     //print("NewQrCodePage");
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//     _startTimer();
//     loadSharedPrefs();
//     if (!_isFirebaseListenerInitialized) {
//       _listenForFirebaseMessages();
//       _isFirebaseListenerInitialized = true;
//     }
//   }
//
//   Future<void> loadSharedPrefs() async {
//     final name = await SharedPref().getAgentName();
//     final id = await SharedPref().getAgentId();
//     final originId = await SharedPref().getAgentOriginId();
//     final code = await SharedPref().getCorpCode();
//     final email = await SharedPref().getEmail();
//     final number = await SharedPref().getSubAgentMobNum();
//
//     if (mounted) {
//       setState(() {
//         agentName = name;
//         agentEmail = email;
//         agentId = id;
//         agentOriginId = originId;
//         corpCode = code;
//         agentPhoneNumber = number;
//         bankName = getBankNameFromCorpCode(code ?? ""); // Set bank name here
//       });
//     }
// if(printStatementStatus){
//   printLog("------------------------------CORP CODE--------------------");
//   printLog(corpCode);
//   printLog("------------------------------Agent Number-------------------");
//   printLog(agentPhoneNumber);
// }
//
//
//
//     generateQr(widget.amount, widget.paymentSessionId, widget.token);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_timeString != "00:00") showWarning();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Screenshot(
//               controller: _screenshotController,
//               child: Stack(
//                 children: [
//                   // Main Content
//                   Column(
//                     children: [
//                       // App Bar
//                       _buildAppBar(),
//                       // Amount Card with Parallax Effect
//                       Transform.translate(
//                         offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
//                         child: Opacity(
//                           opacity: _fadeAnimation.value,
//                           child: _buildAmountCard(),
//                         ),
//                       ),
//
//                       // QR Code with Floating Effect
//                       Expanded(
//                         child: Transform.translate(
//                           offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
//                           child: Opacity(
//                             opacity: _fadeAnimation.value,
//                             child: _buildQrCodeSection(),
//                           ),
//                         ),
//                       ),
//
//                       // Action Buttons
//                       Transform.translate(
//                         offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
//                         child: Opacity(
//                           opacity: _fadeAnimation.value,
//                           child: _buildActionButtons(),
//                         ),
//                       ),
//
//                       // Timer Section
//                       _buildTimerSection(),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         "Scan To Pay",
//         style: GoogleFonts.poppins(
//           fontWeight: FontWeight.w600,
//           color: home2,
//           fontSize: 22,
//           letterSpacing: 0.5,
//         ),
//       ),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_rounded, color: home2, size: 28),
//         onPressed: () {
//           if (_timeString != "00:00") showWarning();
//         },
//       ),
//     );
//   }
//
//   Widget _buildAmountCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [home1, home2],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: deepTeal.withValues(alpha:0.3),
//               blurRadius: 20,
//               spreadRadius: 2,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.currency_rupee_rounded,
//                   color: Colors.white, size: 32),
//               const SizedBox(width: 8),
//               Text(
//                 widget.amount,
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQrCodeSection() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Animated Background Circles
//         Positioned(
//           top: 50,
//           left: 30,
//           child: AnimatedContainer(
//             duration: const Duration(seconds: 8),
//             curve: Curves.easeInOut,
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: home1.withValues(alpha:0.05),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 70,
//           right: 40,
//           child: AnimatedContainer(
//             duration: const Duration(seconds: 6),
//             curve: Curves.easeInOut,
//             width: 160,
//             height: 160,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: home2.withValues(alpha:0.05),
//             ),
//           ),
//         ),
//
//         // QR Code Container
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: Container(
//                 padding: const EdgeInsets.all(17),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha:0.1),
//                       blurRadius: 30,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: qrCodeImageBytes == null
//                     ? const SizedBox(
//                   width: 200,
//                   height: 200,
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       color: deepTeal,
//                       strokeWidth: 3,
//                     ),
//                   ),
//                 )
//                     : Image.memory(
//                   qrCodeImageBytes!,
//                   width: 240,
//                   height: 240,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "Scan the QR code to make payment",
//               style: GoogleFonts.poppins(
//                 color: Colors.grey[700],
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildAnimatedButton(
//             icon: Icons.download_rounded,
//             label: "Save",
//             color: black,
//             onTap: _downloadPdf,
//           ),
//           _buildAnimatedButton(
//             icon: Icons.share_rounded,
//             label: "Share",
//             color: black,
//             onTap: _shareScreenshot,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnimatedButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required Function() onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//           decoration: BoxDecoration(
//             color: color.withValues(alpha:0.1),
//             borderRadius: BorderRadius.circular(50),
//             border: Border.all(color: color.withValues(alpha:0.2), width: 1.5),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: color, size: 22),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimerSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(40),
//           topRight: Radius.circular(40),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha:0.1),
//             blurRadius: 20,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Time remaining",
//             style: GoogleFonts.poppins(
//               color: black,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TweenAnimationBuilder(
//             duration: const Duration(milliseconds: 800),
//             tween: Tween<double>(begin: 0, end: 1),
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: 1 + (0.1 * sin(value * 2 * pi)), // Pulsing effect
//                 child: Opacity(opacity: value, child: child),
//               );
//             },
//             child: Text(
//               _timeString,
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 38,
//                 color: home1,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _start / 180, // 3 minutes = 180 seconds
//             backgroundColor: Colors.grey[200],
//             valueColor: const AlwaysStoppedAnimation<Color>(home2),
//             minHeight: 6,
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ],
//       ),
//     );
//   }
//
//   int generateRandom10DigitNumber() {
//     final random = Random();
//     int firstDigit = 1 + random.nextInt(9); // Generates the first digit (1-9)
//     int remainingDigits = random.nextInt(
//       1000000000,
//     ); // Generates the remaining 9 digits (000000000-999999999)
//     return int.parse(
//       '$firstDigit${remainingDigits.toString().padLeft(9, '0')}',
//     );
//   }
//
//   void showMessage(BuildContext context, String msg, String clr) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           msg.toUpperCase(),
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: clr == "RED" ? Colors.red : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }

