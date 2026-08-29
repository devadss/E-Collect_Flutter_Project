import 'package:e_Collect/presentation/qr_code/widgets/generate_qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/alerts.dart';
import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../../data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import '../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../paymentlink_request_ui.dart';

class RdclDetailModel{
  String? customerNumber;
  String? baseUrl;
  String? customeName;
  String? custId;
  String? customerAccountNumber;
  String? eCollectAgentNumber;
  String? eCollectMerchantName;
  String? eCollectAgentEmail;
  String? eCollectCollectionType;
  String? eCollectAgentBranchCode;
  String? eCollectAgentMerchantID;
  String? eCollectAgentOriginId;
  String? eCollectAgentId;
  String? eCollectToken;

   RdclDetailModel({
    required this.customerNumber,
    required this.baseUrl,
     required this.customerAccountNumber,
     required this.custId,
    required this.eCollectAgentNumber, required this.eCollectMerchantName, required this.eCollectAgentEmail,
    required this.eCollectCollectionType, required this.eCollectAgentBranchCode , required this.eCollectAgentMerchantID,
    required this.eCollectAgentOriginId,
    required this.eCollectAgentId,
    required this.eCollectToken,
});
}

class RdclDueDetail extends StatefulWidget {
  final RdclDetailModel rdclDetailModel;

  const RdclDueDetail(
      {super.key,
      required this.rdclDetailModel});

  @override
  State<RdclDueDetail> createState() => _RdclDueDetailState();
}

class _RdclDueDetailState extends State<RdclDueDetail> {
  TextEditingController amountController = TextEditingController();
  double? duemAount;
  bool isChecked = false;
  String? selectedMethod;

  @override
  void initState() {

    super.initState();
    context.read<RdclDuelistBloc>().add(RdclDueListFetchEvent(widget.rdclDetailModel.baseUrl!,
        "", widget.rdclDetailModel.eCollectAgentBranchCode!, widget.rdclDetailModel.customerAccountNumber!, "", '0', '0'));
  }

