
import 'dart:io';
import 'dart:math';
import 'package:collection_qr_flutter/core/alerts.dart';
import 'package:collection_qr_flutter/data/provider/rdcl_due_under_agent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../../data/provider/cash_transcation_provider.dart';
import '../../../data/provider/transaction_provider.dart';
import '../../../data/repository/payment_link_repository.dart';
import '../../../data/repository/payment_session_id_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/cash_transcation_model.dart';
import '../../dues/widgets/new_qr_code_page.dart';
import '../../profile/widgets/recipect_page.dart';

class RdclAccountDueDetailsPage extends StatefulWidget {
  final int? indexValue;
  final String corpCode;
  final String custName;
  final String custAcNumber;
  final String custPhoneNumber;
  final String custId;
  final String custIdNew;
  final String custEmail;
  final String branchCode;
  final int pageNo;
  final int pageSize;

  const RdclAccountDueDetailsPage(
      {super.key,
      required this.custName,
      required this.custAcNumber,
      required this.custPhoneNumber,
      required this.custId,
      required this.custEmail,
      required this.corpCode,
      required this.indexValue,
      required this.branchCode,
      required this.custIdNew,
      required this.pageNo,
      required this.pageSize});

  @override
  State<RdclAccountDueDetailsPage> createState() =>
      _AccountDueDetailsPageState();
}

class _AccountDueDetailsPageState extends State<RdclAccountDueDetailsPage> {
  List<bool> checkedItems = List.generate(1, (index) => false);

  TextEditingController amountController = TextEditingController();
  num previousCheckboxTotal = 0;
  DateTime? _dateTime;
  String? agentId;
  String? subagentId;
  String? agentOriginId;
  String? agentMobile;
  String? agentName;
  String? custid;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? customerNumber;
  String? customerAccountNumber;
  String? corpCode;
  String? token;
  String? paymentSessionId;
  String orderID = "";
  String? subAgentCodeNew;
  String? subagentPhoneNumber;

