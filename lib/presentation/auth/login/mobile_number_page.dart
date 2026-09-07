import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/core/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'otp_verification.dart';


class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});

  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState
    extends State<MobileNumberVerificationPage> {
  // =========================
  // FINTECH COLOR PALETTE
  // =========================

  static const Color primary = home1;
  static const Color primaryDark = home2;
  static const Color accent = Color(0xFF18B6A4);
  static const Color background = Color(0xFFF6F9FC);
  static const Color textDark = Color(0xFF172B4D);
  static const Color textSecondary = Color(0xFF6B7A90);
  static const Color borderColor = Color(0xFFE3EAF2);
  static const Color errorColor = Color(0xFFD64545);

  bool isChecked = false;
  String? errorMsg;

  final TextEditingController _mobileNumberController =
  TextEditingController();

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, state) {
          if (state is MobLoginRequestOtpLoaderState) {
            showProgressDialog(context);
          }

          if (state is MobLoginRequestOtpSuccessState) {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    OtpRequestVerificationPage(
                      userId: state
                          .otpRequestSuccessModel
                          .otpRequestSuccessResponse
                          .userId,
                      mobileNumber: _mobileNumberController.text,
                      testOtp: state
                          .otpRequestSuccessModel
                          .otpRequestSuccessResponse
                          .otp,
                    ),
              ),
            );
          } else if (state is MobLoginRequestOtpFailureState) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.otpRequestFailureModel
                      .otpRequestErrorResponse
                      .message
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: errorColor,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },

        child: SingleChildScrollView(
          child: Column(
            children: [

              // ============================================================
              // FINTECH HERO SECTION
              // ============================================================

              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),

                child: Stack(
                  children: [

                    // Soft decorative circles
                    Positioned(
                      top: -70,
                      right: -60,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withValues(alpha: 0.12),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -80,
                      left: -60,
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Subtle phone icon
                    const Positioned(
                      top: 42,
                      right: 28,
                      child: Opacity(
                        opacity: 0.06,
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 125,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Main content
                    Positioned(
                      bottom: 55,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [

                          // Security icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Container(
                              height: 88,
                              width: 88,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.phone_android_rounded,
                                size: 42,
                                color: primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            "Secure Login",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Enter your registered mobile number\nto access your account securely",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 13.5,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ============================================================
              // FORM SECTION
              // ============================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Mobile Number",
                      style: GoogleFonts.poppins(
                        color: textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Mobile number field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [

                            // Country code
                            Text(
                              "+91",
                              style: GoogleFonts.poppins(
                                color: textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              height: 28,
                              width: 1,
                              color: borderColor,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextField(
                                controller: _mobileNumberController,
                                keyboardType: TextInputType.phone,

                                style: GoogleFonts.poppins(
                                  color: textDark,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                ),

                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter 10 digit number",
                                  hintStyle: GoogleFonts.poppins(
                                    color: textSecondary.withValues(
                                      alpha: 0.65,
                                    ),
                                    fontSize: 14,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),

                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],

                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      value.length < 10) {
                                    setState(() {
                                      errorMsg =
                                      "Please enter 10 digits";
                                    });
                                  } else {
                                    setState(() {
                                      errorMsg = null;
                                    });
                                  }
                                },
                              ),
                            ),

                            // Verification indicator
                            if (_mobileNumberController.text.length == 10)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: accent,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),

                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 7,
                          left: 5,
                        ),
                        child: Text(
                          errorMsg!,
                          style: GoogleFonts.poppins(
                            color: errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ======================================================
                    // TERMS
                    // ======================================================

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),

                      child: Row(
                        children: [

                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isChecked = newValue ?? false;
                                });
                              },
                              activeColor: accent,
                              checkColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFFB7C3D0),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: textSecondary,
                                  height: 1.45,
                                ),
                                children: [

                                  const TextSpan(
                                    text: "By continuing, you agree to our ",
                                  ),

                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: GoogleFonts.poppins(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await canLaunchUrl(
                                          Uri.parse(termsUrl),
                                        )) {
                                          await launchUrl(
                                            Uri.parse(termsUrl),
                                          );
                                        }
                                      },
                                  ),

                                  const TextSpan(text: " and "),

                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: GoogleFonts.poppins(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await canLaunchUrl(
                                          Uri.parse(privacyUrl),
                                        )) {
                                          await launchUrl(
                                            Uri.parse(privacyUrl),
                                          );
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ======================================================
                    // LOGIN BUTTON
                    // ======================================================

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: confirmButton(context),
                    ),

                    const SizedBox(height: 20),

                    // Security message
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 15,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Your information is encrypted and secure",
                            style: GoogleFonts.poppins(
                              color: textSecondary,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGIN BUTTON
  // ============================================================

  ElevatedButton confirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

        if (!isChecked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please accept Terms & Conditions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: errorColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
          return;
        }

        if (_mobileNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please enter a mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: errorColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
          return;
        }

        if (_mobileNumberController.text.length != 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please enter a valid 10-digit mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: errorColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
          return;
        }

        context
            .read<AuthenticationBloc>()
            .add(
          EventMobOtpRequest(
            _mobileNumberController.text,
          ),
        );
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: primary.withValues(alpha: 0.25),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "CONTINUE",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.arrow_forward_rounded,
            size: 19,
          ),
        ],
      ),
    );
  }
}