  TextStyle _labelTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);

  TextStyle valueTextStyle() => const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, color: black87);

  Widget _buildPaymentOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22, color: iconColor ?? white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: home1,
          foregroundColor: white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _proceedButtonClick() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag indicator
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Options",
                      style: _labelTextStyle().copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Amount card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        home1.withValues(alpha: 0.1),
                        home1.withValues(alpha: 0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: home1.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rs. ${amountController.text}",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: home1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: home1.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          color: home1,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment options
                _buildPaymentOptionButton(
                  icon: Icons.qr_code_scanner,
                  label: "Pay via QR Code",
                  onPressed: () async {
                    selectedMethod = "QR";
                    context.read<PaymentBloc>().add(QrPaymentEvent(
                        QrPaymentRequestModel(
                            agentDetails: AgentDetails(
                                agentName: widget.rdclDetailModel.eCollectMerchantName!,
                                agentId: widget.rdclDetailModel.eCollectAgentId!,
                                agentOrginId: widget.rdclDetailModel.eCollectAgentOriginId!,
                                agentPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                agentEmail: widget.rdclDetailModel.eCollectAgentEmail!,
                                agentBranch:
                                    int.parse(widget.rdclDetailModel.eCollectAgentBranchCode!)),
                            customerDetails: CustomerDetails(
                                customerName: widget.rdclDetailModel.customeName!,
                                customerPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                customerAccno: widget.rdclDetailModel.customerAccountNumber!,
                                customerId: widget.rdclDetailModel.custId!,
                                customerEmail: widget.rdclDetailModel.eCollectAgentEmail!),
                            collectionType: widget.rdclDetailModel.eCollectCollectionType!,
                            amount: double.parse(amountController.text),
                            note: 'Payment for Order',
                            qrSource: 'MOB',
                            source: 'COLLECTION',
                            merchantId: int.parse(widget.rdclDetailModel.eCollectAgentMerchantID!)), widget.rdclDetailModel.eCollectToken!));
                  },
                ),
                const SizedBox(height: 12),

                _buildPaymentOptionButton(
                  icon: Icons.currency_rupee_rounded,
                  label: "Cash Payment",
                  onPressed: () {
                    selectedMethod = "CASH";
                    Navigator.pop(context);
                    paymentConfirmation(
                        context,
                        widget.rdclDetailModel.customeName!,
                        widget.rdclDetailModel.customerAccountNumber!,
                        widget.rdclDetailModel.custId!,
                        "",
                        amountController.text);
                  },
                ),

                const SizedBox(height: 12),
                _buildPaymentOptionButton(
                  icon: Icons.link,
                  label: "Send Payment Link",
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<PaymentBloc>().add(LinkPaymentEvent(
                        QrPaymentRequestModel(
                            agentDetails: AgentDetails(
                                agentName: widget.rdclDetailModel.eCollectMerchantName!,
                                agentId: widget.rdclDetailModel.eCollectAgentId!,
                                agentOrginId: widget.rdclDetailModel.eCollectAgentOriginId!,
                                agentPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                agentEmail: widget.rdclDetailModel.eCollectAgentEmail!,
                                agentBranch:
                                    int.parse(widget.rdclDetailModel.eCollectAgentBranchCode!)),
                            customerDetails: CustomerDetails(
                                customerName: widget.rdclDetailModel.customeName!,
                                customerPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                customerAccno: widget.rdclDetailModel.customerAccountNumber!,
                                customerId: widget.rdclDetailModel.custId!,
                                customerEmail: widget.rdclDetailModel.eCollectAgentEmail!),
                            collectionType: widget.rdclDetailModel.eCollectCollectionType!,
                            amount: double.parse(amountController.text),
                            note: 'Payment for Order',
                            qrSource: 'MOB',
                            source: 'COLLECTION',
                            merchantId: int.parse(widget.rdclDetailModel.eCollectAgentMerchantID!)), widget.rdclDetailModel.eCollectToken!));
                    // merchantId: 1)));
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.red,
                    size: 45,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Confirm Payment",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildConfirmationRow("Customer", name),
                      const SizedBox(height: 10),
                      _buildConfirmationRow("Amount", "Rs. $amt",
                          isAmount: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "Do you wish to proceed with the payment?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: home1.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          "No, Cancel",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PaymentBloc>().add(CashPaymentEvent(
                              QrPaymentRequestModel(
                                  agentDetails: AgentDetails(
                                      agentName: widget.rdclDetailModel.eCollectMerchantName!,
                                      agentId: widget.rdclDetailModel.eCollectAgentId!,
                                      agentOrginId: widget.rdclDetailModel.eCollectAgentOriginId!,
                                      agentPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                      agentEmail: widget.rdclDetailModel.eCollectAgentEmail!,
                                      agentBranch:
                                          int.parse(widget.rdclDetailModel.eCollectAgentBranchCode!)),
                                  customerDetails: CustomerDetails(
                                      customerName: widget.rdclDetailModel.customeName!,
                                      customerPhone: widget.rdclDetailModel.eCollectAgentNumber!,
                                      customerAccno: widget.rdclDetailModel.customerAccountNumber!,
                                      customerId: widget.rdclDetailModel.custId!,
                                      customerEmail: widget.rdclDetailModel.eCollectAgentEmail!),
                                  collectionType: widget.rdclDetailModel.eCollectCollectionType!,
                                  amount: double.parse(amountController.text),
                                  note: 'Payment for Order',
                                  qrSource: 'MOB',
                                  source: 'COLLECTION',
                                  merchantId:
                                      int.parse(widget.rdclDetailModel.eCollectAgentMerchantID!)),widget.rdclDetailModel. eCollectToken!));
                          // merchantId: 1)));
                          // getCashTrans(
                          //   token: token,
                          //   customerName: name,
                          //   custPhoneNumber: customerNumber,
                          //   custAcNumber: accNo,
                          //   custId: custId,
                          //   custEmail: email,
                          //   phoneNumber: agentMobile,
                          //   entityId: agentId,
                          //   note: "Payment For Agent $agentName",
                          //   amount: amt,
                          // );
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                          showProgressDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Yes, Pay",
                          style: GoogleFonts.poppins(
                            color: white,
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
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value,
      {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: isAmount ? Colors.red : Colors.grey[800],
            fontSize: 14,
            fontWeight: isAmount ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        // ),
      ],
    );
  }



  Future<void> _showBottomBar(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Enter Payment Amount",
                style: GoogleFonts.poppins(
                  color: home1,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Maximum due: Rs. ${duemAount?.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: home1.withValues(alpha: 0.2)),
                ),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(
                    color: home1,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixText: 'Rs. ',
                    prefixStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
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
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: home1.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        amountController.text.toString().isNotEmpty
                            ? _proceedButtonClick()
                            : Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: home1,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => {
              Navigator.pop(context)
          },
        ),
        centerTitle: true,
        title: const Text(
          "Account Details",
          style: TextStyle(
            color: home1,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Customer Info Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
              builder: (BuildContext context, RdclDuelistState state) {
                if (state is RdclDueListLoaderState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RdclDueListSuccessState) {
                  final list = state.rdclDulistSuccess.rdclduesListSuccessModel
                      .rdclDuesList1?.data;

                  if (list == null || list.isEmpty) {

                    return const SizedBox.shrink();
                  }
                  //
                  // final data = list
                  //     .where((item) => item.custId.toString() == widget.custAcNumber.toString())
                  //     .toList();
                  //
                  // if (data.isEmpty) {
                  //
                  //   return const SizedBox.shrink();
                  // }
                  //
                  // print((data));

                  final item = list.first;
                  duemAount = item.dueAmount;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: home1.withValues(alpha: 0.08),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          iconColor: Colors.blue,
                          label: "Customer Name",
                          value: item.name ?? "",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        _buildInfoRow(
                          icon: Icons.account_balance_outlined,
                          iconColor: Colors.green,
                          label: "Account Number",
                          value: item.accNo ?? "",
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Due Details Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
              builder: (BuildContext context, RdclDuelistState state) {
                if (state is RdclDueListSuccessState) {
                  final list = state.rdclDulistSuccess.rdclduesListSuccessModel
                      .rdclDuesList1?.data;

                  if (list == null || list.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // final data = list
                  //     .where((item) => item.custId == widget.custAcNumber)
                  //     .toList();
                  //
                  // if (data.isEmpty) {
                  //   return const SizedBox.shrink();
                  // }

                  final item = list.first;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: home1.withValues(alpha: 0.08),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Due Amount with Checkbox
                        Row(
                          children: [
                            _buildDetailIcon(
                              icon: Icons.payment,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Due Amount",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Rs. ${item.dueAmount?.toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: home1.withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Checkbox(
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                activeColor: home1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Grid of Details
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.2,
                          children: [
                            _buildDetailGridItem(
                              icon: Icons.payment,
                              iconColor: Colors.blueGrey,
                              label: "Installment",
                              value:
                                  "Rs. ${item.installAmt?.toStringAsFixed(2)}",
                            ),
                            _buildDetailGridItem(
                              icon: Icons.credit_card,
                              iconColor: Colors.green,
                              label: "Loan Type",
                              value: "RDCL",
                            ),
                            _buildDetailGridItem(
                              icon: Icons.payments_outlined,
                              iconColor: Colors.orange,
                              label: "Total Inst.",
                              value: item.totalInstallment,
                            ),
                            _buildDetailGridItem(
                              icon: Icons.payments_outlined,
                              iconColor: Colors.purple,
                              label: "Paid Inst.",
                              value: item.paidInstallments,
                            ),
                            _buildDetailGridItem(
                              icon: Icons.payments_sharp,
                              iconColor: Colors.teal,
                              label: "Due Inst.",
                              value: item.dueInstallments,
                            ),
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
          BlocListener<PaymentBloc, PaymentState>(
            listener: (BuildContext context, PaymentState state) {
              if (state is QrPaymentLoaderState) {
                showProgressDialog(context);
              }
              if (state is QrPaymentSuccessState) {
                Navigator.pop(context);
                //print(state.qrPaymentSuccess.paymentResponseSuccess.paymentUrl);
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
                    :


                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewQrCodePage(
                      paymentSessionId: state.qrPaymentSuccess
                          .paymentResponseSuccess.paymentUrl,
                      amount: amountController.text,
                      custName: widget.rdclDetailModel.customeName!,
                      custPhone: "custNumber",
                      custId: widget.rdclDetailModel.custId!,
                    ),
                  ),
                );
              } else if (state is QrPaymentFailState) {
                Navigator.pop(context);
                Navigator.pop(context);
                showAlertDialog(
                    state.qrPaymentFail.paymentFailResponse.message, context);
                //print(state.qrPaymentFail.paymentFailResponse.message);
              } else if (state is CashPaymentSuccessState) {
                Navigator.pop(context);
                Navigator.pop(context);
                showAlert(
                    state.cashPaymentSuccess.cashPaymentSuccessResponse
                        .status ==
                        "Y"
                        ? "SUCCESS"
                        : "FAILED",
                    state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
                    context);
              } else if (state is CashPaymentFailState) {
                Navigator.pop(context);
              }
            },
            child: SizedBox(),
          ),

        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: home2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildDetailGridItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

