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
import '../../../core/general.dart';
import '../../../core/utils.dart';
import '../../../data/repository/new_qr_code_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/cash_deposit_model.dart';
import '../../app/bottom_nav_bar_page.dart';
import '../../profile/widgets/recipect_page.dart';

class NewQrCodePage extends StatefulWidget {
  final String paymentSessionId;
  final String amount;
  final String token;
  final String custName;
  final String custPhone;
  final String custId;

  const NewQrCodePage({
    super.key,
    required this.paymentSessionId,
    required this.amount,
    required this.token,
    required this.custName,
    required this.custPhone,
    required this.custId,
  });

  @override
  State<NewQrCodePage> createState() => _NewQrCodePageState();
}

class _NewQrCodePageState extends State<NewQrCodePage>
    with SingleTickerProviderStateMixin {
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
  String? bankName;
  String? subagentPhoneNumber;

/*
  String _getBankNameFromCorpCode(String corpCode) {
    // Map corpcode to bank name
    final Map<String, String> corpCodeToBankName = {
      "BNKKRMR": "KURUMATHUR SERVICE CO OPERATIVE BANK LTD",
      "BNKPDVR": "PIDAVOOR SCB",
      "BNKKNPRM": "Kannapuram SCB",
      "BNKTRK": "Thrikkakkara SCB",
      "BNKKVRY": "KOOVERY SERVICE CO OPERATIVE BANK LTD",
      "BNKKPM": "Kaipamangalam SCB",
      "BNKKPMF": "Kaipamangalam Fisherman SCB",
      "BNKPRK": "Peringottukara SCB",
      "BNKPYPL": "POOYAPALLY SCB",
      "BNKVLMK": "VELIMUKKU SCB",
      "BNKPLKL": "PALLICKAL SCB",
      "BNKCRKT": "CHERUKALATHUR SCB",
      "BNKCLNR": "CHELANNUR SERVICE CO OPERATIVE BANK",
      "BNKPPNS": "Pappinissery Rural Bank",
      "BNKELYR": "ELAYAVOOR SERVICE CO OPERATIVE BANK LTD",
      "BNKKTM": "KOTTAYAM SERVICE CO OPERATIVE BANK LTD",
      "BNKAVN": "Avinissery SCB",
      "BNKDMDM": "DHARMADAM SERVICE CO OPERATIVE BANK LTD",
      "BNKPTVM": "PATTUVAM SERVICE CO OPERATIVE BANK",
      "BNKKUTGM": "KUTTUMUGHAM SERVICE CO OPERATIVE BANK LTD",
      "BNKERKT": "ERAMAM KUTTUR SERVICE CO OPERATIVE BANK LTD",
      "BNKKDKD": "KODAKKAD SERVICE CO OPERATIVE BANK LTD",
      "BNKPMP": "PMP SERVICE CO OPERATIVE BANK",
      "BNKSKMB": "SRI KAMBILAYA MUTUAL NIDHI LIMITED",
      "BNKTSSCB": "Thuravoor South SCB",
      "BNKVBGR": "VIBGYOR NIDHI LIMITED",
      "BNKPPL": "PERUMPILLY SCB",
      "BNKKTRM": "KAITHARAM SCB",
      "BNKKZPL": "KUZHUPPILLY SCB",
      "BNKNABL": "NAYARAMBALAM SCB",
      "BNKELR": "ELOOR SCB",
      "BNKERYD": "ERIYAD SCB",
      "BNKPYVR": "PAYYAVOOR SCB",
      "BNKVDKRA": "VADAKKEKKARA SCB",
      "BNKPRVR": "PARAVUR SCB",
      "BNKVLLR": "Velloor Service Co Operative Bank",
      "BNKMANK": "Manakunnam SCB",
      "BNKAZKD": "AZHIKODE SCB",
      "BNKTHRNL": "Thirunaloor SCB",
      "BNKVDYR": "VADAYAR",
      "BNKKDKPL": "KADAKKARAPALLY SCB",
      "BNKUCMSA": "URBAN CARE MULTI STATE AGRO CSL",
      "BNKKKYR": "KOKKAYAR SCB",
      "BNKMFF": "MILK FARMERS AND FISHERIES",
      "BNKCORDL": "Cordial Gramin Development Foundation",
      "BNKCHLVR": "CHELAVUR SCB",
      "BNKVRND": "VARANAD SCB",
      "BNKVBGRK": "VIBGYOR NIDHI LIMITED KOOTTILANGADI",
      "BNKKNKRA": "KUNNUKARA SCB",
      "BNKEDVNKD": "EDAVANAKKAD",
      "BNKKRDM": "KARTHEDOM SCB",
      "BNKAROOR": "AROOR SCB",
      "BNKGMSA": "Gramin Multi State Agro Co Operative Society Ltd",
      "BNKICCSL": "Indian Cooperative Credit Society Limited",
      "BNKNNDR": "Neendoor scb",
      "BNKCOB": "Co operative bhavan",
      "BNKCHMG": "Chathamangalam SCB",
      "BNKCXTX": "COXTAX",
      "BNKORNTL": "ORIENTAL AGRO MULTISTATE CO OP SOCIETY",
      "BNKTSRA": "Thushara Nidhi",
      "BNKPRTR": "PURATHUR SCB",
      "BNKCLBT": "CLUB T",
      "BNKPNP": "Pearls N Petals",
      "BNKVLKD": "Vellarkkad SCB",
      "BNKMDS": "Medi Soft",
      "BNKPLSCB": "Pulakode service cooperative Bank",
      "BNKMNCHL": "MEENACHIL SCB",
      "BNKOMSRY": "Omassery SCB",
      "BNKPTKL": "Pothukal SCB",
      "BNKFPMC": "FAPMCO MSCS",
      "BNKMULKD": "Mullakkodi Co-operative Bank",
    };

    // Return the bank name if found, otherwise return a default value
    return corpCodeToBankName[corpCode] ?? "Unknown Bank";
  }
*/

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
                Text("BANK NAME : $bankName"), // Display bank name
                const SizedBox(height: 10),
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

//9745228327
  void _listenForFirebaseMessages() {
    print("_listenForFirebaseMessages");
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
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    Navigator.pop(
                      context,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavScreen()));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // Content
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

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Show Receipt Button (only if we have receipt data)
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReceiptPage(
                                        amount: widget.amount,
                                        bankName: bankName ?? "XYZ BANK",
                                        agentName: agentName ?? "Name",
                                        agentPhone:
                                            agentPhoneNumber ?? "agentPhone",
                                        custName: widget.custName,
                                        custPhone: widget.custPhone,
                                        custId: widget.custId,
                                        txnId: "",
                                        txnType: "QR",
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

                    // OK Button
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

  Future<void> generateQr(
      String amount, String paymentSessionId, String token) async {
    final generateQr =
        await NewQrCodeRepository().getQrCode(paymentSessionId, token);
    generateQr.fold((error) {
      print("---------------------ERROR---------------");
      print(error);
    }, (newQrCode) {
      if (newQrCode.data!.payload!.qrcode != null &&
          newQrCode.data!.payload!.qrcode!.isNotEmpty &&
          newQrCode.data!.payload!.qrcode != "") {
        final base64Data = newQrCode.data!.payload!.qrcode!
            .replaceFirst("data:image/png;base64,", "");
        qrCodeImageBytes = base64Decode(base64Data);
        setState(() {
          qrCodeBase64 = newQrCode.data!.payload!.qrcode!;
          generatedQrStatus = true;
        });
      } else {
        showMessage(context, "UNABLE TO GENERATE QR", "RED");
      }
    });
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
    print("NewQrCodePage");
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
    final number = await SharedPref().getSubAgentMobNum();
    final subagentNum = await SharedPref().getSubAgentMobNum();

    if (mounted) {
      setState(() {
        agentName = name;
        agentEmail = email;
        agentId = id;
        subagentPhoneNumber = subagentNum;

        agentOriginId = originId;
        corpCode = code;
        agentPhoneNumber = number;
        bankName = getBankNameFromCorpCode(code ?? ""); // Set bank name here
      });
    }

    printLog("------------------------------CORP CODE--------------------");
    printLog(corpCode);
    printLog("------------------------------Agent Number-------------------");
    printLog(agentPhoneNumber);

    generateQr(widget.amount, widget.paymentSessionId, widget.token);
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
                padding: const EdgeInsets.all(17),
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
            value: _start / 180,
            // 3 minutes = 180 seconds
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(home2),
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

  void showMessage(BuildContext context, String msg, String clr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: clr == "RED" ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
/*
class NewQrCodePage extends StatefulWidget {
  final String paymentSessionId;
  final String amount;
  final String token;
  const NewQrCodePage({
    super.key,
    required this.paymentSessionId,
    required this.amount,
    required this.token,
  });

  @override
  State<NewQrCodePage> createState() => _NewQrCodePageState();
}

class _NewQrCodePageState extends State<NewQrCodePage>
    with SingleTickerProviderStateMixin {
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
//9745228327
  void showOverlay(String? text) async {
    // Check if overlay permission is already granted
    bool isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();

    // If not granted, request it
    if (!isPermissionGranted) {
      await FlutterOverlayWindow.requestPermission();

      // Check again after requesting
      isPermissionGranted = await FlutterOverlayWindow.isPermissionGranted();
    }

    // If permission is granted, show the overlay
    if (isPermissionGranted) {
      await FlutterOverlayWindow.showOverlay(
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPrivate,
        enableDrag: true,
        overlayTitle: "Wallet Load Successful 🎉",
        overlayContent: text,
      );
    } else {
      // Handle the case when permission is not granted
      debugPrint("Overlay permission not granted by the user.");
      // Optionally show a dialog or snackbar to explain how to enable it manually
    }
  }


  void _listenForFirebaseMessages() {
    print("_listenForFirebaseMessages");
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
            showOverlay(notificationBody);
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
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
                          borderRadius: BorderRadius.circular(10)

                      )
                  ),
                  onPressed: () {
                    setState(() {
                      _timeString = "00:00";
                      _timer.cancel();
                    });
                    Navigator.pop(
                      context,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavScreen()));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10,),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: home1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No", style: TextStyle(color: Colors.white),),
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

  Future<void> generateQr(
      String amount,String paymentSessionId,String token) async {

    final generateQr = await NewQrCodeRepository().getQrCode(
        paymentSessionId, token);
    generateQr.fold(
            (error){
          print("---------------------ERROR---------------");
          print(error);
        },
            (newQrCode){
          if(newQrCode.data!.payload!.qrcode != null && newQrCode.data!.payload!.qrcode!.isNotEmpty && newQrCode.data!.payload!.qrcode != ""){
            final base64Data = newQrCode.data!.payload!.qrcode!.replaceFirst("data:image/png;base64,", "");
            qrCodeImageBytes =base64Decode(base64Data);
            setState(() {
              qrCodeBase64 = newQrCode.data!.payload!.qrcode!;
              generatedQrStatus = true;
            });
          }else{
            showMessage(context, "UNABLE TO GENERATE QR", "RED");
          }
        }
    );
  }

  // Future<void> generateQRCode() async {
  //   final qrCode = await PaymentLinkRepository().getPaymentLink(
  //     agentName!,
  //     agentId!,
  //     agentOriginId!,
  //     agentPhoneNumber!,
  //     agentEmail!,
  //     widget.custName,
  //     widget.custPhoneNumber,
  //     widget.custAcNumber,
  //     widget.custEmail,
  //     widget.custId,
  //     num.parse(widget.amount),
  //     "Payment for Order #1234",
  //     corpCode!,
  //     "",
  //     widget.token,
  //   );
  //   qrCode.fold(
  //     (error) {
  //       print("-----------------------ERROR-----------------------");
  //       print(error);
  //     },
  //     (qr) {
  //       final qrData = qr.linkQrcode;
  //       if (qrData != null && qrData.contains(',')) {
  //         setState(() {
  //           qrCodeImageBytes = base64Decode(qrData.split(',').last);
  //         });
  //       } else {
  //         print("Invalid or missing QR code data");
  //       }
  //     },
  //   );
  // }

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
    print("NewQrCodePage");
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

    generateQr(widget.amount,widget.paymentSessionId,widget.token);
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
                child:
                    qrCodeImageBytes == null
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

  void showMessage(BuildContext context, String msg, String clr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: clr == "RED" ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
*/
