import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/data/provider/loan_cash_coolection_provider.dart';
import 'package:collection_qr_flutter/data/provider/whatsapp_share_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/provider/cash_transcation_provider.dart';
import '../../data/repository/payment_link_repository.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../account_dues/widgets/rdcl_account_due_detail_page.dart';
import '../dues/widgets/new_qr_code_page.dart';
import '../profile/widgets/recipect_page.dart';
import 'package:collection_qr_flutter/core/utils.dart' as utl;

class LoanDetailsPage extends StatefulWidget {
  final String customerName;
  final String customerPhoneNumber;
  final String loanNumber;
  final String loanStatus;
  final num emiAmount;
  final num loanTerm;
  final num loanAmount;
  final String scheme;
  final String paymentDate;
  final String collectionFrequency;
  final String email;
  final String custId;

  const LoanDetailsPage(
      {super.key,
      required this.customerName,
      required this.loanNumber,
      required this.emiAmount,
      required this.loanTerm,
      required this.loanStatus,
      required this.loanAmount,
      required this.scheme,
      required this.paymentDate,
      required this.collectionFrequency,
      required this.email,
      required this.customerPhoneNumber,
      required this.custId});

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideUpAnimation;
  late Animation<Color?> _colorAnimation;
  String? agentId;
  String? agent_Id;
  String? corpCode;
  String? agentEmail;
  String? agentIdValue;
  String? token;
  String? agentMobile;
  String? subAgentCodeNew;
  String? subagentId;
  String? agentName;
  String? agentOriginId;
  String? paymentSessionId;
  String? branchCode;
  String? selectedAccNumber;
  TextEditingController editAmountController = TextEditingController();
  TextEditingController utrController = TextEditingController();



  // Sample loan data
  final Map<String, dynamic> loanDetails = {
    'loanNumber': 'LN-2023-45678',
    'borrowerName': 'John Doe',
    'loanAmount': 25000.00,
    'interestRate': 7.5,
    'term': 36, // months
    'startDate': '2023-06-15',
    'endDate': '2026-06-15',
    'monthlyPayment': 777.53,
    'remainingBalance': 18500.00,
    'status': 'Active',
    'lastPaymentDate': '2023-10-01',
    'nextPaymentDue': '2023-11-01',
  };

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    editAmountController.text = widget.emiAmount.toString();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _slideUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: home1.withOpacity(0),
      end: home1.withOpacity(0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    editAmountController.dispose();
    editAmountController.removeListener(validateInput);
    super.dispose();
  }

  void validateInput() {
    if (editAmountController.text.isEmpty) return;

    final value = double.parse(editAmountController.text);
    if (value != null && value > widget.loanAmount) {
      editAmountController.text = widget.loanAmount.toString();
      editAmountController.selection = TextSelection.fromPosition(
          TextPosition(offset: editAmountController.text.length));
    }
  }

/*
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
*/

