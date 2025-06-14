// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:pointycastle/export.dart' as pc;
// import '../../core/colors.dart';
// import '../../data/provider/token_request_provider.dart';
// import '../../data/storage/shared_pref_helper.dart';
// import '../../widgets/build_button.dart';
// import 'authetication_page/google_pin_code_page.dart';
// import 'forgot_username_password_page.dart';
// import 'otp_verification.dart';
//
// class LoginPage extends StatefulWidget {
//   final String mobNum;
//   final String tokenStatus;
//
//   const LoginPage({super.key, required this.mobNum, required this.tokenStatus});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final String _sk = "770A8A65DA156D24EE2A093277530142";
//   final String _iv = "1234567890123456";
//   bool isObscured = true;
//
//   void toggleVisibility() {
//     setState(() {
//       isObscured = !isObscured;
//     });
//   }
//
//   Uint8List padPKCS7(Uint8List input) {
//     final padLength = 16 - (input.length % 16);
//     final output = Uint8List(input.length + padLength)..setAll(0, input);
//     for (var i = input.length; i < output.length; i++) {
//       output[i] = padLength;
//     }
//     return output;
//   }
//
//   String? encryptString(
//       String textToEncrypt, String? secretKey, String? initialVector) {
//     if (textToEncrypt.isEmpty || secretKey == null || initialVector == null) {
//       return null;
//     }
//
//     try {
//       final secretKeyBytes = Uint8List.fromList(secretKey.codeUnits);
//       final iv = Uint8List.fromList(initialVector.codeUnits);
//       final key = pc.KeyParameter(secretKeyBytes);
//       final params = pc.ParametersWithIV(key, iv);
//       final cipher = pc.CBCBlockCipher(pc.AESEngine());
//       cipher.init(true, params);
//
//       final textBytes = Uint8List.fromList(textToEncrypt.codeUnits);
//       final paddedText = padPKCS7(textBytes);
//
//       final encryptedBytes = cipher.process(paddedText);
//
//       return base64.encode(encryptedBytes);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       const CircularProgressIndicator(color: home2),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please wait....",
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   Future<void> credentialValidation() async {
//     showProgressDialog(context);
//     if (userNameController.text.isNotEmpty &&
//         passwordController.text.isNotEmpty) {
//       final provider =
//       Provider.of<TokenRequestProvider>(context, listen: false);
//
//       final response = await provider.requestToken(
//           userNameController.text,
//           encryptString(passwordController.text.toString(), _sk, _iv)
//               .toString(),
//           widget.mobNum,
//           "Mob");
//
//       response.fold(
//             (error) {
//           Navigator.pop(context);
//           if (error == "User not found") {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   "Incorrect Username or Password",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17),
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   "Error: $error",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17),
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//             (data) {
//           Navigator.pop(context);
//           print("Token status : ${widget.tokenStatus}");
//           SharedPref.shared.setTokenValue(data);
//           SharedPref.shared.setAgentName(userNameController.text.toString());
//           SharedPref.shared.setPassword(
//               encryptString(passwordController.text.toString(), _sk, _iv)
//                   .toString()
//           );
//           if (widget.tokenStatus == "MPIN_N") {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => OtpVerification(
//                       mobNum: widget.mobNum,
//                     )));
//           } else {
//             SharedPref.shared.setLogin(true);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const GooglePinCodePage()));
//           }
//         },
//       );
//     } else {
//       Navigator.pop(context);
//       showInSnackBar("Empty fields not allowed");
//     }
//   }
//
//   void showInSnackBar(String value) {
//     var snackBar = SnackBar(
//       content: Text(
//         value,
//         style: TextStyle(
//             color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
//       ),
//       backgroundColor: Colors.red,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Center(
//                   child: Image.asset("assets/images/login.jpg",
//                       width: 300, height: 300, fit: BoxFit.fill, scale: 28),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 10),
//                       Text(
//                         "User Authentication",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 23,
//                             color: black),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 70,
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         decoration: BoxDecoration(
//                           color: deepTeal.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.person, color: black),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: TextField(
//                                 controller: userNameController,
//                                 keyboardType: TextInputType.name,
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'Enter your user name',
//                                   contentPadding:
//                                   EdgeInsets.symmetric(vertical: 15.0),
//                                 ),
//                                 inputFormatters: <TextInputFormatter>[
//                                   LengthLimitingTextInputFormatter(10),
//                                   FilteringTextInputFormatter.singleLineFormatter,
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       Container(
//                         height: 70,
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         decoration: BoxDecoration(
//                           color: deepTeal.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.lock, color: black),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: TextField(
//                                 controller: passwordController,
//                                 obscureText: isObscured,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'Enter Password',
//                                   hintStyle:
//                                   TextStyle(color: Colors.black54),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       isObscured
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                     ),
//                                     onPressed: toggleVisibility,
//                                   ),
//                                 ),
//                                 inputFormatters: <TextInputFormatter>[
//                                   LengthLimitingTextInputFormatter(15),
//                                   FilteringTextInputFormatter.singleLineFormatter,
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 50, right: 50, top: 50, bottom: 20),
//                   child: GestureDetector(
//                       onTap: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         credentialValidation();
//                       },
//                       child: const BuildButton(buttonText: "LOGIN")),
//                 ),
//                 // GestureDetector(
//                 //   onTap: (){
//                 //     Navigator.push(context, MaterialPageRoute(builder: (context)=>
//                 //      ForgotUsernamePasswordPage(mobNum: widget.mobNum)));
//                 //   },
//                 //
//                 //   child: Text(
//                 //     "Forgot username or password ?",
//                 //     style: TextStyle(
//                 //         color: Colors.indigo,
//                 //         fontSize: 17,
//                 //         fontWeight: FontWeight.w400),
//                 //   ),
//                 // )
//                 const SizedBox(height: 40),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ForgotUsernamePasswordPage(mobNum: widget.mobNum,)));
//                   },
//                   child: Center(
//                     child: Text(
//                       "Forgot Username / Password?",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           decoration: TextDecoration.underline,
//                           color: colorBlue,
//                           decorationColor: colorBlue),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
//
//



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pointycastle/export.dart' as pc;
import '../../core/colors.dart';
import '../../data/provider/token_request_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import 'authetication_page/google_pin_code_page.dart';
import 'forgot_username_password_page.dart';
import 'otp_verification.dart';

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

  // All your existing methods remain exactly the same...
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
              const SnackBar(
                content: Text(
                  "Incorrect Username or Password",
                  style: TextStyle(
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
                  style:const TextStyle(
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
          SharedPref.shared.setAgentName(userNameController.text.toString());
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
        style:const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "assets/images/login.jpg",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Welcome back",
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign in with your username and password",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              _buildUberStyleTextField(
                controller: userNameController,
                label: "Username",
                icon: Icons.person_outline,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
              const SizedBox(height: 20),
              _buildUberStyleTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                ),
                obscureText: isObscured,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    credentialValidation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color(0xFFEA307B), // Your existing pink color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "LOG IN",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotUsernamePasswordPage(
                                mobNum: widget.mobNum
                            )
                        )
                    );
                  },
                  child: Text(
                    "Forgot username or password?",
                    style: GoogleFonts.roboto(
                      color:const Color(0xFFEA307B), // Your existing pink color
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUberStyleTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color:const Color(0xFFEA307B)), // Your pink color
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:const BorderSide(color: Color(0xFFEA307B), width: 1.5), // Pink border
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             // Hero Section
  //             Container(
  //               height: MediaQuery.of(context).size.height * 0.3,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [Color(0xFFEA307B), Color(0xFF470952)],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(30),
  //                   bottomRight: Radius.circular(30),
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Image.asset(
  //                       "assets/images/login.jpg",
  //                       width: 150,
  //                       height: 150,
  //                       fit: BoxFit.contain,
  //                     ),
  //                     SizedBox(height: 20),
  //                     Text(
  //                       "Welcome Back",
  //                       style: GoogleFonts.poppins(
  //                         color: Colors.white,
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(height: 8),
  //                     Text(
  //                       "Please enter your credentials",
  //                       style: GoogleFonts.poppins(
  //                         color: Colors.white.withOpacity(0.9),
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //
  //             // Form Section
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "User Authentication",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.black87,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(height: 30),
  //
  //                   // Username Field
  //                   Text(
  //                     "Username",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.black87,
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(height: 8),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.1),
  //                           blurRadius: 10,
  //                           spreadRadius: 2,
  //                         ),
  //                       ],
  //                       border: Border.all(
  //                         color: Colors.grey.withOpacity(0.2),
  //                       ),
  //                     ),
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 15),
  //                       child: Row(
  //                         children: [
  //                           Icon(Icons.person_outline, color: Color(0xFFEA307B)),
  //                           SizedBox(width: 10),
  //                           Expanded(
  //                             child: TextField(
  //                               controller: userNameController,
  //                               style: GoogleFonts.poppins(
  //                                 color: Colors.black87,
  //                                 fontSize: 16,
  //                               ),
  //                               decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 hintText: 'Enter your username',
  //                                 hintStyle: GoogleFonts.poppins(
  //                                   color: Colors.grey.withOpacity(0.7),
  //                                 ),
  //                               ),
  //                               inputFormatters: [
  //                                 LengthLimitingTextInputFormatter(10),
  //                                 FilteringTextInputFormatter.singleLineFormatter,
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 25),
  //
  //                   // Password Field
  //                   Text(
  //                     "Password",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.black87,
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(height: 8),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.1),
  //                           blurRadius: 10,
  //                           spreadRadius: 2,
  //                         ),
  //                       ],
  //                       border: Border.all(
  //                         color: Colors.grey.withOpacity(0.2),
  //                       ),
  //                     ),
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 15),
  //                       child: Row(
  //                         children: [
  //                           Icon(Icons.lock_outline, color: Color(0xFFEA307B)),
  //                           SizedBox(width: 10),
  //                           Expanded(
  //                             child: TextField(
  //                               controller: passwordController,
  //                               obscureText: isObscured,
  //                               style: GoogleFonts.poppins(
  //                                 color: Colors.black87,
  //                                 fontSize: 16,
  //                               ),
  //                               decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 hintText: 'Enter your password',
  //                                 hintStyle: GoogleFonts.poppins(
  //                                   color: Colors.grey.withOpacity(0.7),
  //                                 ),
  //                                 suffixIcon: IconButton(
  //                                   icon: Icon(
  //                                     isObscured
  //                                         ? Icons.visibility_outlined
  //                                         : Icons.visibility_off_outlined,
  //                                     color: Colors.grey,
  //                                   ),
  //                                   onPressed: toggleVisibility,
  //                                 ),
  //                               ),
  //                               inputFormatters: [
  //                                 LengthLimitingTextInputFormatter(15),
  //                                 FilteringTextInputFormatter.singleLineFormatter,
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 40),
  //
  //                   // Login Button
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         FocusManager.instance.primaryFocus?.unfocus();
  //                         credentialValidation();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Color(0xFFEA307B),
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         elevation: 5,
  //                         shadowColor: Color(0xFFEA307B).withOpacity(0.3),
  //                       ),
  //                       child: Text(
  //                         "LOGIN",
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 30),
  //
  //                   // Forgot Password Link
  //                   Center(
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => ForgotUsernamePasswordPage(
  //                                     mobNum: widget.mobNum)));
  //                       },
  //                       child: Text(
  //                         "Forgot Username / Password?",
  //                         style: GoogleFonts.poppins(
  //                           color: Color(0xFFEA307B),
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}