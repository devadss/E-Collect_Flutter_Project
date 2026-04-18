// import 'dart:convert';
// import 'package:pointycastle/export.dart' as pc;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core/colors.dart';
// import '../../core/general.dart';
// import '../../core/utils.dart';
// import '../../data/storage/shared_pref_helper.dart';
// import '../../data/repository/otp_request_repository.dart';
// import '../../data/repository/otp_verification_repository.dart';
// import '../../data/repository/set_mpin_repository.dart';
// import 'authetication_page/google_pin_code_page.dart';
//
//
// class ForgotMpinPage extends StatefulWidget {
//   const ForgotMpinPage({super.key});
//
//   @override
//   State<ForgotMpinPage> createState() => _ForgotMpinPageState();
// }
//
// class _ForgotMpinPageState extends State<ForgotMpinPage> {
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _mpinController = TextEditingController();
//   final TextEditingController _reEnterMpinController = TextEditingController();
//   final String sk =  "770A8A65DA156D24EE2A093277530142";
//   final String iv = "1234567890123456";
//   String mobNumber = "";
//   String tokenValue = "";
//   String entityId = "";
//   final List<TextEditingController> _controllers =
//   List.generate(4, (_) => TextEditingController());
//   var otpValue = '';
//
// // OTP controllers (4 digits)
//   final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
//   final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
//
// // MPIN controllers (6 digits)
//   final List<TextEditingController> _mpinControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _mpinFocusNodes = List.generate(6, (index) => FocusNode());
//
// // Confirm MPIN controllers (6 digits)
//   final List<TextEditingController> _confirmMpinControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _confirmMpinFocusNodes = List.generate(6, (index) => FocusNode());
//
// // Current step tracker
//   int _currentStep = 0; // 0 = phone input, 1 = OTP, 2 = MPIN setup
//   @override
//   void initState() {
//
//     super.initState();
//     getShredValue();
//   }
//
//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     for (var controller in _otpControllers) { controller.dispose(); }
//     for (var node in _otpFocusNodes) { node.dispose(); }
//     for (var controller in _mpinControllers) { controller.dispose(); }
//     for (var node in _mpinFocusNodes) { node.dispose(); }
//     for (var controller in _confirmMpinControllers) { controller.dispose(); }
//     for (var node in _confirmMpinFocusNodes) { node.dispose(); }
//     super.dispose();
//   }
//
//   Future<void> getShredValue() async {
//     String token = await SharedPref.shared.getTokenValue();
//     setState(() {
//       tokenValue = token;
//     });
//   }
//
// /*
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
//                 child: const Padding(
//                   padding: EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(color: home2),
//                       SizedBox(
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
// */
//   void requestOtp(String mobnum) async {
//     showProgressDialog(context);
//     final provider = await OtpRequestRepository().requestOtp(mobnum);
//     provider.fold((error) {
//       Navigator.pop(context);
//       printLog("----------------------ERROR------------------");
//       printLog(error);
//     }, (otpRequest) {
//       Navigator.pop(context);
//       //print("Otp request stst : ${otpRequest.message.toString()}");
//     });
//   }
//
//   void verifyOtp(String mobnum, String otp) async {
//     showProgressDialog(context);
//     final verify = await OtpVerificationRepository().verifyOtp(mobnum, otp);
//     verify.fold((error) {
//       Navigator.pop(context);
//       printLog("-------------------------ERROR---------------------");
//       printLog(error);
//       showInSnackBar(error.message.toString(), "RED");
//       // EasyLoading.showToast('OTP Verification Failed',
//       //     toastPosition: EasyLoadingToastPosition.bottom);
//     }, (verifyOtp) {
//       Navigator.pop(context);
//       //print(verifyOtp);
//       if (verifyOtp.message!.contains('OTP Verified')) {
//         showInSnackBar("OTP Verified", "GREEN");
//
//       }
//       if (verifyOtp.message!.contains('OTP Expired')) {
//
//         showInSnackBar("OTP Expired", "RED");
//
//       }
//     });
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
//   Uint8List padPKCS7(Uint8List input) {
//     final padLength = 16 - (input.length % 16);
//     final output = Uint8List(input.length + padLength)..setAll(0, input);
//     for (var i = input.length; i < output.length; i++) {
//       output[i] = padLength;
//     }
//     return output;
//   }
//   void showInSnackBar(String value, String color) {
//     var snackBar = SnackBar(
//       content: Text(
//         value,
//         style: const TextStyle(
//             color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
//       ),
//       backgroundColor:
//       color == "RED"?
//       Colors.red:
//       Colors.green,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   Future<void> setMpin(String ep,String mpin,String mobnum) async {
//     showProgressDialog(context);
//     final setMpin = await SetMpinRepository().setMpin(mpin, mobnum, tokenValue);
//     setMpin.fold(
//           (error){
//         Navigator.pop(context);
//         printLog("---------------------ERROR-----------------");
//         printLog(error);
//       },
//           (mpin){
//
//         Navigator.pop(context);
//         if(mpin.message!.contains("Otp Not Verified")){
//           showInSnackBar("Otp Not Verified", "RED");
//           //   EasyLoading.showToast('Otp Not Verified', toastPosition: EasyLoadingToastPosition.bottom);
//         }
//         if(mpin.message!.contains("MPIN SET")){
//           SharedPref.shared.setLogin(true);
//           showInSnackBar("MPIN SET", "GREEN");
//           SharedPref.shared.setMpinValue(ep.toString());
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const GooglePinCodePage(),
//             ),
//           );
//         }
//
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Reset MPIN",
//           style: GoogleFonts.poppins(
//             color: home2,
//             fontWeight: FontWeight.w600,
//             fontSize: 22,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_rounded, color: home2),
//           onPressed: () {
//             if (_currentStep > 0) {
//               setState(() => _currentStep--);
//             } else {
//               Navigator.pop(context);
//             }
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24),
//
//               // Step 1: Phone number verification
//               if (_currentStep == 0) _buildPhoneVerificationStep(),
//
//               // Step 2: OTP verification
//               if (_currentStep == 1) _buildOtpVerificationStep(),
//
//               // Step 3: MPIN setup
//               if (_currentStep == 2) _buildMpinSetupStep(),
//
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhoneVerificationStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           title: "Verify Your Identity",
//           subtitle: "We'll send an OTP to your registered mobile number",
//         ),
//         const SizedBox(height: 16),
//         _buildInputField(
//           controller: _phoneNumberController,
//           icon: Icons.phone_android_rounded,
//           hintText: mobNumber,
//           keyboardType: TextInputType.phone,
//         ),
//         const SizedBox(height: 24),
//         _buildActionButton(
//           text: "REQUEST OTP",
//           gradient: const LinearGradient(
//             colors: [home1, home2],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           onPressed: () {
//             if (_phoneNumberController.text.isNotEmpty) {
//               requestOtp(_phoneNumberController.text);
//               setState(() => _currentStep = 1);
//             }
//           },
//         ),
//       ],
//     );
//   }
//   Widget _buildOtpVerificationStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           title: "Enter OTP",
//           subtitle: "Enter the 4-digit code sent to your mobile",
//         ),
//         const SizedBox(height: 16),
//         _buildOtpField(),
//         const SizedBox(height: 24),
//         _buildActionButton(
//           text: "VERIFY OTP",
//           gradient: const LinearGradient(
//             colors: [home1, home2],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           onPressed: () {
//             String otp = _otpControllers.map((c) => c.text).join();
//             if (otp.length == 4) {
//               verifyOtp(_phoneNumberController.text, otp);
//               setState(() => _currentStep = 2);
//             }
//           },
//         ),
//       ],
//     );
//   }
//   Widget _buildMpinSetupStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           title: "Create New MPIN",
//           subtitle: "Enter a 6-digit MPIN you'll remember",
//         ),
//         const SizedBox(height: 16),
//         _buildMpinField(hintText: 'Enter MPIN', controllers: _mpinControllers, focusNodes: _mpinFocusNodes),
//         const SizedBox(height: 16),
//         _buildMpinField(hintText: 'Confirm MPIN', controllers: _confirmMpinControllers, focusNodes: _confirmMpinFocusNodes),
//         const SizedBox(height: 32),
//         _buildActionButton(
//           text: "UPDATE MPIN",
//           gradient: const LinearGradient(
//             colors: [home1, home2],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           onPressed: () {
//             String mpin = _mpinControllers.map((c) => c.text).join();
//             String confirmMpin = _confirmMpinControllers.map((c) => c.text).join();
//
//             if (mpin.length == 6 && confirmMpin.length == 6 && mpin == confirmMpin) {
//               var ep = encryptString(mpin, sk, iv);
//               if (ep != null) {
//                 setMpin(ep, ep, _phoneNumberController.text);
//               }
//             } else {
//               showInSnackBar("Please check your MPIN", "RED");
//             }
//           },
//         ),
//       ],
//     );
//   }
//   Widget _buildOtpField() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(4, (index) {
//         return SizedBox(
//           width: 60,
//           height: 60,
//           child: TextField(
//             controller: _otpControllers[index],
//             focusNode: _otpFocusNodes[index],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             maxLength: 1,
//             onChanged: (value) {
//               if (value.length == 1 && index < 3) {
//                 _otpFocusNodes[index + 1].requestFocus();
//               } else if (value.isEmpty && index > 0) {
//                 _otpFocusNodes[index - 1].requestFocus();
//               }
//             },
//             decoration: InputDecoration(
//               counterText: '',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[200]!),
//               ),
//               filled: true,
//               fillColor: Colors.grey[50],
//             ),
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       }),
//     );
//   }
//   Widget _buildMpinField({
//     required String hintText,
//     required List<TextEditingController> controllers,
//     required List<FocusNode> focusNodes,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           hintText,
//           style: GoogleFonts.poppins(
//             color: Colors.grey[600],
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(6, (index) {
//             return SizedBox(
//               width: 45,
//               height: 45,
//               child: TextField(
//                 controller: controllers[index],
//                 focusNode: focusNodes[index],
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.center,
//                 maxLength: 1,
//                 obscureText: true,
//                 obscuringCharacter: '•',
//                 onChanged: (value) {
//                   if (value.length == 1 && index < 5) {
//                     focusNodes[index + 1].requestFocus();
//                   } else if (value.isEmpty && index > 0) {
//                     focusNodes[index - 1].requestFocus();
//                   }
//                 },
//                 decoration: InputDecoration(
//                   counterText: '',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey[200]!),
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[50],
//                 ),
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//
//   // // Add these new widget builders
//   // Widget _buildOtpField() {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //     children: List.generate(4, (index) {
//   //       return SizedBox(
//   //         width: 60,
//   //         height: 60,
//   //         child: TextField(
//   //           controller: _otpController,
//   //           keyboardType: TextInputType.number,
//   //           textAlign: TextAlign.center,
//   //           maxLength: 1,
//   //           onChanged: (value) {
//   //             if (value.length == 1) {
//   //               FocusScope.of(context).nextFocus();
//   //             }
//   //           },
//   //           decoration: InputDecoration(
//   //             counterText: '',
//   //             border: OutlineInputBorder(
//   //               borderRadius: BorderRadius.circular(12),
//   //               borderSide: BorderSide(color: Colors.grey[200]!),
//   //             ),
//   //             filled: true,
//   //             fillColor: Colors.grey[50],
//   //           ),
//   //           style: GoogleFonts.poppins(
//   //             fontSize: 24,
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //         ),
//   //       );
//   //     }),
//   //   );
//   // }
//   //
//   // Widget _buildMpinField({
//   //   required TextEditingController controller,
//   //   required String hintText,
//   // }) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text(
//   //         hintText,
//   //         style: GoogleFonts.poppins(
//   //           color: Colors.grey[600],
//   //           fontSize: 13,
//   //         ),
//   //       ),
//   //       const SizedBox(height: 8),
//   //       Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         children: List.generate(6, (index) {
//   //           return SizedBox(
//   //             width: 45,
//   //             height: 45,
//   //             child: TextField(
//   //               controller: controller,
//   //               keyboardType: TextInputType.number,
//   //               textAlign: TextAlign.center,
//   //               maxLength: 1,
//   //               obscureText: true,
//   //               obscuringCharacter: '•',
//   //               onChanged: (value) {
//   //                 if (value.length == 1) {
//   //                   FocusScope.of(context).nextFocus();
//   //                 } else if (value.isEmpty) {
//   //                   FocusScope.of(context).previousFocus();
//   //                 }
//   //               },
//   //               decoration: InputDecoration(
//   //                 counterText: '',
//   //                 border: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(8),
//   //                   borderSide: BorderSide(color: Colors.grey[200]!),
//   //                 ),
//   //                 filled: true,
//   //                 fillColor: Colors.grey[50],
//   //               ),
//   //               style: GoogleFonts.poppins(
//   //                 fontSize: 20,
//   //                 fontWeight: FontWeight.bold,
//   //               ),
//   //             ),
//   //           );
//   //         }),
//   //       ),
//   //     ],
//   //   );
//   // }
//   //
//   // // Keep all your existing helper methods (_buildSectionHeader, _buildInputField, etc.)
//   Widget _buildSectionHeader({required String title, required String subtitle}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: home1,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           subtitle,
//           style: GoogleFonts.poppins(
//             color: Colors.grey[600],
//             fontSize: 13,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hintText,
//     required TextInputType keyboardType,
//     bool obscureText = false,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             Icon(icon, color: home2.withOpacity(0.7)),
//             const SizedBox(width: 12),
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 keyboardType: keyboardType,
//                 obscureText: obscureText,
//                 inputFormatters: inputFormatters,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: hintText,
//                   hintStyle: GoogleFonts.poppins(
//                     color: Colors.grey[500],
//                     fontSize: 14,
//                   ),
//                 ),
//                 style: GoogleFonts.poppins(
//                   color: Colors.black87,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required String text,
//     required Gradient gradient,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       borderRadius: BorderRadius.circular(12),
//       elevation: 0,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(12),
//         child: Ink(
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: deepTeal.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Container(
//             height: 56,
//             alignment: Alignment.center,
//             child: Text(
//               text,
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   //
//   // Widget _buildVerifyButton() {
//   //   return Material(
//   //     borderRadius: BorderRadius.circular(8),4
//   //     elevation: 0,
//   //     child: InkWell(
//   //       onTap: () => verifyOtp(_phoneNumberController.text, _otpController.text),
//   //       borderRadius: BorderRadius.circular(8),
//   //       child: Ink(
//   //         decoration: BoxDecoration(
//   //           color: home1,
//   //           borderRadius: BorderRadius.circular(8),
//   //         ),
//   //         child: Container(
//   //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//   //           child: Text(
//   //             'VERIFY',
//   //             style: GoogleFonts.poppins(
//   //               color: Colors.white,
//   //               fontWeight: FontWeight.w600,
//   //               fontSize: 14,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
