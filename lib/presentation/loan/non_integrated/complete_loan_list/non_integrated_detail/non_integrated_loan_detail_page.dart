import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/alerts.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/utils.dart' as utl;
import '../../../../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import '../../../../../domain/model/non_integrated/loan_all_data/complete_loanlist.dart';
import '../../../../merchant/history/ecollect_transaction_detail.dart';
import '../../../../paymentlink_request_ui.dart';
import '../../../../qr_code/widgets/generate_qr_code_page.dart';

class EcollectMerchantModelData {
  final String? eCollectMerchantName;
  final String? eCollectAgentId;
  final String? eCollectAgentOriginId;
  final String? eCollectAgentNumber;
  final String? eCollectAgentEmail;
  final String? eCollectAgentBranchCode;
  final String? eCollectAgentMerchantID;
  final String? eCollectCollectionType;
  final String? eCollectToken;

  EcollectMerchantModelData({
    required this.eCollectMerchantName,
    required this.eCollectAgentId,
    required this.eCollectAgentOriginId,
    required this.eCollectAgentNumber,
    required this.eCollectAgentEmail,
    required this.eCollectAgentBranchCode,
    required this.eCollectAgentMerchantID,
    required this.eCollectCollectionType,
    required this.eCollectToken,
  });
}

class NonIntegratedLoanDetailsScreen extends StatefulWidget {
  final LoanData loanData;
  final EcollectMerchantModelData ecollectMerchantModelData;
  const NonIntegratedLoanDetailsScreen(
      {super.key,
      required this.loanData,
      required this.ecollectMerchantModelData});

  @override
  State<NonIntegratedLoanDetailsScreen> createState() =>
      _NonIntegratedLoanDetailsScreenState();
}

