import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PaymentLinkRequestUi extends StatefulWidget {
  final String customerMobileNumber;
  final String paymentLink;

  const PaymentLinkRequestUi({
    super.key,
    required this.customerMobileNumber,
    required this.paymentLink,
  });

  @override
  State<PaymentLinkRequestUi> createState() =>
      _PaymentLinkRequestUiState();
}

class _PaymentLinkRequestUiState extends State<PaymentLinkRequestUi> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text =
        widget.customerMobileNumber.replaceAll("+91", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        backgroundColor: home1,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          "Send Payment Link",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------------------
              // Header
              // ------------------------------------------------------------
              const Text(
                "Send a payment request",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff111827),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter your customer's mobile number to share the payment link.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------------------
              // Payment Link Preview
              // ------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      home1,
                      home1.withAlpha(220),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: home1.withAlpha(35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.link_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment link ready",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Your customer can pay securely",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------------------
              // Phone Number Label
              // ------------------------------------------------------------
              const Text(
                "CUSTOMER MOBILE NUMBER",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Color(0xff6B7280),
                ),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------------------------
              // Phone Number Field
              // ------------------------------------------------------------
              Container(
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),

                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: home1.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.phone_iphone_rounded,
                        color: home1,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      height: 28,
                      width: 1,
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff111827),
                          letterSpacing: 0.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(
                            color: Color(0xff9CA3AF),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Your customer's number is kept secure",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------------------
              // Send Via
              // ------------------------------------------------------------
              const Text(
                "SEND VIA",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Color(0xff6B7280),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------------------
              // WhatsApp
              // ------------------------------------------------------------
              _sendOption(
                icon: Icons.chat_rounded,
                title: "WhatsApp",
                subtitle: "Instant delivery",
                color: const Color(0xff25D366),
                onTap: () {
                  phoneController.text.isNotEmpty ?
                  Share.share(
                    "Here is your payment link: ${widget.paymentLink}",
                  ):
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter mobile number"))
                      )
                  
                  ;
                },
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------------------
              // SMS
              // ------------------------------------------------------------
              _sendOption(
                icon: Icons.sms_rounded,
                title: "SMS",
                subtitle: "Send as a text message",
                color: home1,
                onTap: () {
                  phoneController.text.isNotEmpty?
                  Share.share(
                    "Here is your payment link: ${widget.paymentLink}",
                  ):
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Enter mobile number"))
                  );
                },
              ),

              const SizedBox(height: 30),

              // ------------------------------------------------------------
              // Security Info
              // ------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: home1,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "The payment link is secure and can be opened on any device.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _sendOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  required VoidCallback onTap,
  }) {
  return Material(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  child: InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(18),
  child: Container(
  padding: const EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 14,
  ),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(18),
  border: Border.all(
  color: Colors.grey.shade200,
  ),
  ),
  child: Row(
  children: [
  Container(
  width: 46,
  height: 46,
  decoration: BoxDecoration(
  color: color.withAlpha(18),
  borderRadius: BorderRadius.circular(14),
  ),
  child: Icon(
  icon,
  color: color,
  size: 23,
  ),
  ),

  const SizedBox(width: 14),

  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  title,
  style: const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: Color(0xff111827),
  ),
  ),
  const SizedBox(height: 3),
  Text(
  subtitle,
  style: TextStyle(
  fontSize: 12,
  color: Colors.grey.shade500,
  ),
  ),
  ],
  ),
  ),

  Container(
  width: 34,
  height: 34,
  decoration: BoxDecoration(
  color: const Color(0xffF5F6F8),
  borderRadius: BorderRadius.circular(10),
  ),
  child: const Icon(
  Icons.arrow_forward_ios_rounded,
  size: 14,
  color: Color(0xff6B7280),
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }


// Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xffF7F8FA),
  //     appBar: AppBar(
  //       elevation: 0,
  //       backgroundColor: home1.withAlpha(200),
  //       centerTitle: true,
  //       title: const Text(
  //         "Send Payment Link",
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.w600,
  //           fontSize: 20,
  //         ),
  //       ),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 20),
  //
  //           /// Title
  //           const Text(
  //             "Enter Customer Number",
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //
  //           const SizedBox(height: 8),
  //
  //           const Text(
  //             "We’ll send the payment link via SMS or WhatsApp",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //
  //           const SizedBox(height: 30),
  //
  //           /// Phone Field Card
  //           Container(
  //             height:50 ,
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withValues(alpha: 0.05),
  //                   blurRadius: 10,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             child:
  //           /*  TextField(
  //               controller: phoneController,
  //               keyboardType: TextInputType.phone,
  //               maxLength: 10,
  //               style: const TextStyle(fontSize: 16),
  //               decoration:  InputDecoration(
  //                 counterText: "",
  //                 border: InputBorder.none,
  //                 icon: Icon(Icons.phone_iphone_rounded, color: home1.withAlpha(150),),
  //                 hintText: "Mobile number",
  //               ),
  //             ),*/
  //             TextField(
  //               controller: phoneController,
  //               decoration: InputDecoration(
  //                 hintText: "Mobile number",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //
  //                 prefixIcon: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     const SizedBox(width: 10),
  //
  //                     /// Icon
  //                     const Icon(Icons.phone_iphone),
  //
  //                     /// Divider (this is the line you want)
  //                     Container(
  //                       height: 25,
  //                       width: 1,
  //                       color: Colors.grey,
  //                       margin: const EdgeInsets.symmetric(horizontal: 10),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ),
  //
  //           const SizedBox(height: 30),
  //
  //           /// SMS Button
  //           SizedBox(
  //             width: double.infinity,
  //             height: 55,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 Share.share("Here is your payment link: ${widget.paymentLink}");
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: home1,
  //                 foregroundColor: Colors.white,
  //                 elevation: 2,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(18),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "Send via SMS",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           const SizedBox(height: 20),
  //
  //           /// OR Divider
  //           Row(
  //             children: [
  //               Expanded(child: Divider(color: Colors.grey.shade300)),
  //               const Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 10),
  //                 child: Text(
  //                   "OR",
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(child: Divider(color: Colors.grey.shade300)),
  //             ],
  //           ),
  //
  //           const SizedBox(height: 20),
  //
  //           /// WhatsApp Button
  //           SizedBox(
  //             width: double.infinity,
  //             height: 55,
  //             child: ElevatedButton.icon(
  //               onPressed: () {
  //                 Share.share("Here is your payment link: ${widget.paymentLink}");
  //               },
  //               icon: const Icon(Icons.message),
  //               label: const Text(
  //                 "Send via WhatsApp",
  //                 style: TextStyle(
  //
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xff25D366),
  //                 foregroundColor: Colors.white,
  //                 elevation: 2,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(18),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           const Spacer(),
  //
  //           /// Footer Hint
  //           const Text(
  //             "Make sure the number is active on WhatsApp for instant delivery",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Colors.grey,
  //               fontSize: 12,
  //             ),
  //           ),
  //
  //           const SizedBox(height: 10),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
