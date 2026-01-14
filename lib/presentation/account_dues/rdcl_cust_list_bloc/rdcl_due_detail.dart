import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../../data/provider/cash_transcation_provider.dart';
import '../../../data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import '../../../data/repository/payment_session_id_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../dues/rdcl_due_home_page.dart';
import '../../dues/widgets/new_qr_code_page.dart';
import '../../profile/widgets/recipect_page.dart';

class RdclDueDetail extends StatefulWidget {
  final String branchCode;
  final String customeName;
  final String custPhoneNumber;
  final String custIdNew;
  final String custAcNumber;
  final String custId;

  const RdclDueDetail(
      {super.key, required this.branchCode, required this.customeName, required this.custPhoneNumber, required this.custIdNew, required this.custAcNumber, required this.custId});

  @override
  State<RdclDueDetail> createState() => _RdclDueDetailState();
}

class _RdclDueDetailState extends State<RdclDueDetail> {
  TextEditingController amountController = TextEditingController();
  double? duemAount;
  bool isChecked = false;
  String? agentId;
  String? agentName;
  String? subagentId;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? agentMobile;
  String? agentOriginId;
  String? customerNumber;
  String? customerAccountNumber;
  String? corpCode;
  String? custid;
  String? token;
  String? paymentSessionId;
  String orderID = "";
  String? subAgentCodeNew;
  String? subagentPhoneNumber;
  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final phone = await SharedPref().getParentAgentMobNum();
    final agentid = await SharedPref().getSubAgentCode();
    final custID = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final agentOrigin = await SharedPref().getAgentOriginId();
    final mail = await SharedPref().getEmail();
    final corp = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final subagentNum = await SharedPref().getSubAgentMobNum();

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        subagentPhoneNumber = subagentNum;

