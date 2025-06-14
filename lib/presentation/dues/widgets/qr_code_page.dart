import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../core/colors.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../../../data/repository/payment_link_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/cash_deposit_model.dart';

class QrCodePage extends StatefulWidget {
  final String amount;
  final String token;
  final String custName;
  final String custAcNumber;
  final String custPhoneNumber;
  final String custId;
  final String custEmail;

  const QrCodePage({
    super.key,
    required this.amount,
    required this.token,
    required this.custName,
    required this.custAcNumber,
    required this.custPhoneNumber,
    required this.custId,
    required this.custEmail,
  });

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> with SingleTickerProviderStateMixin{
  late Timer _timer;
  bool _isFirebaseListenerInitialized = false; // ✅ Prevent duplicate listeners
  int _start = 180; // 3 minutes in seconds
  //int _start = 30; // 30 seconds
  String _timeString = "03:00";
  final ScreenshotController _screenshotController = ScreenshotController();
  StreamSubscription<RemoteMessage>? _firebaseMessageSubscription;
  String? agentId;
  String? agentOriginId;
  String? agentPhoneNumber;
  String? agentName;
  String? agentEmail;
  String? corpCode;
  Uint8List? qrCodeImageBytes;
  String? qrCodeBase64;
  bool generatedQrStatus = false;
  static const String secretKey =
      "770A8A65DA156D24EE2A093277530142"; // Must be 32 characters for AES-256
  static const String initialVector =
      "1234567890123456"; // Must be 16 characters for AES
  StreamSubscription<RemoteMessage>? _messageSubscription;
  Timer? _paymentVerificationTimer; // Timer for payment verification
  bool isPaymentVerified = false; // Flag to check payment status
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  void cashDepositDialog(CashDepositModel? cashDepositModel) {
    print("INSIDE DEPOSIT CASH DIALOG");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(textAlign: TextAlign.center, "Cash Deposit Status"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("ACCOUNT NO : ${cashDepositModel?.receipt?.data?.accNo}"),
                const SizedBox(height: 10),
                Text("TRAN ID : ${cashDepositModel?.receipt?.data?.tranId}"),
                const SizedBox(height: 10),
                Text("NAME : ${cashDepositModel?.receipt?.data?.name}"),
                const SizedBox(height: 10),
                Text(
                  "DEPOSIT AMOUNT : ${cashDepositModel?.receipt?.data?.depositAmount}",
                ),
                const SizedBox(height: 10),
                Text(
                  "CURRENT BALANCE : ${cashDepositModel?.receipt?.data?.currentBalance}",
                ),
                const SizedBox(height: 10),
                Text(
                  "DEPOSIT DATE : ${cashDepositModel?.receipt?.data?.depositDate}",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // _fetchBalance();
                Navigator.pop(context);
                Navigator.pop(context, "fetch_balance");
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _listenForFirebaseMessages() {
    _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener

    _firebaseMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      if (message.notification != null) {
        final String? notificationTitle = message.notification?.title;
        final String? notificationBody = message.notification?.body;

        print("📩 Foreground Notification: $notificationTitle");

        if (notificationTitle == "Wallet Load Successful 🎉") {
          if (mounted) {
            print("✅ Showing Success Message");
            _showSuccessMessage(notificationBody);
          }
        }
      } else {
        print("⚠️ Empty Message Received: ${message.data}");
      }
    });

    // ✅ Handle background notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🚀 Background Notification Clicked: ${message.data}");
    });

    // ✅ Handle terminated app notification taps
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print("📱 App Launched via Notification: ${message.data}");
      }
    });
  }

  void showWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text(
            "WARNING",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          content:const Text(
            "Warning: You cannot go back or cancel this page until the transaction is complete. Please wait until the process finishes.",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
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
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message ?? "Your wallet has been loaded successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  //Navigator.pop(context); // Close the dialog
                  //depositCash();

                  Navigator.pop(context); // Close the dialog
                  //_fetchBalance();
                  Navigator.pop(context, "fetch_balance");
                }
              },
              child: const Text("OK"),
            ),
          ],
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
          // Reduced horizontal padding
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
                      width: 60, // Small CircularProgressIndicator size
                      height: 60,
                      child: CircularProgressIndicator(
                        color: deepTeal,
                        strokeWidth: 4.0, // Reduced stroke width
                      ),
                    ),
                    Image.asset(
                      "assets/images/logo_cut.png",
                      // Replace with your image asset
                      width: 40, // Small image size
                      height: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0), // Reduced space between elements
            ],
          ),
        );
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_start == 0) {
        _timer.cancel();
        Navigator.pop(
          context,
        ); // Navigate back to the previous page when time is up
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

  @override
  void dispose() {
    _timer.cancel();
    _paymentVerificationTimer
        ?.cancel(); // Cancel the payment verification timer
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();

    try {
      // Load the asset image using rootBundle
      final logoBytes = await rootBundle.load(
        "assets/images/adsspay_logo_1.png",
      );

      pdf.addPage(
        pw.Page(
          build:
              (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(
                    pw.MemoryImage(logoBytes.buffer.asUint8List()),
                    height: 100,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Amount: ₹${widget.amount}",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: "Amount: ₹${widget.amount}",
                      width: 200,
                      height: 200,
                    ),
                  ),
                ],
              ),
        ),
      );

      // Save the PDF to the device's application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/QR_Code.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF saved to ${file.path}")));

      // Open the generated PDF file
      // await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error generating PDF: $e")));
    }
  }

  Future<void> _shareScreenshot() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/screenshot.png');
        await imagePath.writeAsBytes(imageBytes);

        await Share.shareXFiles([
          XFile(imagePath.path),
        ], text: 'Here is the QR code with amount ₹${widget.amount}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error sharing screenshot: $e")));
    }
  }


   Future<void> generateQRCode() async {
        final qrCode = await PaymentLinkRepository().getPaymentLink(
          agentName!,
          agentId!,
          agentOriginId!,
          agentPhoneNumber!,
          agentEmail!,
          widget.custName,
          widget.custPhoneNumber,
          widget.custAcNumber,
          widget.custEmail,
          widget.custId,
          num.parse(widget.amount),
          "Payment for Order #1234",
          corpCode!,
          "",
          widget.token,
        );
        qrCode.fold(
              (error) {
            print("-----------------------ERROR-----------------------");
            print(error);
          },
              (qr) {
            final qrData = qr.linkQrcode;
            if (qrData != null && qrData.contains(',')) {
              setState(() {
                qrCodeImageBytes = base64Decode(qrData.split(',').last);
              });
            } else {
              print("Invalid or missing QR code data");
            }
          },
        );
      }



  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(secretKey);
    final iv = encrypt.IV.fromUtf8(initialVector);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
     _startTimer();
    loadSharedPrefs();
    if (!_isFirebaseListenerInitialized) {
      _listenForFirebaseMessages();
      _isFirebaseListenerInitialized = true;
    }
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final id = await SharedPref().getAgentId();
    final originId = await SharedPref().getAgentOriginId();
    final code = await SharedPref().getCorpCode();
    final email = await SharedPref().getEmail();
    final number = await SharedPref().getMobNum();

    if (mounted) {
      setState(() {
        agentName = name;
        agentEmail = email;
        agentId = id;
        agentOriginId = originId;
        corpCode = code;
        agentPhoneNumber = number;
      });
    }

    generateQRCode();

  }

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
            return Screenshot(
              controller: _screenshotController,
              child: Stack(
                children: [
                  // Main Content
                  Column(
                    children: [
                      // App Bar
                      _buildAppBar(),

                      // Amount Card with Parallax Effect
                      Transform.translate(
                        offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildAmountCard(),
                        ),
                      ),

                      // QR Code with Floating Effect
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _buildQrCodeSection(),
                          ),
                        ),
                      ),

                      // Action Buttons
                      Transform.translate(
                        offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildActionButtons(),
                        ),
                      ),

                      // Timer Section
                      _buildTimerSection(),
                    ],
                  ),
                ],
              ),
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
        icon:const Icon(Icons.arrow_back_rounded, color: home2, size: 28),
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
          gradient:const LinearGradient(
            colors: [home1, home2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: deepTeal.withOpacity(0.3),
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
              const Icon(Icons.currency_rupee_rounded, color: Colors.white, size: 32),
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
        // Animated Background Circles
        Positioned(
          top: 50,
          left: 30,
          child: AnimatedContainer(
            duration: const Duration(seconds: 8),
            curve: Curves.easeInOut,
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: home1.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          right: 40,
          child: AnimatedContainer(
            duration: const Duration(seconds: 6),
            curve: Curves.easeInOut,
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: home2.withOpacity(0.05),
            ),
          ),
        ),

        // QR Code Container
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: qrCodeImageBytes == null
                    ?const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: deepTeal,
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : Image.memory(
                  qrCodeImageBytes!,
                  width: 240,
                  height: 240,
                ),
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
            onTap: _downloadPdf,
          ),
          _buildAnimatedButton(
            icon: Icons.share_rounded,
            label: "Share",
            color: black,
            onTap: _shareScreenshot,
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
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
            color: Colors.black.withOpacity(0.1),
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
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
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
            valueColor:const AlwaysStoppedAnimation<Color>(home2),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  int generateRandom10DigitNumber() {
    final random = Random();
    int firstDigit = 1 + random.nextInt(9); // Generates the first digit (1-9)
    int remainingDigits = random.nextInt(
      1000000000,
    ); // Generates the remaining 9 digits (000000000-999999999)
    return int.parse(
      '$firstDigit${remainingDigits.toString().padLeft(9, '0')}',
    );
  }
}
