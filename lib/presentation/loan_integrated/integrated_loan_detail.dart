import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_longpress_preview/flutter_longpress_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:provider/provider.dart';

import '../../core/alerts.dart';
import '../../core/utils.dart' as utl;
import '../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../data/provider/loan_cash_coolection_provider.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../paymentlink_request_ui.dart';
import '../qr_code/widgets/generate_qr_code_page.dart';
//THE LOAN CUSTOMER DETAILS PAGE 2 OF 2....

class IntegratedLoanDetail extends StatefulWidget {

  final String loanDate;
  final String name;
  final String custNo;
  final String loanAmount;
  final String loanNumber;
  final String loanType;
  final String loanPeriod;
  final String loanInterest;
  final double principalAmountReceived;
  final double principalAmountBalance;
  final double principalAmountOverdue;
  final double principalAmountReceipt;
  final double interestAmountReceived;
  final double interestAmountBalance;
  final double interestAmountOverdue;
  final double interestAmountReceipt;
  final double penalInterestAmountReceived;
  final double penalInterestAmountBalance;
  final double penalInterestAmountOverdue;
  final double penalInterestAmountReceipt;
  const IntegratedLoanDetail(
      {super.key,
      required this.loanDate,
      required this.loanAmount,
      required this.loanNumber,
      required this.loanType,
      required this.loanPeriod,
      required this.loanInterest,
      required this.principalAmountReceived,
      required this.principalAmountBalance,
      required this.principalAmountOverdue,
      required this.principalAmountReceipt,
      required this.interestAmountReceived,
      required this.interestAmountBalance,
      required this.interestAmountOverdue,
      required this.interestAmountReceipt,
      required this.penalInterestAmountReceived,
      required this.penalInterestAmountBalance,
      required this.penalInterestAmountOverdue,
      required this.penalInterestAmountReceipt,
      required this.name,
      required this.custNo});

  @override
  State<IntegratedLoanDetail> createState() => _IntegratedLoanDetailState();
}

