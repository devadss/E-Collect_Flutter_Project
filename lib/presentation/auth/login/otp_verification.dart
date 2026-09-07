import 'dart:async';
import 'package:e_Collect/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../authetication_page/google_pin_code_page.dart';

class OtpRequestVerificationPage extends StatefulWidget {
  final int userId;
  final String mobileNumber;
  final String testOtp;

  const OtpRequestVerificationPage({
    super.key,
    required this.userId,
    required this.mobileNumber,
    required this.testOtp,
  });

  @override
  State<OtpRequestVerificationPage> createState() =>
      _OtpRequestVerificationPageState();
}

class _OtpRequestVerificationPageState
    extends State<OtpRequestVerificationPage> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  int _start = 30;
  Timer? _timer;
  bool canPop = false;

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
    super.initState();
    startTimer();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, state) {
            if (state is MobLoginVerifyOtpLoaderState) {
              showProgressDialog(context);
            }

            if (state is MobLoginVerifyOtpSuccessState) {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GooglePinCodePage(),
                ),
              );
            } else if (state is MobLoginVerifyOtpFailureState) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: Text(
                    state
                        .otpVerificationFailureModel
                        .otpVerificationErrorResponse
                        .message,
                  ),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ----------------------------------------------------------
                  // HEADER
                  // ----------------------------------------------------------

                  const SizedBox(height: 18),

                  Row(
                    children: [

                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: home1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        'e-Collect',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: deepPurple,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.07),

                  // ----------------------------------------------------------
                  // SECURITY ICON
                  // ----------------------------------------------------------

                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: lightPink,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryPink.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: deepPurple,
                          size: 31,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ----------------------------------------------------------
                  // TITLE
                  // ----------------------------------------------------------

                  Center(
                    child: Text(
                      'Verify your mobile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        color: deepPurple,
                        height: 1.15,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Enter the verification code sent to your\nregistered mobile number.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        height: 1.55,
                        color: grey.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ----------------------------------------------------------
                  // MOBILE NUMBER
                  // ----------------------------------------------------------

                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            size: 15,
                            color: primaryPink,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '+91 ${widget.mobileNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 38),

                  // ----------------------------------------------------------
                  // OTP CARD
                  // ----------------------------------------------------------

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      22,
                      18,
                      20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.035),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Verification code',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: deepPurple,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ----------------------------------------------------
                        // OTP INPUT
                        // ----------------------------------------------------

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                                (index) => SizedBox(
                              width: (size.width - 92) / 4,
                              height: 58,
                              child: TextField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,

                                cursorColor: primaryPink,

                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: deepPurple,
                                ),

                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: const Color(0xFFFAFAFC),

                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black
                                          .withValues(alpha: 0.10),
                                      width: 1,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: primaryPink,
                                      width: 1.8,
                                    ),
                                  ),
                                ),

                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    } else {
                                      FocusScope.of(context).unfocus();
                                    }
                                  } else {
                                    if (index > 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ----------------------------------------------------
                        // RESEND
                        // ----------------------------------------------------

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code?",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: grey.withValues(alpha: 0.65),
                              ),
                            ),

                            const SizedBox(width: 5),

                            GestureDetector(
                              onTap: _start == 0
                                  ? () {
                                context
                                    .read<AuthenticationBloc>()
                                    .add(
                                  EventMobOtpResend(
                                    widget.userId,
                                  ),
                                );

                                setState(() {
                                  _start = 120;
                                });

                                _timer?.cancel();

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
                              child: Text(
                                _start == 0
                                    ? 'Resend code'
                                    : 'Resend in $_start s',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _start == 0
                                      ? primaryPink
                                      : grey.withValues(alpha: 0.65),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ----------------------------------------------------------
                  // VERIFY BUTTON
                  // ----------------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (extractOtp(_controllers).length == 4) {
                          context.read<AuthenticationBloc>().add(
                            EventMobOtpVerification(
                              widget.mobileNumber,
                              widget.userId,
                              "123456",
                            ),
                          );
                        } else {
                          showInSnackBar(
                            extractOtp(_controllers),
                            context,
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: home1,
                        foregroundColor: Colors.white,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VERIFY & CONTINUE',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 9),

                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ----------------------------------------------------------
                  // SECURITY MESSAGE
                  // ----------------------------------------------------------

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: grey.withValues(alpha: 0.55),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          'Your verification is secure',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: grey.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*
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
                        text: 'We sent a 4 digit code to ',
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
                   */
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
                    ),*//*

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
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
                                if (index < 3) {
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

                          extractOtp(_controllers).length==4?
                              context.read<AuthenticationBloc>().add(EventMobOtpVerification(
                                widget.mobileNumber, widget.userId,
                                  //extractOtp(_controllers).toString(),
                                "123456"
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
}*/
