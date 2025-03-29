import 'dart:convert';

import 'package:pointycastle/export.dart' as pc;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/build_button.dart';
import '../../core/colors.dart';
import '../../core/general.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../data/repository/otp_request_repository.dart';
import '../../data/repository/otp_verification_repository.dart';
import '../../data/repository/set_mpin_repository.dart';
import 'authetication_page/google_pin_code_page.dart';


class ForgotMpinPage extends StatefulWidget {
  const ForgotMpinPage({super.key});

  @override
  State<ForgotMpinPage> createState() => _ForgotMpinPageState();
}

class _ForgotMpinPageState extends State<ForgotMpinPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _mpinController = TextEditingController();
  final TextEditingController _reEnterMpinController = TextEditingController();
  final String sk =  "770A8A65DA156D24EE2A093277530142";
  final String iv = "1234567890123456";
  String mobNumber = "";
  String entityId = "";
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  var otpValue = '';
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
  void requestOtp(String mobnum) async {
    showProgressDialog(context);
    final provider = await OtpRequestRepository().requestOtp(mobnum);
    provider.fold((error) {
      Navigator.pop(context);
      printLog("----------------------ERROR------------------");
      printLog(error);
    }, (otpRequest) {
      Navigator.pop(context);
      print("Otp request stst : ${otpRequest.message.toString()}");
    });
  }

  void verifyOtp(String mobnum, String otp) async {
    showProgressDialog(context);
    final verify = await OtpVerificationRepository().verifyOtp(mobnum, otp);
    verify.fold((error) {
    Navigator.pop(context);
      printLog("-------------------------ERROR---------------------");
      printLog(error);
      showInSnackBar(error!.message.toString(), "RED");
      // EasyLoading.showToast('OTP Verification Failed',
      //     toastPosition: EasyLoadingToastPosition.bottom);
    }, (verifyOtp) {
      Navigator.pop(context);
      print(verifyOtp);
      if (verifyOtp.message!.contains('OTP Verified')) {
        showInSnackBar("OTP Verified", "GREEN");

      }
      if (verifyOtp.message!.contains('OTP Expired')) {

        showInSnackBar("OTP Expired", "RED");

      }
    });
  }

  String? encryptString(
      String textToEncrypt, String? secretKey, String? initialVector) {
    if (textToEncrypt.isEmpty || secretKey == null || initialVector == null) {
      return null;
    }

    try {
      final secretKeyBytes = Uint8List.fromList(secretKey.codeUnits);
      final iv = Uint8List.fromList(initialVector.codeUnits);
      final key = pc.KeyParameter(secretKeyBytes);
      final params = pc.ParametersWithIV(key, iv);
      final cipher = pc.CBCBlockCipher(pc.AESEngine());
      cipher.init(true, params);

      final textBytes = Uint8List.fromList(textToEncrypt.codeUnits);
      final paddedText = padPKCS7(textBytes);

      final encryptedBytes = cipher.process(paddedText);

      return base64.encode(encryptedBytes);
    } catch (e) {
      return null;
    }
  }

  Uint8List padPKCS7(Uint8List input) {
    final padLength = 16 - (input.length % 16);
    final output = Uint8List(input.length + padLength)..setAll(0, input);
    for (var i = input.length; i < output.length; i++) {
      output[i] = padLength;
    }
    return output;
  }
  void showInSnackBar(String value, String color) {
    var snackBar = SnackBar(
      content: Text(
        value,
        style: GoogleFonts.inter(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      backgroundColor:
      color == "RED"?
      Colors.red:
      Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> setMpin(String ep,String mpin,String mobnum) async {
    showProgressDialog(context);
    final setMpin = await SetMpinRepository().setMpin(mpin, mobnum);
    setMpin.fold(
        (error){
          Navigator.pop(context);
          printLog("---------------------ERROR-----------------");
          printLog(error);
        },
        (mpin){

   Navigator.pop(context);
          if(mpin.message!.contains("Otp Not Verified")){
            showInSnackBar("Otp Not Verified", "RED");
             //   EasyLoading.showToast('Otp Not Verified', toastPosition: EasyLoadingToastPosition.bottom);
          }
          if(mpin.message!.contains("MPIN SET")){
                SharedPref.shared.setLogin(true);
                showInSnackBar("MPIN SET", "GREEN");
                SharedPref.shared.setMpinValue(ep.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GooglePinCodePage(),
                  ),
                );
          }

        },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 48),
            child: Text(
              "Forgot Mpin",
              style: GoogleFonts.inter(
                  color: deepTeal, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Request OTP",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Before resetting your mpin please verify your mobile number",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
              child: Container(
                width: 200,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: teal500!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: mobNumber,
                            hintStyle:
                                GoogleFonts.inter(color: Colors.black54)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: InkWell(
                onTap: () async {
                  requestOtp(_phoneNumberController.text);
                },
                child: BuildButton(buttonText: "REQUEST OTP"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: teal500!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.message, color: Colors.black),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter 4 Digit OTP',
                                  hintStyle:
                                      GoogleFonts.inter(color: Colors.black54)),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(4),
                                // Limit to 10 characters
                                FilteringTextInputFormatter.digitsOnly,
                                // Only digits are allowed
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      EasyLoading.show(status: "Please wait...");
                      if (_otpController.text.isNotEmpty) {
                        // handleVerify();
                      } else {
                        EasyLoading.showToast('Enter your OTP',
                            toastPosition: EasyLoadingToastPosition.bottom);
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        verifyOtp(
                            _phoneNumberController.text, _otpController.text);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [deepTeal, deepTeal, yellowGreen],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'VERIFY',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Set Mpin",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
              child: Text("Enter your new mpin in the below fields",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 35, right: 35),
              child: Container(
                width: 200,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: teal500!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _mpinController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Mpin',
                            hintStyle:
                                GoogleFonts.inter(color: Colors.black54)),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          // Limit to 10 characters
                          FilteringTextInputFormatter.digitsOnly,
                          // Only digits are allowed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 35, right: 35),
              child: Container(
                width: 200,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: teal500!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _reEnterMpinController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Re-Enter Mpin',
                            hintStyle:
                                GoogleFonts.inter(color: Colors.black54)),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          // Limit to 10 characters
                          FilteringTextInputFormatter.digitsOnly,
                          // Only digits are allowed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: InkWell(
                onTap: () {
                  if (_mpinController.text.length == 6 &&
                      _reEnterMpinController.text.length == 6 &&
                      _reEnterMpinController.text == _mpinController.text) {
                   // EasyLoading.show(status: "Please wait...");
                    var ep = encryptString(_mpinController.text, sk, iv);
                    print('ep = ${ep}');
                    if (ep != null) {
                      print('ep not null');
                      setMpin(ep,ep,_phoneNumberController.text);
                    } else {
                    //  EasyLoading.dismiss();
                      print('ep null');
                    }
                  } else {
                    EasyLoading.showToast("Please check your mpin",
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }
                },
                child: BuildButton(buttonText: "UPDATE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
