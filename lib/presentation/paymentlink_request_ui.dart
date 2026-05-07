import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: home1.withAlpha(200),
        centerTitle: true,
        title: const Text(
          "Send Payment Link",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Title
            const Text(
              "Enter Customer Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "We’ll send the payment link via SMS or WhatsApp",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// Phone Field Card
            Container(
              height:50 ,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
            /*  TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: const TextStyle(fontSize: 16),
                decoration:  InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  icon: Icon(Icons.phone_iphone_rounded, color: home1.withAlpha(150),),
                  hintText: "Mobile number",
                ),
              ),*/
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "Mobile number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),

                      /// Icon
                      const Icon(Icons.phone_iphone),

                      /// Divider (this is the line you want)
                      Container(
                        height: 25,
                        width: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ],
                  ),
                ),
              )
            ),

            const SizedBox(height: 30),

            /// SMS Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Send via SMS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// OR Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),

            const SizedBox(height: 20),

            /// WhatsApp Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text(
                  "Send via WhatsApp",
                  style: TextStyle(

                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff25D366),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// Footer Hint
            const Text(
              "Make sure the number is active on WhatsApp for instant delivery",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
/*
class PaymentLinkRequestUi extends StatefulWidget {
  final String customerMobileNumber;
  final String paymentLink;
  const PaymentLinkRequestUi({super.key, required this.customerMobileNumber, required this.paymentLink});

  @override
  State<PaymentLinkRequestUi> createState() => _PaymentLinkRequestUiState();
}

class _PaymentLinkRequestUiState extends State<PaymentLinkRequestUi> {
  final TextEditingController phoneController = TextEditingController();
@override
  void initState() {

    super.initState();

    phoneController.text =  widget.customerMobileNumber.replaceAll("+91", "");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: home1,
        title: const Text(
          "Payment Link",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            /// Phone Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: TextField(

                maxLength: 10,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Enter mobile number",
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Continue with this number or use a different number",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// SMS Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Send via SMS"),
              ),
            ),

            const SizedBox(height: 25),

            /// Divider OR
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),

            const SizedBox(height: 25),

            /// WhatsApp Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text("Send via WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // WhatsApp feel
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
