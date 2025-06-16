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
    print("fcmTok $fcmTok");
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
/*  Future<void> validateMpinFingerAuth() async {
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
  }*/

  String? encryptString(
      String textToEncrypt, String? secretKey, String? initialVector)
  {
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
          "Enter Your 6-Digit MPIN",
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
                      size: 60,
                      color: home2,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Enter your secure MPIN",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: home2.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // PIN Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return AnimatedContainer(
                          duration:const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          margin:const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < pin.length ? home2 : home2.withOpacity(0.2),
                            border: Border.all(
                              color: home2,
                              width: 1.5,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                // Number Pad
                Column(
                  children: [
                    GridView.count(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      padding: EdgeInsets.zero,
                      children: [
                        for (int i = 1; i <= 9; i++) _buildNumberButton(i),
                        _buildBackButton(),
                        _buildNumberButton(0),
                        _buildBiometricButton(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: validateMpin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: home2,
                          padding:const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "SUBMIT",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>const ForgotMpinPage()
                          ),
                        );
                      },
                      child: Text(
                        "Forgot MPIN?",
                        style: GoogleFonts.poppins(
                          color: home1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          if (pin.length < 6) {
            setState(() {
              pin += number.toString();
            });
          }
        },
        child: Center(
          child: Text(
            number.toString(),
            style: GoogleFonts.poppins(
              fontSize: 28,
              color: home2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          if (pin.isNotEmpty) {
            setState(() {
              pin = pin.substring(0, pin.length - 1);
            });
          }
        },
        child:const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: home2,
            size: 28,
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
            size: 32,
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: white,
  //     appBar: AppBar(
  //       backgroundColor: white,
  //       centerTitle: true,
  //       title: Text(
  //         "Enter 6 Digit M-PIN",
  //         style:
  //         TextStyle(color: deepTeal, fontWeight: FontWeight.w700),
  //       ),
  //     ),
  //     resizeToAvoidBottomInset: false,
  //     body: Padding(
  //       padding:
  //       const EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 10),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 // Display 6 PIN fields with smaller circles
  //                 for (int i = 0; i < 6; i++) buildPinField(i),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             buildNumberPad(),
  //             const SizedBox(height: 20),
  //             GestureDetector(
  //                 onTap: () {
  //                   validateMpin();
  //                 },
  //                 child: const BuildButton(buttonText: "submit")),
  //             const SizedBox(height: 10),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => ForgotMpinPage()));
  //               },
  //               child: Text(
  //                 "Forgot M-PIN?",
  //                 style: TextStyle(color: const Color(0xFF4200FF)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget buildPinField(int index) {
  //   return Container(
  //     width: 22.0,
  //     height: 22.0,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: index < pin.length ? Colors.black : const Color(0xFFD9D9D9),
  //     ),
  //   );
  // }
  //
  // Widget buildNumberPad() {
  //   return GridView.count(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     crossAxisCount: 3,
  //     children: [
  //       for (int i = 1; i <= 9; i++) buildIconButton(i),
  //       TextButton(
  //         onPressed: () {
  //           setState(() {
  //             if (pin.isNotEmpty) {
  //               setState(() {
  //                 pin = pin.substring(0, pin.length - 1);
  //               });
  //             }
  //           });
  //         },
  //         child: const Icon(
  //           Icons.arrow_back_ios,
  //           color: deepTeal,
  //           size: 40,
  //         ),
  //       ),
  //       buildIconButton(0),
  //     ],
  //   );
  // }
  //
  // Widget buildIconButton(int number) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         if (pin.length < 6) {
  //           pin += number.toString();
  //         }
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           color: deepTeal.withOpacity(0.6),
  //         ),
  //         child: Center(
  //           child: Text(number.toString(),
  //               style: TextStyle(
  //                 fontSize: 35.0,
  //                 color: white,
  //               )),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

