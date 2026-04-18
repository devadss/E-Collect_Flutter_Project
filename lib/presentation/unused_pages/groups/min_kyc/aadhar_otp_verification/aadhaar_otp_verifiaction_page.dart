// import 'dart:async';
// import 'dart:convert';
// import 'package:collection_qr_flutter/core/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../../../../core/alerts.dart';
// import '../../../../core/constants.dart';
// import '../../../../data/provider/aadhaar_otp_request_provider.dart';
//
// import '../../../../data/provider/verify_aadhaar_detail_provider.dart';
// import '../../../../data/storage/shared_pref_helper.dart';
// import '../min_kyc_screen.dart';
// import '../otp_notifier.dart';
//
// class AadhaarOtpVerificationPage extends StatefulWidget {
//   final String aadhaarNumber;
//   final String mobNum;
//
//   const AadhaarOtpVerificationPage({super.key, required this.aadhaarNumber, required this.mobNum});
//
//   @override
//   State<AadhaarOtpVerificationPage> createState() =>
//       _AadhaarOtpVerificationPageState();
// }
//
// class _AadhaarOtpVerificationPageState extends State<AadhaarOtpVerificationPage>
//     with SingleTickerProviderStateMixin {
//   bool isLoading = false;
//   String? getCustId;
//   String? corpCode;
//   String? phoneNo;
//   String? token;
//   OtpNotifier otpState = OtpNotifier();
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   int _start = 30;
//   Timer? _timer;
//   bool _canResend = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _controller.repeat(reverse: true);
//
//     startTimer();
//     loadSharedPref();
//
//     final vap =
//         Provider.of<VerifyAadhaarDetailProvider>(context, listen: false);
//     vap.resetState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       otpState = context.read<OtpNotifier>();
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void startTimer() {
//     setState(() {
//       _start = 30;
//       _canResend = false;
//     });
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _canResend = true;
//         });
//         timer.cancel();
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   Future<void> loadSharedPref() async {
//     // String cid = await SharedPref.shared.getUserId();
//     // String phoneNumber = await SharedPref.shared.getPhoneNumber();
//     // String acToken = await SharedPref.shared.getToken();
//     String crpcode = await SharedPref.shared.getCorpCode();
//     setState(() {
//       // getCustId = cid;
//       // phoneNo = phoneNumber;
//       // token = acToken;
//       corpCode = crpcode;
//     });
//   }
//
//   void verifyOtp() {
//     String otp =
//         otpState.controllers.map((controller) => controller.text).join();
//     if (otp.isEmpty) {
//       showToast(message: "Please enter the 6-digit OTP", color: Colors.red);
//       return;
//     }
//     if (otp.length != 6) {
//       showToast(
//           message: "Please enter complete 6-digit OTP", color: Colors.red);
//       return;
//     }
//
//     setState(() => isLoading = true);
//     validateOtp(otp);
//   }
//
//   Future<void> validateOtp(String otp) async {
//     final arp = Provider.of<AadhaarOtpRequestProvider>(context, listen: false);
//     final vap =
//         Provider.of<VerifyAadhaarDetailProvider>(context, listen: false);
//
//     await vap.getAadhaarDetails(
//       otp,
//       arp.aadhaarDetailOtpRequestModel!.refId.toString(),
//       "",
//       // corpCode!,
//       //getCustId!,
//       "",
//     );
//
//     if (vap.aadhaarOtpRequestFailModel != null) {
//       setState(() => isLoading = false);
//       showToast(
//         message: vap.aadhaarOtpRequestFailModel!.message.toString(),
//         color: Colors.red,
//       );
//     } else if (vap.verifyAadhaarDetailsModel != null) {
//       setState(() => isLoading = false);
//       for (final controller in otpState.controllers) {
//         controller.clear();
//       }
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           transitionDuration: const Duration(milliseconds: 500),
//           pageBuilder: (context, animation, secondaryAnimation) => MinKycScreen(
//             mobileNum: widget.mobNum,
//             tokenValue: token.toString(),
//             aadhaarNumber: widget.aadhaarNumber,
//             fullName: vap.verifyAadhaarDetailsModel!.name.toString(),
//             dob: vap.verifyAadhaarDetailsModel!.dob.toString(),
//             gender: vap.verifyAadhaarDetailsModel!.gender.toString(),
//             address: vap.verifyAadhaarDetailsModel!.address.toString(),
//             fatherName: vap.verifyAadhaarDetailsModel!.careOf
//                 .toString()
//                 .replaceAll("S/O:", ""),
//             houseName:
//                 vap.verifyAadhaarDetailsModel!.splitAddress!.house.toString(),
//             street:
//                 vap.verifyAadhaarDetailsModel!.splitAddress!.street.toString(),
//             state:
//                 vap.verifyAadhaarDetailsModel!.splitAddress!.state.toString(),
//             pincode:
//                 vap.verifyAadhaarDetailsModel!.splitAddress!.pincode.toString(),
//             city: vap.verifyAadhaarDetailsModel!.splitAddress!.dist.toString(),
//             area:
//                 vap.verifyAadhaarDetailsModel!.splitAddress!.subdist.toString(),
//           ),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//         ),
//       );
//     } else {
//       setState(() => isLoading = false);
//     }
//   }
//   Future<void> kycOtpRequest() async {
//     EasyLoading.show(status: "Please wait...");
//     const url = '${baseUrl}api/GenerateOtp';
//     final data = {
//       'entityId': "",
//       'mobileNumber': '+91${widget.mobNum}'
//     };
//
//     print("kycOtpRequest = $data");
//     final response = await http.post(
//       Uri.parse(url),
//       body: json.encode(data),
//       headers: {'Content-Type': 'application/json'},
//     );
//     print("response = ${response.body}");
//     print("kycOtpRequest = ${response.statusCode}");
//     if (response.statusCode == 200) {
//       EasyLoading.dismiss();
//       print("kycOtpRequest = $response");
//       EasyLoading.showToast('OTP Requested',
//           toastPosition: EasyLoadingToastPosition.center);
//     }
//     if (response.statusCode == 401) {
//       EasyLoading.dismiss();
//       if (response.body.contains("Mobile Number Already Registered")) {
//         EasyLoading.showToast('Mobile Number Already Registered',
//             toastPosition: EasyLoadingToastPosition.bottom);
//       }
//     }
//   }
//   Future<void> requestAadhaarOtp() async {
//     final arp = Provider.of<AadhaarOtpRequestProvider>(context, listen: false);
//     await arp.verifyAadhaarNumber(widget.aadhaarNumber);
//
//     if (arp.aadhaarOtpRequestFailModel != null) {
//       setState(() => isLoading = false);
//       showToast(
//         message: arp.aadhaarOtpRequestFailModel!.message.toString(),
//         color: Colors.red,
//       );
//     } else if (arp.aadhaarDetailOtpRequestModel != null) {
//       setState(() => isLoading = false);
//       if (arp.aadhaarDetailOtpRequestModel!.message ==
//           "OTP sent successfully") {
//         startTimer();
//       }
//     } else {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//             ScaleTransition(
//               scale: _animation,
//               child: Image.asset(
//                 "assets/images/verify_otp.jpeg",
//                 height: screenHeight * 0.25,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             ShaderMask(
//               shaderCallback: (bounds) => const LinearGradient(
//                 colors: [Color(0xFFEA307B), Color(0xFF470952)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ).createShader(bounds),
//               child: Text(
//                 "Verify Your OTP",
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
//               "We've sent a 6-digit code to your registered mobile",
//               style: GoogleFonts.inter(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   6,
//                   (index) => AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 50,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: otpState.focusNodes[index].hasFocus
//                           ? Border.all(color: const Color(0xFFEA307B), width: 2)
//                           : Border.all(color: Colors.grey[300]!, width: 1),
//                       color: Colors.grey[50],
//                     ),
//                     child: Center(
//                       child: TextField(
//                         controller: otpState.controllers[index],
//                         focusNode: otpState.focusNodes[index],
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         maxLength: 1,
//                         style: GoogleFonts.inter(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                         decoration: const InputDecoration(
//                           counterText: "",
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty &&
//                               index < otpState.controllers.length - 1) {
//                             FocusScope.of(context)
//                                 .requestFocus(otpState.focusNodes[index + 1]);
//                           } else if (value.isEmpty && index > 0) {
//                             FocusScope.of(context)
//                                 .requestFocus(otpState.focusNodes[index - 1]);
//                           }
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Timer or Resend Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _canResend
//                     ? Row(
//                         children: [
//                           Text(
//                             "Didn't receive code? ",
//                             style: GoogleFonts.inter(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               requestAadhaarOtp();
//                             },
//                             child: Text(
//                               "Resend OTP",
//                               style: GoogleFonts.inter(
//                                 color: const Color(0xFFEA307B),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Text(
//                         "Resend OTP in $_start seconds",
//                         style: GoogleFonts.inter(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//               ],
//             ),
//
//             const SizedBox(height: 40),
//
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
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(15),
//                     onTap: isLoading ? null : verifyOtp,
//                     child: Center(
//                       child: isLoading
//                           ? const SizedBox(
//                               width: 24,
//                               height: 24,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor:
//                                     AlwaysStoppedAnimation(Colors.white),
//                               ),
//                             )
//                           : Text(
//                               "VERIFY OTP",
//                               style: GoogleFonts.inter(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