  void updateTotalAmount() {
    final provider = Provider.of<RdclDueUnderAgentProvider>(context, listen: false);

    // Check if data exists
    if (provider.rdclDueUnderAgentModel?.data == null ||
        provider.rdclDueUnderAgentModel!.data.isEmpty) {
      return;
    }

    // Assuming you only have 1 item since indexValue is passed
    if (widget.indexValue == null ||
        widget.indexValue! >= provider.rdclDueUnderAgentModel!.data.length) {
      return;
    }

    // Get the due item
    final dueItem = provider.rdclDueUnderAgentModel!.data[widget.indexValue!];

    // Access properties safely - adjust field names based on your actual API response
    int manualAmount = int.tryParse(amountController.text) ?? 0;
    int checkboxTotal = 0;
    int maxDueAmount = 0;

    // Since you're only showing one item, use the indexValue
    if (checkedItems.length > widget.indexValue!) {
      // Get the due amount - use the correct field name from your API
      // If your API returns different field names, adjust here:
      // E.g., if the field is 'due_amount' instead of 'dueAmount', use dueItem['due_amount']
      num dueAmount = dueItem.dueAmount ?? 0; // ← Adjust field name if needed

      maxDueAmount += dueAmount.toInt();
      if (checkedItems[widget.indexValue!]) {
        checkboxTotal += dueAmount.toInt();
      }
    }

    // Ensure manual amount + selected account_dues do not exceed the total possible due
    num newTotal = checkboxTotal + (manualAmount - previousCheckboxTotal);
    previousCheckboxTotal = checkboxTotal;

    if (newTotal > maxDueAmount) {
      newTotal = maxDueAmount; // Restrict max limit
    }

    setState(() {
      amountController.text = newTotal.toString();
    });
  }
  // void updateTotalAmount() {
  //   final provider = Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
  //
  //   List.generate(provider.rdclDueUnderAgentModel!.data.length, (index) => false);
  //
  //   int manualAmount = int.tryParse(amountController.text) ?? 0;
  //   int checkboxTotal = 0;
  //   int maxDueAmount = 0;
  //
  //   for (int i = 0; i < 1; i++) {
  //     maxDueAmount +=
  //         (provider.rdclDueUnderAgentModel?.data[i].dueAmount as num).toInt();
  //     if (checkedItems[i]) {
  //       checkboxTotal +=
  //           (provider.rdclDueUnderAgentModel?.data[i].dueAmount as num).toInt();
  //     }
  //   }
  //
  //   // Ensure manual amount + selected account_dues do not exceed the total possible due
  //   num newTotal = checkboxTotal + (manualAmount - previousCheckboxTotal);
  //   previousCheckboxTotal = checkboxTotal;
  //
  //   if (newTotal > maxDueAmount) {
  //     newTotal = maxDueAmount; // Restrict max limit
  //   }
  //
  //   setState(() {
  //     amountController.text = newTotal.toString();
  //   });
  // }

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
                  print("--------------------TOKEN---------------------");
                  print(token);
                  print("---------------------AMOUNT--------------------");
                  print(amountController.text);
                  print("---------------------PHONENUMBER--------------------");
                  print(agentMobile);
                  print("---------------------ENTITYID--------------------");
                  print(agentId);
                  final paymentSession =
                      await CreatePaymentSessionIdRepository()
                          .getPaymentSessionId(
                              agentOriginId: agentId,
                              agentEmail: agentEmail,
                              customerName: widget.custName,
                              customerPhone: widget.custPhoneNumber,
                              customerAccno: widget.custAcNumber,
                              customerId: widget.custIdNew,
                              customerEmail: widget.custEmail,
                              corpCode: widget.corpCode,
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
                    print(
                        "---------------------------------ERROR PAYMENT---------------------------");
                    print(error);
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
                      EasyLoading.showToast("Session id is null");
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
                      widget.custName,
                      widget.custAcNumber,
                      widget.custId,
                      widget.custEmail,
                      amountController.text);
                  //   getCashTrans(
                  //       token: token,
                  //       customerName: widget.custName,
                  //       custPhoneNumber: customerNumber,
                  //       custAcNumber: widget.custAcNumber,
                  //      // custId: custid,
                  //       custId: widget.custId,
                  //       custEmail: widget.custEmail,
                  //       amount: amountController.text,
                  //       phoneNumber: agentMobile,
                  //       entityId: agentId,
                  //       note: "");
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
        customerAccountNumber: widget.custAcNumber,
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
        print("-------------------ERROR---------------------");
        print(error);
      },
      (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          Share.share("Here is your payment link: ${sendLink.linkUrl}");
        } else {
          print("Payment link is empty or null");
        }
      },
    );
  }


  String _getBankNameFromCorpCode(String corpCode) {
    // Map corpcode to bank name
    final Map<String, String> corpCodeToBankName = {
      "BNKKRMR": "KURUMATHUR SERVICE CO OPERATIVE BANK LTD",
      "BNKPDVR": "PIDAVOOR SCB",
      "BNKKNPRM": "Kannapuram SCB",
      "BNKTRK": "Thrikkakkara SCB",
      "BNKKVRY": "KOOVERY SERVICE CO OPERATIVE BANK LTD",
      "BNKKPM": "Kaipamangalam SCB",
      "BNKKPMF": "Kaipamangalam Fisherman SCB",
      "BNKPRK": "Peringottukara SCB",
      "BNKPYPL": "POOYAPALLY SCB",
      "BNKVLMK": "VELIMUKKU SCB",
      "BNKPLKL": "PALLICKAL SCB",
      "BNKCRKT": "CHERUKALATHUR SCB",
      "BNKCLNR": "CHELANNUR SERVICE CO OPERATIVE BANK",
      "BNKPPNS": "Pappinissery Rural Bank",
      "BNKELYR": "ELAYAVOOR SERVICE CO OPERATIVE BANK LTD",
      "BNKKTM": "KOTTAYAM SERVICE CO OPERATIVE BANK LTD",
      "BNKAVN": "Avinissery SCB",
      "BNKDMDM": "DHARMADAM SERVICE CO OPERATIVE BANK LTD",
      "BNKPTVM": "PATTUVAM SERVICE CO OPERATIVE BANK",
      "BNKKUTGM": "KUTTUMUGHAM SERVICE CO OPERATIVE BANK LTD",
      "BNKERKT": "ERAMAM KUTTUR SERVICE CO OPERATIVE BANK LTD",
      "BNKKDKD": "KODAKKAD SERVICE CO OPERATIVE BANK LTD",
      "BNKPMP": "PMP SERVICE CO OPERATIVE BANK",
      "BNKSKMB": "SRI KAMBILAYA MUTUAL NIDHI LIMITED",
      "BNKTSSCB": "Thuravoor South SCB",
      "BNKVBGR": "VIBGYOR NIDHI LIMITED",
      "BNKPPL": "PERUMPILLY SCB",
      "BNKKTRM": "KAITHARAM SCB",
      "BNKKZPL": "KUZHUPPILLY SCB",
      "BNKNABL": "NAYARAMBALAM SCB",
      "BNKELR": "ELOOR SCB",
      "BNKERYD": "ERIYAD SCB",
      "BNKPYVR": "PAYYAVOOR SCB",
      "BNKVDKRA": "VADAKKEKKARA SCB",
      "BNKPRVR": "PARAVUR SCB",
      "BNKVLLR": "Velloor Service Co Operative Bank",
      "BNKMANK": "Manakunnam SCB",
      "BNKAZKD": "AZHIKODE SCB",
      "BNKTHRNL": "Thirunaloor SCB",
      "BNKVDYR": "VADAYAR",
      "BNKKDKPL": "KADAKKARAPALLY SCB",
      "BNKUCMSA": "URBAN CARE MULTI STATE AGRO CSL",
      "BNKKKYR": "KOKKAYAR SCB",
      "BNKMFF": "MILK FARMERS AND FISHERIES",
      "BNKCORDL": "Cordial Gramin Development Foundation",
      "BNKCHLVR": "CHELAVUR SCB",
      "BNKVRND": "VARANAD SCB",
      "BNKVBGRK": "VIBGYOR NIDHI LIMITED KOOTTILANGADI",
      "BNKKNKRA": "KUNNUKARA SCB",
      "BNKEDVNKD": "EDAVANAKKAD",
      "BNKKRDM": "KARTHEDOM SCB",
      "BNKAROOR": "AROOR SCB",
      "BNKGMSA": "Gramin Multi State Agro Co Operative Society Ltd",
      "BNKICCSL": "Indian Cooperative Credit Society Limited",
      "BNKNNDR": "Neendoor scb",
      "BNKCOB": "Co operative bhavan",
      "BNKCHMG": "Chathamangalam SCB",
      "BNKCXTX": "COXTAX",
      "BNKORNTL": "ORIENTAL AGRO MULTISTATE CO OP SOCIETY",
      "BNKTSRA": "Thushara Nidhi",
      "BNKPRTR": "PURATHUR SCB",
      "BNKCLBT": "CLUB T",
      "BNKPNP": "Pearls N Petals",
      "BNKVLKD": "Vellarkkad SCB",
      "BNKMDS": "Medi Soft",
      "BNKPLSCB": "Pulakode service cooperative Bank",
      "BNKMNCHL": "MEENACHIL SCB",
      "BNKOMSRY": "Omassery SCB",
      "BNKPTKL": "Pothukal SCB",
      "BNKFPMC": "FAPMCO MSCS",
      "BNKMULKD": "Mullakkodi Co-operative Bank",
    };

    // Return the bank name if found, otherwise return a default value
    return corpCodeToBankName[corpCode] ?? "Unknown Bank";
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
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
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
      print("getCashTrans $err");
    }, (success) {
      print("getCashTrans $success");
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
                  txnType: "CASH", dat: '', tranType: '', accNo: '',
                ),
              ),
            );
          },
        ),
      );


    });
  }

  @override
  void initState() {


    super.initState();
    loadSharedPrefs();
    _dateTime = DateTime.now();
  }

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
    final provider = Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
    await provider.getRdclDueList("", sub_AgentCodeNew, "", 1, 10, widget.custName);
    if (provider.rdclDueUnderAgentModel == null &&
        provider.rdclDueUnderAgentError != null) {
      showToast(
          message: provider.rdclDueUnderAgentError.toString(),
          color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: Platform.isIOS
              ? const Icon(Icons.arrow_back_ios, color: home2)
              : const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "RDCL Account Details",
          style: GoogleFonts.poppins(
            color: home2,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<RdclDueUnderAgentProvider>(
        builder: (context, provider, child) {
          return provider.rdclDueUnderAgentModel == null
              ? _buildShimmerEffect()
              : Column(
                  children: [
                    _buildCustomerInfoCard(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildDueList(provider),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: home2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: home1.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildInfoRow("Customer Name", widget.custName),
          const Divider(height: 20, thickness: 1),
          _buildInfoRow("Account Number", widget.custAcNumber),
          //const Divider(height: 20, thickness: 1),
          //_buildInfoRow("Mobile", widget.custPhoneNumber),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: home2,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    value,
                    style: GoogleFonts.poppins(
                      color: home1,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (label == "Mobile")
                  IconButton(
                    icon: const Icon(Icons.call, color: home1, size: 20),
                    onPressed: () => _callNumber(value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueList(RdclDueUnderAgentProvider provider) {
    final dataList = provider.rdclDueUnderAgentModel?.data ?? [];

    if (widget.indexValue == null ||
        widget.indexValue! < 0 ||
        widget.indexValue! >= dataList.length) {
      return const Center(child: Text("No due data available"));
    }

    final due = dataList[widget.indexValue!.toInt()];

    // Ensure checkedItems is large enough
    if (checkedItems.length <= widget.indexValue!) {
      checkedItems = List<bool>.filled(dataList.length, false);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: 1, // you're showing just one due detail
        itemBuilder: (_, index) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: home1.withOpacity(0.1)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  checkedItems[widget.indexValue!] =
                  !checkedItems[widget.indexValue!];
                  updateTotalAmount();
                });

                if (checkedItems.contains(true)) {
                  _showBottomBar(context);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Due Amount: ₹ ${due.dueAmount ?? 0}", // ← Use null safety
                            style: GoogleFonts.poppins(
                              color: home1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: checkedItems[widget.indexValue!],
                            onChanged: (bool? value) {
                              setState(() {
                                checkedItems[widget.indexValue!] = value!;
                                updateTotalAmount();
                              });

                              if (checkedItems.contains(true)) {
                                _showBottomBar(context);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            activeColor: home1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Installment Amount: ₹ ${due.installAmt ?? 0}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: home2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Paid : ₹ ${due.paidAmount ?? 0}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Loan Type: RDCL",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due Date: ${due.openDate ?? ''}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total Installment: ${due.totalInstallment ?? 0}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Paid Installments: ${due.paidInstallments ?? 0}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due Installments: ${due.dueInstallments ?? 0}", // ← Use null safety
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
/*
  Widget _buildDueList(RdclDueUnderAgentProvider provider) {
    final dataList = provider.rdclDueUnderAgentModel?.data ?? [];

    // Validate the index before accessing
    if (widget.indexValue == null||
        widget.indexValue! < 0 ||
        widget.indexValue! >= dataList.length
    ) {
      print("widget.indexValue = ${widget.indexValue}");
      return const Center(child: Text("No due data available"));
    }

    final due = dataList[widget.indexValue!.toInt()];

    // Ensure checkedItems is large enough
    if (checkedItems.length <= widget.indexValue!) {
      checkedItems = List<bool>.filled(dataList.length, false);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: 1, // you’re showing just one due detail
        itemBuilder: (_, index) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: home1.withOpacity(0.1)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  checkedItems[widget.indexValue!] =
                  !checkedItems[widget.indexValue!];
                  updateTotalAmount();
                });

                if (checkedItems.contains(true)) {
                  _showBottomBar(context);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Due Amount: ₹ ${due.dueAmount}",
                            style: GoogleFonts.poppins(
                              color: home1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: checkedItems[widget.indexValue!],
                            onChanged: (bool? value) {
                              setState(() {
                                checkedItems[widget.indexValue!] = value!;
                                updateTotalAmount();
                              });

                              if (checkedItems.contains(true)) {
                                _showBottomBar(context);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            activeColor: home1,
                          ),
                        ),
                      ],
                    ),
                   Text(
                        "Installment Amount: ₹ ${due.installAmt}",
                        style: GoogleFonts.poppins(
                          color: home2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                        "Paid : ₹ ${due.paidAmount}",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    const SizedBox(height: 8),
                    Text(
                      "Loan Type: RDCL",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due Date: ${due.openDate}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total Installment: ${due.totalInstallment}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Paid Installments: ${due.paidInstallments}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due Installments: ${due.dueInstallments}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
*/




  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
                      int maxDueAmount = 0;

                      final provider = Provider.of<RdclDueUnderAgentProvider>(
                          context,
                          listen: false);
                      for (var due in provider.rdclDueUnderAgentModel!.data) {
                        maxDueAmount += (due.dueAmount).toInt();
                      }

                      if (enteredAmount > maxDueAmount) {
                        setState(() {
                          amountController.text = maxDueAmount.toString();
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

  // Widget _buildBottomBar(StateSetter setStateModal) {
  //   return SingleChildScrollView(
  //     reverse: true, // Moves content up when keyboard opens
  //     child: Container(
  //       height: MediaQuery.of(context).size.height * 0.15,
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [white, white],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 "Total Amount :",
  //                 style: _bottomTextStyle(),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 120,
  //               child: TextField(
  //                 cursorColor: white,
  //                 controller: amountController,
  //                 keyboardType:
  //                     const TextInputType.numberWithOptions(decimal: true),
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //                 textAlign: TextAlign.center,
  //                 onChanged: (value) {
  //                   int enteredAmount = int.tryParse(value) ?? 0;
  //                   int maxDueAmount = 0;
  //
  //                   final provider = Provider.of<RdclDueUnderAgentProvider>(
  //                       context,
  //                       listen: false);
  //                   for (var due in provider.rdclDueUnderAgentModel!.data) {
  //                     maxDueAmount += (due.dueAmount).toInt();
  //                   }
  //
  //                   if (enteredAmount > maxDueAmount) {
  //                     setState(() {
  //                       amountController.text =
  //                           maxDueAmount.toString(); // Limit input
  //                     });
  //                   }
  //                 },
  //                 decoration: InputDecoration(
  //                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                     borderSide: const BorderSide(color: grey),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                     borderSide: const BorderSide(color: white, width: 2),
  //                   ),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                     borderSide: const BorderSide(color: grey, width: 1),
  //                   ),
  //                   filled: true,
  //                   fillColor: deepTeal,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             ElevatedButton(
  //               onPressed: _proceedButtonClick,
  //               style: ElevatedButton.styleFrom(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10)),
  //                 backgroundColor: white,
  //                 foregroundColor: teal700,
  //                 textStyle: const TextStyle(
  //                     fontWeight: FontWeight.w600, fontSize: 15),
  //               ),
  //               child: const Text("Proceed"),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


  // Widget _buildDueList(RdclDueUnderAgentProvider provider) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     child: ListView.builder(
  //       // itemCount: provider.rdclDueUnderAgentModel!.data.length,
  //       itemCount: 1,
  //       itemBuilder: (_, index) {
  //         final due =
  //             provider.rdclDueUnderAgentModel?.data[widget.indexValue?.toInt()];
  //         return Card(
  //           elevation: 0,
  //           margin: const EdgeInsets.only(bottom: 12),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             side: BorderSide(color: home1.withOpacity(0.1)),
  //           ),
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(12),
  //             onTap: () {
  //               setState(() {
  //                 checkedItems[widget.indexValue.toInt()] =
  //                     !checkedItems[widget.indexValue!];
  //
  //                 updateTotalAmount();
  //               });
  //               if (checkedItems.contains(true)) {
  //                 _showBottomBar(context);
  //               } else {
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text("Due Amount: ₹${due?.dueAmount}",
  //                             style: GoogleFonts.poppins(
  //                               color: home1,
  //                               fontWeight: FontWeight.w600,
  //                             )),
  //                       ),
  //                       Transform.scale(
  //                         scale: 1.2,
  //                         child: Checkbox(
  //                           value: checkedItems[index],
  //                           onChanged: (bool? value) {
  //                             setState(() {
  //                               checkedItems[index] = value!;
  //                               updateTotalAmount();
  //                             });
  //                             if (checkedItems.contains(true)) {
  //                               _showBottomBar(context);
  //                             } else {
  //                               Navigator.of(context).pop();
  //                             }
  //                           },
  //                           activeColor: home1,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     "Loan Type: RDCL",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey[600],
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     "Due Date: ${due?.openDate}",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey[600],
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     "Total Installment: ${due?.totalInstallment}",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey[600],
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     "Paid Installments: ${due?.paidInstallments}",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey[600],
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     "Due Installments: ${due?.dueInstallments}",
  //                     style: GoogleFonts.poppins(
  //                       color: Colors.grey[600],
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildInfoRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       children: [
  //         Expanded(flex: 2, child: Text(label, style: _labelTextStyle())),
  //         Text(":", style: _labelTextStyle()),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           flex: 3,
  //           child: Row(
  //             children: [
  //               Text(value, style: _labelTextStyle()),
  //               if (label == "Mobile Number") // Only add button for phone
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                       icon: const Icon(Icons.call, color: Colors.green),
  //                       onPressed: () => _callNumber(value),
  //                     ),
  //                   ],
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _callNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    // Check permission for CALL_PHONE
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        debugPrint("Permission denied for CALL_PHONE");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Call permission is required")),
        );
        return;
      }
    }

    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }


  TextStyle _labelTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);

  TextStyle _valueTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, color: black87);

  TextStyle _infoTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 14, color: black87);

  TextStyle _bottomTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);
}

class TransactionSuccessDialog extends StatelessWidget {
  final CashTranscation success;
  final VoidCallback onViewReceipt;

  const TransactionSuccessDialog({
    super.key,
    required this.success,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            _buildHeader(context),
            const SizedBox(height: 24),

            // Transaction Details
            _buildTransactionDetails(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Transaction Completed",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
          label: "Status",
          value: success.status ?? 'N/A',
          valueColor: _getStatusColor(success.status),
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Transaction ID",
          value: success.transactionId ?? 'N/A',
          isImportant: true,
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Message",
          value: success.message ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    Color? valueColor,
    bool isImportant = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isImportant ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "CLOSE",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onViewReceipt,
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "VIEW RECEIPT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


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
// String generateRandom12DigitNumber() {
//   final random = Random();
//   double randomNumber = random.nextDouble();
//   int min = 100000000000;
//   int max = 999999999999;
//   int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
//   return scaledNumber.toString();
// }

// String generateRandom6DigitNumber() {
//   final random = Random();
//   double randomNumber = random.nextDouble();
//   int min = 100000;
//   int max = 999999;
//   int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
//   return scaledNumber.toString();
// }
/*  Future<void> fetchTransaction() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.fetchTransaction(
        "", "", agentId.toString(), token.toString());
  }*/

/*
  String formatNumberWithCommas(double? number) {
    final formatter =
        NumberFormat("#,##,##0.00", "en_IN"); // Indian numbering system

    return formatter.format(number ?? 0.0); // Default to 0.0 if number is null
  }
*/