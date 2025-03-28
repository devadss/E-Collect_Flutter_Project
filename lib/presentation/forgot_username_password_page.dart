import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/general.dart';
import '../../core/shared_pref_helper.dart';
import '../../data/repository/cust_reg_repository.dart';
import '../build_button.dart';
import '../core/colors.dart';
import '../data/repository/update_dop_repository.dart';
import '../data/repository/update_password_repository.dart';
import 'auth/mobile_number_password_page.dart';

class ForgotUsernamePasswordPage extends StatefulWidget {
  final String mobNum;
  const ForgotUsernamePasswordPage({super.key, required this.mobNum});

  @override
  State<ForgotUsernamePasswordPage> createState() =>
      _ForgotUsernamePasswordPageState();
}

class _ForgotUsernamePasswordPageState
    extends State<ForgotUsernamePasswordPage> {
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

  final String sk = "770A8A65DA156D24EE2A093277530142";
  final String iv = "1234567890123456";
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();
  String? encryptPassword;
  //String? userName;
 // String? phoneNumber;

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref.shared.getUserName();
    final phone = await SharedPref.shared.getMobNum();
    printLog("-------------------USERNAME---------------");
    print(name);

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        // userName = name;
        // phoneNumber = phone;
      });
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

  Future<void> resetCredentials(String encrypted) async {
    final result = await UpdatePasswordRepository()
        .updatePassword(_nameController.text.toString(), encrypted, encrypted, widget.mobNum);
    result.fold((error) {
      printLog("------------------ERROR----------------");
      printLog(error);
    }, (update) {
      if (update.message!.contains('Password Updated Successfully')) {
        // EasyLoading.showToast('Password Updated Successfully',
        //     toastPosition: EasyLoadingToastPosition.bottom);
        checkIfRegistered(_nameController.text, encryptPassword!);
      }
    });
  }

  Future<void> checkIfRegistered(
      String userNameValue, String passwordValue) async {
    final checkIfReg =
        await CustRegRepository().checkRegCust(int.parse(widget.mobNum));
    checkIfReg.fold((error) {
      printLog("--------------------ERROR_----------------------");
      printLog(error);
    }, (custData) {
      updateDopUserCredentials(
          userNameValue,
          passwordValue,
          custData.response!.data!.custId.toString(),
          custData.status.toString());
    });
  }

  Future<void> updateDopUserCredentials(String userNameValue,
      String passwordValue, String entityID, String tokenStatus) async {
    print('updateDopUserCredentials');
    final updateDop = await UpdateDopRepository()
        .getUpdateDop(entityID, userNameValue, passwordValue);
    updateDop.fold((error) {
    //  EasyLoading.dismiss();
      printLog("---------------------ERROR_-----------------------");
      printLog(error);
    }, (data) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    mobNum: widget.mobNum,
                    tokenStatus: tokenStatus,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Reset Credentials",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 23, color: deepTeal),
        ),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Image.asset("assets/images/reset-password.png", scale: 3),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: GoogleFonts.inter(color: deepTeal),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(8)
                    ],
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.inter(color: deepTeal),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reenterPasswordController,
                    obscureText: true,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(8)
                    ],
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: GoogleFonts.inter(color: deepTeal),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: deepTeal, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      // if(_nameController.text.isEmpty ||
                      //     _passwordController.text.isEmpty||
                      //     _reenterPasswordController.text.isEmpty){
                      //   showInSnackBar("EMPTY FIELDS NOT ALLOWED");
                      // }
                      if (_passwordController.text.length >= 8 &&
                          _reenterPasswordController.text.length >= 8) {
                        if (_passwordController.text ==
                            _reenterPasswordController.text) {
                          print("BOTH ARE SAME");
                          var ep =
                              encryptString(_passwordController.text, sk, iv);
                          print('ep = $ep');
                          if (ep != null) {
                            print('ep not null');
                            encryptPassword = ep;
                            resetCredentials(encryptPassword!);
                          } else {
                            print('ep null');
                          }
                        } else {
                          showInSnackBar("Password do not match");
                         // EasyLoading.showToast('Password do not match');
                        }
                      }
                      else {
                        print(
                            "_passwordController.text.length = ${_passwordController.text.length}");
                        print(
                            "_passwordController.text.length = ${_passwordController.text}");
                        print(
                            "_reenterPasswordController.text.length = ${_reenterPasswordController.text.length}");
                        print(
                            "_reenterPasswordController.text.length = ${_reenterPasswordController.text}");
                        // EasyLoading.showToast(
                        //     'Password length must be of 8 characters',
                        //     toastPosition: EasyLoadingToastPosition.bottom);
                        showInSnackBar("PPassword length must be of 8 characters");
                      }


                    },
                    child: const BuildButton(buttonText: "Confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
