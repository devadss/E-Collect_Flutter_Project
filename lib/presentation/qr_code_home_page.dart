import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:merchant_app_flutter/data/provider/balance_provider.dart';
import 'package:provider/provider.dart';
import '../../core/general.dart';
import '../build_button.dart';
import '../core/colors.dart';
import '../core/shared_pref_helper.dart';
import '../data/provider/create_order_provider.dart';
import 'generate_qr_code_page.dart';


class QrCodeHomePage extends StatefulWidget {
  final String payAbleAmount;
  const QrCodeHomePage({super.key, required this.payAbleAmount});

  @override
  State<QrCodeHomePage> createState() => _QrCodeHomePageState();
}

class _QrCodeHomePageState extends State<QrCodeHomePage> {

  TextEditingController amountController = TextEditingController();
  String paymentSessionId = "";
  String orderID = "";
  String? tokenValue;
  String? entityId;
  String? name;
  String? phoneNumber;
  String? email;
  double? balanceAmount = 0.0;



  Future<void> _fetchBalance() async {
    final provider =
        Provider.of<BalanceProvider>(context, listen: false);
    await provider.getchBalance(entityId.toString(), tokenValue.toString());
  //  setState(() async {
      print('inside _fetchBalance');
      final resposne  = await provider.getchBalance(entityId.toString(), tokenValue.toString());
    resposne.fold(
          (error) {
        print("request error= ${error.message}");

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: ${error.message}",
                style:
                GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
              ),
              backgroundColor: Colors.red,
            )            );
        Navigator.pop(context);
      },
          (data) {
            setState(() {
              balanceAmount = data.result![0].balance!.toDouble();
            });

      },
    );
     // printLog("---------------------FETCH BALANCE-----------------");
     // printLog(balanceAmount);
   // });
  }

  @override
  void initState() {
    amountController.text = widget.payAbleAmount;
    loadSharedPrefs();
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    String? token = await SharedPref().getTokenValue();
    String? userId = await SharedPref().getCustId();
    String? userName = await SharedPref().getUserName();
    String? mobile = await SharedPref().getMobNum();
    //String? emailId = await SharedPref.shared.getEmail();
    if (mounted) {
      setState(() {
        tokenValue = token;
        entityId = userId;
        name = userName;
        phoneNumber = mobile;
      //  email = emailId;
      });
      _fetchBalance();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Qr Payment",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 23, color: deepTeal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [deepTeal, deepTeal, yellowGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "₹ ${formatNumberWithCommas(balanceAmount)}",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 30),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.currency_rupee_sharp,
                                  color: deepIndigo),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              hintStyle: const TextStyle(color: black54),
                              fillColor: deepTeal.withOpacity(0.25),
                              filled: true,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d+\.?\d{0,2}')), // Allows decimal input with up to 2 places
                              LengthLimitingTextInputFormatter(
                                  6), // Adjust length for decimals
                            ],
                            style: const TextStyle(color: black),
                            onChanged: (value) {
                              double enteredValue = double.tryParse(value) ??
                                  0.0; // Parse as double
                              // if (fullKycStatus == true &&
                              //     enteredValue > 300000.00) {
                              //   amountController.text = '300000.00';
                              // } else if (fullKycStatus == false &&
                              //     enteredValue > 10000.00) {
                              //   amountController.text = '10000.00';
                              // }

                              amountController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: amountController.text.length),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(6, (index) {
                              final amounts = [
                                100,
                                500,
                                1000,
                                2000,
                                5000,
                                10000
                              ];
                              return GestureDetector(
                                onTap: () {
                                  amountController.text =
                                      amounts[index].toString();
                                },
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: deepTeal),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${amounts[index]}",
                                      style: GoogleFonts.kodchasan(
                                        fontWeight: FontWeight.bold,
                                        color: black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                if (amountController.text != '' ||
                    amountController.text.isNotEmpty) {

                  createOrderId('SELF');
                } else {
                  print("Please Enter an Amount");
                  // EasyLoading.showToast('Please Enter an Amount',
                  //     toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 51),
                child: BuildButton(
                  buttonText: "Confirm",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> createOrderId(String? type) async {
    final orderCraeteProvider =
        Provider.of<CreateOrderProvider>(context, listen: false);
    await orderCraeteProvider.createOrderId(
        //"1145_adss1zZArL7imer_${generateRandom6DigitNumber()}_Merchant",
        "${type}_${entityId}_${generateRandom12DigitNumber()}",
        double.tryParse(amountController.text),
        entityId,
        name,
        email,
        phoneNumber);
    paymentSessionId = orderCraeteProvider
        .paymentGatewayOrderResponseModel!.paymentSessionId
        .toString();
    orderID = orderCraeteProvider.paymentGatewayOrderResponseModel!.orderId
        .toString();
    print(
        'CREATE paymentSessionId RESPONSE = ${orderCraeteProvider.paymentGatewayOrderResponseModel?.paymentSessionId.toString()}');
    print(
        'CREATE ORDER RESPONSE = ${orderCraeteProvider.paymentGatewayOrderResponseModel?.orderId.toString()}');
    if (paymentSessionId.isNotEmpty && orderID.isNotEmpty) {
      printLog("------------------ORDER ID-----------------");
      printLog(orderID);
      //  Navigator.push(
      //      context,
      //      MaterialPageRoute(
      //          builder: (context) =>
      // // GenerateQrCodeScreen(sessionId: paymentSessionId,)));
      //          GeneratedQrCodePage(
      //          // //QrCodeGenerator(
      //            amount: amountController.text,
      //            userName: widget.userName,
      //            email: widget.email,
      //            phoneNumber: widget.phoneNumber,
      //            entityId: widget.entityId,
      //            token: widget.token,
      //            sessionID: paymentSessionId,
      //            orderId: orderID,
      //          )));
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GeneratedQrCodePage(
                  amount: amountController.text,
                  userName: name!,
                  email: "absc@hmail.com",
                  phoneNumber: phoneNumber!,
                  entityId: entityId!,
                  token: tokenValue!,
                  sessionID: paymentSessionId,
                  orderId: orderID)
              // GenerateQrCodeScreen(sessionId: paymentSessionId,)));
              // GeneratedQrCodePage(
              //   // //QrCodeGenerator(
              //   amount: amountController.text,
              //   userName: widget.userName,
              //   email: widget.email,
              //   phoneNumber: widget.phoneNumber,
              //   entityId: widget.entityId,
              //   token: widget.token,
              //   sessionID: paymentSessionId,
              //   orderId: orderID,
              // )
              ));
      if (result == "fetch_balance") {
        _fetchBalance();
      }
    } else {
      EasyLoading.showToast("Session id is null");
    }
  }

  String formatNumberWithCommas(double? number) {
    final formatter =
        NumberFormat("#,##,##0.00", "en_IN"); // Indian numbering system

    return formatter.format(number ?? 0.0); // Default to 0.0 if number is null
  }
}

String generateRandom12DigitNumber() {
  final random = Random();
  double randomNumber = random.nextDouble();
  int min = 100000000000;
  int max = 999999999999;
  int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
  return scaledNumber.toString();
}

String generateRandom6DigitNumber() {
  final random = Random();
  double randomNumber = random.nextDouble();
  int min = 100000;
  int max = 999999;
  int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
  return scaledNumber.toString();
}
