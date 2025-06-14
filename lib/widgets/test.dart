// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:merchant_app_flutter/core/colors.dart';
// import 'package:merchant_app_flutter/presentation/auth/sign_up/merchant_sign_up/merchant_sign_up_otp_page.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../network_calls/provider/mobile_num_login_provider.dart';
// import '../widgets/button.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController phoneNumberController = TextEditingController();
//   bool showLoader = false;
//
//   void showMessage(String msg, String clr) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),backgroundColor:
//     clr=="RED"?
//     Colors.red:
//     Colors.green,
//     ));
//   }
//
//   Future<void> _submitClick(BuildContext context, WidgetRef ref) async {
//     final postNotifier = ref.read(loginPostNotifierProvider.notifier);
//     //postNotifier.setLoading(true); // ✅ Show loading state
//
//     try {
//       final apiService = ref.read(apiServiceProvider);
//       final response =
//       await apiService.validateLoginNumber(phoneNumberController.text);
//
//       print("response.isSuccess = ${response.isSuccess}");
//
//
//
//       if (response.isSuccess) {
//         final message = response.data?.message ?? "OTP sent successfully";
//
//         if (message.contains("SMS Sent Successfully")) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   MerchantSignUpOtpPage(phoneNumberController.text, ""),
//             ),
//           );
//         }
//
//         showMessage(message, "GREEN");
//         print("OTP sent successfully: $message");
//       } else {
//         final errorMessage =
//             response.data?.message ?? response.error ?? "Something went wrong";
//
//         if (errorMessage.contains("User doesn't exist")) {
//           showMessage("User doesn't exist, please signup", "RED");
//         } else if (errorMessage.contains("SMS Sent Successfully")) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   MerchantSignUpOtpPage(phoneNumberController.text, ""),
//             ),
//           );
//         } else {
//           showMessage(errorMessage, "RED");
//         }
//         EasyLoading.dismiss();
//         print("Failed: $errorMessage");
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       showMessage("An error occurred: $e", "RED");
//       print("Error: $e");
//     } finally {
//       // postNotifier.setLoading(false); // ✅ Hide loading state
//     }
//   }
//
//   bool isChecked = false; // Track checkbox state
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: deepIndigo,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 20, vertical: 180),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.60,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Center(
//                             child: Text(
//                               "Merchant Login",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 22,
//                                   color: black),
//                             )),
//                         Center(
//                           child: Image.asset(
//                             "assets/Access.png",
//                             scale: 3,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Container(
//                           height: 61,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                               border: Border.all(
//                                   color: deepIndigo!.withOpacity(0.25),
//                                   width: 1.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                     offset: const Offset(0, 2),
//                                     color: black.withOpacity(0.25),
//                                     blurRadius: 10,
//                                     spreadRadius: 0)
//                               ]),
//                           child: TextFormField(
//                             controller: phoneNumberController,
//                             keyboardType: TextInputType.number,
//                             // Numeric keyboard
//                             maxLength: 10,
//                             // Restrict input to 10 digits
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 color: black,
//                                 fontWeight: FontWeight.w700),
//                             decoration: InputDecoration(
//                               counterText: "",
//                               // Hides default character counter
//                               hintText: "Enter your mobile number",
//                               helperStyle: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   color: black,
//                                   fontSize: 17),
//                               hintStyle: TextStyle(color: Colors.grey),
//                               prefixText: "+91-",
//                               prefixStyle: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: black,
//                                   fontSize: 17),
//                               prefixIcon: Icon(Icons.phone_android_sharp,
//                                   color: deepIndigo),
//                               // Phone icon
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 18),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                     color: deepIndigo!.withOpacity(0.25),
//                                     width: 1.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                     color: deepIndigo!.withOpacity(0.25),
//                                     width: 1.0),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide:
//                                 BorderSide(color: deepIndigo!, width: 2.0),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please enter your mobile number";
//                               } else if (!RegExp(r'^[0-9]{10}$')
//                                   .hasMatch(value)) {
//                                 return "Enter a valid 10-digit number";
//                               }
//                               return null;
//                             },
//                             inputFormatters: [
//                               FilteringTextInputFormatter
//                                   .digitsOnly, // Prevents text input
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start, // Aligns text properly
//                           children: [
//                             Checkbox(
//                               value: isChecked,
//                               onChanged: (bool? newValue) {
//                                 setState(() {
//                                   isChecked = newValue!;
//                                 });
//                               },
//                             ),
//                             Expanded(
//                               // Ensures text wraps correctly
//                               child: RichText(
//                                 text: TextSpan(
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w600,
//                                     color: black,
//                                   ),
//                                   children: [
//                                     const TextSpan(
//                                         text:
//                                         "By clicking on the login button, you agree to Adsspay Merchant App's"),
//                                     TextSpan(
//                                       text: "Privacy Policy",
//                                       style: TextStyle(
//                                           color: deepIndigo,
//                                           fontWeight: FontWeight.bold),
//                                       recognizer: TapGestureRecognizer()
//                                         ..onTap = () async {
//                                           final url = Uri.parse(
//                                               "https://aanvinsolutions.com/privacy.html");
//                                           if (await canLaunchUrl(url)) {
//                                             await launchUrl(url,
//                                                 mode: LaunchMode
//                                                     .externalApplication);
//                                           }
//                                         },
//                                     ),
//                                     const TextSpan(text: " and "),
//                                     TextSpan(
//                                       text: "Terms & Conditions.",
//                                       style: TextStyle(
//                                           color: deepIndigo,
//                                           fontWeight: FontWeight.bold),
//                                       recognizer: TapGestureRecognizer()
//                                         ..onTap = () async {
//                                           final url = Uri.parse(
//                                               "https://aanvinsolutions.com/terms.html");
//                                           if (await canLaunchUrl(url)) {
//                                             await launchUrl(url,
//                                                 mode: LaunchMode
//                                                     .externalApplication);
//                                           }
//                                         },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),
//                         // Consumer(builder: (context, ref, child) {
//                         //   return GestureDetector(
//                         //     onTap: () async {
//                         //       if (phoneNumberController.text.isNotEmpty &&
//                         //           phoneNumberController.text.length == 10) {
//                         //         setState(() {
//                         //           isChecked = true;
//                         //           showLoader = true;
//                         //         });
//                         //
//                         //         FocusManager.instance.primaryFocus?.unfocus();
//                         //
//                         //         /// to close onscreen keyboard
//                         //         await _submitClick(
//                         //             ref); // Wait for API response before continuing
//                         //
//                         //         setState(() {
//                         //           showLoader = false;
//                         //         });
//                         //       } else {
//                         //         FocusManager.instance.primaryFocus?.unfocus();
//                         //         showMessage("Please Check the mobile number");
//                         //       }
//                         //     },
//                         //     child: Padding(
//                         //         padding:
//                         //             const EdgeInsets.symmetric(horizontal: 51),
//                         //         child: showLoader
//                         //             ? const CircularProgressIndicator()
//                         //             : const BuildButton(label: "LOGIN")),
//                         //   );
//                         // }),
//                         Consumer(
//                           builder: (context, ref, child) {
//                             final postState =
//                             ref.watch(loginPostNotifierProvider);
//                             final postNotifier =
//                             ref.read(loginPostNotifierProvider.notifier);
//
//                             return Padding(
//                               padding:
//                               const EdgeInsets.symmetric(horizontal: 51),
//                               child: showLoader
//                                   ? const CircularProgressIndicator()
//                                   :  BuildButton(label: "LOGIN",  onTap: () async {
//                                 if (phoneNumberController.text.isNotEmpty &&
//                                     phoneNumberController.text.length == 10) {
//                                   EasyLoading.show(status: "Please wait....");
//                                   setState(() {
//                                     showLoader = true;
//                                     isChecked = true;
//                                   });
//                                   // postNotifier.setLoading(true); // ✅ Use Riverpod instead of setState
//
//                                   FocusManager.instance.primaryFocus
//                                       ?.unfocus(); // ✅ Close keyboard
//
//                                   /// Wait for API response before continuing
//                                   await _submitClick(context, ref);
//                                   setState(() {
//                                     showLoader = false;
//                                   });
//                                   // postNotifier.setLoading(false); // ✅ Use Riverpod instead of setState
//                                 } else {
//                                   FocusManager.instance.primaryFocus?.unfocus();
//                                   showMessage("Please Check the mobile number", "RED");
//                                 }
//                               },),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AccountDueDetailsPage extends StatefulWidget {
//   // ... (keep all existing properties and constructor)
//
//   @override
//   State<AccountDueDetailsPage> createState() => _AccountDueDetailsPageState();
// }
//
// class _AccountDueDetailsPageState extends State<AccountDueDetailsPage> {
//   // ... (keep all existing state variables and methods)
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: home2,
//       appBar: AppBar(
//         backgroundColor: home1,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: home2),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Account Due Details",
//           style: GoogleFonts.poppins(
//             color: home2,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: Consumer<DueListProvider>(
//         builder: (context, provider, child) {
//           return provider.dueListModel == null
//               ? _buildShimmerEffect()
//               : Column(
//             children: [
//               _buildCustomerInfoCard(),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: _buildDueList(provider),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildCustomerInfoCard() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: home2,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: home1.withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           _buildInfoRow("Customer Name", widget.custName),
//           const Divider(height: 20, thickness: 1),
//           _buildInfoRow("Account Number", widget.custAcNumber),
//           const Divider(height: 20, thickness: 1),
//           _buildInfoRow("Mobile", widget.custPhoneNumber),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: GoogleFonts.poppins(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Row(
//               children: [
//                 Text(
//                   value,
//                   style: GoogleFonts.poppins(
//                     color: home1,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 if (label == "Mobile")
//                   IconButton(
//                     icon: Icon(Icons.call, color: home1, size: 20),
//                     onPressed: () => _callNumber(value),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDueList(DueListProvider provider) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: ListView.builder(
//         itemCount: provider.dueListModel!.duesList!.data!.length,
//         itemBuilder: (_, index) {
//           final due = provider.dueListModel!.duesList!.data![index];
//           return Card(
//             elevation: 0,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: home1.withOpacity(0.1)),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(12),
//               onTap: () {
//                 setState(() {
//                   checkedItems[index] = !checkedItems[index];
//                   updateTotalAmount();
//                 });
//                 if (checkedItems.contains(true)) {
//                   _showBottomBar(context);
//                 } else {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                               "Due Amount: ₹${due.dueAmount}",
//                               style: GoogleFonts.poppins(
//                                 color: home1,
//                                 fontWeight: FontWeight.w600,
//                               )),
//                         ),
//                         Transform.scale(
//                           scale: 1.2,
//                           child: Checkbox(
//                             value: checkedItems[index],
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 checkedItems[index] = value!;
//                                 updateTotalAmount();
//                               });
//                               if (checkedItems.contains(true)) {
//                                 _showBottomBar(context);
//                               } else {
//                                 Navigator.of(context).pop();
//                               }
//                             },
//                             activeColor: home1,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Loan Type: RD",
//                       style: GoogleFonts.poppins(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Due Date: ${due.dueMonth}",
//                       style: GoogleFonts.poppins(
//                         color: Colors.grey[600],
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildShimmerEffect() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               height: 160,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (_, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _showBottomBar(BuildContext context) async {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => GestureDetector(
//         onTap: () {},
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: home2,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(24),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Total Amount Due",
//                   style: GoogleFonts.poppins(
//                     color: home1,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   style: GoogleFonts.poppins(
//                     color: home1,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     prefixIcon: const Icon(Icons.currency_rupee),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: home1.withOpacity(0.3)),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: home1.withOpacity(0.3)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: home1, width: 1.5),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     int enteredAmount = int.tryParse(value) ?? 0;
//                     int maxDueAmount = 0;
//
//                     final provider =
//                     Provider.of<DueListProvider>(context, listen: false);
//                     for (var due in provider.dueListModel!.duesList!.data!) {
//                       maxDueAmount += (due.dueAmount as num).toInt();
//                     }
//
//                     if (enteredAmount > maxDueAmount) {
//                       setState(() {
//                         amountController.text = maxDueAmount.toString();
//                       });
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           side: BorderSide(color: home1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: GoogleFonts.poppins(
//                             color: home1,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _proceedButtonClick,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: home1,
//                           foregroundColor: home2,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           "Proceed",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// // ... (keep all other existing methods exactly the same)
// }



import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  home1,
                  home2,
                  Colors.white,
                ],
                stops: [0.1, 0.5, 0.9],
              ),
            ),
          ),

          // Floating QR Code Particles
          Positioned(
            top: 50,
            left: 30,
            child: _FloatingParticle(
              color: home1.withOpacity(0.3),
              size: 40,
              delay: 0,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 40,
            child: _FloatingParticle(
              color: home2.withOpacity(0.3),
              size: 60,
              delay: 0.5,
            ),
          ),
          Positioned(
            top: 150,
            right: 70,
            child: _FloatingParticle(
              color: home2.withOpacity(0.2),
              size: 30,
              delay: 1,
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated QR Code SVG
                Hero(
                  tag: 'splash-logo',
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SvgPicture.asset(
                      "assets/svg/QR Code-bro.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // App Name with Typing Animation
                _TypingText(
                  text: "QR Collection",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle with Fade Animation
                _FadeInText(
                  text: "Scan. Collect. Secure.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: black,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 30),

                // Loading Indicator
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(home1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Animated Widgets
class _FloatingParticle extends StatefulWidget {
  final Color color;
  final double size;
  final double delay;

  const _FloatingParticle({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  __FloatingParticleState createState() => __FloatingParticleState();
}

class __FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(
            opacity: 0.6,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TypingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypingText({required this.text, required this.style});

  @override
  __TypingTextState createState() => __TypingTextState();
}

class __TypingTextState extends State<_TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  String _displayText = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 100),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: widget.text.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _displayText = widget.text.substring(0, _animation.value);
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}

class _FadeInText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _FadeInText({required this.text, required this.style});

  @override
  __FadeInTextState createState() => __FadeInTextState();
}

class __FadeInTextState extends State<_FadeInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}