// class MobileNumberVerificationPage extends StatefulWidget {
//   const MobileNumberVerificationPage({super.key});
//
//   @override
//   State<MobileNumberVerificationPage> createState() =>
//       _MobileNumberVerificationPageState();
// }
//
// class _MobileNumberVerificationPageState
//     extends State<MobileNumberVerificationPage> {
//   bool isChecked = false;
//   String? errorMsg;
//   final TextEditingController _mobileNumberController = TextEditingController();
//
//
//   @override
//   void dispose() {
//     _mobileNumberController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocListener<AuthenticationBloc, AuthenticationState>(
//         listener: (BuildContext context, state) {
//           if (state is MobLoginRequestOtpLoaderState) {
//             showProgressDialog(context);
//           }
//           if (state is MobLoginRequestOtpSuccessState) {
//             Navigator.pop(context);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext cotext) =>
//                         OtpRequestVerificationPage(
//                           userId: state.otpRequestSuccessModel
//                               .otpRequestSuccessResponse.userId,
//                           mobileNumber: _mobileNumberController.text, testOtp: state.otpRequestSuccessModel.otpRequestSuccessResponse.otp,
//                         )));
//           }
//           else if (state is MobLoginRequestOtpFailureState) {
//             Navigator.pop(context);
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(
//                 textAlign: TextAlign.center,
//                 state.otpRequestFailureModel.otpRequestErrorResponse.message
//                     .toUpperCase(),
//                 style:
//                     TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//               ), backgroundColor: Colors.red,
//
//             ));
//           }
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Hero Section with new color theme
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.43,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFEA307B), Color(0xFF470952)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.1),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     /// 🌈 BACKGROUND GRADIENT (PREMIUM LOOK)
//                     Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFFEA307B),
//                             Color(0xFF470952),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     /// 🧩 DOODLE BACKGROUND (SOFT)
//                     Positioned.fill(
//                       child: Opacity(
//                         opacity: 0.08,
//                         child: Image.asset(
//                           "assets/images/doodle.jpeg",
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//
//                     /// 📱 FLOATING ICON (TOP RIGHT – MORE SUBTLE)
//                     const Positioned(
//                       top: 40,
//                       right: 30,
//                       child: Opacity(
//                         opacity: 0.08,
//                         child: Icon(
//                           Icons.phone_iphone,
//                           size: 120,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//
//                     /// 🎯 MAIN CONTENT
//                     Positioned(
//                       bottom: 60,
//                       left: 20,
//                       right: 20,
//                       child: Column(
//                         children: [
//                           /// 🔘 ICON CONTAINER (GLASS + GLOW EFFECT)
//                           Container(
//                             padding: const EdgeInsets.all(22),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withValues(alpha: 0.15),
//                               border: Border.all(
//                                 color: Colors.white.withValues(alpha: 0.3),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFFEA307B)
//                                       .withValues(alpha: 0.4),
//                                   blurRadius: 25,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                               child: Image.asset(g",
//                                 height: 60,
//                                 width: 60,
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 28),
//
//                           /// 📝 TITLE
//                           Text(
//                             "Mobile Verification",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               color: Colors.white,
//                               fontSize: 26,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//
//                           const SizedBox(height: 10),
//
//                           /// 📄 SUBTITLE
//                           Text(
//                             "Enter your registered mobile number\nto continue securely",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               color: Colors.white.withValues(alpha: 0.85),
//                               fontSize: 14,
//                               height: 1.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Form Section
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Mobile Number",
//                       style: GoogleFonts.poppins(
//                         color: Colors.black87,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withValues(alpha: 0.1),
//                             blurRadius: 10,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                         border: Border.all(
//                           color: Colors.grey.withValues(alpha: 0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               child: Text(
//                                 '+91',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black87,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               height: 30,
//                               width: 1,
//                               color: Colors.grey.withValues(alpha: 0.3),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: TextField(
//                                 controller: _mobileNumberController,
//                                 keyboardType: TextInputType.phone,
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black87,
//                                   fontSize: 16,
//                                 ),
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'Enter 10 digit number',
//                                   hintStyle: GoogleFonts.poppins(
//                                     color: Colors.grey.withValues(alpha: 0.7),
//                                   ),
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 15,
//                                   ),
//                                 ),
//                                 inputFormatters: <TextInputFormatter>[
//                                   LengthLimitingTextInputFormatter(10),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                                 onChanged: (value) {
//                                   if (value.length < 10) {
//                                     setState(() {
//                                       errorMsg = 'Please enter 10 digits';
//                                     });
//                                   } else {
//                                     setState(() {
//                                       errorMsg = null;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (errorMsg != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0, left: 5),
//                         child: Text(
//                           errorMsg!,
//                           style: GoogleFonts.poppins(
//                             color: Colors.red,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 20),
//
//                     // Terms and Conditions with updated color theme
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withValues(alpha: 0.05),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                             color: Colors.grey.withValues(alpha: 0.1)),
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Transform.scale(
//                             scale: 0.9,
//                             child: Checkbox(
//                               value: isChecked,
//                               onChanged: (bool? newValue) {
//                                 setState(() {
//                                   isChecked = newValue!;
//                                 });
//                               },
//                               activeColor: const Color(0xFFEA307B),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: RichText(
//                               text: TextSpan(
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 12,
//                                   color: Colors.black87,
//                                   height: 1.4,
//                                 ),
//                                 children: [
//                                   const TextSpan(
//                                     text: "By continuing, you agree to our ",
//                                   ),
//                                   TextSpan(
//                                     text: "Terms & Conditions",
//                                     style: GoogleFonts.poppins(
//                                       color: const Color(0xFFEA307B),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () async {
//                                         if (await canLaunchUrl(
//                                             Uri.parse(termsUrl))) {
//                                           await launchUrl(Uri.parse(termsUrl));
//                                         }
//                                       },
//                                   ),
//                                   const TextSpan(text: " and "),
//                                   TextSpan(
//                                     text: "Privacy Policy",
//                                     style: GoogleFonts.poppins(
//                                       color: const Color(0xFFEA307B),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () async {
//                                         if (await canLaunchUrl(
//                                             Uri.parse(privacyUrl))) {
//                                           await launchUrl(
//                                               Uri.parse(privacyUrl));
//                                         }
//                                       },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Confirm Button with updated color theme
//                     SizedBox(
//                       width: double.infinity,
//                       child: confirmButton(context),
//                     ),
//                     // SizedBox(
//                     //   height: 20,
//                     // ),
//                     // InkWell(
//                     //     onTap: () {
//                     //       Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //               builder: (BuildContext context) =>
//                     //                   OnboardingScreen()));
//                     //     },
//                     //     child: Center(
//                     //       child: Text(
//                     //         "New User ? Register Now",
//                     //         style: TextStyle(
//                     //             color: const Color(0xFFEA307B),
//                     //             fontWeight: FontWeight.w700),
//                     //       ),
//                     //     ))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ElevatedButton confirmButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         // UI-only - button press handler without API calls
//         if (!isChecked) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(textAlign: TextAlign.center,"Please accept Terms & Conditions",
//                 style: TextStyle(fontWeight: FontWeight.w700),),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }
//         if (_mobileNumberController.text.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(textAlign: TextAlign.center,"Please enter a mobile number",style: TextStyle(fontWeight: FontWeight.w700),),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }
//         if (_mobileNumberController.text.length != 10) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(textAlign: TextAlign.center,"Please enter a valid 10-digit mobile number",style: TextStyle(fontWeight: FontWeight.w700),),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }
//         context
//             .read<AuthenticationBloc>()
//             .add(EventMobOtpRequest(_mobileNumberController.text));
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFFEA307B),
//         foregroundColor: Colors.white,
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shadowColor: const Color(0xFFEA307B).withValues(alpha: 0.3),
//       ),
//       child: Text(
//         "LOGIN",
//         style: GoogleFonts.poppins(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
// }
