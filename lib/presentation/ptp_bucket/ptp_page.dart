import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import '../../core/utils.dart';

import 'package:flutter/material.dart';

class PtpPage extends StatefulWidget {
  const PtpPage({super.key});

  @override
  State<PtpPage> createState() => _PtpPageState();
}

class _PtpPageState extends State<PtpPage> {
  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController remarkController =
  TextEditingController();

  final Map<String, dynamic> ptpData = {
    "Customer Name": "Ravi Kumar",
    "Loans No": "LN092020",
    "Due Amount": "₹12,500",
    "Bucket": 4,
  };

  DateTime selectedPromiseDate = DateTime.now();

  // ------------------------------------------------------------
  // FINTECH COLOR SYSTEM
  // ------------------------------------------------------------

  static const Color primary = Color(0xFF175CD3);
  static const Color primaryDark = Color(0xFF0F3FA8);

  static const Color background = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF667085);
  static const Color border = Color(0xFFE4E7EC);

  static const Color success = Color(0xFF039855);
  static const Color warning = Color(0xFFF79009);

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    amountController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,

      appBar: ptpBucketAppbar("Promise to Pay"),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildCustomerCard(),

                    const SizedBox(height: 24),

                    _buildSectionTitle(
                      "PTP DETAILS",
                    ),

                    const SizedBox(height: 12),

                    _buildDateField(),

                    const SizedBox(height: 20),

                    _buildAmountField(),

                    const SizedBox(height: 20),

                    _buildRemarksField(),

                    const SizedBox(height: 24),

                    _buildPtpSummary(),
                  ],
                ),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CUSTOMER CARD
  // ------------------------------------------------------------

  Widget _buildCustomerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // CUSTOMER INITIALS
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "RK",
                  style: TextStyle(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // CUSTOMER NAME
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      ptpData["Customer Name"],
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Loan ID  •  ${ptpData["Loans No"]}",
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // BUCKET
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "B${ptpData["Bucket"]}",
                  style: const TextStyle(
                    color: Color(0xFFB54708),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // DIVIDER
          const Divider(
            height: 1,
            color: border,
          ),

          const SizedBox(height: 16),

          // OUTSTANDING
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 20,
                  color: primary,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Outstanding Due",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹12,500",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
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
                  color: const Color(0xFFECFDF3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: success,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: success,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: textSecondary,
        fontSize: 12,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ------------------------------------------------------------
  // DATE FIELD
  // ------------------------------------------------------------

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promise Date",
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _selectPromiseDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "New Promise Date",
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        _formatDate(selectedPromiseDate),
                        style: const TextStyle(
                          color: textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // AMOUNT FIELD
  // ------------------------------------------------------------

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promise Amount",
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,

          onChanged: (_) {
            setState(() {});
          },

          style: const TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),

          decoration: InputDecoration(
            hintText: "Enter amount",
            hintStyle: const TextStyle(
              color: Color(0xFF98A2B3),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            prefixText: "₹  ",
            prefixStyle: const TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),

            filled: true,
            fillColor: Colors.white,

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: border,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: border,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: primary,
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          "Enter the amount the customer has committed to pay.",
          style: TextStyle(
            color: textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // REMARK FIELD
  // ------------------------------------------------------------

  Widget _buildRemarksField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Remarks",
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: remarkController,
          maxLength: 100,
          maxLines: 4,
          textInputAction: TextInputAction.newline,

          decoration: InputDecoration(
            hintText:
            "Add collection remarks...",
            hintStyle: const TextStyle(
              color: Color(0xFF98A2B3),
              fontSize: 14,
            ),

            counterStyle: const TextStyle(
              color: textSecondary,
              fontSize: 10,
            ),

            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                left: 14,
                right: 8,
                top: 14,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1,
                child: Icon(
                  Icons.notes_outlined,
                  size: 20,
                  color: primary,
                ),
              ),
            ),

            filled: true,
            fillColor: Colors.white,

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: border,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: border,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PTP SUMMARY
  // ------------------------------------------------------------

  Widget _buildPtpSummary() {
    final double dueAmount = 12500;

    final double promiseAmount =
        double.tryParse(
          amountController.text.trim(),
        ) ??
            0;

    final double remaining =
        dueAmount - promiseAmount;

    final double safeRemaining =
    remaining < 0 ? 0 : remaining;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 18,
                color: primary,
              ),
              SizedBox(width: 8),
              Text(
                "PTP SUMMARY",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _summaryRow(
            "Outstanding Due",
            "₹12,500",
          ),

          const SizedBox(height: 10),

          _summaryRow(
            "Promise Amount",
            promiseAmount > 0
                ? "₹${_formatAmount(promiseAmount)}"
                : "₹0",
          ),

          const SizedBox(height: 10),

          const Divider(
            color: border,
          ),

          const SizedBox(height: 10),

          _summaryRow(
            "Remaining Due",
            "₹${_formatAmount(safeRemaining)}",
            valueColor: safeRemaining == 0
                ? success
                : textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String title,
      String value, {
        Color valueColor = textPrimary,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BOTTOM BUTTON
  // ------------------------------------------------------------

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: border,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: validateFields,
          style: ElevatedButton.styleFrom(
            backgroundColor: home1,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                "Confirm PTP",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // DATE PICKER
  // ------------------------------------------------------------

  Future<void> _selectPromiseDate() async {
    final DateTime? picked =
    await showDatePicker(
      context: context,
      initialDate: selectedPromiseDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      builder: (
          BuildContext context,
          Widget? child,
          ) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedPromiseDate = picked;
      });
    }
  }

  // ------------------------------------------------------------
  // VALIDATION
  // ------------------------------------------------------------

  void validateFields() {
    final String amount =
    amountController.text.trim();

    final String remarks =
    remarkController.text.trim();

    if (amount.isEmpty) {
      showNotification(
        context,
        "Enter promise amount",
        warning,
        Colors.white,
      );
      return;
    }

    final double? promiseAmount =
    double.tryParse(amount);

    if (promiseAmount == null ||
        promiseAmount <= 0) {
      showNotification(
        context,
        "Enter a valid promise amount",
        warning,
        Colors.white,
      );
      return;
    }

    if (promiseAmount > 12500) {
      showNotification(
        context,
        "Promise amount cannot exceed ₹12,500",
        warning,
        Colors.white,
      );
      return;
    }

    if (remarks.isEmpty) {
      showNotification(
        context,
        "Enter collection remarks",
        warning,
        Colors.white,
      );
      return;
    }

    showNotification(
      context,
      "PTP submitted successfully",
      success,
      Colors.white,
    );
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day.toString().padLeft(2, '0')} "
        "${months[date.month - 1]} "
        "${date.year}";
  }

  // ------------------------------------------------------------
  // NUMBER FORMAT
  // ------------------------------------------------------------

  String _formatAmount(double amount) {
    final String value =
    amount.toStringAsFixed(0);

    final StringBuffer result =
    StringBuffer();

    int count = 0;

    for (int i = value.length - 1;
    i >= 0;
    i--) {
      result.write(value[i]);
      count++;

      if (count == 3 &&
          i != 0) {
        result.write(",");
        count = 0;
      } else if (count == 2 &&
          i > 0 &&
          value.length - i > 3) {
        result.write(",");
        count = 0;
      }
    }

    return result
        .toString()
        .split('')
        .reversed
        .join();
  }
}
/*
class PtpPage extends StatefulWidget {
  const PtpPage({super.key});

  @override
  State<PtpPage> createState() => _PtpPageState();
}
class _PtpPageState extends State<PtpPage> {

  TextEditingController amountController =
  TextEditingController();

  TextEditingController remarkController =
  TextEditingController();

  Map<String, dynamic> ptpData = {
    "Customer Name": "Ravi Kumar",
    "Loans No": "LN092020",
    "Due Amount": "Rs 12,500",
    "Bucket": 4
  };

  String newPromiseDate =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: const Color(0xffF4F7FC),

      appBar: ptp_bucket_appbar("PTP"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// CUSTOMER DETAILS CARD
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha:.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: Column(
                children: [

                  /// TOP
                  Row(
                    children: [

                      Container(
                        padding:
                        const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          Colors.indigo.shade50,
                        ),

                        child: const Icon(
                          Icons.person,
                          color: Colors.indigo,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: const [

                            Text(
                              "Ravi Kumar",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Loan No : LN092020",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              30),
                          color:
                          Colors.orange.shade100,
                        ),

                        child: const Text(
                          "B4",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DUE AMOUNT
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(18),
                      color: Colors.orange.shade50,
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        const Text(
                          "Due Amount",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        Text(
                          "₹ 12,500",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// DATE TITLE
            const Text(
              "Select Promise Date",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            /// DATE DISPLAY
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(18),

                color: home1.withValues(alpha:.08),

                border: Border.all(
                  color: home1.withValues(alpha:.15),
                ),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    backgroundColor: home1,
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "New Promise Date : $newPromiseDate",
                      style: const TextStyle(
                        color: home1,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// DATE PICKER
            Container(
              height: 220,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha:.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,

                initialDateTime: DateTime.now(),

                onDateTimeChanged:
                    (DateTime newDateTime) {

                  setState(() {
                    newPromiseDate =
                    "${newDateTime.day}-${newDateTime.month}-${newDateTime.year}";
                  });
                },
              ),
            ),

            const SizedBox(height: 28),

            /// PROMISE AMOUNT TITLE
            const Text(
              "Promise Amount",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 14),

            buildTextField(
              amountController,
              "Enter Promise Amount",
            ),

            const SizedBox(height: 22),

            const Text(
              "Remarks",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 14),

            buildTextField(
              remarkController,
              "Enter Remarks",
            ),

            const SizedBox(height: 32),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor: home1,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {
                  validateFields();
                },

                child: const Text(
                  "Save PTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  TextField buildTextField(
      TextEditingController controller,
      String labelName,
      )
  {

    bool isRemark =
    labelName.contains("Remarks");

    return TextField(
      controller: controller,

      maxLength: isRemark ? 50 : 8,

      keyboardType: isRemark
          ? TextInputType.text
          : TextInputType.number,

      decoration: InputDecoration(
        counterText: "",

        hintText: labelName,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: isRemark
                ? Colors.indigo.shade50
                : Colors.green.shade50,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Icon(
            isRemark
                ? Icons.notes_rounded
                : Icons.currency_rupee_rounded,

            color: isRemark
                ? Colors.indigo
                : Colors.green,
          ),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: home1,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void validateFields() {

    if (amountController.text.isNotEmpty &&
        remarkController.text.isNotEmpty) {

      showNotification(
        context,
        "Success",
        Colors.green,
        Colors.white,
      );

    } else {

      showNotification(
        context,
        "Fill empty fields",
        Colors.orange,
        Colors.black,
      );
    }
  }

  ListView buildListView({
    required Map<String, dynamic> ptpD,
  }) {

    return ListView.builder(
      itemCount: ptpD.keys.length,

      itemBuilder:
          (BuildContext context, int index) {

        return Padding(
          padding: const EdgeInsets.all(3.0),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Text(
                ptpD.keys.elementAt(index),
              ),

              Text(
                ptpD.values
                    .elementAt(index)
                    .toString(),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/


