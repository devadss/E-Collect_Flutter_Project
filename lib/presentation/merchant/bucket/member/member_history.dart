import 'package:flutter/material.dart';

class MemberPaymentHistoryPage extends StatefulWidget {
  final String groupName;
  const MemberPaymentHistoryPage({super.key, required this.groupName});

  @override
  State<MemberPaymentHistoryPage> createState() => _MemberPaymentHistoryPageState();
}

class _MemberPaymentHistoryPageState extends State<MemberPaymentHistoryPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Late'];
  List<PaymentRecord> get _groupPayments =>
      _payments.where((p) => p.groupName == widget.groupName).toList();
  // Mock payment history data
  final List<PaymentRecord> _payments = [
    PaymentRecord(
      id: 'TXN123456',
      groupName: 'Chai & Sutta Group',
      amount: 1000,
      date: DateTime(2026, 6, 1),
      status: PaymentStatus.paid,
      note: 'June week 1',
      category: 'Daily',
      paymentMethod: 'UPI - Google Pay',
    ),
    PaymentRecord(
      id: 'TXN123457',
      groupName: 'Chai & Sutta Group',
      amount: 1000,
      date: DateTime(2026, 6, 8),
      status: PaymentStatus.paid,
      note: 'June week 2',
      category: 'Daily',
      paymentMethod: 'UPI - PhonePe',
    ),
    PaymentRecord(
      id: 'TXN123458',
      groupName: 'Chai & Sutta Group',
      amount: 1000,
      date: DateTime(2026, 6, 15),
      status: PaymentStatus.paid,
      note: 'June week 3',
      category: 'Daily',
      paymentMethod: 'UPI - Google Pay',
    ),
    PaymentRecord(
      id: 'TXN223456',
      groupName: 'Office Lunch Club',
      amount: 2000,
      date: DateTime(2026, 6, 5),
      status: PaymentStatus.paid,
      note: 'Week 1 lunch',
      category: 'Weekly',
      paymentMethod: 'Credit Card',
    ),
    PaymentRecord(
      id: 'TXN223457',
      groupName: 'Office Lunch Club',
      amount: 2000,
      date: DateTime(2026, 6, 12),
      status: PaymentStatus.paid,
      note: 'Week 2 lunch',
      category: 'Weekly',
      paymentMethod: 'Debit Card',
    ),
    PaymentRecord(
      id: 'TXN223458',
      groupName: 'Office Lunch Club',
      amount: 3000,
      date: DateTime(2026, 6, 19),
      status: PaymentStatus.late,
      note: 'Week 3 lunch - late',
      category: 'Weekly',
      paymentMethod: 'UPI - Paytm',
    ),
    PaymentRecord(
      id: 'TXN323456',
      groupName: 'Book Reading Club',
      amount: 1000,
      date: DateTime(2026, 5, 1),
      status: PaymentStatus.paid,
      note: 'May books',
      category: 'Monthly',
      paymentMethod: 'Net Banking',
    ),
    PaymentRecord(
      id: 'TXN323457',
      groupName: 'Book Reading Club',
      amount: 1000,
      date: DateTime(2026, 5, 15),
      status: PaymentStatus.paid,
      note: 'June books',
      category: 'Monthly',
      paymentMethod: 'UPI - Google Pay',
    ),
    PaymentRecord(
      id: 'TXN423456',
      groupName: 'Goa Trip Fund',
      amount: 1000,
      date: DateTime(2026, 6, 10),
      status: PaymentStatus.paid,
      note: 'Initial deposit',
      category: 'Savings',
      paymentMethod: 'Cash Deposit',
    ),
    PaymentRecord(
      id: 'TXN423457',
      groupName: 'Goa Trip Fund',
      amount: 1000,
      date: DateTime(2026, 6, 20),
      status: PaymentStatus.paid,
      note: 'Second payment',
      category: 'Savings',
      paymentMethod: 'UPI - PhonePe',
    ),
    PaymentRecord(
      id: 'TXN423458',
      groupName: 'Goa Trip Fund',
      amount: 2000,
      date: DateTime(2026, 6, 30),
      status: PaymentStatus.pending,
      note: 'Third payment',
      category: 'Savings',
      paymentMethod: 'Pending',
    ),
  ];

  List<PaymentRecord> get _filteredPayments {
    print(_payments[0].groupName);
    var payments = _payments.where(
          (p) => p.groupName == widget.groupName,
    );

    if (_selectedFilter != 'All') {
      payments = payments.where(
            (p) => p.status.name.toLowerCase() ==
            _selectedFilter.toLowerCase(),
      );
    }

    return payments.toList();
  }


  double get _totalPaid => _groupPayments
      .where((p) => p.status == PaymentStatus.paid)
      .fold(0, (sum, p) => sum + p.amount);

  double get _totalPending => _groupPayments
      .where((p) => p.status == PaymentStatus.pending)
      .fold(0, (sum, p) => sum + p.amount);

  int get _totalTransactions => _groupPayments.length;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment History',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Color(0xFF4B5563)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF4B5563)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSummaryCard(
                  '💰 Total Paid',
                  '₹${_totalPaid.toStringAsFixed(0)}',
                  Colors.green.shade600,
                  Icons.trending_up,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  '⏳ Pending',
                  '₹${_totalPending.toStringAsFixed(0)}',
                  Colors.orange.shade600,
                  Icons.pending_actions,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  '📊 Transactions',
                  '$_totalTransactions',
                  const Color(0xFF4F46E5),
                  Icons.receipt_long,
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                  label: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF4F46E5),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Payment List
          Expanded(
            child: _filteredPayments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = _filteredPayments[index];
                return _buildPaymentCard(payment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(PaymentRecord payment) {
    final isPaid = payment.status == PaymentStatus.paid;
    final isPending = payment.status == PaymentStatus.pending;
   // final isLate = payment.status == PaymentStatus.late;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isPaid) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Paid';
    } else if (isPending) {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
      statusText = 'Pending';
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.warning;
      statusText = 'Late';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showPaymentDetails(payment),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.groupName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              payment.note,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                payment.category,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
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
                      Text(
                        '₹${payment.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(payment.date),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.payment,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    payment.paymentMethod,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📭',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            'No payments found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the filter above',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(PaymentRecord payment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('💳', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        payment.groupName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Amount', '₹${payment.amount.toStringAsFixed(0)}'),
            _buildDetailRow('Status', _getStatusText(payment.status), color: _getStatusColor(payment.status)),
            _buildDetailRow('Date', _formatDate(payment.date)),
            _buildDetailRow('Transaction ID', payment.id),
            _buildDetailRow('Payment Method', payment.paymentMethod),
            _buildDetailRow('Note', payment.note),
            _buildDetailRow('Category', payment.category),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayOfWeek = days[date.weekday - 1];
    return '$dayOfWeek, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return '✅ Paid';
      case PaymentStatus.pending:
        return '⏳ Pending';
      case PaymentStatus.late:
        return '⚠️ Late';
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.late:
        return Colors.red;
    }
  }
}

// Models
enum PaymentStatus { paid, pending, late }

class PaymentRecord {
  final String id;
  final String groupName;
  final double amount;
  final DateTime date;
  final PaymentStatus status;
  final String note;
  final String category;
  final String paymentMethod;

  PaymentRecord({
    required this.id,
    required this.groupName,
    required this.amount,
    required this.date,
    required this.status,
    required this.note,
    required this.category,
    required this.paymentMethod,
  });
}