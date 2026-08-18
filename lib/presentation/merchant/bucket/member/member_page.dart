import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

import 'member_history.dart';

class MemberBucketTrackingDashboard extends StatefulWidget {
  const MemberBucketTrackingDashboard({super.key});

  @override
  State<MemberBucketTrackingDashboard> createState() =>
      _MemberBucketTrackingDashboardState();
}

class _MemberBucketTrackingDashboardState
    extends State<MemberBucketTrackingDashboard> {
  int _selectedTab = 0;

  // Mock data
  final List<Group> groups = [
    Group(
      id: 1,
      name: "Family Savings Group",
      totalAmount: 5000,
      paidAmount: 3500,
      pendingAmount: 1500,
      nextPayment: DateTime(2026, 7, 15),
      members: 12,
      status: GroupStatus.active,
      paymentHistory: [
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 1),
            status: PaymentStatus.paid),
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 8),
            status: PaymentStatus.paid),
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 15),
            status: PaymentStatus.paid),
        Payment(
            amount: 500,
            date: DateTime(2026, 6, 22),
            status: PaymentStatus.pending),
      ],
    ),
    Group(
      id: 2,
      name: "Business Investment Group",
      totalAmount: 10000,
      paidAmount: 7000,
      pendingAmount: 3000,
      nextPayment: DateTime(2026, 7, 20),
      members: 8,
      status: GroupStatus.active,
      paymentHistory: [
        Payment(
            amount: 2000,
            date: DateTime(2026, 6, 5),
            status: PaymentStatus.paid),
        Payment(
            amount: 2000,
            date: DateTime(2026, 6, 12),
            status: PaymentStatus.paid),
        Payment(
            amount: 3000,
            date: DateTime(2026, 6, 19),
            status: PaymentStatus.late),
        Payment(
            amount: 3000,
            date: DateTime(2026, 6, 26),
            status: PaymentStatus.pending),
      ],
    ),
    Group(
      id: 3,
      name: "Education Fund",
      totalAmount: 3000,
      paidAmount: 3000,
      pendingAmount: 0,
      nextPayment: DateTime(2026, 8, 1),
      members: 5,
      status: GroupStatus.completed,
      paymentHistory: [
        Payment(
            amount: 1000,
            date: DateTime(2026, 5, 1),
            status: PaymentStatus.paid),
        Payment(
            amount: 1000,
            date: DateTime(2026, 5, 15),
            status: PaymentStatus.paid),
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 1),
            status: PaymentStatus.paid),
      ],
    ),
    Group(
      id: 4,
      name: "Vacation Planning",
      totalAmount: 8000,
      paidAmount: 2000,
      pendingAmount: 6000,
      nextPayment: DateTime(2026, 7, 10),
      members: 6,
      status: GroupStatus.active,
      paymentHistory: [
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 10),
            status: PaymentStatus.paid),
        Payment(
            amount: 1000,
            date: DateTime(2026, 6, 20),
            status: PaymentStatus.paid),
        Payment(
            amount: 2000,
            date: DateTime(2026, 6, 30),
            status: PaymentStatus.pending),
      ],
    ),
  ];

  List<Group> get filteredGroups {
    if (_selectedTab == 0) return groups;
    if (_selectedTab == 1) {
      return groups.where((g) => g.status == GroupStatus.active).toList();
    }
    if (_selectedTab == 2) {
      return groups.where((g) => g.status == GroupStatus.completed).toList();
    }
    if (_selectedTab == 3) {
      return groups.where((g) => g.pendingAmount > 0).toList();
    }
    return groups;
  }

  double get totalPaid => groups.fold(0, (sum, g) => sum + g.paidAmount);
  double get totalPending => groups.fold(0, (sum, g) => sum + g.pendingAmount);
  int get totalGroups => groups.length;
  int get activeGroups =>
      groups.where((g) => g.status == GroupStatus.active).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Buckets',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1A237E)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF1A237E)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          _buildStatsCards(),

          const SizedBox(height: 16),

          // Filter Tabs
          _buildFilterTabs(),

          const SizedBox(height: 16),

          // Group List
          Expanded(
            child: filteredGroups.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      return _buildGroupCard(filteredGroups[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatCard(
            icon: Icons.account_balance_wallet,
            title: 'Total Paid',
            value: '₹${totalPaid.toStringAsFixed(0)}',
            color: Colors.green,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          _buildStatCard(
            icon: Icons.pending_actions,
            title: 'Pending',
            value: '₹${totalPending.toStringAsFixed(0)}',
            color: Colors.orange,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          _buildStatCard(
            icon: Icons.business_center_outlined,
            title: 'Active Buckets',
            value: '$activeGroups/$totalGroups',
            color: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildFilterTab('All', 0),
            _buildFilterTab('Active', 1),
            _buildFilterTab('Completed', 2),
            _buildFilterTab('Pending', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? home1 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    final progress =
        group.totalAmount > 0 ? group.paidAmount / group.totalAmount : 0;
    final isUpcoming = group.nextPayment.isAfter(DateTime.now());

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MemberPaymentHistoryPage(
                      groupName: 'Chai & Sutta Group',
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          home1.withValues(alpha: 0.1),
                          home1.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.business_center_outlined,
                      color: home1,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${group.members} members',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildStatusChip(group.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    itemBuilder: (context) => [
                      const PopupMenuItem(child: Text('View Details')),
                      const PopupMenuItem(child: Text('Payment History')),
                      const PopupMenuItem(child: Text('Share')),
                    ],
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: progress >= 0.8
                              ? Colors.green
                              : const Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.toDouble(),
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 0.8
                            ? Colors.green
                            : const Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAmountChip(
                        'Paid',
                        '₹${group.paidAmount.toStringAsFixed(0)}',
                        Colors.green,
                      ),
                      _buildAmountChip(
                        'Pending',
                        '₹${group.pendingAmount.toStringAsFixed(0)}',
                        Colors.orange,
                      ),
                      _buildAmountChip(
                        'Total',
                        '₹${group.totalAmount.toStringAsFixed(0)}',
                        const Color(0xFF1A237E),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isUpcoming ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUpcoming ? 'Next Payment' : 'Overdue Payment',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${_formatDate(group.nextPayment)} • ₹${group.pendingAmount > 0 ? (group.pendingAmount / (group.members > 0 ? group.members : 1)).toStringAsFixed(0) : '0'} per member',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showPaymentDialog(group);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: home1,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 32),
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildStatusChip(GroupStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case GroupStatus.active:
        color = Colors.green;
        label = 'Active';
        icon = Icons.check_circle;
        break;
      case GroupStatus.completed:
        color = Colors.blue;
        label = 'Completed';
        icon = Icons.task_alt;
        break;
      case GroupStatus.suspended:
        color = Colors.red;
        label = 'Suspended';
        icon = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No groups found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You are not a member of any group in this category',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showPaymentDialog(Group group) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Make Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                group.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentSummary(
                        'Amount Due',
                        '₹${group.pendingAmount.toStringAsFixed(0)}',
                        Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPaymentSummary(
                        'Your Share',
                        '₹${(group.pendingAmount / group.members).toStringAsFixed(0)}',
                        const Color(0xFF1A237E)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentSummary(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your payment has been processed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Models
enum GroupStatus { active, completed, suspended }

enum PaymentStatus { paid, pending, late }

class Payment {
  final double amount;
  final DateTime date;
  final PaymentStatus status;

  Payment({
    required this.amount,
    required this.date,
    required this.status,
  });
}

class Group {
  final int id;
  final String name;
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final DateTime nextPayment;
  final int members;
  final GroupStatus status;
  final List<Payment> paymentHistory;

  Group({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.nextPayment,
    required this.members,
    required this.status,
    required this.paymentHistory,
  });
}
