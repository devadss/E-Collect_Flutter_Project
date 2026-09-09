import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_finder/location_finder.dart';
import '../../../core/alerts.dart';
import '../../../core/utils.dart';
import '../../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import '../../merchant/history/ecollect_transaction_detail.dart';
import '../../paymentlink_request_ui.dart';
import '../../qr_code/widgets/generate_qr_code_page.dart';

class RdDetailsModel {
  final String? custName;
  final String? accNo;
  final String? scheme;
  final String? custId;
  RdDetailsModel(
      {required this.custName,
      required this.accNo,
      required this.scheme,
      required this.custId});
}

class EcollectMerchantModel {
  final String? eCollectMerchantName;
  final String? eCollectUserToken;
  final String? eCollectAgentNumber;
  final String? eCollectAgentEmail;
  final String? eCollectCollectionType;
  final String? eCollectAgentBranchCode;
  final String? eCollectAgentMerchantID;
  final String? eCollectExternalAgentId;
  final String? eCollectAgentId;

  EcollectMerchantModel({
    required this.eCollectMerchantName,
    required this.eCollectUserToken,
    required this.eCollectAgentNumber,
    required this.eCollectAgentEmail,
    required this.eCollectCollectionType,
    required this.eCollectAgentBranchCode,
    required this.eCollectAgentMerchantID,
    required this.eCollectExternalAgentId,
    required this.eCollectAgentId,
  });
}

class AccountDetailNew extends StatefulWidget {
  final RdDetailsModel rdDetailsModel;
  final EcollectMerchantModel ecollectMerchantModel;

  const AccountDetailNew({
    super.key,
    required this.rdDetailsModel,
    required this.ecollectMerchantModel,
  });

  @override
  State<AccountDetailNew> createState() => _AccountDetailNewState();
}

class _AccountDetailNewState extends State<AccountDetailNew> {
  final TextEditingController amountController = TextEditingController();

