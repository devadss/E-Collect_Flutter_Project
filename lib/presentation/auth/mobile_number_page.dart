import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app_flutter/core/shared_pref_helper.dart';
import 'package:provider/provider.dart';
import '../../build_button.dart';
import '../../core/colors.dart';
import '../../data/provider/cust_register_provider.dart';
import 'mobile_number_password_page.dart';

class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});

  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState
    extends State<MobileNumberVerificationPage> {
  String? errorMsg;
  final TextEditingController _mobileNumberController = TextEditingController();

  Future<void> checkMobileNumber() async {
    showProgressDialog(context);
    if (_mobileNumberController.text.isNotEmpty) {
      validateMobile(_mobileNumberController.text);
    } else {
      Navigator.pop(context);
      showInSnackBar("EMPTY FIELD NOT ALLOWED");
    }
  }

  Future<void> validateMobile(String value) async {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      showInSnackBar('EMPTY FIELDS NOT ALLOWED');
    } else if (!regExp.hasMatch(value)) {
      Navigator.pop(context);
      showInSnackBar('Please enter valid mobile number');
    } else {
      final provider =
          Provider.of<CustRegisterProvider>(context, listen: false);
      provider.checkRegCust(int.parse(value));
      final response = await provider.checkRegCust(int.parse(value));
      response.fold(
        (error) {
          Navigator.pop(context);
          print("Error: ${error?.message}");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Error: ${error}",
                  style:
                  GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
                ),
                backgroundColor: Colors.red,
              )          );
        },
        (customer) {
          Navigator.pop(context);
          print("Customer Name: ${customer.response!.data!.firstName}");
          print("Customer MPin: ${customer.mpin.toString()}");
          SharedPref.shared.setCustId(customer.response!.data!.custId.toString());
          SharedPref.shared.setMobNum(customer.response!.data!.contactNo.toString());
          SharedPref.shared.setMpinValue(customer.mpin.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                        mobNum: _mobileNumberController.text,
                        tokenStatus: customer.status.toString(),
                      )));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Customer Name: ${customer.status}")),
          );
        },
      );
    }
  }

  void showInSnackBar(String value) {
    var snackBar =
    SnackBar(
    content: Text(value,
        style:GoogleFonts.inter(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700
        )
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Stack(
            children: [
              // Gradient Background
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [deepTeal, yellowGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Doodle Image with Opacity (positioned behind)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    "assets/images/doodle.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/mobile_number.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter mobile number",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 380,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: deepTeal.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_android_sharp, color: black),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _mobileNumberController,
                          keyboardType: const TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter mobile number here',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                '+91-',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(10),
                            // Limit to 10 characters
                            FilteringTextInputFormatter.digitsOnly,
                            // Only digits are allowed
                          ],
                          onChanged: (value) {
                            // Validate length here and update error message if needed
                            if (value.length < 10) {
                              setState(() {
                                errorMsg = 'Please enter at least 10 digits';
                              });
                            } else {
                              setState(() {
                                errorMsg = null; // Clear error message if valid
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMsg!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              checkMobileNumber();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: BuildButton(buttonText: "Confirm"),
            ),
          )
        ],
      ),
    );
  }
}

/*class MobileNumberAuthenticationPage extends StatefulWidget {
  const MobileNumberAuthenticationPage({super.key});

  @override
  State<MobileNumberAuthenticationPage> createState() =>
      _MobileNumberAuthenticationPageState();
}

class _MobileNumberAuthenticationPageState
    extends State<MobileNumberAuthenticationPage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController mobileNumberController = TextEditingController();

  Future<void> checkMobileNumber() async {
    if (mobileNumberController.text.isNotEmpty) {
      validateMobile(mobileNumberController.text);
    } else {
      showInSnackBar("EMPTY FIELD NOT ALLOWED");
    }
  }

  Future<void> validateMobile(String value) async {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      showInSnackBar('EMPTY FIELDS NOT ALLOWED');
    } else if (!regExp.hasMatch(value)) {
      //Navigator.pop(context);
      showInSnackBar('Please enter valid mobile number');
    } else {
      // Navigator.pop(context);
      showInSnackBar('VALID NUMBER');
      final provider =
          Provider.of<CustRegisterProvider>(context, listen: false);
      provider.checkRegCust(int.parse(value));
      final response = await provider.checkRegCust(int.parse(value));
      response.fold(
        (error) {
          // Handle error case
          print("Error: ${error.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${error.message}")),
          );
        },
        (customer) {
          // Handle success case
          print("Customer Name: ${customer.response!.data!.firstName}");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserNamePasswordPage()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Customer Name: ${customer.status}")),
          );
        },
      );
    }
  }

  void showInSnackBar(String value) {
    var snackBar = SnackBar(content: Text(value));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade500,
                  Colors.green.shade200
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Icon(
                  Icons.phone_android,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Enter Mobile Number",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: Container(
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: const Color(0xFF21F319).withOpacity(0.2)),
                child: Expanded(
                  child: TextField(
                    controller: mobileNumberController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        prefix: Padding(
                          padding: EdgeInsets.only(top: 5, left: 10),
                          child: Icon(Icons.mobile_friendly_outlined),
                        ),
                        border: InputBorder.none,
                        hintText: "Enter mobile number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    style: const TextStyle(
                        letterSpacing: .9,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                const CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 10,
                );
                checkMobileNumber();
              },
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade900,
                      Colors.green.shade500,
                      Colors.green.shade200
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                    child: Text(
                  "CONTINUE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/
