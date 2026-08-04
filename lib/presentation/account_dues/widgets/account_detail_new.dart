import 'dart:io';

import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/alerts.dart';
import '../../../core/utils.dart';
import '../../../data/provider/cash_transcation_provider.dart';
import '../../../data/repository/payment_link_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../dues/rdcl_due_home_page.dart';
import '../../paymentlink_request_ui.dart';
import '../../profile/widgets/recipect_page.dart';

class AccountDetailNew extends StatefulWidget {
  final String custName;
  final String accNo;
  final String scheme;
  final String custId;
  const AccountDetailNew({super.key, required this.custName, required this.accNo, required this.scheme, required this.custId});

  @override
  State<AccountDetailNew> createState() => _AccountDetailNewState();
}

class _AccountDetailNewState extends State<AccountDetailNew> {
  DateTime? dateTime;
  String? agentId;
  String? subagentId;
  String? agentOriginId;
  String? agentMobile;
  String? agentName;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? customerNumber;
  String? customerAccountNumber;
  String? subAgentCodeNew;
  String? corpCode;
  String? token;
  String? paymentSessionId;
  String orderID = "";
  bool value = true;
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
loadSharedPrefs();
    super.initState();
  }

  Future<void> _showBottomBar(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
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
                            borderSide: BorderSide(color: home1.withValues(alpha: 0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: home1.withValues(alpha: 0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: home1, width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          int enteredAmount = int.tryParse(value) ?? 0;
                          int maxDueAmount = 0;

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
                              onPressed:(){
                                if(amountController.text.isNotEmpty ){
                                  _proceedButtonClick();
                                }else{
                                  showToast(
                                      message: "Amount field cannot be empty",
                                      color: Colors.orange
                                  );
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
  TextStyle _valueTextStyle() =>
      const TextStyle(
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

             // Payment options buttons
             //  _buildPaymentOptionButton(
             //    icon: Icons.qr_code,
             //    label: "Pay via QR Code",
             //    onPressed: () async {
             //      // print("--------------------TOKEN---------------------");
             //      // print(token);
             //      // print("---------------------AMOUNT--------------------");
             //      // print(amountController.text);
             //      // print("---------------------PHONENUMBER--------------------");
             //      // print(agentMobile);
             //      // print("---------------------ENTITYID--------------------");
             //      // print(agentId);
             //      // print("AccountDetailNew");
             //      showProgressDialog(context);
             //      final paymentSession =
             //          await CreatePaymentSessionIdRepository()
             //              .getPaymentSessionId(
             //                  agentOriginId: agentOriginId,
             //                  agentEmail: agentEmail,
             //                  customerName: widget.custName,
             //                  customerPhone: "",
             //                  customerAccno: widget.accNo,
             //                  customerId: widget.custId,
             //                  customerEmail: "",
             //                  corpCode: corpCode,
             //                  cardRefNum: "",
             //                  token: token,
             //                  amount: amountController.text,
             //                  agentPhone: agentMobile,
             //                  agentId: agentId,
             //                  note: "Payment For Agent $agentName",
             //                  subAgentId: subagentId,
             //                  agentName: agentName,
             //                  subAgentBranchCode: subAgentCodeNew, collectionType: 'RD');
             //      paymentSession.fold((error) {
             //        print(
             //            "---------------------------------ERROR PAYMENT---------------------------");
             //        print(error);
             //      },
             //              (sessionId)
             //      async {
             //        paymentSessionId = sessionId.paymentSessionId ?? "";
             //        if (paymentSessionId!.isNotEmpty &&
             //            paymentSessionId != null &&
             //            paymentSessionId != "") {
             //          if (!mounted) return;
             //          Navigator.pop(context);
             //
             //          if (!mounted) return;
             //          final result = await Navigator.push(
             //            context,
             //            MaterialPageRoute(
             //              builder: (context) => NewQrCodePage(
             //                paymentSessionId: paymentSessionId!,
             //                amount: amountController.text ?? "",
             //                token: token!,
             //                custName: customerName ?? "custName",
             //                custPhone: "",
             //                custId: widget.custId,
             //              ),
             //            ),
             //          );
             //          if (!mounted) return;
             //          if (result == "fetch_balance") {
             //            Navigator.pop(context);
             //          }
             //        } else {
             //          if (!mounted) return;
             //          Navigator.pop(context);
             //          EasyLoading.showToast("Session id is null");
             //        }
             //      });
             //    },
             //  ),
             //  const SizedBox(height: 12),

              _buildPaymentOptionButton(
                icon: Icons.link,
                label: "Send Payment Link",
                onPressed: () {
                  Navigator.pop(context);
                  sendLinkFunction();
                },
              ),
              const SizedBox(height: 12),

              _buildPaymentOptionButton(
                icon: Icons.money,
                label: "Cash Payment",
                onPressed: () {
                  Navigator.pop(context);
                  paymentConfirmation(
                      context,
                      widget.custName,
                      widget.accNo,
                      widget.custId,
                      "",
                      amountController.text);
                    // getCashTrans(
                    //     token: token,
                    //     customerName: widget.custName,
                    //     custPhoneNumber: customerNumber,
                    //     custAcNumber: widget.accNo,
                    //    // custId: custid,
                    //     custId: widget.custId,
                    //     custEmail: "",
                    //     amount: amountController.text,
                    //     phoneNumber: agentMobile,
                    //     entityId: agentId,
                    //     note: "");
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

                          getCashTrans(
                            token: token,
                            customerName: name,
                            custPhoneNumber: customerNumber,
                            custAcNumber: accNo,
                            custId: custId,
                            custEmail: email,
                            phoneNumber: agentMobile,
                            entityId: agentId,
                            note: "Payment For Agent $agentName",
                            amount: amt,
                          );
                          Navigator.pop(context, true); // ✅ User confirmed
                          Navigator.pop(context, true); // ✅ User confirmed
                          showProgressDialog(context);
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
  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        agentName: agentName!,
        agentId: agentId!,
        agentOriginId: agentOriginId!,
        agentPhone: agentMobile!,
        agentEmail: agentEmail!,
        customerName: widget.custName,
        customerPhone: agentMobile!,
        customerAccountNumber: widget.accNo,
        customerEmail: "",
        customerId: widget.custId,
        linkAmount: num.parse(amountController.text),
        note: "Payment for Order #12345",
        corpCode: corpCode!,
        cardRefNum: "",
        token: token.toString(),
        subAgentId: subagentId!);

         send.fold(
          (error) {
        //print("-------------------ERROR---------------------");
       // print(error);
      },
          (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          //Share.share("Here is your payment link: ${sendLink.linkUrl}");
          print("3");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
              PaymentLinkRequestUi(customerMobileNumber: customerNumber.toString(), paymentLink: sendLink.linkUrl.toString(),)
          ));
        } else {
         // print("Payment link is empty or null");
        }
      },
    );
  }
  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final phone = await SharedPref().getParentAgentMobNum();
    final agentid = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final agentOrigin = await SharedPref().getSubAgentCode();

    final mail = await SharedPref().getEmail();
    final corp = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final sub_AgentCodeNew = await SharedPref.shared.getSubAgentCodeNew();

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        agentName = name;
        subagentId = subAgentId;
        agentMobile = phone;
        agentId = agentid;
        agentOriginId = agentOrigin;
        agentEmail = mail;
        corpCode = corp;
        token = tok;
        subAgentCodeNew = sub_AgentCodeNew;
      });
    }

  }
  Future<void> getCashTrans(
      {required String? token,
        required String? customerName,
        required String? custPhoneNumber,
        required String? custAcNumber,
        required String? custId,
        required String? custEmail,
        required String? amount,
        required String? phoneNumber,
        required String? entityId,
        required String? note})
  async {
    final cashPaymentProvider =
    Provider.of<CashTranscationProvider>(context, listen: false);
    final cash = await cashPaymentProvider.getTranscations(
        agentName: agentName,
        agentId: agentId,
        agentOriginId: agentOriginId,
        agentPhone: phoneNumber,
        agentEmail: agentEmail,
        subAgentId: subagentId,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: widget.accNo,
        customerId: widget.custId,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: "", collectionType: 'RD');
    cash.fold((err) {
      //print("getCashTrans $err");
      Navigator.pop(context);
    }, (success) {
      //print("getCashTrans $success");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => TransactionSuccessDialog(
          success: success,
          onViewReceipt: () {
            Navigator.pop(context);
            var receiptModel = ReceiptDataModel(
              amount: success.amount.toString(),
              bankName: getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
              agentName: agentName ?? "Name",
              agentPhone: phoneNumber ?? "agentPhone",
              custName: customerName!,
              custPhone: custPhoneNumber ?? "",
              custId: custId!,
              txnId: success.transactionId.toString(),
              txnType: "CASH", dat: '', tranType: '', accNo: '',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
              receiptDataModel: receiptModel,
                ),
              ),
            );
          },
        ),
      );

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text("Transaction Result"),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text("Status: ${success.status ?? 'N/A'}"),
      //           const SizedBox(height: 8),
      //           Text("Transaction ID: ${success.transactionId ?? 'N/A'}"),
      //           const SizedBox(height: 8),
      //           Text("Message: ${success.message ?? 'N/A'}"),
      //         ],
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () => {
      //             Navigator.pop(context),
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => ReceiptPage(
      //                           amount: success.amount.toString(),
      //                           bankName: _getBankNameFromCorpCode(corpCode!) ??
      //                               "XYZ BANK",
      //                           agentName: agentName ?? "Name",
      //                           agentPhone: subagentPhoneNumber.toString() ??
      //                               "agentPhone",
      //                           custName: customerName!,
      //                           custPhone: phoneNumber.toString(),
      //                           custId: custId!,
      //                           txnId: success.transactionId.toString(),
      //                           txnType: "CASH",
      //                         )))
      //           },
      //           child: const Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Rd Account Details", style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:

            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(16),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 10,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       _buildInfoRow(
            //         label: "Customer Name",
            //         value: widget.custName,
            //         icon: Icons.person,
            //       ),
            //
            //       const SizedBox(height: 12),
            //
            //       _buildInfoRow(
            //         label: "Account Number",
            //         value: widget.accNo,
            //         icon: Icons.account_balance,
            //       ),
            //
            //       const SizedBox(height: 12),
            //
            //       _buildInfoRow(
            //         label: "Scheme",
            //         value: widget.scheme,
            //         icon: Icons.description,
            //       ),
            //     ],
            //   ),
            // )
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(colors: [
                  home1.withValues(alpha: 0.22),
                  home1.withValues(alpha: 0.02)


                ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Customer Name
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                        gradient: LinearGradient(colors: [
                          home1.withValues(alpha: 0.02),
                          home1.withValues(alpha: 0.02),
                        ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.person_rounded, size: 20, color: Colors.blue.shade700),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.custName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.verified_rounded, size: 18, color: Colors.green.shade400),
                      ],
                    ),
                  ),

                  /// Divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade100,
                  ),

                  /// Account Number
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.account_balance_wallet_rounded, size: 20, color: Colors.purple.shade700),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.accNo,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                        fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: widget.accNo));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied!'),
                                          duration: Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.copy_rounded, size: 16, color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Divider
                  Container(
                    height: 1,
                    color: Colors.grey.shade100,
                  ),

                  /// Scheme
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.description_rounded, size: 20, color: Colors.orange.shade700),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Scheme",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.scheme,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            "Active",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                          ),
                          backgroundColor: Colors.green.shade50,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        Spacer(flex: 1,),
        //  SizedBox(height: 50,),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
           child: SizedBox(
             width: double.infinity,
             height: 50,
             child: ElevatedButton(onPressed: (){
               _showBottomBar(context);
             },
                 style: ElevatedButton.styleFrom(backgroundColor: home1, shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),foregroundColor: Colors.white),
                 child: Text("Submit")),
           ),
         ),


        ],
      ),
    );
  }
}

Widget _buildInfoRow({
  required String label,
  required String value,
  required IconData icon,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Icon
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: home1.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: home1),
      ),

      const SizedBox(width: 12),

      /// Texts
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: home1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}