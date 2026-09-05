import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/alerts.dart';
import '../../../../core/utils.dart' as utl;
import '../../../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import '../../../../domain/model/non_integarted_loan_list_due.dart';
import '../../../merchant/history/ecollect_transaction_detail.dart';
import '../../../paymentlink_request_ui.dart';
import '../../../qr_code/widgets/generate_qr_code_page.dart';

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

class CustomerDetailPage extends StatefulWidget {
  final  CustomerDue customer;
  final EcollectMerchantModelData ecollectMerchantModelData;

  const CustomerDetailPage({
    super.key,
    required this.customer, required this.ecollectMerchantModelData,
  });

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  String? paymentOrderID;
  String selectedMethod = "";

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Loan Due Details',
          style: TextStyle(
            color: home1,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'More options',
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),



      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            _CustomerHeader(customer: widget.customer),
            const SizedBox(height: 16),
            _AmountCard(customer: widget.customer),
            const SizedBox(height: 16),
            _SectionTitle(title: 'Payment & Account'),
            const SizedBox(height: 8),
            _AccountInfoCard(customer: widget.customer),
            const SizedBox(height: 20),
            _SectionTitle(title: 'Contact Customer'),
            const SizedBox(height: 8),
            _ContactActions(
              customer: widget.customer,
              onCall: () => _callCustomer(context),
              onWhatsapp: () => _whatsappCustomer(context),
            ),
            const SizedBox(height: 20),
            _SectionTitle(title: 'Collection Assignment'),
            const SizedBox(height: 8),
            _AssignmentCard(customer: widget.customer),
            const SizedBox(height: 20),
            _SectionTitle(title: 'Account Information'),
            const SizedBox(height: 8),
            _AccountMetaCard(customer: widget.customer),
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
                              custName: widget.customer.customerName,
                              custPhone: "",
                              custId: widget.customer.id.toString(),
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

