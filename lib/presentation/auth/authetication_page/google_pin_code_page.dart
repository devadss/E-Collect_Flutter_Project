import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:collection_qr_flutter/data/provider/auth_provider.dart';
import 'package:collection_qr_flutter/presentation/screens/home/bottom_nav_bar_page.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/build_button.dart';
import '../../../core/colors.dart';
import '../../../data/service/notification_service/notification_service.dart';
import '../forgot_mpin_page.dart';

class GooglePinCodePage extends StatefulWidget {
  const GooglePinCodePage({super.key});

  @override
  State<GooglePinCodePage> createState() => _GooglePinCodePageState();
}

class _GooglePinCodePageState extends State<GooglePinCodePage> {
  String pin = "";
  String custID = "";
  String token = "";
  String m_pin = "";
  String mpin = "";
  String fcmToken = "";
  String contactNum = ""; // contains +91
  bool _isClicked = false;
  final LocalAuthentication auth = LocalAuthentication();
  final String _sk = "770A8A65DA156D24EE2A093277530142";
  final String _iv = "1234567890123456";

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  void loadSharedData() async {
    String custid = await SharedPref.shared.getAgentId();
    token = await SharedPref.shared.getTokenValue();
    String fcmTok = await SharedPref.shared.getFcmToken();
    m_pin = await SharedPref.shared.getMpinValue();

    String mobNum = await SharedPref.shared.getMobNum();
    setState(() {
      contactNum = mobNum;
      mpin = m_pin;
      custID = custid;
      fcmToken = fcmTok;
    });
    print("MPIN $mpin");
    _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      print('PlatformException: $e');
      //  EasyLoading.showToast('Biometric/PIN authentication is not available');
      return;
    } on Exception catch (e) {
      print('Exception during authentication: $e');
      //  EasyLoading.showToast('Authentication error');
      return;
    }

    if (!authenticated) {
      // Instead of popping the current screen, show a toast message
      //  EasyLoading.dismiss();
      // EasyLoading.showToast('Authentication canceled');
    } else {
      validateMpinFingerAuth();
    }
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

  Future<void> validateMpin() async {
    print("validateMpin");
    if (pin.isNotEmpty) {
      if (pin.length == 6) {
        showProgressDialog(context);
        final provider = Provider.of<AuthProvider>(context, listen: false);
        final response = await provider.getAuthResult(
            contactNum, encryptString(pin, _sk, _iv).toString(), token);

        response.fold(
          (error) {
            Navigator.pop(context);
            print("Error: ${error?.message}");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Error: ${error.message}- Invalid M-pin",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17),
              ),
              backgroundColor: Colors.red,
            ));
          },
          (data) {
            ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text("RESULT: ${data.message}")),
                SnackBar(
              content: Text(
                "${data.message}",
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              backgroundColor: Colors.green,
            ));
            Navigator.pop(context);
            if (data.message == "Login Successfull") {
              if (fcmToken.isNotEmpty) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BottomNavScreen()));
              }else{
                saveFcmToken(custID, context, "GPIN", token, contactNum, mpin);
              }

            }
          },
        );

        print("MPIN = ${encryptString(pin, _sk, _iv)}");
      } else {
        print("Enter 6 digit mpin");
      }
    } else {
      print("Empty fields not allowed");
    }
  }

  Future<void> validateMpinFingerAuth() async {
    print("validateMpinFingerAuth");
    if (mpin.isNotEmpty) {
      print("mpin.isNotEmpty");
      print("mpin = $mpin");

      showProgressDialog(context);
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final response = await provider.getAuthResult(contactNum, mpin, token);

      response.fold(
        (error) {
          Navigator.pop(context);
          print("Error: ${error?.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Error: ${error.message}- Invalid M-pin",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
            ),
            backgroundColor: Colors.red,
          ));
        },
        (data) {
          Navigator.pop(context);
          print("data.message = ${data.message}");
          if (data.message == "Login Successfull") {
            if (fcmToken.isNotEmpty) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNavScreen()));
            } else {
              saveFcmToken(custID, context, "GPIN", token, contactNum, mpin);
            }
          }
          // Navigator.pop(context);
        },
      );

      print("MPIN = $mpin");
    } else {
      print("Empty fields not allowed");
    }
  }

  String? encryptString(
      String textToEncrypt, String? secretKey, String? initialVector) {
    print("-------------------encryptString values----------------");
    print("textToEncrypt : $textToEncrypt");
    print("secretKey : $secretKey");
    print("initialVector : $initialVector");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Enter 6 Digit M-PIN",
          style:
              GoogleFonts.inter(color: deepTeal, fontWeight: FontWeight.w700),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Display 6 PIN fields with smaller circles
                  for (int i = 0; i < 6; i++) buildPinField(i),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              buildNumberPad(),
              const SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    validateMpin();
                  },
                  child: const BuildButton(buttonText: "submit")),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotMpinPage()));
                },
                child: Text(
                  "Forgot M-PIN?",
                  style: GoogleFonts.inter(color: const Color(0xFF4200FF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPinField(int index) {
    return Container(
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index < pin.length ? Colors.black : const Color(0xFFD9D9D9),
      ),
    );
  }

  Widget buildNumberPad() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      children: [
        for (int i = 1; i <= 9; i++) buildIconButton(i),
        TextButton(
          onPressed: () {
            setState(() {
              if (pin.isNotEmpty) {
                setState(() {
                  pin = pin.substring(0, pin.length - 1);
                });
              }
            });
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: deepTeal,
            size: 40,
          ),
        ),
        buildIconButton(0),
      ],
    );
  }

  Widget buildIconButton(int number) {
    return InkWell(
      onTap: () {
        setState(() {
          if (pin.length < 6) {
            pin += number.toString();
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: deepTeal.withOpacity(0.6),
          ),
          child: Center(
            child: Text(number.toString(),
                style: GoogleFonts.inter(
                  fontSize: 35.0,
                  color: white,
                )),
          ),
        ),
      ),
    );
  }
}