class _IntegratedLoanDetailState extends State<IntegratedLoanDetail> {
  String? agentId;
  String? agent_Id;
  String? corpCode;
  String? agentEmail;
  String? agentIdValue;
  String? token;
  String? agentMobile;
  String? subAgentCodeNew;
  String? cid;
  String? subagentId;
  String? agentName;
  String? agentOriginId;
  String? paymentSessionId;
  String? branchCode;
  String selectedMethod ="";
  String? selectedAccNumber;
  TextEditingController editAmountController = TextEditingController();
   Color? dominantColor;
  String? eCollectAgentNumber;
  String? subagentPhoneNumber;
  String? eCollectMerchantName;
  String? eCollectAgentEmail;
  String? eCollectCollectionType;
  String? eCollectAgentBranchCode;
  String? eCollectAgentMerchantID;
  String? eCollectAgentOriginId;
  String? eCollectAgentId;
  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    createColorPallet("assets/images/person.png");
    editAmountController.text = (widget.principalAmountBalance+widget.interestAmountBalance+widget.penalInterestAmountBalance).toString();
  }

  void validateInput() {
    if (editAmountController.text.isEmpty) return;

    final value = double.parse(editAmountController.text);
    if (value != null && value > int.parse(widget.loanAmount)) {
      editAmountController.text = widget.loanAmount.toString();
      editAmountController.selection = TextSelection.fromPosition(
          TextPosition(offset: editAmountController.text.length));
    }
  }
  @override
  void dispose() {
    editAmountController.dispose();
    editAmountController.removeListener(validateInput);
    super.dispose();
  }
  Future<void> loadSharedPrefs() async {
    final prefs = SharedPref();
    final id = await SharedPref().getSubAgentCode();
    final agentid = await SharedPref().getAgentId();
    String custid = await SharedPref().getCustId();
    final crpCd = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final mail = await SharedPref().getEmail();
    final agentOrigin = await SharedPref().getSubAgentCode();
    final custId = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final phone = await SharedPref().getParentAgentMobNum();
    final name = await SharedPref().getAgentName();
    final brCode = await SharedPref().getBranchCode();

    //-------------------------------------
    final _eCollectMerchantName = await prefs.getECollectMerchantName();
    final _eCollectAgentId = await prefs.getECollectUserID();
    final _eCollectAgentOriginId = await prefs.getECollectUserID();
    final _eCollectAgentNumber = await prefs.getECollectUserNumber();
    final _eCollectAgentEmail = await prefs.getECollectUserEmail();
    final _eCollectAgentBranchCode =
    await prefs.getECollectMerchantBranchCode();
    final _eCollectAgentMerchantID = await prefs.getECollectMerchantID();
    final _eCollectCollectionType = await prefs.getECollectUserType();
    //---------------------------------------
    setState(() {
      cid = custid;
      eCollectMerchantName = _eCollectMerchantName;
      eCollectAgentId = _eCollectAgentId;
      eCollectAgentOriginId = _eCollectAgentOriginId;
      eCollectAgentNumber = _eCollectAgentNumber;
      eCollectAgentEmail = _eCollectAgentEmail;
      eCollectAgentBranchCode = _eCollectAgentBranchCode;
      eCollectAgentMerchantID = _eCollectAgentMerchantID;
      eCollectCollectionType = _eCollectCollectionType;

      subAgentCodeNew = sub_AgentCodeNew;
      branchCode = brCode;
      agent_Id = agentid;
      agentId = id;
      corpCode = crpCd;
      agentIdValue = custId;
      token = tok;
      agentName = name;
      agentOriginId = agentOrigin;
      agentEmail = mail;
      agentMobile = phone;
      subagentId = subAgentId;
    });
    editAmountController.addListener(validateInput);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          "LOAN DETAILS",
          style: TextStyle(color: home1, fontWeight: FontWeight.w700),
        ),
      ),
      body:

      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildLoanDetailsCard(),
            const SizedBox(height: 24),

            // Modern Card Container for Amount Sections
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildModernAmountSection(
                    title: "Principal Amount",
                    received: widget.principalAmountReceived,
                    balance: widget.principalAmountBalance,
                    overdue: widget.principalAmountOverdue,
                    current: widget.principalAmountReceipt,
                    icon: Icons.account_balance_wallet,
                    color: const Color(0xFF4361EE),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildModernAmountSection(
                    title: "Interest",
                    received: widget.interestAmountReceived,
                    balance: widget.interestAmountBalance,
                    overdue: widget.interestAmountOverdue,
                    current: widget.interestAmountReceipt,
                    icon: Icons.trending_up,
                    color: const Color(0xFFE76F51),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildModernAmountSection(
                    title: "Penal Interest",
                    received: widget.penalInterestAmountReceived,
                    balance: widget.penalInterestAmountBalance,
                    overdue: widget.penalInterestAmountOverdue,
                    current: widget.penalInterestAmountReceipt,
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFE63946),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Modern Button Row
            Row(
              children: [
                Expanded(
                  child: _buildModernButton(
                    text: "QR",
                    icon: Icons.qr_code,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "QR Amount",
                                        style: TextStyle(
                                          color: Color(0xFF4361EE),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          editAmountController.text = widget.loanAmount.toString();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: editAmountController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.currency_rupee,
                                        color: Color(0xFF4361EE),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                                      ),
                                      labelText: "Enter collection amount",
                                      labelStyle: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedMethod = "QR";
                                        });

                                        context.read<PaymentBloc>().add(QrPaymentEvent(QrPaymentRequestModel(
                                            agentDetails: AgentDetails(agentName: eCollectMerchantName!, agentId: eCollectAgentId!, agentOrginId: "1079", agentPhone: eCollectAgentNumber!, agentEmail: eCollectAgentEmail!, agentBranch: int.parse(eCollectAgentBranchCode!)),
                                            customerDetails: CustomerDetails(customerName:
                                            widget.name, customerPhone: eCollectAgentNumber!,
                                               // customerAccno: widget.loanNumber,
                                                customerAccno: "01042888",
                                                customerId: widget.custNo, customerEmail: eCollectAgentEmail!),
                                            collectionType: eCollectCollectionType!,
                                            amount: double.parse(editAmountController.text),
                                            note: 'Payment for Order',
                                            qrSource: 'MOB',
                                            source: 'COLLECTION',
                                            merchantId: int.parse(eCollectAgentMerchantID!))));
                                           // merchantId: 1)
                                       // ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: home1,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        "Generate Payment QR",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    isOutlined: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernButton(
                    text: "Link",
                    icon: Icons.link,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Link Amount",
                                        style: TextStyle(
                                          color: Color(0xFF4361EE),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          editAmountController.text = widget.loanAmount.toString();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: editAmountController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.currency_rupee,
                                        color: Color(0xFF4361EE),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                                      ),
                                      labelText: "Enter collection amount",
                                      labelStyle: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedMethod = "Link";
                                        });
                                        context.read<PaymentBloc>().add(LinkPaymentEvent(QrPaymentRequestModel(
                                            agentDetails: AgentDetails(agentName: eCollectMerchantName!,
                                                agentId: eCollectAgentId!,
                                                agentOrginId: "1079",
                                                agentPhone: eCollectAgentNumber!,
                                                agentEmail: eCollectAgentEmail!,
                                                agentBranch: int.parse(eCollectAgentBranchCode!)),
                                            customerDetails: CustomerDetails(customerName:
                                            widget.name,
                                                customerPhone: eCollectAgentNumber!,
                                               // customerAccno: widget.loanNumber,
                                                customerAccno: "01042888",
                                                customerId: widget.custNo, customerEmail: eCollectAgentEmail!),
                                            collectionType: eCollectCollectionType!,
                                            amount: double.parse(editAmountController.text),
                                            note: 'Payment for Order',
                                            qrSource: 'MOB',
                                            source: 'COLLECTION',
                                            merchantId: int.parse(eCollectAgentMerchantID!))));
                                            //merchantId:1)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: home1,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        "Send Payment Link",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    isOutlined: false,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: _buildModernButton(
                    text: "Cash",
                    icon: Icons.money_rounded,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Collection Amount",
                                        style: TextStyle(
                                          color: Color(0xFF4361EE),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          editAmountController.text = widget.loanAmount.toString();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: editAmountController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.currency_rupee,
                                        color: Color(0xFF4361EE),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                                      ),
                                      labelText: "Enter collection amount",
                                      labelStyle: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        paymentConfirmation(
                                          context,
                                          agentName!,
                                          widget.loanNumber,
                                          widget.custNo,
                                          editAmountController.text,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: home1,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        "Confirm Collection",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),

              ],
            ),
            BlocListener<PaymentBloc, PaymentState>(
              listener: (BuildContext context, PaymentState state) {
                if (state is QrPaymentLoaderState) {
                  utl.showProgressDialog(context);
                }
                if (state is QrPaymentSuccessState) {
                  Navigator.pop(context);
                  print(state.qrPaymentSuccess.paymentResponseSuccess.paymentUrl);
                  selectedMethod == "Link"
                      ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PaymentLinkRequestUi(
                                customerMobileNumber: "",
                                paymentLink: state.qrPaymentSuccess
                                    .paymentResponseSuccess.paymentUrl,
                              )))
                      : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewQrCodePage(
                        paymentSessionId: state.qrPaymentSuccess
                            .paymentResponseSuccess.paymentUrl,
                        amount: editAmountController.text,
                        custName: "",
                        custPhone: "custNumber",
                        custId: "CustId",
                      ),
                    ),
                  );
                } else if (state is QrPaymentFailState) {
                  Navigator.pop(context);
                  showAlertDialog(
                      state.qrPaymentFail.paymentFailResponse.message, context);
                  print(state.qrPaymentFail.paymentFailResponse.message);
                } else if (state is CashPaymentSuccessState) {
                  Navigator.pop(context);
                  showAlert(
                      state.cashPaymentSuccess.cashPaymentSuccessResponse
                          .status ==
                          "Y"
                          ? "SUCCESS"
                          : "FAILED",
                      state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
                      context);
                  print(state
                      .cashPaymentSuccess.cashPaymentSuccessResponse.message);
                } else if (state is CashPaymentFailState) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showAlertDialog(state.cashPaymentFail.payemtError, context);
                  print(state.cashPaymentFail.payemtError);
                }
              },
              child: SizedBox(),
            ),

          ],
        ),
      )
    );
  }

  BoxDecoration _modernCardDecoration() {
    return BoxDecoration(
      color: dominantColor?.withAlpha(150),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha:0.02),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

/*  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        agentName: agentName!,
        agentId: agentId!,
        agentOriginId: agentOriginId!,
        agentPhone: agentMobile!,
        agentEmail: agentEmail!,
        customerName: widget.name,
        customerPhone: widget.custNo,
        customerAccountNumber: widget.loanNumber,
        customerEmail: "",
        customerId: cid!,
        linkAmount: num.parse(editAmountController.text),
        note: "Payment for Order #12345",
        corpCode: corpCode!,
        cardRefNum: "",
        token: token.toString(),
        subAgentId: subagentId!);

    send.fold(
          (error) {

      },
          (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          //Share.share("Here is your payment link: ${sendLink.linkUrl}");
          if(utl.printStatementStatus){
            print("3");
          }

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
              PaymentLinkRequestUi(customerMobileNumber: widget.custNo, paymentLink: sendLink.linkUrl.toString(),)
          ));
        } else {
          // print("Payment link is empty or null");
        }
      },
    );
  }*/
  Future<void> createColorPallet(String imageStr) async {
    final ImageProvider imageProvider = AssetImage(imageStr);
    final PaletteGeneratorMaster paletteGenerator =
        await PaletteGeneratorMaster.fromImageProvider(
      imageProvider,
      maximumColorCount: 16,
      generateHarmony: true,      // Generate color harmony
    );
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
if(utl.printStatementStatus){
  print("dominantColor = $dominantColor");
}

    //final Color? vibrantColor = paletteGenerator.vibrantColor?.color;
   // final Color? mutedColor = paletteGenerator.mutedColor?.color;
  }
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _modernCardDecoration(),
      child: Row(
        children: [
          // Modern Avatar with gradient background
          LongPressImagePreview(
            imageProvider: AssetImage("assets/images/cq1.webp"),
            child: Container(
              decoration: BoxDecoration(
                color: dominantColor,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 40,
                 backgroundImage: AssetImage("assets/images/cq1.webp"),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: Text(
                        
                          widget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 12,
                            color: const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4361EE).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.badge_rounded,
                        size: 14,
                        color: Color(0xFF4361EE),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Customer ID: ${widget.custNo}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade200,),

                Row(children: [
                  InkWell(
                    onTap: (){
                      utl.openGoogleMaps(9.992079734802246,   76.27655792236328);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "View Customer Location",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],)
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLoanDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Loan Details",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: home2)),

          const SizedBox(height: 12),

          _buildDetailRow(Icons.date_range, "Loan Date", widget.loanDate),
          _buildDetailRow(Icons.currency_rupee, "Loan Amount", widget.loanAmount),
          _buildDetailRow(Icons.numbers, "Loan Number", widget.loanNumber),
          _buildDetailRow(Icons.account_balance_wallet, "Loan Type", widget.loanType),
          _buildDetailRow(Icons.schedule, "Loan Period", widget.loanPeriod),
          _buildDetailRow(Icons.percent, "Interest", widget.loanInterest),
        ],
      ),
    );
  }
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEA307B).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFEA307B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
/*  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: home1),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }*/
  // Widget _buildAmountSection({
  //   required String title,
  //   required dynamic received,
  //   required dynamic balance,
  //   required dynamic overdue,
  //   required dynamic current,
  // })
  // {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: _cardDecoration(),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(title,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 color: home2)),
  //
  //         const SizedBox(height: 12),
  //
  //         _buildAmountRow("Received", received, Colors.green),
  //         _buildAmountRow("Balance", balance, Colors.blue),
  //         _buildAmountRow("Overdue", overdue, Colors.red),
  //         _buildAmountRow("Current", current, home1),
  //       ],
  //     ),
  //   );
  // }
  // Widget _buildAmountRow(String label, dynamic value, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(label, style: TextStyle(color: color, fontSize: 12)),
  //         Text(value.toString(),
  //             style: TextStyle(
  //                 color: color,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 13)),
  //       ],
  //     ),
  //   );
  // }
  // Widget _buildPrimaryButton(String text, {required VoidCallback onTap}) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: onTap,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: home1,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //       ),
  //       child: Text(text, style: const TextStyle(fontSize: 14)),
  //     ),
  //   );
  // }
  //
  // Widget _buildOutlineButton(String text, {required VoidCallback onTap}) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: OutlinedButton(
  //       onPressed: onTap,
  //       style: OutlinedButton.styleFrom(
  //         side: BorderSide(color: home1),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //       ),
  //       child: Text(text, style: TextStyle(color: home1)),
  //     ),
  //   );
  // }
  Widget _buildModernAmountSection({
    required String title,
    required double received,
    required double balance,
    required double overdue,
    required double current,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAmountChip("Received", received, const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _buildAmountChip("Balance", balance, const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              _buildAmountChip("Overdue", overdue, const Color(0xFFEF4444)),
            ],
          ),
          if (current > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha:0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Current Receipt",
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  Text(
                    "₹${current.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountChip(String label, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "₹${amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : home1,
        foregroundColor: isOutlined ? home1 : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isOutlined ? BorderSide(color: home1) : BorderSide.none,
        ),
        elevation: isOutlined ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }


  Future<bool> paymentConfirmation(
      BuildContext context,
      String name,
      String accNo,
      String custId,
      String amt,
      )
  async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
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
                  color: Colors.black.withValues(alpha:0.2),
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
                      color: Colors.redAccent.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
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
                        onPressed: () {
                          Navigator.pop(context, false); // 🚫 User said NO
                        },
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

                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMethod = "Cash";
                          });
                          Navigator.pop(context);
                          context.read<PaymentBloc>().add(CashPaymentEvent(QrPaymentRequestModel(
                              agentDetails: AgentDetails(agentName: eCollectMerchantName!, agentId: eCollectAgentId!, agentOrginId: "1079", agentPhone: eCollectAgentNumber!, agentEmail: eCollectAgentEmail!, agentBranch: int.parse(eCollectAgentBranchCode!)),
                              customerDetails: CustomerDetails(customerName:
                              widget.name, customerPhone: eCollectAgentNumber!,
                                //  customerAccno: widget.loanNumber,
                                  customerAccno: "01042888",
                                  customerId: widget.custNo, customerEmail: eCollectAgentEmail!),
                              collectionType: eCollectCollectionType!,
                              amount: double.parse(editAmountController.text),
                              note: 'Payment for Order',
                              qrSource: 'MOB',
                              source: 'COLLECTION',
                               merchantId: int.parse(eCollectAgentMerchantID!))));
                             // merchantId: 1)));

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
    ).then((value) => value ?? false); // default to false if dismissed
  }


  Future<void> loanCashCollection() async {
    utl.showProgressDialog(context);
    final loanCashProvider =
    Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agent_Id.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.name,
        "",
        widget.loanNumber,
        widget.custNo,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB", "CASH", "", "LOAN");
    if (loanCashProvider.loanCashCollectionResponse != null) {
      if(!mounted) return;
      Navigator.pop(context);
      //print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context,
                loanCashProvider.loanCashCollectionResponse!.status == "Y"
                    ? true
                    : false,
                loanCashProvider.loanCashCollectionResponse!.message
                    .toString());
          });
    } else {
      if(!mounted) return;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context, false, loanCashProvider.loanCollectionErr.toString());
          });
    }
  }

  Future<void> generateQrPaymentSession() async {
    utl.showProgressDialog(context);
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
        agentOriginId: agentOriginId,
        agentEmail: agentEmail,
        customerName: widget.name,
        customerPhone: "",
        customerAccno: widget.loanNumber,
        customerId: widget.custNo,
        customerEmail: "",
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        amount: editAmountController.text,
        agentPhone: agentMobile,
        agentId: agent_Id,
        note: "Payment For Agent ${widget.loanType}",
        subAgentId: subagentId,
        agentName: agentName,
        subAgentBranchCode: subAgentCodeNew,
        collectionType: 'LOAN');
    paymentSession.fold((error) {
      // print(
      //     "---------------------------------ERROR PAYMENT---------------------------");
      // print(error);
    }, (sessionId) async {
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
              amount: editAmountController.text ?? "",
              custName: widget.name ?? "custName",
              custPhone: "",
              custId: widget.custNo,
            ),
          ),
        ).then((_){
          if(!mounted) return;
          Navigator.pop(context);});
        if (!mounted) return;
        if (result == "fetch_balance") {
          Navigator.pop(context);
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        // EasyLoading.showToast("Session id is null");
      }
    });
  }


  AlertDialog linkShareAlert(BuildContext context, bool status, String msg) {
    return AlertDialog(
      icon: status == true
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
              size: 30,
            ),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Center(
          child: status == true ? const Text("Success") : const Text("Error")),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Text(
              msg,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(" OK "))
          ],
        ),
      ),
    );
  }
}

