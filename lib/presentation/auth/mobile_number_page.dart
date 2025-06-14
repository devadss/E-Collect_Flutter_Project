// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../core/colors.dart';
// import '../../data/provider/cust_register_provider.dart';
// import '../../data/storage/shared_pref_helper.dart';
// import '../../widgets/build_button.dart';
// import 'mobile_number_password_page.dart';
//
// class MobileNumberVerificationPage extends StatefulWidget {
//   const MobileNumberVerificationPage({super.key});
//   @override
//   State<MobileNumberVerificationPage> createState() =>
//       _MobileNumberVerificationPageState();
// }
//
// class _MobileNumberVerificationPageState
//     extends State<MobileNumberVerificationPage> {
//   bool isChecked = false;
//   final String termsUrl = 'https://aanvinsolutions.com/terms.html';
//   final String privacyUrl = 'https://aanvinsolutions.com/privacy.html';
//   String? errorMsg;
//   final TextEditingController _mobileNumberController = TextEditingController();
//   Future<void> checkMobileNumber() async {
//     showProgressDialog(context);
//     if (_mobileNumberController.text.isNotEmpty) {
//       validateMobile(_mobileNumberController.text);
//     } else {
//       Navigator.pop(context);
//       showInSnackBar("EMPTY FIELD NOT ALLOWED");
//     }
//   }
//
//   Future<void> validateMobile(String value) async {
//     String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//     RegExp regExp = RegExp(pattern);
//     if (value.isEmpty) {
//       showInSnackBar('EMPTY FIELDS NOT ALLOWED');
//     } else if (!regExp.hasMatch(value)) {
//       Navigator.pop(context);
//       showInSnackBar('Please enter valid mobile number');
//     } else {
//       final provider =
//           Provider.of<CustRegisterProvider>(context, listen: false);
//       provider.checkRegCust(int.parse(value));
//       final response = await provider.checkRegCust(int.parse(value));
//       response.fold(
//         (error) {
//           Navigator.pop(context);
//           print("Error: ${error.message}");
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(
//               "Error: ${error.message}",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//             backgroundColor: Colors.red,
//           ));
//         },
//         (customer) {
//           Navigator.pop(context);
//           //print("Customer Name: ${customer.response!.data!.firstName}");
//           print("Customer Name: ${customer.response!.data!['firstName']}");
//           print("Customer MPin: ${customer.mpin.toString()}");
//           if (customer.response!.data!['Customer_type'] != null ||
//               customer.response!.data!['Customer_type']?.isNotEmpty == true) {
//             print("Phase 1");
//             if (customer.response!.data!['Customer_type'] ==
//                 "COLLECTION_AGENT") {
//               print("Phase 2");
//               if (customer.response!.data!.containsKey("CustId")) {
//                 SharedPref.shared
//                     .setAgentId(customer.response!.data!['CustId'].toString());
//               } else {
//                 SharedPref.shared
//                     .setAgentId(customer.response!.data!['custId'].toString());
//               }
//               SharedPref.shared
//                   .setMobNum(customer.response!.data!['contactNo'].toString());
//               SharedPref.shared.setAgentName(
//                   customer.response!.data!['firstName'].toString());
//               SharedPref.shared.setAgentOriginId(
//                   customer.response!.data!['AgentOrginId'].toString());
//               SharedPref.shared
//                   .setEmail(customer.response!.data!['emailId'].toString());
//               SharedPref.shared
//                   .setCorpCode(customer.response!.data!['CorpCode'].toString());
//               SharedPref.shared.setMpinValue(customer.mpin.toString());
//               //SharedPref.shared.setMobNum(customer.response!.data!.contactNo.toString());
//               //SharedPref.shared.setUserName(customer.response!.data!.firstName.toString());
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => LoginPage(
//                             mobNum: _mobileNumberController.text,
//                             tokenStatus: customer.status.toString(),
//                           )));
//             } else {
//               print("Not a valid collection agent");
//               showInSnackBar("Not a valid collection agent");
//             }
//           } else {
//             print("Not a valid collection agent");
//             showInSnackBar("Not a valid collection agent");
//           }
//         },
//       );
//     }
//   }
//
//   void showInSnackBar(String value) {
//     var snackBar = SnackBar(
//       content: Text(value,
//           style: TextStyle(
//               color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
//       backgroundColor: Colors.red,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       const CircularProgressIndicator(color: home2),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please wait....",
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   // Gradient Background
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.45,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [deepTeal, yellowGreen],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//
//                   // Doodle Image with Opacity (positioned behind)
//                   Positioned.fill(
//                     child: Opacity(
//                       opacity: 0.1,
//                       child: Image.asset(
//                         "assets/images/doodle.jpeg",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: Center(
//                       child: Container(
//                         height: 200,
//                         width: 200,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: white,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Image.asset("assets/images/mobile_number.png"),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Enter mobile number",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       width: 380,
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       decoration: BoxDecoration(
//                         color: deepTeal.withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.phone_android_sharp, color: black),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: _mobileNumberController,
//                               keyboardType:
//                                   const TextInputType.numberWithOptions(),
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'Enter mobile number here',
//                                 prefixIcon: Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Text(
//                                     '+91-',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                                 contentPadding:
//                                     const EdgeInsets.symmetric(vertical: 15.0),
//                               ),
//                               inputFormatters: <TextInputFormatter>[
//                                 LengthLimitingTextInputFormatter(10),
//                                 // Limit to 10 characters
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 // Only digits are allowed
//                               ],
//                               onChanged: (value) {
//                                 // Validate length here and update error message if needed
//                                 if (value.length < 10) {
//                                   setState(() {
//                                     errorMsg =
//                                         'Please enter at least 10 digits';
//                                   });
//                                 } else {
//                                   setState(() {
//                                     errorMsg =
//                                         null; // Clear error message if valid
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (errorMsg != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           errorMsg!,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start, // Aligns text properly
//                 children: [
//                   Checkbox(
//                     value: isChecked,
//                     onChanged: (bool? newValue) {
//                       setState(() {
//                         isChecked = newValue!;
//                       });
//                     },
//                   ),
//                   Expanded(
//                     //Ensures text wraps correctly
//                     child: RichText(
//                       text: TextSpan(
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: black,
//                         ),
//                         children: [
//                           const TextSpan(
//                               text:
//                                   "By clicking on the login button, you agree to Collection App's "),
//                           TextSpan(
//                             text: "Terms and Conditions",
//                             style: GoogleFonts.inter(
//                                 color: const Color(0xFF4200FF)),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () async {
//                                 if (await canLaunch(termsUrl)) {
//                                   await launch(termsUrl);
//                                 } else {
//                                   print("Could not launch $termsUrl");
//                                 }
//                               },
//                           ),
//                           const TextSpan(text: " and "),
//                           TextSpan(
//                             text: "Privacy Policy",
//                             style: GoogleFonts.inter(
//                                 color: const Color(0xFF4200FF)),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () async {
//                                 if (await canLaunch(privacyUrl)) {
//                                   await launch(privacyUrl);
//                                 } else {
//                                   print("Could not launch $privacyUrl");
//                                 }
//                               },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   if (!isChecked) {
//                     showInSnackBar("Please accept Terms & Conditions");
//                     return;
//                   }
//                   checkMobileNumber();
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 50),
//                   child: BuildButton(buttonText: "Confirm"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/colors.dart';
import '../../data/provider/cust_register_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../widgets/build_button.dart';
import 'mobile_number_password_page.dart';

class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});
  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState
    extends State<MobileNumberVerificationPage> {
  bool isChecked = false;
  final String termsUrl = 'https://aanvinsolutions.com/terms.html';
  final String privacyUrl = 'https://aanvinsolutions.com/privacy.html';
  String? errorMsg;
  final TextEditingController _mobileNumberController = TextEditingController();

  // All your existing methods remain exactly the same...
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
      final provider = Provider.of<CustRegisterProvider>(
        context,
        listen: false,
      );
      provider.checkRegCust(int.parse(value));
      final response = await provider.checkRegCust(int.parse(value));
      response.fold(
        (error) {
          Navigator.pop(context);
          print("Error: ${error.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: ${error.message}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
        (customer) {
          Navigator.pop(context);
          print("Customer Name: ${customer.response!.data!['firstName']}");
          print("Customer MPin: ${customer.mpin.toString()}");
          if (customer.response!.data!['Customer_type'] != null ||
              customer.response!.data!['Customer_type']?.isNotEmpty == true) {
            print("Phase 1");
            if (customer.response!.data!['Customer_type'] ==
                "COLLECTION_AGENT") {
              print("Phase 2");
              if (customer.response!.data!.containsKey("CustId")) {
                SharedPref.shared.setAgentId(
                  customer.response!.data!['CustId'].toString(),
                );
              } else {
                SharedPref.shared.setAgentId(
                  customer.response!.data!['custId'].toString(),
                );
              }
              SharedPref.shared.setMobNum(
                customer.response!.data!['contactNo'].toString(),
              );
              SharedPref.shared.setAgentName(
                customer.response!.data!['firstName'].toString(),
              );
              SharedPref.shared.setAgentOriginId(
                customer.response!.data!['AgentOrginId'].toString(),
              );
              SharedPref.shared.setEmail(
                customer.response!.data!['emailId'].toString(),
              );
              SharedPref.shared.setCorpCode(
                customer.response!.data!['CorpCode'].toString(),
              );
              SharedPref.shared.setMpinValue(customer.mpin.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => LoginPage(
                        mobNum: _mobileNumberController.text,
                        tokenStatus: customer.status.toString(),
                      ),
                ),
              );
            } else {
              print("Not a valid collection agent");
              showInSnackBar("Not a valid collection agent");
            }
          } else {
            print("Not a valid collection agent");
            showInSnackBar("Not a valid collection agent");
          }
        },
      );
    }
  }

  void showInSnackBar(String value) {
    var snackBar = SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: home2),
                    const SizedBox(height: 10),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with new color theme
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Icon(
                        Icons.phone_iphone,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        "assets/images/doodle.jpeg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFEA307B).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/images/mobile_number.png",
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Mobile Verification",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter your registered mobile number",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
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
                            color: Colors.grey.withOpacity(0.3),
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
                                  color: Colors.grey.withOpacity(0.7),
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
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            activeColor: Color(0xFFEA307B),
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
                                    color: Color(0xFFEA307B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunch(termsUrl)) {
                                            await launch(termsUrl);
                                          }
                                        },
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFEA307B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunch(privacyUrl)) {
                                            await launch(privacyUrl);
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
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isChecked) {
                          showInSnackBar("Please accept Terms & Conditions");
                          return;
                        }
                        checkMobileNumber();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEA307B),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shadowColor: Color(0xFFEA307B).withOpacity(0.3),
                      ),
                      child: Text(
                        "CONFIRM",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         // Hero Section with improved design
    //         Container(
    //           height: MediaQuery.of(context).size.height * 0.35,
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [home1, home2],
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //             ),
    //             borderRadius: const BorderRadius.only(
    //               bottomLeft: Radius.circular(30),
    //               bottomRight: Radius.circular(30),
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withOpacity(0.1),
    //                 blurRadius: 20,
    //                 spreadRadius: 5,
    //               ),
    //             ],
    //           ),
    //           child: Stack(
    //             children: [
    //               // Decorative elements
    //               Positioned(
    //                 top: 20,
    //                 right: 20,
    //                 child: Opacity(
    //                   opacity: 0.2,
    //                   child: Icon(
    //                     Icons.phone_iphone,
    //                     size: 150,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               Positioned(
    //                 bottom: 40,
    //                 left: 0,
    //                 right: 0,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       padding: const EdgeInsets.all(20),
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         shape: BoxShape.circle,
    //                         boxShadow: [
    //                           BoxShadow(
    //                             color: deepTeal.withOpacity(0.3),
    //                             blurRadius: 15,
    //                             spreadRadius: 5,
    //                           ),
    //                         ],
    //                       ),
    //                       child: Image.asset(
    //                         "assets/images/mobile_number.png",
    //                         height: 80,
    //                         width: 80,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 20),
    //                     Text(
    //                       "Mobile Verification",
    //                       style: GoogleFonts.poppins(
    //                         color: Colors.white,
    //                         fontSize: 24,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 8),
    //                     Text(
    //                       "Enter your registered mobile number",
    //                       style: GoogleFonts.poppins(
    //                         color: Colors.white.withOpacity(0.9),
    //                         fontSize: 14,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Positioned.fill(
    //                 child: Opacity(
    //                   opacity: 0.1,
    //                   child: Image.asset(
    //                     "assets/images/doodle.jpeg",
    //                     fit: BoxFit.fitWidth,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //         // Form Section
    //         Padding(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 30,
    //             vertical: 30,
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Mobile Number",
    //                 style: GoogleFonts.poppins(
    //                   color: Colors.black87,
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(12),
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: Colors.grey.withOpacity(0.1),
    //                       blurRadius: 10,
    //                       spreadRadius: 5,
    //                     ),
    //                   ],
    //                   border: Border.all(
    //                     color: Colors.grey.withOpacity(0.2),
    //                     width: 1,
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 15),
    //                   child: Row(
    //                     children: [
    //                       Container(
    //                         padding: const EdgeInsets.symmetric(vertical: 15),
    //                         child: Text(
    //                           '+91',
    //                           style: GoogleFonts.poppins(
    //                             color: Colors.black87,
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                       ),
    //                       const SizedBox(width: 10),
    //                       Container(
    //                         height: 30,
    //                         width: 1,
    //                         color: Colors.grey.withOpacity(0.3),
    //                       ),
    //                       const SizedBox(width: 10),
    //                       Expanded(
    //                         child: TextField(
    //                           controller: _mobileNumberController,
    //                           keyboardType: TextInputType.phone,
    //                           style: GoogleFonts.poppins(
    //                             color: Colors.black87,
    //                             fontSize: 16,
    //                           ),
    //                           decoration: InputDecoration(
    //                             border: InputBorder.none,
    //                             hintText: 'Enter 10 digit number',
    //                             hintStyle: GoogleFonts.poppins(
    //                               color: Colors.grey.withOpacity(0.7),
    //                             ),
    //                             contentPadding: const EdgeInsets.symmetric(
    //                               vertical: 15,
    //                             ),
    //                           ),
    //                           inputFormatters: <TextInputFormatter>[
    //                             LengthLimitingTextInputFormatter(10),
    //                             FilteringTextInputFormatter.digitsOnly,
    //                           ],
    //                           onChanged: (value) {
    //                             if (value.length < 10) {
    //                               setState(() {
    //                                 errorMsg = 'Please enter 10 digits';
    //                               });
    //                             } else {
    //                               setState(() {
    //                                 errorMsg = null;
    //                               });
    //                             }
    //                           },
    //                         ),
    //                       ),
    //                       Icon(
    //                         Icons.phone_android,
    //                         color: deepTeal.withOpacity(0.7),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               if (errorMsg != null)
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 8.0, left: 5),
    //                   child: Text(
    //                     errorMsg!,
    //                     style: GoogleFonts.poppins(
    //                       color: Colors.red,
    //                       fontSize: 13,
    //                     ),
    //                   ),
    //                 ),
    //               const SizedBox(height: 20),
    //
    //               // Terms and Conditions with improved styling
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.withOpacity(0.05),
    //                   borderRadius: BorderRadius.circular(12),
    //                   border: Border.all(color: Colors.grey.withOpacity(0.1)),
    //                 ),
    //                 padding: const EdgeInsets.all(12),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Transform.scale(
    //                       scale: 0.9,
    //                       child: Checkbox(
    //                         value: isChecked,
    //                         onChanged: (bool? newValue) {
    //                           setState(() {
    //                             isChecked = newValue!;
    //                           });
    //                         },
    //                         activeColor: deepTeal,
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(4),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(width: 5),
    //                     Expanded(
    //                       child: RichText(
    //                         text: TextSpan(
    //                           style: GoogleFonts.poppins(
    //                             fontSize: 12,
    //                             color: Colors.black87,
    //                             height: 1.4,
    //                           ),
    //                           children: [
    //                             const TextSpan(
    //                               text: "By continuing, you agree to our ",
    //                             ),
    //                             TextSpan(
    //                               text: "Terms & Conditions",
    //                               style: GoogleFonts.poppins(
    //                                 color: deepTeal,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                               recognizer:
    //                                   TapGestureRecognizer()
    //                                     ..onTap = () async {
    //                                       if (await canLaunch(termsUrl)) {
    //                                         await launch(termsUrl);
    //                                       }
    //                                     },
    //                             ),
    //                             const TextSpan(text: " and "),
    //                             TextSpan(
    //                               text: "Privacy Policy",
    //                               style: GoogleFonts.poppins(
    //                                 color: deepTeal,
    //                                 fontWeight: FontWeight.w600,
    //                               ),
    //                               recognizer:
    //                                   TapGestureRecognizer()
    //                                     ..onTap = () async {
    //                                       if (await canLaunch(privacyUrl)) {
    //                                         await launch(privacyUrl);
    //                                       }
    //                                     },
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(height: 30),
    //
    //               // Confirm Button with improved styling
    //               SizedBox(
    //                 width: double.infinity,
    //                 child: ElevatedButton(
    //                   onPressed: () {
    //                     if (!isChecked) {
    //                       showInSnackBar("Please accept Terms & Conditions");
    //                       return;
    //                     }
    //                     checkMobileNumber();
    //                   },
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: deepTeal,
    //                     foregroundColor: Colors.white,
    //                     elevation: 5,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(12),
    //                     ),
    //                     padding: const EdgeInsets.symmetric(vertical: 16),
    //                     shadowColor: deepTeal.withOpacity(0.3),
    //                   ),
    //                   child: Text(
    //                     "CONFIRM",
    //                     style: GoogleFonts.poppins(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w600,
    //                       letterSpacing: 0.5,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