        agentName = name;
        subagentId = subAgentId;
        agentMobile = phone;
        agentId = agentid;
        custid = custID;
        agentOriginId = agentOrigin;
        agentEmail = mail;
        corpCode = corp;
        token = tok;
        subAgentCodeNew = sub_AgentCodeNew;
      });
    }

  }
  @override
  void initState() {
    super.initState();
    context.read<RdclDuelistBloc>().add(
        RdclDueListFetchEvent("", widget.branchCode, "", widget.customeName));
    loadSharedPrefs();
  }
  TextStyle _labelTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);

  TextStyle _valueTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, color: black87);


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
              _buildPaymentOptionButton(
                icon: Icons.qr_code,
                label: "Pay via QR Code",
                onPressed: () async {
showProgressDialog(context);
                  final paymentSession =
                  await CreatePaymentSessionIdRepository()
                      .getPaymentSessionId(
                      agentOriginId: agentId,
                      agentEmail: agentEmail,
                      customerName: widget.customeName,
                      customerPhone: widget.custPhoneNumber,
                      customerAccno: widget.custAcNumber,
                      customerId: widget.custIdNew,
                      customerEmail: "",
                      corpCode: corpCode,
                      cardRefNum: "",
                      token: token,
                      amount: amountController.text,
                      agentPhone: agentMobile,
                      agentId: widget.custId,
                      note: "Payment For Agent $agentName",
                      subAgentId: subagentId,
                      agentName: agentName,
                      subAgentBranchCode: subAgentCodeNew, collectionType: 'RDCL');
                  paymentSession.fold((error) {
                    Navigator.pop(context);
                    // print(
                    //     "---------------------------------ERROR PAYMENT---------------------------");
                    // print(error);
                  },
                          (sessionId)
                      async {
                        paymentSessionId = sessionId.paymentSessionId ?? "";
                        if (paymentSessionId!.isNotEmpty &&
                            paymentSessionId != null &&
                            paymentSessionId != "") {
                          if (!mounted) return;
                          Navigator.pop(context);

                          if (!mounted) return;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewQrCodePage(
                                paymentSessionId: paymentSessionId!,
                                amount: amountController.text ?? "",
                                token: token!,
                                custName: customerName ?? "custName",
                                custPhone: widget.custPhoneNumber,
                                custId: widget.custId,
                              ),
                            ),
                          );
                          if (!mounted) return;
                          if (result == "fetch_balance") {
                            Navigator.pop(context);
                          }
                        } else {
                          if (!mounted) return;
                          Navigator.pop(context);
                        //  EasyLoading.showToast("Session id is null");
                        }
                      });
                },
              ),
              // const SizedBox(height: 12),
              //
              // _buildPaymentOptionButton(
              //   icon: Icons.link,
              //   label: "Send Payment Link",
              //   onPressed: () {
              //     Navigator.pop(context);
              //     sendLinkFunction();
              //   },
              // ),
              const SizedBox(height: 12),

              _buildPaymentOptionButton(
                icon: Icons.money,
                label: "Cash Payment",
                onPressed: () {
                  Navigator.pop(context);
                  paymentConfirmation(
                      context,
                      widget.customeName,
                      widget.custAcNumber,
                      widget.custId,
                      "",
                      amountController.text);

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
                  color: Colors.black.withOpacity(0.2),
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
                      color: Colors.redAccent.withOpacity(0.1),
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
        agentId: custId,
        agentOriginId: agentOriginId,
        agentPhone: phoneNumber,
        agentEmail: agentEmail,
        subAgentId: subagentId,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: widget.custAcNumber,
        customerId: widget.custIdNew,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: widget.branchCode, collectionType: 'RDCL');
    cash.fold((err) {
      Navigator.pop(context);
    //  print("getCashTrans $err");
    }, (success) {
     // print("getCashTrans $success");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => TransactionSuccessDialog(
          success: success,
          onViewReceipt: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  amount: success.amount.toString(),
                  bankName: getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
                  agentName: agentName ?? "Name",
                  agentPhone: phoneNumber ?? "agentPhone",
                  custName: customerName!,
                  custPhone: custPhoneNumber!,
                  custId: custId!,
                  txnId: success.transactionId.toString(),
                  txnType: "CASH",
                ),
              ),
            );
          },
        ),
      );


    });
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
                    color: Colors.black.withOpacity(0.1),
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
                        borderSide: BorderSide(color: home1.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: home1.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: home1, width: 1.5),
                      ),
                    ),
                    onChanged: (value) {
                      int enteredAmount = int.tryParse(value) ?? 0;
                      double? maxDueAmount = duemAount?.toDouble();

                      if (enteredAmount > maxDueAmount!) {
                        setState(() {
                          amountController.text = duemAount.toString();
                        });
                      }
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
                          //onPressed: () {},
                          onPressed: _proceedButtonClick,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "RDCL Account Details",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
        builder: (BuildContext context, RdclDuelistState state) {
          if (state is RdclDueListLoaderState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RdclDueListSuccessState) {
            final list = state
                .rdclDulistSuccess
                .rdclduesListSuccessModel
                .rdclDuesList1
                ?.data;

            if (list == null || list.isEmpty) {
              return const SizedBox.shrink();
            }

            final data = list
                .where((item) => item.accNo == widget.custAcNumber)
                .toList();

            if (data.isEmpty) {
              return const SizedBox.shrink(); // 🔐 prevents RangeError
            }

            final item = data.first; // ✅ SAFE
            duemAount = item.dueAmount;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: home1.withAlpha(50)),
                boxShadow: [
                  BoxShadow(
                    color: home1.withAlpha(30),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Customer name : "),
                      Text(item.name ?? ""),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Account Number : "),
                      Text(item.accNo ?? ""),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ),
    SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
              builder: (BuildContext context, RdclDuelistState state) {


                if (state is RdclDueListSuccessState) {
                  final list = state
                      .rdclDulistSuccess
                      .rdclduesListSuccessModel
                      .rdclDuesList1
                      ?.data;

                  if (list == null || list.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final data = list
                      .where((item) => item.accNo == widget.custAcNumber)
                      .toList();

                  if (data.isEmpty) {
                    return const SizedBox.shrink(); // 👈 VERY IMPORTANT
                  }

                  final item = data.first; // ✅ safe now

                  return Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border.all(color: home1.withAlpha(100)),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ],
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Due amount: ${item.dueAmount}"),
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });

                                if (isChecked) {
                                  _showBottomBar(context);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        Text("Installment amount: ${item.installAmt}"),
                        const Text("Loan Type: RDCL"),
                        Text("Total Installment: ${item.totalInstallment}"),
                        Text("Paid Installment: ${item.paidInstallments}"),
                        Text("Due Installment: ${item.dueInstallments}"),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