  String _getCurrentTime() {
    final now = DateTime.now();

    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";
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
                          widget.customer.accountNumber,
                          widget.customer.id.toString(),
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


  void _callCustomer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Call ${widget.customer.customerName}'),
      ),
    );
  }

  QrPaymentRequestModel _createPaymentRequest({
    required String collectionType,
  })
  {
    final merchant = widget.ecollectMerchantModelData;
    print(
        "merchant.eCollectAgentBranchCod = ${merchant.eCollectAgentBranchCode}");
    final loan = widget.customer;

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

  void _whatsappCustomer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open WhatsApp for ${widget.customer.customerName}'),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CUSTOMER HEADER
// -----------------------------------------------------------------------------

class _CustomerHeader extends StatelessWidget {
  final CustomerDue customer;

  const _CustomerHeader({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card.filled(
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: home1.withValues(alpha: 0.3),
              child: Text(
                customer.customerName.isNotEmpty
                    ? customer.customerName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: home1,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          customer.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _StatusChip(status: customer.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A/C ${customer.accountNumber}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${customer.branchCode} • ${customer.productType}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// AMOUNT CARD
// -----------------------------------------------------------------------------

class _AmountCard extends StatelessWidget {
  final CustomerDue customer;

  const _AmountCard({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool overdue = customer.daysPastDue > 0;

    return Card(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AMOUNT DUE',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _money(customer.dueAmount),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${customer.emiFrequency} EMI',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _AmountMetric(
                    label: 'Outstanding',
                    value: _money(customer.outstandingAmount.toDouble()),
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: colors.outlineVariant,
                ),
                Expanded(
                  child: _AmountMetric(
                    label: 'Days Past Due',
                    value: '${customer.daysPastDue} days',
                    valueColor: overdue ? colors.error : colors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _RiskBanner(
              riskCategory: customer.riskCategory,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _AmountMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// RISK
// -----------------------------------------------------------------------------

class _RiskBanner extends StatelessWidget {
  final String riskCategory;

  const _RiskBanner({
    required this.riskCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool highRisk = riskCategory.startsWith('SMA-2');
    final bool mediumRisk = riskCategory.startsWith('SMA-0');

    final Color background;
    final Color foreground;
    final IconData icon;

    if (highRisk) {
      background = colors.errorContainer;
      foreground = colors.onErrorContainer;
      icon = Icons.warning_amber_rounded;
    } else if (mediumRisk) {
      background = colors.tertiaryContainer;
      foreground = colors.onTertiaryContainer;
      icon = Icons.info_outline;
    } else {
      background = colors.onPrimaryFixed.withValues(alpha: 0.5);
      foreground = colors.primaryFixed;
      icon = Icons.check_circle_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: foreground,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              riskCategory,
              style: theme.textTheme.labelLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PAYMENT / ACCOUNT
// -----------------------------------------------------------------------------

class _AccountInfoCard extends StatelessWidget {
  final CustomerDue customer;

  const _AccountInfoCard({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Next due date',
            value: _formatDate(customer.nextDueDate),
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.history_rounded,
            label: 'Last paid',
            value: _formatDate(customer.lastPaidDate),
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.autorenew_rounded,
            label: 'EMI frequency',
            value: customer.emiFrequency,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.receipt_long_outlined,
            label: 'EMI amount',
            value: _money(customer.emiAmount.toDouble()),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CONTACT
// -----------------------------------------------------------------------------

class _ContactActions extends StatelessWidget {
  final CustomerDue customer;
  final VoidCallback onCall;
  final VoidCallback onWhatsapp;

  const _ContactActions({
    required this.customer,
    required this.onCall,
    required this.onWhatsapp,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCall,
            icon: const Icon(Icons.phone_outlined),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onWhatsapp,
            icon: const Icon(Icons.chat_outlined),
            label: const Text('WhatsApp'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ASSIGNMENT
// -----------------------------------------------------------------------------

class _AssignmentCard extends StatelessWidget {
  final CustomerDue customer;

  const _AssignmentCard({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colors.primaryContainer,
              child: Icon(
                Icons.person_outline,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.assignedAgentName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Agent ${customer.assignedAgentCode}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.verified_outlined,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// META
// -----------------------------------------------------------------------------

class _AccountMetaCard extends StatelessWidget {
  final CustomerDue customer;

  const _AccountMetaCard({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Customer ID',
            value: customer.id.toString(),
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Mobile',
            value: customer.mobileNumber,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.account_balance_outlined,
            label: 'Branch',
            value: customer.branchCode,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.credit_score_outlined,
            label: 'Product',
            value: customer.productType,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PAYMENT COLLECTION SHEET
// -----------------------------------------------------------------------------

class PaymentCollectionSheet extends StatefulWidget {
  final CustomerDue customer;

  const PaymentCollectionSheet({
    super.key,
    required this.customer,
  });

  @override
  State<PaymentCollectionSheet> createState() => _PaymentCollectionSheetState();
}

class _PaymentCollectionSheetState extends State<PaymentCollectionSheet> {
  late final TextEditingController amountController;
  late final TextEditingController referenceController;

  String paymentMode = 'UPI';

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.customer.dueAmount.toStringAsFixed(0),
    );

    referenceController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collect Payment',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: home1
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.customer.customerName} • ${widget.customer.accountNumber}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Amount',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Payment mode',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final mode in [
                    'UPI',
                    'Cash',
                    'Payment Link',
                  ])
                    ChoiceChip(
                      selectedColor: home1.withValues(alpha: 0.3),
                      label: Text(mode),
                      selected: paymentMode == mode,
                      onSelected: (_) {
                        setState(() {
                          paymentMode = mode;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Reference number',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: referenceController,
                decoration: InputDecoration(
                  hintText: 'Optional',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submitPayment,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Collection', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
                style: FilledButton.styleFrom(
                  backgroundColor: home1,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPayment() {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment collection submitted'),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SMALL COMPONENTS
// -----------------------------------------------------------------------------

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onSecondaryContainer,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPERS
// -----------------------------------------------------------------------------

String _money(double amount) {
  final value = amount.round().toString();

  final formatted = value.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );

  return '₹$formatted';
}

String _formatDate(String value) {
  final parts = value.split('-');

  if (parts.length != 3) {
    return value;
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = int.tryParse(parts[1]);

  if (month == null || month < 1 || month > 12) {
    return value;
  }

  return '${parts[2]} ${months[month - 1]} ${parts[0]}';
}
