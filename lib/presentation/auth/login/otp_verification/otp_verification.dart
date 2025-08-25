import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../../core/general.dart';
import '../../../../data/provider/otp_request_provider.dart';
import '../../../../data/provider/otp_verification_provider.dart';
import '../../../../data/provider/token_request_provider.dart';
import '../../../../data/storage/shared_pref_helper.dart';
import '../../authetication_page/google_pin_code_page.dart';

class OtpRequestVerificationPage extends StatefulWidget {
  final String subAgentmobNum;
  final String parentAgentMobNum;
  final String userName;
  final String password;
  final String tokenStatus;
  final String loggedInUserType;

  const OtpRequestVerificationPage({super.key, required this.parentAgentMobNum, required this.userName, required this.password, required this.tokenStatus, required this.subAgentmobNum, required this.loggedInUserType});

  @override
  State<OtpRequestVerificationPage> createState() => _OtpRequestVerificationPageState();
}

class _OtpRequestVerificationPageState extends State<OtpRequestVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _start = 120;
  Timer? _timer;
  bool _canPop = false;

  // Color palette
  final Color primaryPink = const Color(0xFFEA307B);
  final Color deepPurple = const Color(0xFF470952);
  final Color lightPink = const Color(0xFFFFF0F5);
  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color grey = Colors.grey;


  Future<void> tokenGeneration() async {
    showProgressDialog(context);
    final tokenRequestProvider = Provider.of<TokenRequestProvider>(context, listen: false);
    final response = await tokenRequestProvider.requestToken(
        widget.userName,
        widget.password,
        widget.parentAgentMobNum.replaceAll("+91", ""),
        "Mob");
    response.fold(
          (error) {
        Navigator.pop(context);
        print("Inside tokenGeneration error");
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
          (data) async {
            print("Inside tokenGeneration data");
        Navigator.pop(context);
        await SharedPref.shared.setTokenValue(data.toString());
        await SharedPref.shared.setLogin(true);
        await SharedPref.shared.setLoggedInUserType(widget.loggedInUserType);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GooglePinCodePage()));

      },
    );
  }

  Future<void> verifyOtp() async {
    String otpVal = _controllers.map((controller) => controller.text).join();
    if (otpVal.isNotEmpty) {
      if (otpVal.length == 4) {
        showProgressDialog(context);
        final provider = Provider.of<OtpVerificationProvider>(
          context,
          listen: false,
        );
        final data = await provider.verifyOtp(widget.subAgentmobNum, otpVal);
        data.fold(
          (error) {
            print("request error= ${error.message}");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Error: ${error.message}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          },
          (data) async {
            Navigator.pop(context);
            if (data.message == "OTP Verified"|| data.message == "OTP Verified (Play Store)") {
              SharedPref.shared.setLogin(true);
              if(
              widget.loggedInUserType == "NOT_AN_AGENT"){
                await SharedPref.shared.setTokenValue(data.toString());
                await SharedPref.shared.setLogin(true);
                await SharedPref.shared.setLoggedInUserType(widget.loggedInUserType);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GooglePinCodePage()));
              }else{
                tokenGeneration();
              }

           //    if (widget.tokenStatus == "MPIN_N") {
           //      Navigator.push(
           //          context,
           //          MaterialPageRoute(
           //              builder: (context) => const GooglePinCodePage()));
           // /*     Navigator.push(
           //          context,
           //          MaterialPageRoute(
           //              builder: (context) => OtpVerification(
           //                mobNum: widget.subAgentmobNum,
           //              )));*/
           //    } else {
           //      SharedPref.shared.setLogin(true);
           //      tokenGeneration();
           //
           //    }
            }
            print("Otp request stst : ${data.message}");
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "ENTER 4 DIGIT NUMBER",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "ENTER OTP",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> otpRequest() async {
    // showProgressDialog(context);
    final provider = Provider.of<OtpRequestProvider>(context, listen: false);
    final data = await provider.requestOtp(widget.subAgentmobNum);
    data.fold(
      (error) {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $error",
              style:const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      },
      (data) {
        //Navigator.pop(context);
        print("Otp request stst : ${data.message.toString()}");
      },
    );
  }

  void startTimer() {
    printLog('Starting the timer');
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
      _canPop = value;
    });
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding:  EdgeInsets.all(50),
                child: Column(
                  children: [
                     CircularProgressIndicator(color: home2),
                     SizedBox(height: 10),
                    Text("Please wait....", style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    startTimer();
    otpRequest();
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
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset("assets/images/otp_verify_img.jpg"),
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
                        color: grey.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: widget.subAgentmobNum,
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
                      onTap:
                          _start == 0
                              ? () {
                            otpRequest();
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
                            color: grey.withOpacity(0.6),
                          ),
                          children: [
                            TextSpan(
                              text:
                                  _start == 0
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
                      onPressed: () {

                        String otp =
                            _controllers
                                .map((controller) => controller.text)
                                .join();
                        if (otp.length == 4) {
                          verifyOtp();
                        }else{
                          EasyLoading.showToast("Enter a valid OTP");
                        }
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