/*  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final agentid = await SharedPref().getAgentId();
    String custid = await SharedPref().getCustId();

    final crpCd = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final mail = await SharedPref().getEmail();
    final agentOrigin = await SharedPref().getAgentOriginId();
    final custId = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final phone = await SharedPref().getParentAgentMobNum();
    final name = await SharedPref().getAgentName();
    final brCode = await SharedPref().getBranchCode();

    setState(() {
      cid = custid;
      subAgentCodeNew = sub_AgentCodeNew;
      branchCode = brCode;
      agent_Id = agentid;
      agentId = id;
      corpCode = crpCd;
      agentIdValue = custId;
      token = tok;
      agentName = name;
      agentOriginId = agentOrigin;
      agentEmail = mail;
      agentMobile = phone;
      subagentId = subAgentId;
    });
    editAmountController.addListener(validateInput);
  }
  Future<void> loanCashCollection() async {
    utl.showProgressDialog(context);
    final loanCashProvider =
    Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agentId.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.name,
        widget.custNo,
        widget.loanNumber,
        widget.,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB", "CASH", "");
    if (loanCashProvider.loanCashCollectionResponse != null) {
      Navigator.pop(context);
      print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context,
                loanCashProvider.loanCashCollectionResponse!.status == "Y"
                    ? true
                    : false,
                loanCashProvider.loanCashCollectionResponse!.message
                    .toString());
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context, false, loanCashProvider.loanCollectionErr.toString());
          });
    }
  }*/