import 'package:flutter/material.dart';

const Color successColor = Color(0xFF00B894);
const Color warningColor = Colors.amber;
const Color backgroundColor = Colors.white;
const Color cardColor = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);

const Color home1 = Color(0xFF6C5CE7);
const Color home2 = Color(0xFFA29BFE);
const Color errorColor = Colors.red;
const Color black = Colors.black12;
const Color black87 = Colors.black26;
const Color white = Colors.white;

class PaymentLinkHomePageMerchant extends StatelessWidget {
  const PaymentLinkHomePageMerchant({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 VERIFICATION STATE - Change this to true/false to test
    const bool isVerified = true; // Set to false for unverified state

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(isVerified),
      body: isVerified
          ? _buildVerifiedBody()
          : _buildUnverifiedBody(),
      floatingActionButton: _buildFAB(isVerified),
    );
  }

  Widget _buildVerifiedBody() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _WelcomeHeader()),
        const SliverToBoxAdapter(child: _SummaryCards()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        const SliverToBoxAdapter(child: _SectionHeader("Received Payments", 4)),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: _PaymentsList(isReceived: true)),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        const SliverToBoxAdapter(child: _SectionHeader("Due Payments", 3)),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: _PaymentsList(isReceived: false)),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildUnverifiedBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const _WelcomeHeader(),
            const SizedBox(height: 16),
            const _VerificationBanner(),
            const SizedBox(height: 32),

            // Full screen lock state
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    textAlign: TextAlign.center,
                    "Transaction Features Locked",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Once the verification is complete,you'll be able access all transaction features including:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildFeatureList(),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Contact support if you need assistance with verification",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      "View Transaction summaries and analytics",
      "Send and manage payment links",
      "Track received and due payments",
      "Send reminders to payers",
      "Access Transaction history",
    ];

    return features.map((feature) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 18,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  PreferredSizeWidget _buildAppBar(bool isVerified) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Transactions",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          if (!isVerified) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade300.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Locked",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade100,
                ),
              ),
            ),
          ],
        ],
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEA307B), Color(0xFF470952)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildFAB(bool isVerified) {
    return FloatingActionButton(
      onPressed: isVerified
          ? () {
        // Navigate to create payment link
      }
          : null,
      backgroundColor: isVerified ? home1 : Colors.grey.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Icon(
        isVerified ? Icons.add : Icons.lock_outline,
        color: isVerified ? Colors.white : Colors.grey.shade600,
      ),
    );
  }
}

// 🔹 Verification Banner Widget
class _VerificationBanner extends StatelessWidget {
  const _VerificationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.orange.shade100.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade300.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              color: Colors.orange.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verification Pending",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Complete verification to access all transaction features",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Existing widgets (unchanged below this line)
// ============================================================

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back, Amal K!",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Manage your payment links seamlessly",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
    const receivedAmount = "₹ 800.00";
    const dueAmount = "₹ 690.00";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _SummaryCard("Received", receivedAmount, true)),
          const SizedBox(width: 16),
          Expanded(child: _SummaryCard("Due", dueAmount, false)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool success;

  const _SummaryCard(this.title, this.amount, this.success);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: success
              ? const [Color(0xFF00B894), Color(0xFF00C6A7)]
              : const [Color(0xFFFDCB6E), Color(0xFFFFD180)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: success
                    ? [Colors.green.shade400, Colors.green.shade600]
                    : [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (success ? Colors.green : Colors.orange).withValues(alpha:0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              success ? Icons.check_circle : Icons.access_time,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          if (success) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Payment Successful",
                style: TextStyle(
                  color: Colors.white.withValues(alpha:0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader(this.title, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: title == "Due Payments" ? errorColor : textPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [home1, home2]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _PaymentsList extends StatelessWidget {
  final bool isReceived;

  const _PaymentsList({required this.isReceived});

  final List<Map<String, dynamic>> receivedPayments = const [
    {
      "name": "John Doe",
      "amount": "\$150.00",
      "date": "Mar 02, 2025",
      "initial": "J"
    },
    {
      "name": "Sarah Smith",
      "amount": "\$200.00",
      "date": "Mar 01, 2025",
      "initial": "S"
    },
    {
      "name": "Mike Johnson",
      "amount": "\$450.00",
      "date": "Feb 28, 2025",
      "initial": "M"
    },
    {
      "name": "Emily Davis",
      "amount": "\$100.00",
      "date": "Feb 27, 2025",
      "initial": "E"
    },
  ];

  final List<Map<String, dynamic>> duePayments = const [
    {
      "name": "David Wilson",
      "amount": "\$250.00",
      "date": "Mar 05, 2025",
      "initial": "D"
    },
    {
      "name": "Lisa Brown",
      "amount": "\$180.00",
      "date": "Mar 06, 2025",
      "initial": "L"
    },
    {
      "name": "Robert Taylor",
      "amount": "\$260.00",
      "date": "Mar 07, 2025",
      "initial": "R"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final payments = isReceived ? receivedPayments : duePayments;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: black),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: payments.length,
        separatorBuilder: (_, __) => const Divider(
          color: Colors.grey,
          thickness: 0.5,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (_, index) => _PaymentItem(
          isReceived: isReceived,
          payment: payments[index],
        ),
      ),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  final bool isReceived;
  final Map<String, dynamic> payment;

  const _PaymentItem({
    required this.isReceived,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final color = isReceived ? successColor : warningColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha:0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha:0.3),
                child: Text(
                  payment["initial"],
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      fontSize: 16,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: textSecondary.withValues(alpha:0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        payment["date"],
                        style: TextStyle(
                          color: textSecondary.withValues(alpha:0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    payment["amount"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (!isReceived) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle remind action
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: home1.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.alarm,
                            size: 12,
                            color: home1,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Remind",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: home1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}