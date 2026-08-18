import 'dart:async';
import 'package:collection_qr_flutter/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/colors.dart';
import '../../../../core/utils.dart';
import '../../authetication_page/google_pin_code_page.dart';

class OtpRequestVerificationPage extends StatefulWidget {
  final int userId;
  final String mobileNumber;
  final String testOtp;
  const OtpRequestVerificationPage({super.key,
    required this.userId, required this.mobileNumber,
    required this.testOtp, });

  @override
  State<OtpRequestVerificationPage> createState() => _OtpRequestVerificationPageState();
}

class _OtpRequestVerificationPageState
    extends State<OtpRequestVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController(),);
 // int _start = 120;
   int _start = 30;
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
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, state) {
            if(state is MobLoginVerifyOtpLoaderState){
              showProgressDialog(context);
            }
            if(state is MobLoginVerifyOtpSuccessState){
              Navigator.pop(context);
              print(state.otpVerificationSuccessModel.loginResponse.user.name);

              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
              //     BottomNavBar()));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GooglePinCodePage()));
            }else if (state is MobLoginVerifyOtpFailureState){
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.otpVerificationFailureModel.otpVerificationErrorResponse.message)));
              print((state.otpVerificationFailureModel.otpVerificationErrorResponse.message));
            }
          },
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
                        text: 'We sent a 6 digit code to ',
                        style: GoogleFonts.poppins(
                          color: grey.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "+91 ${widget.mobileNumber}",
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
                   /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                            (index) => SizedBox(
                          width: 50,
                          height: 60,
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
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                            (index) => SizedBox(
                          width: 50,
                          height: 60,
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
                              if (value.isNotEmpty) {
                                // Move to next field
                                if (index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  FocusScope.of(context).unfocus();
                                }
                              } else {
                                // Move to previous field on delete
                                if (index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
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
                          context.read<AuthenticationBloc>().add(EventMobOtpResend(widget.userId));

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

                          extractOtp(_controllers).length==6?
                              context.read<AuthenticationBloc>().add(EventMobOtpVerification(
                                widget.mobileNumber, widget.userId, extractOtp(_controllers).toString()
                              ))

                              :
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
      ),
    );
  }
}