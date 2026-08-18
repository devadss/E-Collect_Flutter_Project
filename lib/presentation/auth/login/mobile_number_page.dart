import 'package:collection_qr_flutter/core/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import '../../merchant/onboarding_screen/onboarding_screen.dart';
import 'otp_verification.dart';

class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});

  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState
    extends State<MobileNumberVerificationPage> {
  bool isChecked = false;
  String? errorMsg;
  final TextEditingController _mobileNumberController = TextEditingController();


  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    builder: (BuildContext cotext) =>
                        OtpRequestVerificationPage(
                          userId: state.otpRequestSuccessModel
                              .otpRequestSuccessResponse.userId,
                          mobileNumber: _mobileNumberController.text, testOtp: state.otpRequestSuccessModel.otpRequestSuccessResponse.otp,
                        )));
          }
          else if (state is MobLoginRequestOtpFailureState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                textAlign: TextAlign.center,
                state.otpRequestFailureModel.otpRequestErrorResponse.message
                    .toUpperCase(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ), backgroundColor: Colors.red,

            ));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section with new color theme
              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA307B), Color(0xFF470952)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    /// 🌈 BACKGROUND GRADIENT (PREMIUM LOOK)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEA307B),
                            Color(0xFF470952),
                          ],
                        ),
                      ),
                    ),

                    /// 🧩 DOODLE BACKGROUND (SOFT)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.08,
                        child: Image.asset(
                          "assets/images/doodle.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// 📱 FLOATING ICON (TOP RIGHT – MORE SUBTLE)
                    const Positioned(
                      top: 40,
                      right: 30,
                      child: Opacity(
                        opacity: 0.08,
                        child: Icon(
                          Icons.phone_iphone,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    /// 🎯 MAIN CONTENT
                    Positioned(
                      bottom: 60,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          /// 🔘 ICON CONTAINER (GLASS + GLOW EFFECT)
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA307B)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                "assets/images/mobile_number.png",
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// 📝 TITLE
                          Text(
                            "Mobile Verification",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// 📄 SUBTITLE
                          Text(
                            "Enter your registered mobile number\nto continue securely",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile Number",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                '+91',
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _mobileNumberController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter 10 digit number',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.withValues(alpha: 0.7),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.length < 10) {
                                    setState(() {
                                      errorMsg = 'Please enter 10 digits';
                                    });
                                  } else {
                                    setState(() {
                                      errorMsg = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 5),
                        child: Text(
                          errorMsg!,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Terms and Conditions with updated color theme
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                              activeColor: const Color(0xFFEA307B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "By continuing, you agree to our ",
                                  ),
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFEA307B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(termsUrl))) {
                                          await launchUrl(Uri.parse(termsUrl));
                                        }
                                      },
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFEA307B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(privacyUrl))) {
                                          await launchUrl(
                                              Uri.parse(privacyUrl));
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
                    const SizedBox(height: 30),

                    // Confirm Button with updated color theme
                    SizedBox(
                      width: double.infinity,
                      child: confirmButton(context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OnboardingScreen()));
                        },
                        child: Center(
                          child: Text(
                            "New User ? Register Now",
                            style: TextStyle(
                                color: const Color(0xFFEA307B),
                                fontWeight: FontWeight.w700),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton confirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // UI-only - button press handler without API calls
        if (!isChecked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(textAlign: TextAlign.center,"Please accept Terms & Conditions",
                style: TextStyle(fontWeight: FontWeight.w700),),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (_mobileNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(textAlign: TextAlign.center,"Please enter a mobile number",style: TextStyle(fontWeight: FontWeight.w700),),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (_mobileNumberController.text.length != 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(textAlign: TextAlign.center,"Please enter a valid 10-digit mobile number",style: TextStyle(fontWeight: FontWeight.w700),),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        context
            .read<AuthenticationBloc>()
            .add(EventMobOtpRequest(_mobileNumberController.text));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEA307B),
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shadowColor: const Color(0xFFEA307B).withValues(alpha: 0.3),
      ),
      child: Text(
        "LOGIN",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