  Future<void> accTrans() async {
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
        widget.customerName,
        widget.customerPhoneNumber,
        widget.loanNumber,
        widget.custId,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB", "TRANSFER",utrController.text );
    if (loanCashProvider.loanCashCollectionResponse != null) {
      Navigator.pop(context);
      print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(context, loanCashProvider.loanCashCollectionResponse!.status == "Y" ? true
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
        widget.customerName,
        widget.customerPhoneNumber,
        widget.loanNumber,
        widget.custId,
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
      required String? note}) async {
    final cashPaymentProvider =
        Provider.of<CashTranscationProvider>(context, listen: false);
    final cash = await cashPaymentProvider.getTranscations(
        agentName: agentName,
        agentId: agent_Id,
        agentOriginId: agentOriginId,
        agentPhone: phoneNumber,
        agentEmail: agentEmail,
        subAgentId: subagentId,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: custAcNumber,
        customerId: custId,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: branchCode);
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
                  bankName:
                      utl.getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
                  agentName: agentName ?? "Name",
                  agentPhone: agentMobile ?? "agentPhone",
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

  Future<bool> paymentConfirmation(
    BuildContext context,
    String name,
    String accNo,
    String custId,
    String amt,
  ) async {
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
                          getCashTrans(
                            token: token,
                            customerName: name,
                            custPhoneNumber: widget.customerPhoneNumber,
                            custAcNumber: accNo,
                            custId: custId,
                            custEmail: widget.email,
                            phoneNumber: "$agentMobile",
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
    ).then((value) => value ?? false); // default to false if dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Loan Details'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: home2),
        titleTextStyle: const TextStyle(
          color: home2,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header with profile and status
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: home1.withOpacity(0.2),
                                child: const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: home1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.customerName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: home2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Loan #${widget.loanNumber.replaceAll("LOAN-", "")}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.loanStatus == 'Active'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: widget.loanStatus == 'Active'
                                        ? Colors.green
                                        : Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.loanStatus,
                                  style: TextStyle(
                                    color: widget.loanStatus == 'Active'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loan summary cards in a row
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Outstanding Amount',
                              '₹ ${widget.loanAmount}',
                              Icons.attach_money,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              'Monthly payment',
                              //'\$${loanDetails['remainingBalance'].toStringAsFixed(2)}',
                              '₹ ${widget.emiAmount.toStringAsFixed(2)}',
                              Icons.account_balance_wallet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Loan details
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.4),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.zero,
                        // To match previous container width behavior
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Loan Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: home2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // _buildDetailItem(
                              //   Icons.percent,
                              //   'Interest Rate',
                              //   '${loanDetails['interestRate']}%',
                              // ),
                              _buildDetailItem(
                                  Icons.calendar_today,
                                  'Loan Term',
                                  "${widget.loanTerm} ${widget.collectionFrequency}"),
                              _buildDetailItem(
                                Icons.payment,
                                'Monthly Payment',
                                '₹${widget.emiAmount}',
                              ),
                              _buildDetailItem(
                                Icons.date_range,
                                'Scheme',
                                widget.scheme,
                              ),
                              _buildDetailItem(
                                Icons.event_available,
                                'End Date',
                                loanDetails['endDate'],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment information section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.zero, // Ensures full width
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: home2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                Icons.history,
                                'Last Payment',
                                widget.paymentDate,
                              ),
                              _buildDetailItem(
                                Icons.next_plan,
                                'Next Payment Due',
                                loanDetails['nextPaymentDue'],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.6),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: home1,
                                elevation: 0,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true, // Already set
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom, // <-- important
                                      ),
                                      child: SizedBox(
                                        height: 200,
                                        // You can make it dynamic if needed
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  const Text(
                                                    "QR Amount",
                                                    style: TextStyle(
                                                        color: home1,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const Spacer(flex: 1),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      editAmountController
                                                              .text =
                                                          widget.emiAmount
                                                              .toString();
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel_rounded,
                                                      size: 30,
                                                      color: home2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    editAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.currency_rupee,
                                                          color: home1,
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        labelText:
                                                            "Enter collection amount"),
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  //Navigator.pop(context);
                                                  generateQrPaymentSession();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: home1,
                                                    foregroundColor:
                                                        Colors.white),
                                                child: const Text("Submit"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                // paymentConfirmation(context, agentName!,
                                //     widget.loanNumber, widget.custId, "1");

                                // Handle make payment action
                              },
                              child: const Text(
                                'Generate QR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true, // Already set
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom, // <-- important
                                        ),
                                        child: SizedBox(
                                          height: 200,
                                          // You can make it dynamic if needed
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Spacer(flex: 1),
                                                    const Text(
                                                      "Collection Amount",
                                                      style: TextStyle(
                                                          color: home1,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    const Spacer(flex: 1),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        editAmountController
                                                                .text =
                                                            widget.emiAmount
                                                                .toString();
                                                      },
                                                      child: const Icon(
                                                        Icons.cancel_rounded,
                                                        size: 30,
                                                        color: home2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      editAmountController,
                                                  decoration:
                                                      const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .currency_rupee,
                                                            color: home1,
                                                          ),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          labelText:
                                                              "Enter collection amount"),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    loanCashCollection();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              home1,
                                                          foregroundColor:
                                                              Colors.white),
                                                  child: const Text("Submit"))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  // paymentConfirmation(context, agentName!,
                                  //     widget.loanNumber, widget.custId, "1");
                                },
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: const BorderSide(color: home2)),
                                child: const Text(
                                  "Collect Cash",
                                  style: TextStyle(
                                      color: home1,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: home1),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true, // Already set
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom, // <-- important
                                      ),
                                      child: SizedBox(
                                        height: 200,
                                        // You can make it dynamic if needed
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  const Text(
                                                    "Payment Link Amount",
                                                    style: TextStyle(
                                                        color: home1,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const Spacer(flex: 1),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      editAmountController
                                                              .text =
                                                          widget.emiAmount
                                                              .toString();
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel_rounded,
                                                      size: 30,
                                                      color: home2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    editAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.currency_rupee,
                                                          color: home1,
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        labelText:
                                                            "Enter collection amount"),
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  utl.showProgressDialog(context);
                                                  sendLinkFunction();

                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: home1,
                                                    foregroundColor:
                                                        Colors.white),
                                                child: const Text("Submit"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                // Handle view schedule action
                              },
                              child: const Text(
                                'Send Payment Link',
                                style: TextStyle(
                                  color: home1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: home1),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true, // Already set
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom, // <-- important
                                      ),
                                      child: SizedBox(
                                        height: 250,
                                        // You can make it dynamic if needed
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  const Text(
                                                    "Account Transfer",
                                                    style: TextStyle(
                                                        color: home1,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  const Spacer(flex: 1),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      editAmountController
                                                              .text =
                                                          widget.emiAmount
                                                              .toString();
                                                      utrController.clear();
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel_rounded,
                                                      size: 30,
                                                      color: home2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: editAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.account_balance_sharp,
                                                          color: home1,
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        labelText:
                                                            "Enter collection amount"),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    utrController,
                                                decoration:
                                                    const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.currency_rupee,
                                                          color: home1,
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        labelText:
                                                            "Enter UTR Number"),
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  accTrans();

                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: home1,
                                                    foregroundColor:
                                                        Colors.white),
                                                child: const Text("Submit"))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                // Handle view schedule action
                              },
                              child: const Text(
                                'Account Transfer',
                                style: TextStyle(
                                  color: home1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                         const SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final agentid = await SharedPref().getAgentId();

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

  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        agentName: agentName!,
        agentId: agentId!,
        agentOriginId: agentOriginId!,
        agentPhone: agentMobile!,
        agentEmail: agentEmail!,
        customerName: widget.customerName,
        customerPhone: agentMobile!,
        customerAccountNumber: widget.loanNumber,
        customerEmail: "",
        customerId: widget.custId,
        linkAmount: int.parse(editAmountController.text),
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
      (sendLink) async {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          ///the link
          var whatsAppProvider =
              Provider.of<WhatsAppShareProvider>(context, listen: false);
          await whatsAppProvider.sendPaymentLinkViaWhatsApp(
              "7909103947",
              widget.customerName,
              widget.loanNumber,
              editAmountController.text,
              sendLink.linkUrl.toString());
          if (whatsAppProvider.whatsAppResponse != null) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return linkShareAlert(
                      context,
                      whatsAppProvider.whatsAppResponse!.success,
                      "Message send success");
                });
          }
        } else {
          print("Payment link is empty or null");
        }
      },
    );
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

   showAccTransDialog() async {
   return SizedBox(
      height: 100,
      child: await showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return  SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Center(child: Text("Collect Amount", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),)),


              ],),
            );
          }),
    );

  }

  Future<void> generateQrPaymentSession() async {
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
            agentOriginId: agentId,
            agentEmail: agentEmail,
            customerName: widget.customerName,
            customerPhone: widget.customerPhoneNumber,
            customerAccno: widget.loanNumber,
            customerId: widget.custId,
            customerEmail: widget.email,
            corpCode: corpCode,
            cardRefNum: "",
            token: token,
            amount: editAmountController.text,
            agentPhone: agentMobile,
            agentId: widget.custId,
            note: "Payment For Agent ${widget.scheme}",
            subAgentId: subagentId,
            agentName: agentName,
            subAgentBranchCode: subAgentCodeNew,
            collectionType: 'LOAN');
    paymentSession.fold((error) {
      print(
          "---------------------------------ERROR PAYMENT---------------------------");
      print(error);
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
              token: token!,
              custName: widget.customerName ?? "custName",
              custPhone: widget.customerPhoneNumber,
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
        // EasyLoading.showToast("Session id is null");
      }
    });
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: home1.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: home1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: home2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: home1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: home2,
            ),
          ),
        ],
      ),
    );
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
//
//           onPressed: () => {Navigator.pop(context),
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ReceiptPage(
//               amount: success.amount.toString(),
//               bankName: _getBankNameFromCorpCode(corpCode!)?? "XYZ BANK",
//               agentName: agentName ?? "Name",
//               agentPhone:
//               agentPhoneNumber ?? "agentPhone",
//               custName: customerName!,
//               custPhone: custPhoneNumber!,
//               custId: custId!, txnId: success.transactionId.toString(), txnType: "CASH",
//             )))},
//           child: const Text("OK"),
//         ),
//       ],
//     );
//   },
// );
// return Container(
//   padding: const EdgeInsets.all(16),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(16),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.05),
//         blurRadius: 10,
//         offset: const Offset(0, 5),
//       ),
//     ],
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: home1.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 20,
//               color: home1,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 8),
//       Text(
//         value,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: home2,
//         ),
//       ),
//     ],
//   ),
// );
// FadeTransition(
//   opacity: _fadeAnimation,
//   child: SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(_animationController),
//     child: Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Payment Information',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: home2,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildDetailItem(
//             Icons.history,
//             'Last Payment',
//             loanDetails['lastPaymentDate'],
//           ),
//           _buildDetailItem(
//             Icons.next_plan,
//             'Next Payment Due',
//             loanDetails['nextPaymentDue'],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
// FadeTransition(
//   opacity: _fadeAnimation,
//   child: SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(0, 0.4),
//       end: Offset.zero,
//     ).animate(_animationController),
//     child: Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Loan Details',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: home2,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildDetailItem(
//             Icons.percent,
//             'Interest Rate',
//             '${loanDetails['interestRate']}%',
//           ),
//           _buildDetailItem(
//             Icons.calendar_today,
//             'Loan Term',
//             '${widget.loanTerm} days',
//           ),
//           _buildDetailItem(
//             Icons.payment,
//             'Monthly Payment',
//             '₹${widget.emiAmount}',
//           ),
//           _buildDetailItem(
//             Icons.date_range,
//             'Start Date',
//             loanDetails['startDate'],
//           ),
//           _buildDetailItem(
//             Icons.event_available,
//             'End Date',
//             loanDetails['endDate'],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
// FadeTransition(
//   opacity: _fadeAnimation,
//   child: SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(_animationController),
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: home1.withOpacity(0.2),
//             child: Icon(
//               Icons.person,
//               size: 30,
//               color: home1,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.customerName,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: home2,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Loan #${widget.loanNumber.replaceAll("LOAN-", "")}',
//                   style: const TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: widget.loanStatus == 'Active'
//                   ? Colors.green.withOpacity(0.1)
//                   : Colors.orange.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: widget.loanStatus == 'Active'
//                     ? Colors.green
//                     : Colors.orange,
//                 width: 1,
//               ),
//             ),
//             child: Text(
//               widget.loanStatus,
//               style: TextStyle(
//                 color: widget.loanStatus == 'Active'
//                     ? Colors.green
//                     : Colors.orange,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
/*
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
*/
