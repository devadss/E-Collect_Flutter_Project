import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/core/shared_pref_helper.dart';
import 'package:collection_qr_flutter/data/provider/set_mpin_provider.dart';
import 'package:collection_qr_flutter/presentation/auth/authetication_page/google_pin_code_page.dart';
import 'package:provider/provider.dart';
import 'package:pointycastle/export.dart' as pc;
import '../../../build_button.dart';
import '../../../core/colors.dart';

class SetMpinPage extends StatefulWidget {
  final String monNumber;

  const SetMpinPage({super.key, required this.monNumber});

  @override
  State<SetMpinPage> createState() => _SetMpinPageState();
}

class _SetMpinPageState extends State<SetMpinPage> {
  final String _sk = "770A8A65DA156D24EE2A093277530142";
  final String _iv = "1234567890123456";
  final List<TextEditingController> _mpinController =
      List.generate(6, (_) => TextEditingController());

  final List<TextEditingController> _confirmMpinController =
      List.generate(6, (_) => TextEditingController());

  String? errorMsg;

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

  Uint8List padPKCS7(Uint8List input) {
    final padLength = 16 - (input.length % 16);
    final output = Uint8List(input.length + padLength)..setAll(0, input);
    for (var i = input.length; i < output.length; i++) {
      output[i] = padLength;
    }
    return output;
  }

  String? encryptPasswordString(
      String textToEncrypt, String? secretKey, String? initialVector) {
    if (textToEncrypt.isEmpty || secretKey == null || initialVector == null) {
      return null;
    }

    try {
      final secretKeyBytes = Uint8List.fromList(secretKey.codeUnits);
      final iv = Uint8List.fromList(initialVector.codeUnits);
      final key = pc.KeyParameter(secretKeyBytes);
      final params = pc.ParametersWithIV(key, iv);
      final cipher = pc.CBCBlockCipher(pc.AESFastEngine());
      cipher.init(true, params);

      final textBytes = Uint8List.fromList(textToEncrypt.codeUnits);
      final paddedText = padPKCS7(textBytes);

      final encryptedBytes = cipher.process(paddedText);

      return base64.encode(encryptedBytes);
    } catch (e) {
      return null;
    }
  }

  Future<void> validateMpin() async {
    String pinOne = _mpinController.map((controller) => controller.text).join();
    String pinTwo =
        _confirmMpinController.map((controller) => controller.text).join();

    if (pinOne.length == 6 && pinTwo.length == 6) {
      if (pinOne == pinTwo) {
        showProgressDialog(context);
        final provider = Provider.of<SetMpinProvider>(context, listen: false);

        final response = await provider.setMpin(
            encryptPasswordString(pinTwo, _sk, _iv).toString(),
            widget.monNumber);

        response.fold(
          (error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Error: ${error}",
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  backgroundColor: Colors.red,
                )
            );
          },
          (data) {
            Navigator.pop(context);
            print("MPIN RESPONSE : ${data.message}");
            SharedPref.shared.setLogin(true);
            SharedPref.shared.setMpinStatus("MPIN_S");
            SharedPref.shared.setMpinValue(encryptPasswordString(pinTwo, _sk, _iv).toString());
            data.message == "MPIN SET"
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GooglePinCodePage()))
                : "";
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "MPIN MIS-MATCH",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
              ),
              backgroundColor: Colors.red,
            )
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ENTER 6 DIGIT MPIN",
              style:
              GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
            ),
            backgroundColor: Colors.red,
          )      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  "assets/images/mpin_page.jpg",
                  scale: 6,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Let's Create Mpin",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                "Before continuing, create an MPIN. You are required to set a 6-digit MPIN.",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: black54,
                ),
              ),
              const SizedBox(height: 20),
              _buildMpinField("Enter 6-digit M-PIN", _mpinController),
              const SizedBox(height: 20),
              _buildMpinField("Re-enter 6-digit M-PIN", _confirmMpinController),
              if (errorMsg != null) ...[
                const SizedBox(height: 5),
                Text(
                  errorMsg!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      validateMpin();
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> GooglePinCodePage()));
                    },
                    child: const BuildButton(buttonText: "Continue"),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMpinField(
      String label, List<TextEditingController> controllers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (index) => Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: deepTeal.withOpacity(0.4),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
