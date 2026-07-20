import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/data/provider/loan_cash_coolection_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/provider/cash_transcation_provider.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../account_dues/widgets/rdcl_account_due_detail_page.dart';
import '../dues/widgets/new_qr_code_page.dart';
import '../profile/widgets/recipect_page.dart';
import 'package:collection_qr_flutter/core/utils.dart' as utl;

class LoanDetailsPage extends StatefulWidget {
  final utl.LoanDetailsModel loanDetailsModel;

  const LoanDetailsPage({super.key, required this.loanDetailsModel});

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> slideUpAnimation;
  late Animation<Color?> colorAnimation;
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
  String? selectedAccNumber;
  TextEditingController editAmountController = TextEditingController();
  TextEditingController utrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      editAmountController.text = widget.loanDetailsModel.loanAmount.toString();
    });


    loadSharedPrefs();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    slideUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    colorAnimation = ColorTween(
      begin: home1.withValues(alpha:0),
      end: home1.withValues(alpha:0.1),
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
    if (value != null && value > widget.loanDetailsModel.loanAmount) {

      editAmountController.text = widget.loanDetailsModel.loanAmount.toString();
      editAmountController.selection = TextSelection.fromPosition(TextPosition(offset: editAmountController.text.length));
    }
  }

  Future<void> accTrans() async {
    utl.showProgressDialog(context);
    final loanCashProvider = Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agentId.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.loanDetailsModel.customerName,
        widget.loanDetailsModel.customerPhoneNumber,
        widget.loanDetailsModel.loanNumber,
        widget.loanDetailsModel.custId,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB",
        "TRANSFER",
        utrController.text,
        "LOAN");
    if (loanCashProvider.loanCashCollectionResponse != null) {
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
        agent_Id.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.loanDetailsModel.customerName,
        widget.loanDetailsModel.customerPhoneNumber,
        widget.loanDetailsModel.loanNumber,
        widget.loanDetailsModel.custId,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB",
        "CASH",
        "",
        "LOAN");
    if (loanCashProvider.loanCashCollectionResponse != null) {
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
        branchCode: branchCode,
        collectionType: 'LOAN');
    cash.fold((err) {
      //print("getCashTrans $err");
    }, (success) {
      //print("getCashTrans $success");
      showDialog(
        context: context,
        builder: (context) => TransactionSuccessDialog(
          success: success,
          onViewReceipt: () {
            Navigator.pop(context);

            var receiptModel = utl.ReceiptDataModel(
              amount: success.amount.toString(),
              bankName: utl.getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
              agentName: agentName ?? "Name",
              agentPhone: agentMobile ?? "agentPhone",
              custName: customerName!,
              custPhone: custPhoneNumber!,
              custId: custId!,
              txnId: success.transactionId.toString(),
              txnType: "CASH",
              dat: '',
              tranType: 'CASH',
              accNo: custAcNumber.toString(),
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
                          loanCashCollection();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: home1,
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
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with profile and status
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: home1.withValues(alpha:0.1),
                                child: Text(
                                  widget.loanDetailsModel.customerName[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: home1,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.loanDetailsModel.customerName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: home2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Loan #${widget.loanDetailsModel.loanNumber.replaceAll("LOAN-", "")}',
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
                                  color: widget.loanDetailsModel.loanStatus ==
                                          'Active'
                                      ? Colors.green.withValues(alpha:0.1)
                                      : Colors.orange.withValues(alpha:0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: widget.loanDetailsModel.loanStatus ==
                                            'Active'
                                        ? Colors.green
                                        : Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.loanDetailsModel.loanStatus,
                                  style: TextStyle(
                                    color: widget.loanDetailsModel.loanStatus ==
                                            'Active'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

                const SizedBox(height: 20),

                // Loan summary cards in a row
                FadeTransition(
                  opacity: fadeAnimation,
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
                            '₹ ${widget.loanDetailsModel.loanAmount}',
                            Icons.currency_rupee_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Monthly payment',
                            //'\$${loanDetails['remainingBalance'].toStringAsFixed(2)}',
                            '₹ ${widget.loanDetailsModel.emiAmount.toStringAsFixed(2)}',
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
                  opacity: fadeAnimation,
                  child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.4),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: home1.withAlpha(20)),
                                child: Text(
                                  'Loan Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.bold,
                                    color: home2.withAlpha(170),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade100,
                              ),
                              //  const SizedBox(height: 12),
                              // _buildDetailItem(
                              //   Icons.percent,
                              //   'Interest Rate',
                              //   '${loanDetails['interestRate']}%',
                              // ),
                              _buildDetailItem(
                                  Icons.currency_rupee_rounded,
                                  'Loan Term',
                                  "${widget.loanDetailsModel.loanTerm} ${widget.loanDetailsModel.collectionFrequency}"),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Divider(color: Colors.grey.shade200),
                              ),
                              _buildDetailItem(
                                Icons.currency_rupee_rounded,
                                'Due Amount',
                                '₹${widget.loanDetailsModel.dueAmount}',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Divider(color: Colors.grey.shade200),
                              ),
                              _buildDetailItem(
                                Icons.date_range,
                                'Scheme',
                                widget.loanDetailsModel.scheme,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Divider(color: Colors.grey.shade200),
                              ),
                              _buildDetailItem(
                                Icons.rotate_90_degrees_ccw_rounded,
                                'Collection Frequency',
                                widget.loanDetailsModel.collectionFrequency,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Divider(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              _buildDetailItem(
                                Icons.support_agent_outlined,
                                'Agent ID',
                                widget.loanDetailsModel.assignedAgent,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

                const SizedBox(height: 20),

                // Payment information section
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_animationController),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: home1.withAlpha(20)),
                                child: Text(
                                  'Payment Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.bold,
                                    color: home2.withAlpha(170),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                Icons.history,
                                'Last Payment Date',
                                widget.loanDetailsModel.paymentDate
                                    .replaceAll("00:00:00.000", ""),
                              ),
                              _buildDetailItem(
                                Icons.next_plan,
                                'Created At',
                                widget.loanDetailsModel.createdAt
                                    .replaceAll("00:00:00.000", ""),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

                const SizedBox(height: 24),

                // Action buttons
                FadeTransition(
                  opacity: fadeAnimation,
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                            padding: const EdgeInsets.all(8.0),
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
                                                    editAmountController.text = widget.loanDetailsModel.emiAmount.toString();
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: editAmountController,
                                              decoration: const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.currency_rupee,
                                                    color: home1,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
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
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
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
                              //     widget.loanDetailsModel.loanNumber, widget.loanDetailsModel.custId, "1");

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
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                  ),
                                  // builder: (context) {
                                  //   return Padding(
                                  //     padding: const EdgeInsets.all(20),
                                  //     child: SizedBox(
                                  //       height: 200,
                                  //       // You can make it dynamic if needed
                                  //       width: double.infinity,
                                  //       child: Column(
                                  //         children: [
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.all(8.0),
                                  //             child: Row(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.center,
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceBetween,
                                  //               children: [
                                  //                 const Spacer(flex: 1),
                                  //                 const Text(
                                  //                   "Collection Amount",
                                  //                   style: TextStyle(
                                  //                       color: home1,
                                  //                       fontSize: 18,
                                  //                       fontWeight:
                                  //                           FontWeight.w700),
                                  //                 ),
                                  //                 const Spacer(flex: 1),
                                  //                 InkWell(
                                  //                   onTap: () {
                                  //                     Navigator.pop(context);
                                  //                     editAmountController
                                  //                             .text =
                                  //                         widget
                                  //                             .loanDetailsModel
                                  //                             .emiAmount
                                  //                             .toString();
                                  //                   },
                                  //                   child: const Icon(
                                  //                     Icons.cancel_rounded,
                                  //                     size: 30,
                                  //                     color: home2,
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 20,
                                  //                     vertical: 10),
                                  //             child: TextField(
                                  //               keyboardType:
                                  //                   TextInputType.number,
                                  //               controller:
                                  //                   editAmountController,
                                  //               decoration:
                                  //                   const InputDecoration(
                                  //                       prefixIcon: Icon(
                                  //                         Icons.currency_rupee,
                                  //                         color: home1,
                                  //                       ),
                                  //                       border: OutlineInputBorder(
                                  //                           borderRadius:
                                  //                               BorderRadius
                                  //                                   .all(Radius
                                  //                                       .circular(
                                  //                                           10))),
                                  //                       labelText:
                                  //                           "Enter collection amount"),
                                  //             ),
                                  //           ),
                                  //           ElevatedButton(
                                  //               onPressed: () {
                                  //                 Navigator.pop(context);
                                  //                 paymentConfirmation(
                                  //                     context,
                                  //                     agentName!,
                                  //                     widget.loanDetailsModel
                                  //                         .loanNumber,
                                  //                     widget.loanDetailsModel
                                  //                         .custId,
                                  //                     editAmountController
                                  //                         .text);
                                  //               },
                                  //               style: ElevatedButton.styleFrom(
                                  //                   backgroundColor: home1,
                                  //                   foregroundColor:
                                  //                       Colors.white),
                                  //               child: const Text("Submit"))
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   );
                                  // },
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 important
                                      ),
                                      child: SingleChildScrollView( // 👈 prevents overflow
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min, // 👈 dynamic height
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Spacer(),
                                                  const Text(
                                                    "Collection Amount",
                                                    style: TextStyle(
                                                        color: home1,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      editAmountController.text = widget
                                                          .loanDetailsModel.emiAmount
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
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: editAmountController,
                                                decoration: const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.currency_rupee,
                                                    color: home1,
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(10))),
                                                  labelText: "Enter collection amount",
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                paymentConfirmation(
                                                  context,
                                                  agentName!,
                                                  widget.loanDetailsModel.loanNumber,
                                                  widget.loanDetailsModel.custId,
                                                  editAmountController.text,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: home1,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                                // paymentConfirmation(context, agentName!,
                                //     widget.loanDetailsModel.loanNumber, widget.loanDetailsModel.custId, "1");
                              },
                              style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: home2)),
                              child: const Text(
                                "Collect Cash",
                                style: TextStyle(
                                    color: home1, fontWeight: FontWeight.bold),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadSharedPrefs() async {
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
    final phone = await SharedPref().getSubAgentMobNum();
    final name = await SharedPref().getSubAgentName();
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
   // editAmountController.text = widget.loanDetailsModel.emiAmount.toString();

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

  Future<SizedBox> showAccTransDialog() async {
    return SizedBox(
      height: 100,
      child: await showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    "Collect Amount",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  )),
                ],
              ),
            );
          }),
    );
  }

  Future<void> generateQrPaymentSession() async {
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
            agentOriginId: agentOriginId,
            agentEmail: agentEmail,
            customerName: widget.loanDetailsModel.customerName,
            customerPhone: widget.loanDetailsModel.customerPhoneNumber,
            customerAccno: widget.loanDetailsModel.loanNumber,
            customerId: widget.loanDetailsModel.custId,
            customerEmail: widget.loanDetailsModel.email,
            corpCode: corpCode,
            cardRefNum: "",
            token: token,
            amount: editAmountController.text,
            agentPhone: agentMobile,
            agentId: agent_Id,
            note: "Payment For Agent ${widget.loanDetailsModel.scheme}",
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
              token: token!,
              custName: widget.loanDetailsModel.customerName ?? "custName",
              custPhone: widget.loanDetailsModel.customerPhoneNumber,
              custId: widget.loanDetailsModel.custId,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            home1.withValues(alpha:0.08),
            home1.withValues(alpha:0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: home1, size: 22),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: home2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: home1.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: home1),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: home2,
            ),
          ),
        ],
      ),
    );
  }
}