  String selectedMethod = "";
  String? paymentOrderID;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE7E9EE);
  static const Color success = Color(0xFF159957);
  String agentLocation = "Fetching location ....";
  bool visitCompleteStatus = false;

  // ============================================================
  // HELPERS
  // ============================================================

  String get customerName => widget.rdDetailsModel.custName ?? "Customer";

  String get accountNumber => widget.rdDetailsModel.accNo ?? "";

  String get scheme => widget.rdDetailsModel.scheme ?? "";

  String get maskedAccount {
    if (accountNumber.length <= 4) return accountNumber;
    return "•••• ${accountNumber.substring(accountNumber.length - 4)}";
  }

  String get formattedAmount {
    if (amountController.text.isEmpty) return "₹0";
    return "₹${amountController.text}";
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }
  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: _handlePaymentState,
        ),
        BlocListener<PaymentTransactionBloc, TransactionState>(
          listener: _handleTransactionState,
        ),
      ],
      child: Scaffold(
        backgroundColor: background,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCustomerHeader(),
                      const SizedBox(height: 28),
                      _buildAmountSection(),
                      const SizedBox(height: 24),
                      _buildAccountSection(),
                      const SizedBox(height: 24),
                      customerVisitWidget(),
                      const SizedBox(height: 16),
                      _buildSecurityBanner(),
                    ],
                  ),
                ),
              ),
              _buildBottomCTA(),
            ],
          ),
        ),
      ),
    );
  }

  Column customerVisitWidget() {
    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        const Text(
                          'Customer Visit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Verify the customer visit before completing.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Customer Mobile
                        Text(
                          'CUSTOMER MOBILE NUMBER',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.7,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1B8A5A),
                                width: 1.3,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Visit Verification
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Location Icon
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0FDF4),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      size: 21,
                                      color: Color(0xFF168A57),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Visit location',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'GPS location captured',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Status
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: visitCompleteStatus
                                          ? const Color(0xFFF0FDF4)
                                          : const Color(0xFFFFF7ED),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          visitCompleteStatus
                                              ? Icons.check_circle
                                              : Icons.schedule,
                                          size: 13,
                                          color: visitCompleteStatus
                                              ? const Color(0xFF168A57)
                                              : const Color(0xFFEA8A15),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          visitCompleteStatus
                                              ? 'Verified'
                                              : 'Pending',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: visitCompleteStatus
                                                ? const Color(0xFF168A57)
                                                : const Color(0xFFB96B08),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Location Details
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.my_location_outlined,
                                      size: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        agentLocation.toString().isEmpty
                                            ? 'Please wait, location is being fetched...'
                                            : agentLocation.toString(),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          height: 1.35,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Information Note
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                'Your current location will be securely recorded '
                                'as proof of the customer visit.',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.4,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Complete Visit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                visitCompleteStatus = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: visitCompleteStatus
                                  ? const Color(0xFF168A57)
                                  : const Color(0xFF111827),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  visitCompleteStatus
                                      ? Icons.check_circle_outline
                                      : Icons.arrow_forward_rounded,
                                  size: 19,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  visitCompleteStatus
                                      ? 'Visit Completed'
                                      : 'Complete Visit',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 19,
        ),
        color: textPrimary,
      ),
      title: const Text(
        "Collect Payment",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  // ============================================================
  // CUSTOMER HEADER
  // ============================================================

  Widget _buildCustomerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CUSTOMER",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: home1.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials(customerName),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: home1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "RD Account",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        maskedAccount,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: success.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 13,
                    color: success,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Active",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // AMOUNT
  // ============================================================

  Widget _buildAmountSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "AMOUNT TO COLLECT",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "₹",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD1D5DB),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter the amount you want to collect from this customer.",
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT INFORMATION
  // ============================================================

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ACCOUNT DETAILS",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              _accountRow(
                icon: Icons.account_balance_wallet_outlined,
                title: "Account number",
                value: accountNumber,
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: accountNumber),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Account number copied"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 17,
                  ),
                ),
              ),
              const Divider(
                height: 1,
                indent: 60,
                endIndent: 16,
              ),
              _accountRow(
                icon: Icons.description_outlined,
                title: "Scheme",
                value: scheme,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "ACTIVE",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: success,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accountRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "-" : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: home1.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: home1,
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Secure collection",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Payments are processed securely.",
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM CTA
  // ============================================================

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _openPaymentMethods,
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 20,
                ),
                const SizedBox(width: 9),
                const Text(
                  "Collect Payment",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                if (amountController.text.isNotEmpty)
                  Text(
                    "· ${formattedAmount}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT METHOD SHEET
  // ============================================================

  void _openPaymentMethods() {
    if (amountController.text.trim().isEmpty) {
      _showAmountError();
      return;
    }

    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      _showAmountError();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Choose payment method",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$customerName · $maskedAccount",
                    style: const TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedAmount,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _paymentMethodTile(
                  icon: Icons.qr_code_2_rounded,
                  title: "QR Code",
                  subtitle: "Customer scans and pays",
                  onTap: () {
                    Navigator.pop(context);
                    selectedMethod = "QR";

                    _createQrPayment();
                  },
                ),
                const SizedBox(height: 10),
                _paymentMethodTile(
                  icon: Icons.link_rounded,
                  title: "Payment Link",
                  subtitle: "Send a secure payment link",
                  onTap: () {
                    Navigator.pop(context);
                    selectedMethod = "Link";
                    _createLinkPayment();
                  },
                ),
                const SizedBox(height: 10),
                _paymentMethodTile(
                  icon: Icons.payments_outlined,
                  title: "Cash",
                  subtitle: "Record a cash collection",
                  onTap: () {
                    Navigator.pop(context);
                    _showCashConfirmation();
                  },
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
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

  Future<void> getLocation() async {
    final LocationDetails? details = await LocationFinder.init();

    if (details != null) {
      print('Location: ${details.toString()}');
      setState(() {
        agentLocation = details.address.toString();
      });

      // Use the fields available on LocationDetails
      print(details);
    } else {
      print('Could not fetch location or permission denied.');
    }
  }

  Widget _paymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: home1.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: home1,
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT REQUEST
  // ============================================================

  void _createQrPayment() {
    context.read<PaymentBloc>().add(
          QrPaymentEvent(
            _buildPaymentRequest(),
            widget.ecollectMerchantModel.eCollectUserToken!,
          ),
        );
  }

  void _createLinkPayment() {
    context.read<PaymentBloc>().add(
          LinkPaymentEvent(
            _buildPaymentRequest(),
            widget.ecollectMerchantModel.eCollectUserToken!,
          ),
        );
  }

  void _createCashPayment() {
    context.read<PaymentBloc>().add(
          CashPaymentEvent(
            _buildPaymentRequest(),
            widget.ecollectMerchantModel.eCollectUserToken!,
          ),
        );
  }

  QrPaymentRequestModel _buildPaymentRequest() {
    return QrPaymentRequestModel(
      agentDetails: AgentDetails(
        agentName: widget.ecollectMerchantModel.eCollectMerchantName!,
        agentId: widget.ecollectMerchantModel.eCollectAgentId!,
        agentOrginId: widget.ecollectMerchantModel.eCollectExternalAgentId!,
        agentPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
        agentEmail: widget.ecollectMerchantModel.eCollectAgentEmail!,
        agentBranch: int.parse(
          widget.ecollectMerchantModel.eCollectAgentBranchCode!,
        ),
      ),
      customerDetails: CustomerDetails(
        customerName: widget.rdDetailsModel.custName!,
        customerPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
        customerAccno: widget.rdDetailsModel.accNo!,
        customerId: widget.rdDetailsModel.custId!,
        customerEmail: widget.ecollectMerchantModel.eCollectAgentEmail!,
      ),
      collectionType: widget.ecollectMerchantModel.eCollectCollectionType!,
      amount: double.parse(amountController.text),
      note: 'Payment for Order',
      qrSource: 'MOB',
      source: 'COLLECTION',
      merchantId: int.parse(
        widget.ecollectMerchantModel.eCollectAgentMerchantID!,
      ),
    );
  }

  // ============================================================
  // CASH CONFIRMATION
  // ============================================================

  void _showCashConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirm cash collection",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            "Record ${formattedAmount} as a cash payment from $customerName?",
            style: const TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                selectedMethod = "Cash";
                _createCashPayment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: home1,
                foregroundColor: Colors.white,
              ),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PAYMENT STATE
  // ============================================================

  void _handlePaymentState(
    BuildContext context,
    PaymentState state,
  ) {
    if (state is QrPaymentLoaderState) {
      showProgressDialog(context);
    }

    if (state is QrPaymentSuccessState) {
      paymentOrderID = state.qrPaymentSuccess.paymentResponseSuccess.orderId;

      Navigator.pop(context);

      final paymentUrl =
          state.qrPaymentSuccess.paymentResponseSuccess.paymentUrl;

      if (selectedMethod == "Link") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentLinkRequestUi(
              customerMobileNumber: "",
              paymentLink: paymentUrl,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewQrCodePage(
              paymentSessionId: paymentUrl,
              amount: amountController.text,
              custName: customerName,
              custPhone: "",
              custId: widget.rdDetailsModel.custId!,
              orderID: paymentOrderID!,
              merchantID: widget.ecollectMerchantModel.eCollectAgentMerchantID!,
              token: widget.ecollectMerchantModel.eCollectUserToken!,
            ),
          ),
        );
      }
    }

    if (state is QrPaymentFailState) {
      Navigator.pop(context);

      showAlertDialog(
        state.qrPaymentFail.paymentFailResponse.message,
        context,
      );
    }

    if (state is CashPaymentSuccessState) {
      paymentOrderID =
          state.cashPaymentSuccess.cashPaymentSuccessResponse.transactionId;

      Navigator.pop(context);

      _showSuccessMessage(
        state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
        state.cashPaymentSuccess.cashPaymentSuccessResponse.transactionId,
      );
    }

    if (state is CashPaymentFailState) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // TRANSACTION STATE
  // ============================================================

  void _handleTransactionState(
    BuildContext context,
    TransactionState state,
  ) {
    if (state is TransactionReportSuccessState) {
      final rawData = state.transactionSuccessModel.transactionOkReport.data;

      for (final order in rawData) {
        if (order.paymentGatewayTransactionId.contains(
          paymentOrderID ?? "",
        )) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EcollectTransactionDetail(
                paymentTransaction: PaymentTransaction(
                  id: order.id,
                  orderId: order.orderId,
                  transactionId: order.transactionId,
                  paymentGatewayTransactionId:
                      order.paymentGatewayTransactionId,
                  amount: order.amount,
                  currency: order.currency,
                  description: order.description,
                  customerName: order.customerName,
                  customerEmail: order.customerEmail,
                  customerPhone: order.customerPhone,
                  paymentMode: order.paymentMode,
                  paymentChannel: order.paymentChannel,
                  status: order.status,
                  responseCode: order.responseCode,
                  responseMessage: order.responseMessage,
                  createdAt: order.createdAt,
                  completedAt: order.completedAt,
                  merchantId: order.merchantId,
                  merchantName: order.merchantName,
                ),
              ),
            ),
          );

          break;
        }
      }
    }
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  void _showSuccessMessage(
    String? message,
    String orderId,
  ) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: success,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Payment successful",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message ?? "The payment has been recorded successfully.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _successRow(
                        "Amount",
                        formattedAmount,
                      ),
                      const SizedBox(height: 12),
                      _successRow(
                        "Order ID",
                        orderId,
                      ),
                      const SizedBox(height: 12),
                      _successRow(
                        "Date",
                        _getCurrentDate(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: home1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
          ),
        );
      },
    );
  }

  Widget _successRow(
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  void _showAmountError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Please enter a valid amount",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // UTILITIES
  // ============================================================

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty) return "C";

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first.substring(0, 1)}"
            "${parts.last.substring(0, 1)}"
        .toUpperCase();
  }

  String _getCurrentDate() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }
}

