import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/colors.dart';
import '../../../data/provider/auth_provider.dart';
import '../../../data/service/notification_service/notification_service.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../app/bottom_nav_bar_page.dart';

class GooglePinCodePage extends StatefulWidget {
  const GooglePinCodePage({super.key});

  @override
  State<GooglePinCodePage> createState() => _GooglePinCodePageState();
}

class _GooglePinCodePageState extends State<GooglePinCodePage> {
  String pin = "";
  String custID = "";
  String token = "";
  bool authenticated = false;
  String mpin = "";
  String fcmToken = "";
  String contactNum = ""; // contains +91
  String subAgentContactNum = ""; // contains +91
  final LocalAuthentication auth = LocalAuthentication();
  final String _sk = "770A8A65DA156D24EE2A093277530142";
  final String _iv = "1234567890123456";

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  void loadSharedData() async {
   String custid = await SharedPref.shared.getSubAgentId();

    String tok = await SharedPref.shared.getTokenValue();
    String fcmTok = await SharedPref.shared.getFcmToken();
    String m_pin = await SharedPref.shared.getMpinValue();
    String mobNum = await SharedPref.shared.getParentAgentMobNum();
    String subAgentMobNum = await SharedPref.shared.getSubAgentMobNum();
    setState(() {
      token = tok;
      contactNum = mobNum;
      mpin = m_pin;
      subAgentContactNum =subAgentMobNum;
      custID = custid;
      fcmToken = fcmTok;
    });
    print("contactNum $contactNum");
    print("MPIN $mpin");
    print("fcmTok $fcmTok");
    _authenticateWithBiometrics();
  }
  Future<void> _authenticateWithBiometrics() async {


    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        print('No biometric or device auth support');
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: false, // ✅ Allows device PIN/password fallback
          stickyAuth: false,
        ),
      );
      validateMpinFingerAuth();
    } on PlatformException catch (e) {
      authenticated = true;
      validateMpinFingerAuth();
      print('PlatformException during biometric auth: ${e.code} - ${e.message}');
      return;
    } on Exception catch (e) {
      print('Exception during biometric authentication: $e');
      return;
    }

    if (!authenticated) {
      print('Authentication canceled by user.');
      return;
    }

   // validateMpinFingerAuth();
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
                child:const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
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
            contactNum,
            encryptString(pin, _sk, _iv).toString(),
            token);

        response.fold(
              (error) {
            Navigator.pop(context);
            print("Error: ${error.message}");
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
            //Navigator.pop(context);
            if (data.message == "Login Successfull") {
              if (fcmToken.isNotEmpty) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BottomNavScreen()));
              }else{
                saveFcmToken(custID, context, "GPIN", token, subAgentContactNum, mpin);
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
    if (fcmToken.isNotEmpty && authenticated== true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()));
    }
    else if(fcmToken.isEmpty && authenticated== true){
      await  saveFcmToken(custID, context, "GPIN", token, subAgentContactNum, mpin);

    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text("Authentication Error", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
        ),
      );
    }


      print("MPIN = $mpin");
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
      backgroundColor: white, // Using home2 as background
      appBar: AppBar(
        backgroundColor: white, // Matching background
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Please authenticate to proceed",
          style: GoogleFonts.poppins(
            color: home2, // Using home2 for text
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: home2,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Authenticate to Continue",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: home2.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // Number Pad
                Column(
                  children: [
                    GridView.count(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 1,
                      childAspectRatio: 2.5,
                      padding: EdgeInsets.zero,
                      children: [
                        _buildBiometricButton()
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildBiometricButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: _authenticateWithBiometrics,
        child:const Center(
          child: Icon(
            Icons.fingerprint,
            color: home2,
            size: 100,
          ),
        ),
      ),
    );
  }

}

