// import 'package:e_Collect/core/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/alerts.dart';
// import '../../../../data/provider/aadhaar_otp_request_provider.dart';
// import '../aadhar_otp_verification/aadhaar_otp_verifiaction_page.dart';
//
// class AadhaarOtpRequest extends StatefulWidget {
// final String? mobNum;
//   const AadhaarOtpRequest(  {super.key, this.mobNum});
//
//   @override
//   State<AadhaarOtpRequest> createState() => _AadhaarOtpRequestState();
// }
//
// class _AadhaarOtpRequestState extends State<AadhaarOtpRequest> with SingleTickerProviderStateMixin {
//   final TextEditingController aadhaarController = TextEditingController();
//   bool isLoading = false;
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isFieldFocused = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _controller.repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     aadhaarController.dispose();
//     super.dispose();
//   }
//
//   Future<void> requestAadhaarOtp() async {
//     final arp = Provider.of<AadhaarOtpRequestProvider>(context, listen: false);
//     await arp.verifyAadhaarNumber(aadhaarController.text);
//
//     if (arp.aadhaarOtpRequestFailModel != null) {
//       setState(() => isLoading = false);
//       showToast(
//         message: arp.aadhaarOtpRequestFailModel!.message.toString(),
//         color: Colors.red,
//       );
//     } else if (arp.aadhaarDetailOtpRequestModel != null) {
//       setState(() => isLoading = false);
//       if (arp.aadhaarDetailOtpRequestModel!.message == "OTP sent successfully") {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             transitionDuration: const Duration(milliseconds: 500),
//             pageBuilder: (context, animation, secondaryAnimation) => AadhaarOtpVerificationPage(mobNum:
//               widget.mobNum!,
//               aadhaarNumber: aadhaarController.text,
//             ),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               return FadeTransition(
//                 opacity: animation,
//                 child: child,
//               );
//             },
//           ),
//         );
//       }
//     } else {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void validateFields() {
//     if (aadhaarController.text.isEmpty) {
//       showToast(message: "Empty fields not allowed", color: Colors.red);
//       return;
//     }
//
//     if (aadhaarController.text.length != 12) {
//       showToast(message: "Enter 12 digit aadhaar number", color: Colors.red);
//       return;
//     }
//
//     setState(() => isLoading = true);
//        requestAadhaarOtp();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Animated header section
//             ScaleTransition(
//               scale: _animation,
//               child: Image.asset(
//                 height: screenHeight * 0.25,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Title with gradient text
//             ShaderMask(
//
//               shaderCallback: (bounds) => const LinearGradient(
//                // colors: [Color(0xFFEA307B), Color(0xFF470952)],
//                 colors: [Color(0xFFEA307B), Color(0xFF470952)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ).createShader(bounds),
//               child: Text(
//                 "Verify Your Aadhaar",
//                 style: GoogleFonts.inter(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             Text(
//               "We'll send an OTP to your registered mobile",
//               style: GoogleFonts.inter(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // Aadhaar input field with focus animation
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: FocusScope(
//                 child: Focus(
//                   onFocusChange: (hasFocus) => setState(() => _isFieldFocused = hasFocus),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: _isFieldFocused
//                           ? [
//                         BoxShadow(
//                           color: const Color(0xFFEA307B).withOpacity(0.2),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         )
//                       ]
//                           : [],
//                     ),
//                     child: TextFormField(
//                       style: GoogleFonts.inter(
//                         fontSize: 17,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       inputFormatters: [LengthLimitingTextInputFormatter(12)],
//                       keyboardType: TextInputType.number,
//                       controller: aadhaarController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[50],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFEA307B),
//                             width: 2,
//                           ),
//                         ),
//                         hintText: "Enter 12-digit Aadhaar",
//                         hintStyle: GoogleFonts.inter(
//                           color: Colors.grey[400],
//                           fontWeight: FontWeight.w300,
//                         ),
//                         prefixIcon: Container(
//                             margin: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFEA307B).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Image.asset
//                         ),
//                         contentPadding: const EdgeInsets.
//                         symmetric(
//                           vertical: 18,
//                           horizontal: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             // Animated submit button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 height: 55,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: home1,
//                   // gradient: const LinearGradient(
//                   //   colors: [Color(0xFFEA307B), Color(0xFF470952)],
//                   //   begin: Alignment.topCenter,
//                   //   end: Alignment.bottomCenter,
//                   // ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFFEA307B).withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     )
//                   ],
//                 ),
//                 child:
//                 Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(15),
//                     onTap: isLoading ? null : validateFields,
//                     child: Center(
//                       child: isLoading
//                           ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation(Colors.white),
//                         ),
//                       )
//                           : Text(
//                         "REQUEST OTP",
//                         style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Footer text
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               child: Text(
//                 "By continuing, you agree to our Terms of Service and Privacy Policy",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.inter(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }