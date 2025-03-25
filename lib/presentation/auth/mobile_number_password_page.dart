import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app_flutter/core/shared_pref_helper.dart';
import 'package:merchant_app_flutter/data/provider/token_request_provider.dart';
import 'package:merchant_app_flutter/presentation/auth/authetication_page/google_pin_code_page.dart';
import 'package:merchant_app_flutter/presentation/auth/otp_verification.dart';
import 'package:provider/provider.dart';
import 'package:pointycastle/export.dart' as pc;
import '../../build_button.dart';
import '../../core/colors.dart';

class LoginPage extends StatefulWidget {
  final String mobNum;
  final String tokenStatus;

  const LoginPage({super.key, required this.mobNum, required this.tokenStatus});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String _sk = "770A8A65DA156D24EE2A093277530142";
  final String _iv = "1234567890123456";
  bool isObscured = true;

  void toggleVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  Uint8List padPKCS7(Uint8List input) {
    final padLength = 16 - (input.length % 16);
    final output = Uint8List(input.length + padLength)..setAll(0, input);
    for (var i = input.length; i < output.length; i++) {
      output[i] = padLength;
    }
    return output;
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
                      const CircularProgressIndicator(),
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

  Future<void> credentialValidation() async {
    showProgressDialog(context);
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      final provider =
          Provider.of<TokenRequestProvider>(context, listen: false);

      final response = await provider.requestToken(
          userNameController.text,
          encryptString(passwordController.text.toString(), _sk, _iv)
              .toString(),
          widget.mobNum,
          "Mob");

      response.fold(
        (error) {
          Navigator.pop(context);
          if (error == "User not found") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Incorrect Username or Password",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Error: $error",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (data) {
          Navigator.pop(context);
          print("Token status : ${widget.tokenStatus}");
          SharedPref.shared.setTokenValue(data);
          SharedPref.shared.setUserName(userNameController.text.toString());
          SharedPref.shared.setPassword(
              encryptString(passwordController.text.toString(), _sk, _iv)
                  .toString()
          );
          if (widget.tokenStatus == "MPIN_N") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpVerification(
                          mobNum: widget.mobNum,
                        )));
          } else {
            SharedPref.shared.setLogin(true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GooglePinCodePage()));
          }
        },
      );
    } else {
      Navigator.pop(context);
      showInSnackBar("Empty fields not allowed");
    }
  }

  void showInSnackBar(String value) {
    var snackBar = SnackBar(
      content: Text(
        value,
        style: GoogleFonts.inter(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        body: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.asset("assets/images/login.jpg",
                  width: 300, height: 300, fit: BoxFit.fill, scale: 28),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "User Authentication",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                        color: black),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: deepTeal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: userNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your user name',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: deepTeal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, color: black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            obscureText: isObscured,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Password',
                              hintStyle:
                                  GoogleFonts.inter(color: Colors.black54),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: toggleVisibility,
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(15),
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 50, bottom: 20),
              child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    credentialValidation();
                  },
                  child: const BuildButton(buttonText: "LOGIN")),
            ),
            Text(
              "Forgot username or password ?",
              style: GoogleFonts.inter(
                  color: Colors.indigo,
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            )
          ],
        ));
  }
}