class _NonIntegratedLoanDetailsScreenState
    extends State<NonIntegratedLoanDetailsScreen> {
  TextEditingController amountController = TextEditingController();
  String? paymentOrderID;
  String selectedMethod = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

// ----------------------------------------------------------
// APP BAR
// ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Loan Details',
          style: TextStyle(
            color: home1,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

// ----------------------------------------------------------
// BODY
// ----------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// ----------------------------------------------------
// LOAN HOLDER
// ----------------------------------------------------

            Text(
              widget.loanData.customerName.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,

              ),
            ),

            const SizedBox(height: 4),
Divider(),
            Text(
              'Account No : ${widget.loanData.accountNumber}',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

// ----------------------------------------------------
// LOAN SUMMARY CARD
// ----------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outstanding',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${NumberFormat('#,##,##0', 'en_IN').format(widget.loanData.outstandingAmount)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'EMI',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '₹${NumberFormat('#,##,##0', 'en_IN').format(widget.loanData.emiAmount)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.loanData.emiFrequency,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

// ----------------------------------------------------
// PAYMENT
// ----------------------------------------------------

            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            _infoRow(
              title: 'Last paid',
              value: widget.loanData.lastPaidDate.toString().replaceRange(10, 23, "")

            ),

            const SizedBox(height: 12),

            _infoRow(
              title: 'Next due',
              value: widget.loanData.nextDueDate.toString().replaceRange(10, 23, ""),
            ),

            const SizedBox(height: 24),

            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),

            const SizedBox(height: 24),

// ----------------------------------------------------
// REMINDER
// ----------------------------------------------------

            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  size: 21,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _infoRow(
              title: 'Enabled',
              valueWidget: Switch(
                value: widget.loanData.reminderEnabled,
                onChanged: (value) {
                  setState(() {
                    // widget.loanData.reminderEnabled = value;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),

            const SizedBox(height: 12),

            _infoRow(
              title: 'Before due',
              value: '2d',
            ),

            const SizedBox(height: 12),

            _infoRow(
              title: 'Risk',
              valueWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

// ----------------------------------------------------
// CHANNELS
// ----------------------------------------------------

            // const Text(
            //   'Channels',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),

           Divider(),

            const SizedBox(height: 10),
            // COLLECTION TITLE
            _buildSectionTitle(
              title: "Collect Payment",
              subtitle: "Choose a collection method",
            ),
            SizedBox(
              height: 10,
            ),

            _buildPaymentMethod(
              icon: Icons.qr_code_2_rounded,
              title: "QR Payment",
              subtitle: "Customer scans and pays",
              isPrimary: true,
              onTap: () {
                _showAmountSheet(
                  title: "QR Payment",
                  buttonText: "Generate Payment QR",
                  method: "QR",
                );
              },
            ),
            const SizedBox(height: 10),
            _buildPaymentMethod(
              icon: Icons.link_rounded,
              title: "Payment Link",
              subtitle: "Send a secure payment link",
              onTap: () {
                _showAmountSheet(
                  title: "Payment Link",
                  buttonText: "Send Payment Link",
                  method: "Link",
                );
              },
            ),

            const SizedBox(height: 10),

            // CASH
            _buildPaymentMethod(
              icon: Icons.payments_outlined,
              title: "Cash Collection",
              subtitle: "Record cash received",
              isCash: true,
              onTap: () {
                _showAmountSheet(
                  title: "Cash Collection",
                  buttonText: "Continue",
                  method: "Cash",
                );
              },
            ),
            const SizedBox(height: 20),
            MultiBlocListener(
              listeners: [
                // ========================================================
                // PAYMENT BLOC
                // ========================================================

                BlocListener<PaymentBloc, PaymentState>(
                  listener: (BuildContext context, PaymentState state) {
                    if (state is QrPaymentLoaderState) {
                      utl.showProgressDialog(context);
                    }

                    // ----------------------------------------------------
                    // QR / LINK SUCCESS
                    // ----------------------------------------------------

                    if (state is QrPaymentSuccessState) {
                      paymentOrderID =
                          state.qrPaymentSuccess.paymentResponseSuccess.orderId;

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      final paymentUrl = state
                          .qrPaymentSuccess.paymentResponseSuccess.paymentUrl;

                      if (selectedMethod == "Link") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentLinkRequestUi(
                              customerMobileNumber: "",
                              paymentLink: paymentUrl,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewQrCodePage(
                              paymentSessionId: paymentUrl,
                              amount: amountController.text,
                              custName: widget.loanData.customerName,
                              custPhone: "",
                              custId: widget.loanData.id.toString(),
                              orderID: paymentOrderID!,
                              merchantID: widget.ecollectMerchantModelData
                                  .eCollectAgentMerchantID!,
                              token: widget
                                  .ecollectMerchantModelData.eCollectToken!,
                            ),
                          ),
                        );
                      }
                    }

                    // ----------------------------------------------------
                    // QR / LINK FAILURE
                    // ----------------------------------------------------

                    else if (state is QrPaymentFailState) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      showAlertDialog(
                        state.qrPaymentFail.paymentFailResponse.message,
                        context,
                      );
                    }

                    // ----------------------------------------------------
                    // CASH SUCCESS
                    // ----------------------------------------------------

                    else if (state is CashPaymentSuccessState) {
                      paymentOrderID = state.cashPaymentSuccess
                          .cashPaymentSuccessResponse.transactionId;

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      _showSuccessMessage(
                        state.cashPaymentSuccess.cashPaymentSuccessResponse
                            .message,
                      );
                    }

                    // ----------------------------------------------------
                    // CASH FAILURE
                    // ----------------------------------------------------

                    else if (state is CashPaymentFailState) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      showAlertDialog(
                        state.cashPaymentFail.payemtError,
                        context,
                      );
                    }
                  },
                ),
                // ========================================================
                // TRANSACTION BLOC
                // ========================================================
                BlocListener<PaymentTransactionBloc, TransactionState>(
                  listener: (
                    BuildContext context,
                    TransactionState state,
                  ) {
                    if (state is TransactionReportSuccessState) {
                      final rawData = state
                          .transactionSuccessModel.transactionOkReport.data;

                      for (var orderid in rawData) {
                        if (paymentOrderID != null &&
                            orderid.paymentGatewayTransactionId
                                .contains(paymentOrderID!)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EcollectTransactionDetail(
                                paymentTransaction: PaymentTransaction(
                                  id: orderid.id,
                                  orderId: orderid.orderId,
                                  transactionId: orderid.transactionId,
                                  paymentGatewayTransactionId:
                                      orderid.paymentGatewayTransactionId,
                                  amount: orderid.amount,
                                  currency: orderid.currency,
                                  description: orderid.description,
                                  customerName: orderid.customerName,
                                  customerEmail: orderid.customerEmail,
                                  customerPhone: orderid.customerPhone,
                                  paymentMode: orderid.paymentMode,
                                  paymentChannel: orderid.paymentChannel,
                                  status: orderid.status,
                                  responseCode: orderid.responseCode,
                                  responseMessage: orderid.responseMessage,
                                  createdAt: orderid.createdAt,
                                  completedAt: orderid.completedAt,
                                  merchantId: orderid.merchantId,
                                  merchantName: orderid.merchantName,
                                ),
                              ),
                            ),
                          );

                          break;
                        }
                      }
                    }
                  },
                ),
              ],
              child: Text(""),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8A94A6),
          ),
        ),
      ],
    );
  }

  void _showSuccessMessage(String? message) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              26,
              22,
              22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8F0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF159957),
                    size: 38,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Transaction Successful",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message ??
                      "Your transaction has been completed successfully.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF697386),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E6ED),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        "Transaction Status",
                        "Successful",
                        valueColor: const Color(0xFF159957),
                      ),
                      const Divider(height: 18),
                      _buildDetailRow(
                        "Transaction Date",
                        _getCurrentDate(),
                      ),
                      const Divider(height: 18),
                      _buildDetailRow(
                        "Order ID",
                        paymentOrderID ?? "-",
                      ),
                      const Divider(height: 18),
                      _buildDetailRow(
                        "Transaction Time",
                        _getCurrentTime(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          getHistoryData(message);
                        },
                        icon: const Icon(
                          Icons.print_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          "Print",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(
                            color: Color(0xFFD5DAE3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(
                            dialogContext,
                          ).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3157D5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
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

  String _getCurrentDate() {
    final now = DateTime.now();

    return "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
  }

  void getHistoryData(String? message) {
    debugPrint(
      "Printing: ${message ?? ''}",
    );

    context.read<PaymentTransactionBloc>().add(
          GetTransactionByMerchant(
            widget.ecollectMerchantModelData.eCollectAgentMerchantID!,
            widget.ecollectMerchantModelData.eCollectToken!,
          ),
        );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF697386),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF172033),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAmountSheet({
    required String title,
    required String buttonText,
    required String method,
  }) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9DEE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF697386),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Enter the amount you want to collect",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A8496),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE1E5EB),
                    ),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172033),
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.currency_rupee_rounded,
                        color: home1,
                      ),
                      hintText: "0.00",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Outstanding amount",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7A8496),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(
                        amountController.text.trim(),
                      );

                      if (amount == null || amount <= 0) {
                        showAlertDialog(
                            "Please enter a valid collection amount.", context);
                        return;
                      }

                      Navigator.pop(sheetContext);

                      if (method == "QR") {
                        _processQrPayment();
                      } else if (method == "Link") {
                        _processLinkPayment();
                      } else {
                        paymentConfirmation(
                          context,
                          widget
                              .ecollectMerchantModelData.eCollectMerchantName!,
                          widget.loanData.accountNumber,
                          widget.loanData.id.toString(),
                          amountController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: home1,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();

    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";
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
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: Color(0xFFD64545),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Confirm Cash Collection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please verify the amount before recording this cash collection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF697386),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E6ED),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "COLLECTION AMOUNT",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8A94A6),
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "₹ ${double.tryParse(amt)?.toStringAsFixed(2) ?? amt}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF172033),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                                false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              side: const BorderSide(
                                color: Color(0xFF3157D5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Color(0xFF3157D5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedMethod = "Cash";
                              });

                              Navigator.pop(
                                dialogContext,
                              );

                              _processCashPayment();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3157D5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
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
        ) ??
        false;
  }

  QrPaymentRequestModel _createPaymentRequest({
    required String collectionType,
  })
  {
    final merchant = widget.ecollectMerchantModelData;
    print(
        "merchant.eCollectAgentBranchCod = ${merchant.eCollectAgentBranchCode}");
    final loan = widget.loanData;

    return QrPaymentRequestModel(
      agentDetails: AgentDetails(
        agentName: merchant.eCollectMerchantName!,
        agentId: merchant.eCollectAgentId!,
        agentOrginId: merchant.eCollectAgentOriginId!,
        agentPhone: merchant.eCollectAgentNumber!,
        agentEmail: merchant.eCollectAgentEmail!,
        agentBranch: 01,
      ),
      customerDetails: CustomerDetails(
        customerName: loan.customerName,
        customerPhone: loan.mobileNumber,
        customerAccno: loan.accountNumber,
        customerId: loan.id.toString(),
        customerEmail: merchant.eCollectAgentEmail!,
      ),
      collectionType: collectionType,
      amount: double.parse(
        amountController.text,
      ),
      note: "Payment for Order",
      qrSource: "MOB",
      source: "COLLECTION",
      merchantId: int.parse(
        widget.ecollectMerchantModelData.eCollectAgentMerchantID!,
      ),
    );
  }

  void _processCashPayment() {
    final merchant = widget.ecollectMerchantModelData;

    context.read<PaymentBloc>().add(
          CashPaymentEvent(
            _createPaymentRequest(
              collectionType: merchant.eCollectCollectionType!,
            ),
            merchant.eCollectToken!,
          ),
        );
  }

  void _processQrPayment() {
    setState(() {
      selectedMethod = "QR";
    });
    context.read<PaymentBloc>().add(
          QrPaymentEvent(
            _createPaymentRequest(
              collectionType: "LOAN",
            ),
            widget.ecollectMerchantModelData.eCollectToken!,
          ),
        );
  }

  void _processLinkPayment() {
    setState(() {
      selectedMethod = "Link";
    });

    final merchant = widget.ecollectMerchantModelData;

    context.read<PaymentBloc>().add(
          LinkPaymentEvent(
            _createPaymentRequest(
              collectionType: merchant.eCollectCollectionType!,
            ),
            merchant.eCollectToken!,
          ),
        );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isCash = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isPrimary ? home1.withValues(alpha: 0.3) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPrimary ? home1 : const Color(0xFFE2E6ED),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? home1.withValues(alpha: 0.12)
                      : isCash
                          ? const Color(0xFFFFF4E5)
                          : const Color(0xFFEAF0FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: isPrimary
                      ? Colors.white
                      : isCash
                          ? const Color(0xFFE18A00)
                          : const Color(0xFF3157D5),
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:
                            isPrimary ? Colors.black : const Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: isPrimary
                            ? Colors.black.withValues(
                                alpha: 0.70,
                              )
                            : const Color(0xFF7A8496),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: isPrimary ? Colors.white : const Color(0xFF9AA3B2),
              ),
            ],
          ),
        ),
      ),
    );
  }
// ------------------------------------------------------------
// INFO ROW
// ------------------------------------------------------------

  Widget _infoRow({
    required String title,
    String? value,
    Widget? valueWidget,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        if (valueWidget != null)
          valueWidget
        else
          Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }
}
