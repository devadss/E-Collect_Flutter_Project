import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/colors.dart';
import '../../../../core/utils.dart';
import '../../../merchant/onboarding_screen/onboarding_screen.dart';

class OtpRequestVerificationPage extends StatefulWidget {
  final OtpPageData otpPageData;
  const OtpRequestVerificationPage({super.key, required this.otpPageData});

  @override
  State<OtpRequestVerificationPage> createState() => _OtpRequestVerificationPageState();
}

class _OtpRequestVerificationPageState
    extends State<OtpRequestVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController(),);
  int _start = 120;
  Timer? _timer;
  bool canPop = false;
  String otpValue = "";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _updateCanPop(true);
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _updateCanPop(bool value) {
    setState(() {
      canPop = value;
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: white, automaticallyImplyLeading: false),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top decorative element
            Center(
              child: Container(
                width: 260,
                height: 260,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),

                  /// 🌈 SOFT BACKGROUND
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  /// 💎 SHADOW
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    "assets/images/verify_otp.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify Phone Number',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: deepPurple,
                    ),
                  ),

                  const SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      text: 'We sent a code to ',
                      style: GoogleFonts.poppins(
                        color: grey.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: widget.otpPageData.subAgentmobNum,
                          style: GoogleFonts.poppins(
                            color: deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                          (index) => SizedBox(
                        width: 64,
                        height: 64,
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: deepPurple,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: lightPink,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryPink,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resend Code
                  Center(
                    child: GestureDetector(
                      onTap: _start == 0
                          ? () {
                        setState(() {
                          _start = 120;
                        });
                        _timer = Timer.periodic(
                          const Duration(seconds: 1),
                              (timer) {
                            if (_start == 0) {
                              timer.cancel();
                            } else {
                              setState(() {
                                _start--;
                              });
                            }
                          },
                        );
                      }
                          : null,
                      child: RichText(
                        text: TextSpan(
                          text: "Didn't receive code? ",
                          style: GoogleFonts.poppins(
                            color: grey.withValues(alpha: 0.6),
                          ),
                          children: [
                            TextSpan(
                              text: _start == 0
                                  ? 'Resend now'
                                  : 'Resend in $_start sec',
                              style: GoogleFonts.poppins(
                                color: _start == 0 ? primaryPink : grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {

                        extractOtp(_controllers).length==4?
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                            OnboardingScreen())):
                        showInSnackBar(extractOtp(_controllers), context)
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'VERIFY',
                        style: GoogleFonts.poppins(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
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