// class AccountDetailNew extends StatefulWidget {
//  final RdDetailsModel rdDetailsModel;
//  final EcollectMerchantModel ecollectMerchantModel;
//   const AccountDetailNew(
//       {super.key,
//       required this.rdDetailsModel, required this.ecollectMerchantModel});
//
//   @override
//   State<AccountDetailNew> createState() => _AccountDetailNewState();
// }
//
// class _AccountDetailNewState extends State<AccountDetailNew> {
//   DateTime? dateTime;
//   String selectedMethod = "";
//   String? customerEmail;
//   String? customerName;
//   String? customerNumber;
//   String? customerAccountNumber;
//   String? paymentSessionId;
//   String orderID = "";
//   bool value = true;
//   String? paymentOrderID;
//
//   TextEditingController amountController = TextEditingController();
//
//   @override
//   void dispose() {
//     amountController.dispose();
//     super.dispose();
//   }
//   Future<void> _showBottomBar(BuildContext context) async {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => GestureDetector(
//         onTap: () {},
//         behavior: HitTestBehavior.opaque,
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: white,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Total Amount Due",
//                     style: GoogleFonts.poppins(
//                       color: home1,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: amountController,
//                     keyboardType: TextInputType.number,
//                     style: GoogleFonts.poppins(
//                       color: home1,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       prefixIcon: const Icon(Icons.currency_rupee),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide:
//                             BorderSide(color: home1.withValues(alpha: 0.3)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide:
//                             BorderSide(color: home1.withValues(alpha: 0.3)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: home1, width: 1.5),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       // int enteredAmount = int.tryParse(value) ?? 0;
//                       // int maxDueAmount = 0;
//
//                       // final provider =
//                       // Provider.of<DueListProvider>(context, listen: false);
//                       // for (var due in provider.dueListModel!.duesList!
//                       //     .data!) {
//                       //   maxDueAmount += (due.dueAmount as num).toInt();
//                       // }
//                       //
//                       // if (enteredAmount > maxDueAmount) {
//                       //   setState(() {
//                       //     amountController.text = maxDueAmount.toString();
//                       //   });
//                       // }
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             side: const BorderSide(color: home1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text(
//                             "Cancel",
//                             style: GoogleFonts.poppins(
//                               color: home1,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (amountController.text.isNotEmpty) {
//                               _proceedButtonClick();
//                             } else {
//                               showToast(
//                                   message: "Amount field cannot be empty",
//                                   color: Colors.black);
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: home1,
//                             foregroundColor: white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text(
//                             "Proceed",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TextStyle _labelTextStyle() =>
//       const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);
//   TextStyle _valueTextStyle() => const TextStyle(
//       fontWeight: FontWeight.w500, fontSize: 16, color: black87);
//   void _proceedButtonClick() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header with close button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Payment Options",
//                     style: _labelTextStyle().copyWith(fontSize: 18),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Amount information
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Total Amount", style: _labelTextStyle()),
//                     Text(
//                       "Rs. ${amountController.text}",
//                       style: _valueTextStyle().copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               //  Payment options buttons
//               _buildPaymentOptionButton(
//                 icon: Icons.qr_code,
//                 label: "Pay via QR Code",
//                 onPressed: () async {
//                  // setState(() {
//                     selectedMethod = "QR";
//                  // });
//                   context.read<PaymentBloc>().add(QrPaymentEvent(
//                       QrPaymentRequestModel(
//                           agentDetails: AgentDetails(
//                               agentName: widget.ecollectMerchantModel.eCollectMerchantName!,
//                               agentId: widget.ecollectMerchantModel.eCollectAgentId!,
//                               agentOrginId: widget.ecollectMerchantModel.eCollectExternalAgentId!,
//
//                               agentPhone:widget.ecollectMerchantModel. eCollectAgentNumber!,
//                               agentEmail: widget.ecollectMerchantModel.eCollectAgentEmail!,
//                               agentBranch: int.parse(widget.ecollectMerchantModel.eCollectAgentBranchCode!)),
//                           customerDetails: CustomerDetails(
//                               customerName: widget.rdDetailsModel.custName!,
//                               customerPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
//                              customerAccno: widget.rdDetailsModel.accNo!,
//                               customerId: widget.rdDetailsModel.custId!,
//                               customerEmail: widget.ecollectMerchantModel.eCollectAgentEmail!),
//                           collectionType: widget.ecollectMerchantModel.eCollectCollectionType!,
//                           amount: double.parse(amountController.text),
//                           note: 'Payment for Order',
//                           qrSource: 'MOB',
//                           source: 'COLLECTION',
//                           merchantId: int.parse(widget.ecollectMerchantModel.eCollectAgentMerchantID!)
//                           ), widget.ecollectMerchantModel.eCollectUserToken!
//
//                   ));
//                 },
//               ),
//               const SizedBox(height: 12),
//
//               _buildPaymentOptionButton(
//                 icon: Icons.link,
//                 label: "Send Payment Link",
//                 onPressed: () {
//                   Navigator.pop(context);
//                  // setState(() {
//                     selectedMethod = "Link";
//                  // });
//                   context.read<PaymentBloc>().add(LinkPaymentEvent(
//                       QrPaymentRequestModel(
//                           agentDetails: AgentDetails(
//                               agentName: widget.ecollectMerchantModel.eCollectMerchantName!,
//                               agentId: widget.ecollectMerchantModel.eCollectAgentId!,
//                               agentOrginId: widget.ecollectMerchantModel.eCollectExternalAgentId!,
//                               agentPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
//                               agentEmail: widget.ecollectMerchantModel.eCollectAgentEmail!,
//                               agentBranch: int.parse(widget.ecollectMerchantModel.eCollectAgentBranchCode!)),
//                           customerDetails: CustomerDetails(
//                               customerName: widget.rdDetailsModel.custName!,
//                               customerPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
//                               customerAccno: widget.rdDetailsModel.accNo!,
//                               customerId: widget.rdDetailsModel.custId!,
//                               customerEmail: widget.ecollectMerchantModel.eCollectAgentEmail!),
//                           collectionType: widget.ecollectMerchantModel.eCollectCollectionType!,
//                           amount: double.parse(amountController.text),
//                           note: 'Payment for Order',
//                           qrSource: 'MOB',
//                           source: 'COLLECTION',
//                           merchantId: int.parse(widget.ecollectMerchantModel.eCollectAgentMerchantID!))
//                       ,widget.ecollectMerchantModel.eCollectUserToken!));
//                 },
//               ),
//               const SizedBox(height: 12),
//
//               _buildPaymentOptionButton(
//                 icon: Icons.money,
//                 label: "Cash Payment",
//                 onPressed: () {
//                   Navigator.pop(context);
//                   paymentConfirmation(context, widget.rdDetailsModel.custName!, widget.rdDetailsModel.accNo!,
//                       widget.rdDetailsModel.custId!, "", amountController.text);
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> paymentConfirmation(
//     BuildContext context,
//     String name,
//     String accNo,
//     String custId,
//     String email,
//     String amt,
//   ) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.2),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Animated icon
//                 TweenAnimationBuilder(
//                   duration: const Duration(milliseconds: 500),
//                   tween: Tween<double>(begin: 0, end: 1),
//                   builder: (context, value, child) {
//                     return Transform.scale(scale: value, child: child);
//                   },
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.redAccent.withValues(alpha: 0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     // child: Lottie.asset
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 Text(
//                   "Payment Confirmation",
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Do you wish to proceed with the payment ?",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   children: [
//                     // Cancel button
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           side: const BorderSide(color: home1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           backgroundColor: white,
//                         ),
//                         child: Text(
//                           "No",
//                           style: GoogleFonts.poppins(
//                             color: home1,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//
//                     // Logout button
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                         //  setState(() {
//                             selectedMethod = "Cash";
//                          // });
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                           context.read<PaymentBloc>().add(CashPaymentEvent(
//                               QrPaymentRequestModel(
//                                   agentDetails: AgentDetails(
//                                       agentName: widget.ecollectMerchantModel.eCollectMerchantName!,
//                                       agentId: widget.ecollectMerchantModel.eCollectAgentId!,
//                                       agentOrginId: widget.ecollectMerchantModel.eCollectExternalAgentId!,
//                                       agentPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
//                                       agentEmail:widget.ecollectMerchantModel. eCollectAgentEmail!,
//                                       agentBranch:
//                                           int.parse(widget.ecollectMerchantModel.eCollectAgentBranchCode!)),
//                                   customerDetails: CustomerDetails(
//                                       customerName: widget.rdDetailsModel.custName!,
//                                       customerPhone: widget.ecollectMerchantModel.eCollectAgentNumber!,
//                                       customerAccno: widget.rdDetailsModel.accNo!,
//                                       customerId: widget.rdDetailsModel.custId!,
//                                       customerEmail: widget.ecollectMerchantModel.eCollectAgentEmail!),
//                                   collectionType: widget.ecollectMerchantModel.eCollectCollectionType!,
//                                   amount: double.parse(amountController.text),
//                                   note: 'Payment for Order',
//                                   qrSource: 'MOB',
//                                   source: 'COLLECTION',
//                                   merchantId:
//                                       int.parse(widget.ecollectMerchantModel.eCollectAgentMerchantID!))
//
//                               ,widget.ecollectMerchantModel.eCollectUserToken!));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.redAccent,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: Text(
//                           "Yes",
//                           style: GoogleFonts.poppins(
//                             color: white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPaymentOptionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//         width: double.infinity,
//         child: ElevatedButton.icon(
//           icon: Icon(icon, size: 24),
//           label: Text(
//             label,
//             style: const TextStyle(fontSize: 16),
//           ),
//           onPressed: onPressed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: home1, // Use your color variable
//             foregroundColor: white, // Use your color variable
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FB),
//       appBar: AppBar(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         backgroundColor: const Color(0xFFF6F7FB),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
//           color: const Color(0xFF172033),
//         ),
//         title: Text(
//           "Account Details",
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF172033),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Text(
//                       "RD Account",
//                       style: GoogleFonts.poppins(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: const Color(0xFF7B8497),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//
//                       Text(
//                         "Customer information",
//                         style: GoogleFonts.poppins(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF172033),
//                         ),
//                       ),
//
//
//                     const SizedBox(height: 20),
//
//
//
//               Container(
//               width: double.infinity,
//                   padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: const Color(0xFFE8EBF0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.025),
//                     blurRadius: 16,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // ─────────────────────────────────────
//                   // CUSTOMER
//                   // ─────────────────────────────────────
//                   _modernInfoTile(
//                     icon: Icons.person_outline_rounded,
//                     iconBackground: const Color(0xFFF1F5FF),
//                     iconColor: const Color(0xFF4263EB),
//                     title: "Customer",
//                     value: widget.rdDetailsModel.custName!,
//                     trailing: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 9,
//                         vertical: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEAF8F0),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.check_circle_rounded,
//                             size: 12,
//                             color: Color(0xFF159957),
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             "Verified",
//                             style: TextStyle(
//                               fontSize: 9,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF159957),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   _modernDivider(),
//
//                   const SizedBox(height: 16),
//
//                   // ─────────────────────────────────────
//                   // ACCOUNT NUMBER
//                   // ─────────────────────────────────────
//                   _modernInfoTile(
//                     icon: Icons.account_balance_wallet_outlined,
//                     iconBackground: home1.withValues(alpha: 0.08),
//                     iconColor: home1,
//                     title: "Account Number",
//                     value: widget.rdDetailsModel.accNo!,
//                     trailing: Material(
//                       color: const Color(0xFFF5F6F8),
//                       borderRadius: BorderRadius.circular(9),
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(9),
//                         onTap: () {
//                           Clipboard.setData(
//                             ClipboardData(
//                               text: widget.rdDetailsModel.accNo!,
//                             ),
//                           );
//
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 "Account number copied",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               behavior: SnackBarBehavior.floating,
//                               margin: const EdgeInsets.all(16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               duration: const Duration(seconds: 1),
//                             ),
//                           );
//                         },
//                         child: const Padding(
//                           padding: EdgeInsets.all(8),
//                           child: Icon(
//                             Icons.copy_outlined,
//                             size: 16,
//                             color: Color(0xFF667085),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   _modernDivider(),
//
//                   const SizedBox(height: 16),
//
//                   // ─────────────────────────────────────
//                   // SCHEME
//                   // ─────────────────────────────────────
//                   _modernInfoTile(
//                     icon: Icons.description_outlined,
//                     iconBackground: const Color(0xFFFFF6E9),
//                     iconColor: const Color(0xFFE88A24),
//                     title: "Scheme",
//                     value: widget.rdDetailsModel.scheme!,
//                     trailing: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 9,
//                         vertical: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEAF8F0),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         "ACTIVE",
//                         style: TextStyle(
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF159957),
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//                     const SizedBox(height: 24),
//
//                     // Secure payment info
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: home1.withValues(alpha: 0.05),
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: const Color(0xFFDCEBFF),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Icon(
//                               Icons.lock_outline_rounded,
//                               color: home1,
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Secure collection",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w700,
//                                     color: const Color(0xFF243B64),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   "Choose a payment method to collect the amount.",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 11,
//                                     color: const Color(0xFF667085),
//                                     height: 1.4,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Bottom CTA
//             Container(
//               padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   top: BorderSide(
//                     color: const Color(0xFFE8EBF2),
//                   ),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.04),
//                     blurRadius: 18,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: () => _showBottomBar(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: home1,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(17),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.payments_rounded,
//                         size: 21,
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         "Collect Payment",
//                         style: GoogleFonts.poppins(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Icon(
//                         Icons.arrow_forward_rounded,
//                         size: 19,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             MultiBlocListener(
//               listeners: [
//                 BlocListener<PaymentBloc, PaymentState>(
//                   listener: (BuildContext context, PaymentState state) {
//                     if (state is QrPaymentLoaderState) {
//                       showProgressDialog(context);
//                     }
//
//                     if (state is QrPaymentSuccessState) {
//                       paymentOrderID  = state.qrPaymentSuccess.paymentResponseSuccess.orderId;
//
//                       Navigator.pop(context);
//
//                       selectedMethod == "Link"
//                           ? Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (BuildContext context) =>
//                               PaymentLinkRequestUi(
//                                 customerMobileNumber: "",
//                                 paymentLink: state
//                                     .qrPaymentSuccess
//                                     .paymentResponseSuccess
//                                     .paymentUrl,
//                               ),
//                         ),
//                       )
//                           : Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NewQrCodePage(
//                             paymentSessionId: state
//                                 .qrPaymentSuccess
//                                 .paymentResponseSuccess
//                                 .paymentUrl,
//                             amount: amountController.text,
//                             custName: "",
//                             custPhone: "custNumber",
//                             custId: "CustId", orderID: paymentOrderID!, merchantID:widget.ecollectMerchantModel.eCollectAgentMerchantID!
//                             , token: widget.ecollectMerchantModel.eCollectUserToken!,
//                           ),
//                         ),
//                       );
//                     } else if (state is QrPaymentFailState) {
//                       Navigator.pop(context);
//                       showAlertDialog(
//                         state.qrPaymentFail.paymentFailResponse.message,
//                         context,
//                       );
//                     } else if (state is CashPaymentSuccessState) {
//
//                         paymentOrderID  = state.cashPaymentSuccess.cashPaymentSuccessResponse.transactionId;
//
//                       Navigator.pop(context);
//                       _showSuccessMessage(state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
//                       state.cashPaymentSuccess.cashPaymentSuccessResponse.transactionId);
//                     } else if (state is CashPaymentFailState) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const SizedBox.shrink(),
//                 ),
//                 BlocListener<PaymentTransactionBloc, TransactionState>
//                   (listener: (BuildContext context, TransactionState state) {
//                   if (state is TransactionReportSuccessState) {
//                     final rawData =
//                         state.transactionSuccessModel
//                             .transactionOkReport.data;
//
//                     for (var orderid in rawData){
//                       if(orderid.paymentGatewayTransactionId.contains(paymentOrderID!)){
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => EcollectTransactionDetail(
//                               paymentTransaction: PaymentTransaction(
//                                 id: orderid.id,
//                                 orderId: orderid.orderId,
//                                 transactionId: orderid.transactionId,
//                                 paymentGatewayTransactionId:
//                                 orderid.paymentGatewayTransactionId,
//                                 amount: orderid.amount,
//                                 currency: orderid.currency,
//                                 description: orderid.description,
//                                 customerName: orderid.customerName,
//                                 customerEmail: orderid.customerEmail,
//                                 customerPhone: orderid.customerPhone,
//                                 paymentMode: orderid.paymentMode,
//                                 paymentChannel: orderid.paymentChannel,
//                                 status: orderid.status,
//                                 responseCode: orderid.responseCode,
//                                 responseMessage: orderid.responseMessage,
//                                 createdAt: orderid.createdAt,
//                                 completedAt: orderid.completedAt,
//                                 merchantId: orderid.merchantId,
//                                 merchantName: orderid.merchantName,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                     }
//                   }
//                 },)
//               ], child: Text(""),
//
//             ),
//
//
//           ],
//         ),
//       ),
//     );
//   }
//
// //==============================================================================
//   void _showSuccessMessage(String? message, String orderId) {
//     if (!mounted) return;
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 24,
//           ),
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 500,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Column(
//                     children: [
//                       SizedBox(
//                         width: 90,
//                         height: 70,
//                         child: Image.asset(
//                           'assets/images/ecollect_white.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       const Text(
//                         'Transaction Successful',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         message ??
//                             'Your transaction has been completed successfully.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.grey.shade200,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildDetailRow(
//                           'Transaction Status',
//                           'Successful',
//                           valueColor: Colors.green,
//                         ),
//                         const Divider(height: 20),
//                         _buildDetailRow(
//                           'Transaction Date',
//                           _getCurrentDate(),
//                         ),
//                         const Divider(height: 20),
//                         _buildDetailRow(
//                           'Order ID',
//                           orderId,
//                         ),
//                         const Divider(height: 20),
//                         _buildDetailRow(
//                           'Transaction Time',
//                           _getCurrentTime(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             getHistoryData(message);
//                           },
//                           icon: const Icon(
//                             Icons.print_outlined,
//                             size: 20,
//                           ),
//                           label: const Text(
//                             'Print',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             minimumSize: const Size.fromHeight(48),
//                             side: BorderSide(
//                               color: Colors.grey.shade400,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: FilledButton(
//                           onPressed: () {
//
//                             if (!mounted) return;
//                             Navigator.of(context).pop();
//                           },
//                           style: FilledButton.styleFrom(
//                             minimumSize: const Size.fromHeight(48),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             'OK',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildDetailRow(
//       String title,
//       String value, {
//         Color? valueColor,
//       }) {
//     return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: valueColor ?? Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );}
//   String _getCurrentDate() {
//     final now = DateTime.now();
//
//     return '${now.day.toString().padLeft(2, '0')}/'
//         '${now.month.toString().padLeft(2, '0')}/'
//         '${now.year}';
//   }
//   String _getCurrentTime() {
//     final now = DateTime.now();
//
//     return '${now.hour.toString().padLeft(2, '0')}:'
//         '${now.minute.toString().padLeft(2, '0')}';
//   }
//   void getHistoryData(String? message) {
//     debugPrint('Printing: ${message ?? ''}');
//     context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(widget.ecollectMerchantModel.eCollectAgentMerchantID!, widget.ecollectMerchantModel.eCollectUserToken!));
//   }
// //===============================================================================
//
//
//
//
//   Widget _modernInfoTile({
//     required IconData icon,
//     required Color iconBackground,
//     required Color iconColor,
//     required String title,
//     required String value,
//     Widget? trailing,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 38,
//           height: 38,
//           decoration: BoxDecoration(
//             color: iconBackground,
//             borderRadius: BorderRadius.circular(11),
//           ),
//           child: Icon(
//             icon,
//             size: 19,
//             color: iconColor,
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF8A93A5),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF20252D),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         if (trailing != null) ...[
//           const SizedBox(width: 10),
//           trailing,
//         ],
//       ],
//     );
//   }
//
//
//
//   Widget _modernDivider() {
//     return Container(
//       height: 1,
//       color: const Color(0xFFF0F1F5),
//     );
//   }
//
// }
