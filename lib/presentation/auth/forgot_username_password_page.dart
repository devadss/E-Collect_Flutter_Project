// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:pointycastle/export.dart' as pc;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/general.dart';
// import '../../data/storage/shared_pref_helper.dart';
// import '../../../data/repository/cust_reg_repository.dart';
// import '../../core/colors.dart';
// import '../../data/repository/update_dop_repository.dart';
// import '../../data/repository/update_password_repository.dart';
// import 'mobile_number_password_page.dart';
//
// class ForgotUsernamePasswordPage extends StatefulWidget {
//   final String mobNum;
//   const ForgotUsernamePasswordPage({super.key, required this.mobNum});
//
//   @override
//   State<ForgotUsernamePasswordPage> createState() =>
//       _ForgotUsernamePasswordPageState();
// }
//
// class _ForgotUsernamePasswordPageState
//     extends State<ForgotUsernamePasswordPage> {
//   String? token;
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
//   Uint8List padPKCS7(Uint8List input) {
//     final padLength = 16 - (input.length % 16);
//     final output = Uint8List(input.length + padLength)..setAll(0, input);
//     for (var i = input.length; i < output.length; i++) {
//       output[i] = padLength;
//     }
//     return output;
//   }
//
//   final String sk = "770A8A65DA156D24EE2A093277530142";
//   final String iv = "1234567890123456";
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _reenterPasswordController = TextEditingController();
//   String? encryptPassword;
//   //String? userName;
//   // String? phoneNumber;
//
//   Future<void> loadSharedPrefs() async {
//     final name = await SharedPref.shared.getAgentName();
//     final phone = await SharedPref.shared.getMobNum();
//     final tok = await SharedPref.shared.getTokenValue();
//     printLog("-------------------USERNAME---------------");
//     print(name);
//
//     // Trigger rebuild after fetching the userName
//     if (mounted) {
//       setState(() {
//         token = tok ;
//         // userName = name;
//         // phoneNumber = phone;
//       });
//     }
//   }
//
//   // void showInSnackBar(String value) {
//   //   var snackBar = SnackBar(
//   //     content: Text(
//   //       value,
//   //       style: TextStyle(
//   //           color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
//   //     ),
//   //     backgroundColor: Colors.red,
//   //   );
//   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   // }
//
//   Future<void> resetCredentials(String encrypted) async {
//     final result = await UpdatePasswordRepository()
//         .updatePassword(_nameController.text.toString(), encrypted, encrypted, widget.mobNum,token!);
//     result.fold((error) {
//       printLog("------------------ERROR----------------");
//       printLog(error);
//     }, (update) {
//       if (update.message!.contains('Password Updated Successfully')) {
//         // EasyLoading.showToast('Password Updated Successfully',
//         //     toastPosition: EasyLoadingToastPosition.bottom);
//         checkIfRegistered(_nameController.text, encryptPassword!);
//       }
//     });
//   }
//
//   Future<void> checkIfRegistered(
//       String userNameValue, String passwordValue) async {
//     final checkIfReg =
//     await CustRegRepository().checkRegCust(int.parse(widget.mobNum));
//     checkIfReg.fold((error) {
//       printLog("--------------------ERROR_----------------------");
//       printLog(error);
//     }, (custData) {
//       updateDopUserCredentials(
//           userNameValue,
//           passwordValue,
//           // custData.response!.data!.custId.toString(),
//           custData.response!.data!["custId"].toString(),
//           custData.status.toString()
//       );
//     });
//   }
//
//   Future<void> updateDopUserCredentials(String userNameValue,
//       String passwordValue, String entityID, String tokenStatus) async {
//     print('updateDopUserCredentials');
//     final updateDop = await UpdateDopRepository()
//         .getUpdateDop(entityID, userNameValue, passwordValue,token!);
//     updateDop.fold((error) {
//       //  EasyLoading.dismiss();
//       printLog("---------------------ERROR_-----------------------");
//       printLog(error);
//     }, (data) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => LoginPage(
//                 mobNum: widget.mobNum,
//                 tokenStatus: tokenStatus,
//               )));
//     });
//   }
//
//   @override
//   void initState() {
//    loadSharedPrefs();
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white, // Using home2 as background
//       appBar: AppBar(
//         backgroundColor: white, // Matching background
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Reset Credentials",
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             fontSize: 22,
//             color: home1, // Using home1 for text color
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: home1), // Using home1 for icon
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//               Hero(
//                 tag: 'reset-password',
//                 child: Image.asset(
//                   "assets/images/reset-password.png",
//                   height: 180,
//                   color: home1.withOpacity(0.8), // Tinting image with home1
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 "Create New Credentials",
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: home1, // Using home1 for heading
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Please enter your new username and password",
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: home1.withOpacity(0.7), // Semi-transparent home1
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               _buildTextField(
//                 controller: _nameController,
//                 label: "Username",
//                 icon: Icons.person_outline,
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _passwordController,
//                 label: "Password",
//                 icon: Icons.lock_outline,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _reenterPasswordController,
//                 label: "Confirm Password",
//                 icon: Icons.lock_outline,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _handleResetCredentials,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: home1, // Using home1 for button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     shadowColor: home1.withOpacity(0.3), // Home1 with opacity
//                   ),
//                   child: Text(
//                     "Confirm",
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: home2, // Using home2 for button text (contrast)
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       inputFormatters: isPassword
//           ? [LengthLimitingTextInputFormatter(8)]
//           : null,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: GoogleFonts.poppins(color: home1.withOpacity(0.6)),
//         prefixIcon: Icon(icon, color: home1),
//         filled: true,
//         fillColor: white, // Slightly lighter than background
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: home1.withOpacity(0.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: home1, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//       style: GoogleFonts.poppins(color: home1),
//     );
//   }
//
//   void _handleResetCredentials() {
//     if (_passwordController.text.length >= 8 &&
//         _reenterPasswordController.text.length >= 8) {
//       if (_passwordController.text == _reenterPasswordController.text) {
//         var ep = encryptString(_passwordController.text, sk, iv);
//         if (ep != null) {
//           encryptPassword = ep;
//           resetCredentials(encryptPassword!);
//         }
//       } else {
//         showInSnackBar("Passwords do not match");
//       }
//     } else {
//       showInSnackBar("Password must be 8 characters long");
//     }
//   }
//
//   void showInSnackBar(String value) {
//     var snackBar = SnackBar(
//       content: Text(
//         value,
//         style: GoogleFonts.poppins(
//           color: home2, // Using home2 for text
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//         ),
//       ),
//       backgroundColor: home1, // Using home1 for background
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: const EdgeInsets.all(20),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: white,
//   //       centerTitle: true,
//   //       title: Text(
//   //         "Reset Credentials",
//   //         style: TextStyle(
//   //             fontWeight: FontWeight.w700, fontSize: 23, color: deepTeal),
//   //       ),
//   //     ),
//   //     backgroundColor: white,
//   //     body: SingleChildScrollView(
//   //       child: Column(
//   //         children: [
//   //           const SizedBox(height: 50),
//   //           Center(
//   //             child: Image.asset("assets/images/reset-password.png", scale: 3),
//   //           ),
//   //           const SizedBox(height: 30),
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 20),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 TextField(
//   //                   controller: _nameController,
//   //                   decoration: InputDecoration(
//   //                     labelText: 'Username',
//   //                     labelStyle: TextStyle(color: deepTeal),
//   //                     focusedBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 2),
//   //                     ),
//   //                     enabledBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 1),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 TextField(
//   //                   controller: _passwordController,
//   //                   obscureText: true,
//   //                   inputFormatters: <TextInputFormatter>[
//   //                     LengthLimitingTextInputFormatter(8)
//   //                   ],
//   //                   decoration: InputDecoration(
//   //                     labelText: 'Password',
//   //                     labelStyle: TextStyle(color: deepTeal),
//   //                     focusedBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 2),
//   //                     ),
//   //                     enabledBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 1),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 TextField(
//   //                   controller: _reenterPasswordController,
//   //                   obscureText: true,
//   //                   inputFormatters: <TextInputFormatter>[
//   //                     LengthLimitingTextInputFormatter(8)
//   //                   ],
//   //                   decoration: InputDecoration(
//   //                     labelText: 'Confirm Password',
//   //                     labelStyle: TextStyle(color: deepTeal),
//   //                     focusedBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 2),
//   //                     ),
//   //                     enabledBorder: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(10),
//   //                       borderSide: const BorderSide(color: deepTeal, width: 1),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 40),
//   //                 GestureDetector(
//   //                   onTap: () {
//   //                     // if(_nameController.text.isEmpty ||
//   //                     //     _passwordController.text.isEmpty||
//   //                     //     _reenterPasswordController.text.isEmpty){
//   //                     //   showInSnackBar("EMPTY FIELDS NOT ALLOWED");
//   //                     // }
//   //                     if (_passwordController.text.length >= 8 &&
//   //                         _reenterPasswordController.text.length >= 8) {
//   //                       if (_passwordController.text ==
//   //                           _reenterPasswordController.text) {
//   //                         print("BOTH ARE SAME");
//   //                         var ep =
//   //                         encryptString(_passwordController.text, sk, iv);
//   //                         print('ep = $ep');
//   //                         if (ep != null) {
//   //                           print('ep not null');
//   //                           encryptPassword = ep;
//   //                           resetCredentials(encryptPassword!);
//   //                         } else {
//   //                           print('ep null');
//   //                         }
//   //                       } else {
//   //                         showInSnackBar("Password do not match");
//   //                         // EasyLoading.showToast('Password do not match');
//   //                       }
//   //                     }
//   //                     else {
//   //                       print(
//   //                           "_passwordController.text.length = ${_passwordController.text.length}");
//   //                       print(
//   //                           "_passwordController.text.length = ${_passwordController.text}");
//   //                       print(
//   //                           "_reenterPasswordController.text.length = ${_reenterPasswordController.text.length}");
//   //                       print(
//   //                           "_reenterPasswordController.text.length = ${_reenterPasswordController.text}");
//   //                       // EasyLoading.showToast(
//   //                       //     'Password length must be of 8 characters',
//   //                       //     toastPosition: EasyLoadingToastPosition.bottom);
//   //                       showInSnackBar("PPassword length must be of 8 characters");
//   //                     }
//   //
//   //
//   //                   },
//   //                   child: const BuildButton(buttonText: "Confirm"),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }