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
import '../../../../data/repository/payment_link_repository.dart';
import '../../../../data/storage/shared_pref_helper.dart';
import '../../../../domain/model/cash_deposit_model.dart';

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

class _QrCodePageState extends State<QrCodePage> {
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
  static const String secretKey = "770A8A65DA156D24EE2A093277530142"; // Must be 32 characters for AES-256
  static const String initialVector = "1234567890123456"; // Must be 16 characters for AES
  StreamSubscription<RemoteMessage>? _messageSubscription;
  Timer? _paymentVerificationTimer; // Timer for payment verification
  bool isPaymentVerified = false; // Flag to check payment status

  void cashDepositDialog(CashDepositModel? cashDepositModel) {
    print("INSIDE DEPOSIT CASH DIALOG");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                const Text(textAlign: TextAlign.center, "Cash Deposit Status"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "ACCOUNT NO : ${cashDepositModel?.receipt?.data?.accNo}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("TRAN ID : ${cashDepositModel?.receipt?.data?.tranId}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("NAME : ${cashDepositModel?.receipt?.data?.name}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "DEPOSIT AMOUNT : ${cashDepositModel?.receipt?.data?.depositAmount}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "CURRENT BALANCE : ${cashDepositModel?.receipt?.data?.currentBalance}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "DEPOSIT DATE : ${cashDepositModel?.receipt?.data?.depositDate}"),
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
                  child: const Text("OK"))
            ],
          );
        });
  }

  void _listenForFirebaseMessages() {
    print("_listenForFirebaseMessages");
    _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener

    _firebaseMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("message.notification != null");
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
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("📱 App Launched via Notification: ${message.data}");
      }
    });
  }
/*  void _listenForFirebaseMessages() {
    _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener

    _firebaseMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("message.notification != null");
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
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("📱 App Launched via Notification: ${message.data}");
      }
    });
  }*/

  void showWarning() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "WARNING",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Text(
              "Warning: You cannot go back or cancel this page until the transaction is complete. Please wait until the process finishes.",
              style:
                  GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
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
            context); // Navigate back to the previous page when time is up
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
      final logoBytes =
          await rootBundle.load("assets/images/adsspay_logo_1.png");

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved to ${file.path}")),
      );

      // Open the generated PDF file
      // await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating PDF: $e")),
      );
    }
  }

  Future<void> _shareScreenshot() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = File('${directory.path}/screenshot.png');
        await imagePath.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Here is the QR code with amount ₹${widget.amount}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sharing screenshot: $e")),
      );
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
        widget.token
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
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    loadSharedPrefs();
    if (!_isFirebaseListenerInitialized) {
      print("__isFirebaseListenerInitialized");
      _listenForFirebaseMessages();
      _isFirebaseListenerInitialized = true;
    }else{
      print("_isFirebaseListenerInitialized not initalized");
    }
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref.shared.getAgentName();
    final id = await SharedPref.shared.getAgentId();
    final originId = await SharedPref.shared.getAgentOriginId();
    final code = await SharedPref.shared.getCorpCode();
    final email = await SharedPref.shared.getEmail();
    final number = await SharedPref.shared.getMobNum();

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

    generateQRCode(); // Fetch the QR code on initialization
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_timeString != "00:00") {
          showWarning();
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: Text(
            "Scan To Pay",
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w700, color: deepTeal),
          ),
        ),
        body: Screenshot(
          controller: _screenshotController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.25),
                        )
                      ],
                      gradient: const LinearGradient(
                        colors: [deepTeal, deepTeal, yellowGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          "Amount :Rs. ${widget.amount}",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, color: white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Show QR code below the amount container
                qrCodeImageBytes == null
                    ? const CircularProgressIndicator()
                    : Image.memory(qrCodeImageBytes!),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async => await _downloadPdf(),
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          minWidth: 120,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: deepTeal),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.download_for_offline_outlined,
                                color: teal600,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Download",
                                style: GoogleFonts.inter(
                                  color: teal600,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async => await _shareScreenshot(),
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          minWidth: 120,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: deepTeal),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Icon(Icons.share, color: teal600),
                              const SizedBox(width: 15),
                              Text(
                                "Share",
                                style: GoogleFonts.inter(
                                  color: teal600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "This page will close in:",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  _timeString,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int generateRandom10DigitNumber() {
    final random = Random();
    int firstDigit = 1 + random.nextInt(9); // Generates the first digit (1-9)
    int remainingDigits = random.nextInt(
        1000000000); // Generates the remaining 9 digits (000000000-999999999)
    return int.parse(
        '$firstDigit${remainingDigits.toString().padLeft(9, '0')}');
  }

}
