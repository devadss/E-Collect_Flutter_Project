import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app_flutter/data/provider/otp_request_provider.dart';
import 'package:merchant_app_flutter/data/provider/otp_verification_provider.dart';
import 'package:provider/provider.dart';

import '../../build_button.dart';
import '../../core/colors.dart';
import '../../core/general.dart';
import 'mpin_page/set_mpin_page.dart';

class OtpVerification extends StatefulWidget {
  final String mobNum;
  const OtpVerification({
    super.key, required this.mobNum,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  var otpValue = '';
  Timer? _timer;
  bool _canPop = false;
  int _start = 120;

  @override
  void initState() {
    startTimer();
    otpRequest();
    super.initState();
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
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> verifyOtp() async{


    String otpVal = _controllers.map((controller) => controller.text).join();
    if(otpVal.isNotEmpty){
      if(otpVal.length == 4){
        showProgressDialog(context);
        final provider = Provider.of<OtpVerificationProvider>(context, listen: false);
        final data = await provider.verifyOtp(widget.mobNum, otpVal);
        data.fold(
              (error) {
            print("request error= ${error.message}");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${error.message}")),
            );
            Navigator.pop(context);
          },
              (data) {
            Navigator.pop(context);
            if(data.message == "OTP Verified"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SetMpinPage(monNumber: widget.mobNum,)));
            }
            print("Otp request stst : ${data.message}");
          },
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter 4 digit number")),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter an otp")),
      );
    }

  }


  Future<void> otpRequest() async {
   // showProgressDialog(context);
    final provider = Provider.of<OtpRequestProvider>(context , listen: false);
    final data = await provider.requestOtp(widget.mobNum);
    data.fold(
          (error) {
       // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error}")),
        );
      },
          (data) {
            //Navigator.pop(context);
       print("Otp request stst : ${data.message.toString()}");
      },
    );

  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    printLog('Starting the timer');
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
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
      },
    );
  }

  void _updateCanPop(bool value) {
    setState(() {
      _canPop = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 100),
          Image.asset(
            "assets/images/otp_verification.png",
            width: 200,
            height: 250,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OTP Verification',
                    style: GoogleFonts.inter(
                      color: black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Enter the 4 digit OTP sent to your mobile number',
                      style: GoogleFonts.inter(
                        color: black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => SizedBox(
                        width: 60,
                        height: 60,
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: deepTeal.withOpacity(0.4),
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Haven’t got the confirmation code yet?",
                            style: GoogleFonts.inter(color: grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              // if (_start == 0) {
                              //   requestOtp();
                              //   _updateCanPop(false);
                              //   _start = 120;
                              //   startTimer();
                              // }
                            },
                            child: Center(
                              child: Text(
                                _start == 0
                                    ? 'Resend OTP'
                                    : "Resend Otp in $_start",
                                style: GoogleFonts.inter(color: blueAccent),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      verifyOtp();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: BuildButton(buttonText: "VERIFY"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
