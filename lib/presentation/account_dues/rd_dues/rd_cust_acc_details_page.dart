import 'dart:io';

import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/alerts.dart';
import '../../../core/utils.dart';
import '../../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../paymentlink_request_ui.dart';
import '../../qr_code/widgets/generate_qr_code_page.dart';

class AccountDetailNew extends StatefulWidget {
  final String custName;
  final String accNo;
  final String scheme;
  final String custId;
  const AccountDetailNew(
      {super.key,
      required this.custName,
      required this.accNo,
      required this.scheme,
      required this.custId});

  @override
  State<AccountDetailNew> createState() => _AccountDetailNewState();
}
//01042888
class _AccountDetailNewState extends State<AccountDetailNew> {
  DateTime? dateTime;
  String? agentId;
  String? subagentId;
  String? agentOriginId;
  String? agentMobile;
  String selectedMethod = "";
  String? agentName;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? customerNumber;
  String? customerAccountNumber;
  String? subAgentCodeNew;
  String? eCollectUserToken;
  String? corpCode;
 // String? token;
  String? paymentSessionId;
  String orderID = "";
  bool value = true;
  String? eCollectAgentNumber;
  String? subagentPhoneNumber;
  String? eCollectMerchantName;
  String? cid;
  String? eCollectAgentEmail;
  String? eCollectCollectionType;
  String? eCollectAgentBranchCode;
  String? eCollectAgentMerchantID;
  String? eCollectExternalAgentId;
  String? eCollectAgentId;
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
  Future<void> _showBottomBar(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Amount Due",
                    style: GoogleFonts.poppins(
                      color: home1,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                      color: home1,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: home1.withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: home1.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: home1, width: 1.5),
                      ),
                    ),
                    onChanged: (value) {
                      // int enteredAmount = int.tryParse(value) ?? 0;
                      // int maxDueAmount = 0;

                      // final provider =
                      // Provider.of<DueListProvider>(context, listen: false);
                      // for (var due in provider.dueListModel!.duesList!
                      //     .data!) {
                      //   maxDueAmount += (due.dueAmount as num).toInt();
                      // }
                      //
                      // if (enteredAmount > maxDueAmount) {
                      //   setState(() {
                      //     amountController.text = maxDueAmount.toString();
                      //   });
                      // }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: home1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              color: home1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (amountController.text.isNotEmpty) {
                              _proceedButtonClick();
                            } else {
                              showToast(
                                  message: "Amount field cannot be empty",
                                  color: Colors.orange);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: home1,
                            foregroundColor: white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Proceed",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _labelTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);
  TextStyle _valueTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, color: black87);
  void _proceedButtonClick() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Options",
                    style: _labelTextStyle().copyWith(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount", style: _labelTextStyle()),
                    Text(
                      "Rs. ${amountController.text}",
                      style: _valueTextStyle().copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              //  Payment options buttons
              _buildPaymentOptionButton(
                icon: Icons.qr_code,
                label: "Pay via QR Code",
                onPressed: () async {
                 // setState(() {
                    selectedMethod = "QR";
                 // });
                  context.read<PaymentBloc>().add(QrPaymentEvent(
                      QrPaymentRequestModel(
                          agentDetails: AgentDetails(
                              agentName: eCollectMerchantName!,
                              agentId: eCollectAgentId!,
                              agentOrginId: eCollectExternalAgentId!,

                              agentPhone: eCollectAgentNumber!,
                              agentEmail: eCollectAgentEmail!,
                              agentBranch: int.parse(eCollectAgentBranchCode!)),
                          customerDetails: CustomerDetails(
                              customerName: widget.custName,
                              customerPhone: eCollectAgentNumber!,
                             customerAccno: widget.accNo,
                              customerId: widget.custId,
                              customerEmail: eCollectAgentEmail!),
                          collectionType: eCollectCollectionType!,
                          amount: double.parse(amountController.text),
                          note: 'Payment for Order',
                          qrSource: 'MOB',
                          source: 'COLLECTION',
                          merchantId: int.parse(eCollectAgentMerchantID!)
                          ), eCollectUserToken!

                  ));
                },
              ),
              const SizedBox(height: 12),

              _buildPaymentOptionButton(
                icon: Icons.link,
                label: "Send Payment Link",
                onPressed: () {
                  Navigator.pop(context);
                 // setState(() {
                    selectedMethod = "Link";
                 // });
                  context.read<PaymentBloc>().add(LinkPaymentEvent(
                      QrPaymentRequestModel(
                          agentDetails: AgentDetails(
                              agentName: eCollectMerchantName!,
                              agentId: eCollectAgentId!,
                              agentOrginId: eCollectExternalAgentId!,
                              agentPhone: eCollectAgentNumber!,
                              agentEmail: eCollectAgentEmail!,
                              agentBranch: int.parse(eCollectAgentBranchCode!)),
                          customerDetails: CustomerDetails(
                              customerName: widget.custName,
                              customerPhone: eCollectAgentNumber!,
                              customerAccno: widget.accNo,
                              customerId: widget.custId,
                              customerEmail: eCollectAgentEmail!),
                          collectionType: eCollectCollectionType!,
                          amount: double.parse(amountController.text),
                          note: 'Payment for Order',
                          qrSource: 'MOB',
                          source: 'COLLECTION',
                          merchantId: int.parse(eCollectAgentMerchantID!))
                      //  merchantId: 1)
                      ,eCollectUserToken!));
                },
              ),
              const SizedBox(height: 12),

              _buildPaymentOptionButton(
                icon: Icons.money,
                label: "Cash Payment",
                onPressed: () {
                  Navigator.pop(context);
                  paymentConfirmation(context, widget.custName, widget.accNo,
                      widget.custId, "", amountController.text);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> paymentConfirmation(
    BuildContext context,
    String name,
    String accNo,
    String custId,
    String email,
    String amt,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    // child: Lottie.asset("assets/animations/logout.json"),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Payment Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Do you wish to proceed with the payment ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: home1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: home1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Logout button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                        //  setState(() {
                            selectedMethod = "Cash";
                         // });
                          Navigator.pop(context);
                          Navigator.pop(context);
                          context.read<PaymentBloc>().add(CashPaymentEvent(
                              QrPaymentRequestModel(
                                  agentDetails: AgentDetails(
                                      agentName: eCollectMerchantName!,
                                      agentId: eCollectAgentId!,
                                      agentOrginId: eCollectExternalAgentId!,
                                      agentPhone: eCollectAgentNumber!,
                                      agentEmail: eCollectAgentEmail!,
                                      agentBranch:
                                          int.parse(eCollectAgentBranchCode!)),
                                  customerDetails: CustomerDetails(
                                      customerName: widget.custName,
                                      customerPhone: eCollectAgentNumber!,
                                      customerAccno: widget.accNo,
                                      customerId: widget.custId,
                                      customerEmail: eCollectAgentEmail!),
                                  collectionType: eCollectCollectionType!,
                                  amount: double.parse(amountController.text),
                                  note: 'Payment for Order',
                                  qrSource: 'MOB',
                                  source: 'COLLECTION',
                                  merchantId:
                                      int.parse(eCollectAgentMerchantID!))
                              // merchantId: 1)
                              ,eCollectUserToken!));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 24),
          label: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: home1, // Use your color variable
            foregroundColor: white, // Use your color variable
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }


  Future<void> loadSharedPrefs() async {
    final result = await Future.wait([
      SharedPref.shared.getAgentId(),
      SharedPref.shared.getSubAgentId(),
      SharedPref.shared.getSubAgentCode(),
      SharedPref.shared.getEmail(),
      SharedPref.shared.getCorpCode(),
      SharedPref.shared.getTokenValue(),
      SharedPref.shared.getSubAgentCodeNew(),
      SharedPref.shared.getCustId(),
      SharedPref.shared.getCorpCode(),
      SharedPref.shared.getAgentId(),
      SharedPref.shared.getParentAgentMobNum(),
      SharedPref.shared.getAgentName(),
      SharedPref.shared.getBranchCode(),
      SharedPref.shared.getECollectMerchantName(),
      SharedPref.shared.getECollectUserID(),
      SharedPref.shared.getExternalAgentID(),
      SharedPref.shared.getECollectUserNumber(),
      SharedPref.shared.getECollectUserEmail(),
      SharedPref.shared.getECollectMerchantBranchCode(),
      SharedPref.shared.getECollectMerchantID(),
      SharedPref.shared.getECollectUserToken(),
    ]);

        cid = result[9];
        eCollectMerchantName = result[13];
        eCollectAgentId = result[14];
        eCollectExternalAgentId = result[15];
        eCollectAgentNumber = result[16];
        eCollectAgentEmail = result[17];
        eCollectAgentBranchCode = result[18];
        eCollectAgentMerchantID = result[19];
        eCollectCollectionType = "RD";
        agentName = result[11];
        subagentId = result[1];
        agentMobile = result[10];
        agentId = result[0];
        agentOriginId = result[2];
        agentEmail = result[3];
        corpCode = result[4];
        subAgentCodeNew = result[6];
eCollectUserToken = result[20];
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF6F7FB),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF172033),
        ),
        title: Text(
          "Account Details",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF172033),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "RD Account",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7B8497),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Customer information",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Main account card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFE8EBF2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.045),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Customer
                          _modernInfoTile(
                            icon: Icons.person_rounded,
                            iconBackground: const Color(0xFFEFF4FF),
                            iconColor: const Color(0xFF4263EB),
                            title: "Customer",
                            value: widget.custName,
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF9F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 13,
                                    color: Color(0xFF18A957),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Verified",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF168B4A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          _modernDivider(),
                          const SizedBox(height: 20),

                          // Account number
                          _modernInfoTile(
                            icon: Icons.account_balance_wallet_rounded,
                            iconBackground: home1.withValues(alpha: 0.2),
                            iconColor: home1,
                            title: "Account Number",
                            value: widget.accNo,
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: widget.accNo),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Account number copied",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  size: 17,
                                  color: Color(0xFF667085),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          _modernDivider(),
                          const SizedBox(height: 20),

                          // Scheme
                          _modernInfoTile(
                            icon: Icons.description_rounded,
                            iconBackground: const Color(0xFFFFF4E8),
                            iconColor: const Color(0xFFE88A24),
                            title: "Scheme",
                            value: widget.scheme,
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF9F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "ACTIVE",
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF168B4A),
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Secure payment info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: home1.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFDCEBFF),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: home1,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Secure collection",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF243B64),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Choose a payment method to collect the amount.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF667085),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFE8EBF2),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showBottomBar(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.payments_rounded,
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Collect Payment",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            BlocListener<PaymentBloc, PaymentState>(
              listener: (BuildContext context, PaymentState state) {
                if (state is QrPaymentLoaderState) {
                  showProgressDialog(context);
                }

                if (state is QrPaymentSuccessState) {
                  Navigator.pop(context);

                  selectedMethod == "Link"
                      ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PaymentLinkRequestUi(
                            customerMobileNumber: "",
                            paymentLink: state
                                .qrPaymentSuccess
                                .paymentResponseSuccess
                                .paymentUrl,
                          ),
                    ),
                  )
                      : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewQrCodePage(
                        paymentSessionId: state
                            .qrPaymentSuccess
                            .paymentResponseSuccess
                            .paymentUrl,
                        amount: amountController.text,
                        custName: "",
                        custPhone: "custNumber",
                        custId: "CustId",
                      ),
                    ),
                  );
                } else if (state is QrPaymentFailState) {
                  Navigator.pop(context);
                  showAlertDialog(
                    state.qrPaymentFail.paymentFailResponse.message,
                    context,
                  );
                } else if (state is CashPaymentSuccessState) {
                  Navigator.pop(context);
                  showAlert(
                    state.cashPaymentSuccess.cashPaymentSuccessResponse.status ==
                        "Y"
                        ? "SUCCESS"
                        : "FAILED",
                    state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
                    context,
                  );
                } else if (state is CashPaymentFailState) {
                  Navigator.pop(context);
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _modernInfoTile({
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 21,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8A92A3),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF172033),
                ),
              ),
            ],
          ),
        ),

        if (trailing != null) ...[
          const SizedBox(width: 10),
          trailing,
        ],
      ],
    );
  }

  Widget _modernDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFF0F1F5),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       title: Text(
  //         "Rd Account Details",
  //         style: TextStyle(color: home1, fontWeight: FontWeight.w700),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: Column(
  //       children: [
  //         Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //             child: Container(
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     home1.withValues(alpha: 0.22),
  //                     home1.withValues(alpha: 0.02)
  //                   ],
  //                   begin: Alignment.topRight,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.circular(20),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withValues(alpha: 0.06),
  //                     blurRadius: 16,
  //                     offset: const Offset(0, 6),
  //                     spreadRadius: -2,
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 children: [
  //                   /// Customer Name
  //                   Container(
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                         borderRadius: const BorderRadius.only(
  //                           topLeft: Radius.circular(20),
  //                           topRight: Radius.circular(20),
  //                         ),
  //                         gradient: LinearGradient(
  //                           colors: [
  //                             home1.withValues(alpha: 0.02),
  //                             home1.withValues(alpha: 0.02),
  //                           ],
  //                           begin: Alignment.topLeft,
  //                           end: Alignment.bottomRight,
  //                         )),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.blue.shade50,
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: Icon(Icons.person_rounded,
  //                               size: 20, color: Colors.blue.shade700),
  //                         ),
  //                         const SizedBox(width: 14),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Customer Name",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.grey.shade600,
  //                                   letterSpacing: 0.5,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 widget.custName,
  //                                 style: const TextStyle(
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.w600,
  //                                   height: 1.3,
  //                                 ),
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Icon(Icons.verified_rounded,
  //                             size: 18, color: Colors.green.shade400),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   /// Divider
  //                   Container(
  //                     height: 1,
  //                     color: Colors.grey.shade100,
  //                   ),
  //
  //                   /// Account Number
  //                   Padding(
  //                     padding: const EdgeInsets.all(16),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.purple.shade50,
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: Icon(Icons.account_balance_wallet_rounded,
  //                               size: 20, color: Colors.purple.shade700),
  //                         ),
  //                         const SizedBox(width: 14),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Account Number",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.grey.shade600,
  //                                   letterSpacing: 0.5,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Row(
  //                                 children: [
  //                                   Flexible(
  //                                     child: Text(
  //                                       widget.accNo,
  //                                       style: TextStyle(
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.w600,
  //                                         letterSpacing: 1.2,
  //                                         fontFamily: Platform.isIOS
  //                                             ? 'Courier'
  //                                             : 'monospace',
  //                                       ),
  //                                       overflow: TextOverflow.ellipsis,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 8),
  //                                   GestureDetector(
  //                                     onTap: () {
  //                                       Clipboard.setData(
  //                                           ClipboardData(text: widget.accNo));
  //                                       ScaffoldMessenger.of(context)
  //                                           .showSnackBar(
  //                                         const SnackBar(
  //                                           content: Text('Copied!'),
  //                                           duration: Duration(seconds: 1),
  //                                           behavior: SnackBarBehavior.floating,
  //                                         ),
  //                                       );
  //                                     },
  //                                     child: Icon(Icons.copy_rounded,
  //                                         size: 16,
  //                                         color: Colors.grey.shade400),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   /// Divider
  //                   Container(
  //                     height: 1,
  //                     color: Colors.grey.shade100,
  //                   ),
  //
  //                   /// Scheme
  //                   Padding(
  //                     padding: const EdgeInsets.all(16),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.orange.shade50,
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: Icon(Icons.description_rounded,
  //                               size: 20, color: Colors.orange.shade700),
  //                         ),
  //                         const SizedBox(width: 14),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Scheme",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Colors.grey.shade600,
  //                                   letterSpacing: 0.5,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 widget.scheme,
  //                                 style: const TextStyle(
  //                                   fontSize: 15,
  //                                   fontWeight: FontWeight.w600,
  //                                   height: 1.3,
  //                                 ),
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Chip(
  //                           label: Text(
  //                             "Active",
  //                             style: TextStyle(
  //                                 fontSize: 10,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Colors.green.shade700),
  //                           ),
  //                           backgroundColor: Colors.green.shade50,
  //                           side: BorderSide.none,
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 8, vertical: 0),
  //                           materialTapTargetSize:
  //                               MaterialTapTargetSize.shrinkWrap,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )),
  //         Spacer(
  //           flex: 1,
  //         ),
  //         //  SizedBox(height: 50,),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  //           child: SizedBox(
  //             width: double.infinity,
  //             height: 50,
  //             child: ElevatedButton(
  //                 onPressed: () {
  //                   _showBottomBar(context);
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: home1,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10)),
  //                     foregroundColor: Colors.white),
  //                 child: Text("Submit")),
  //           ),
  //         ),
  //         BlocListener<PaymentBloc, PaymentState>(
  //           listener: (BuildContext context, PaymentState state) {
  //             if (state is QrPaymentLoaderState) {
  //               showProgressDialog(context);
  //             }
  //             if (state is QrPaymentSuccessState) {
  //               Navigator.pop(context);
  //               print(state.qrPaymentSuccess.paymentResponseSuccess.paymentUrl);
  //               selectedMethod == "Link"
  //                   ? Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (BuildContext context) =>
  //                           PaymentLinkRequestUi(
  //                             customerMobileNumber: "",
  //                             paymentLink: state.qrPaymentSuccess
  //                                 .paymentResponseSuccess.paymentUrl,
  //                           )))
  //                   : Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => NewQrCodePage(
  //                     paymentSessionId: state.qrPaymentSuccess
  //                         .paymentResponseSuccess.paymentUrl,
  //                     amount: amountController.text,
  //                     custName: "",
  //                     custPhone: "custNumber",
  //                     custId: "CustId",
  //                   ),
  //                 ),
  //               );
  //             } else if (state is QrPaymentFailState) {
  //               Navigator.pop(context);
  //
  //               showAlertDialog(
  //                   state.qrPaymentFail.paymentFailResponse.message, context);
  //               print(state.qrPaymentFail.paymentFailResponse.message);
  //             } else if (state is CashPaymentSuccessState) {
  //               Navigator.pop(context);
  //               showAlert(
  //                   state.cashPaymentSuccess.cashPaymentSuccessResponse
  //                       .status ==
  //                       "Y"
  //                       ? "SUCCESS"
  //                       : "FAILED",
  //                   state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
  //                   context);
  //               print(state
  //                   .cashPaymentSuccess.cashPaymentSuccessResponse.message);
  //             } else if (state is CashPaymentFailState) {
  //               Navigator.pop(context);
  //               print(state.cashPaymentFail.payemtError);
  //             }
  //           },
  //           child: SizedBox(),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }
}
