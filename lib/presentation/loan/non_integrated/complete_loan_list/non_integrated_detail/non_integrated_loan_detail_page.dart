import 'package:flutter/material.dart';

class NonIntegratedLoanDetailsScreen extends StatefulWidget {
  const NonIntegratedLoanDetailsScreen({super.key});

  @override
  State<NonIntegratedLoanDetailsScreen> createState() => _NonIntegratedLoanDetailsScreenState();
}

class _NonIntegratedLoanDetailsScreenState extends State<NonIntegratedLoanDetailsScreen> {
  bool reminderEnabled = true;

  final List<String> channels = [
    'SMS',
    'WhatsApp',
    'Call',
  ];

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
            color: Colors.black87,
            fontSize: 18,
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

            const Text(
              'Manju',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Account 903U28828',
              style: TextStyle(
                fontSize: 13,
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
                    color: Colors.black.withOpacity(0.03),
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
                  const Text(
                    '₹2,00,000',
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
                  const Row(
                    children: [
                      Text(
                        '₹16,667',
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
                        'Monthly',
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
              value: 'Jun 1, 2026',
            ),

            const SizedBox(height: 12),

            _infoRow(
              title: 'Next due',
              value: 'Jul 1, 2026',
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
                value: reminderEnabled,
                onChanged: (value) {
                  setState(() {
                    reminderEnabled = value;
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
                  color: Colors.green.withOpacity(0.10),
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

            const Text(
              'Channels',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: channels.map((channel) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    channel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),



            const SizedBox(height: 20),
          ],
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
