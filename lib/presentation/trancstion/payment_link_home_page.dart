import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/colors.dart';

class PaymentLinkHomePage extends StatefulWidget {
  const PaymentLinkHomePage({super.key});

  @override
  State<PaymentLinkHomePage> createState() => _PaymentLinkHomePageState();
}

class _PaymentLinkHomePageState extends State<PaymentLinkHomePage> {
  // Sample data - replace with your actual data source
  final List<Payment> receivedPayments = [
    Payment('John Doe', 150.00, DateTime.now().subtract(const Duration(days: 2)), true),
    Payment('Jane Smith', 200.00, DateTime.now().subtract(const Duration(days: 5)), true),
    Payment('Group A', 350.00, DateTime.now().subtract(const Duration(days: 10)), true),
    Payment('Mike Johnson', 100.00, DateTime.now().subtract(const Duration(days: 15)), true),
  ];

  final List<Payment> duePayments = [
    Payment('Sarah Williams', 180.00, DateTime.now().add(const Duration(days: 5)), false),
    Payment('Group B', 420.00, DateTime.now().add(const Duration(days: 7)), false),
    Payment('David Brown', 90.00, DateTime.now().add(const Duration(days: 3)), false),
  ];

  // Theme colors
// Home 1 secondary
  final Color successColor = const Color(0xFF00B894); // Home 2 success
  final Color warningColor = const Color(0xFFFDCB6E); // Home 2 warning
  final Color backgroundColor = const Color(0xFFF5F6FA); // Light background

  @override
  Widget build(BuildContext context) {
    double totalReceived = receivedPayments.fold(0, (sum, payment) => sum + payment.amount);
    double totalDue = duePayments.fold(0, (sum, payment) => sum + payment.amount);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Payment Links', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                  'Received',
                  totalReceived,
                  successColor,
                  Icons.check_circle,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'Due',
                  totalDue,
                  warningColor,
                  Icons.pending_actions,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Received Payments Section
            _buildSectionHeader('Received Payments', receivedPayments.length),
            const SizedBox(height: 8),
            _buildPaymentsList(receivedPayments, true),
            const SizedBox(height: 24),

            // Due Payments Section
            _buildSectionHeader('Due Payments', duePayments.length),
            const SizedBox(height: 8),
            _buildPaymentsList(duePayments, false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPaymentLink,
        backgroundColor: home1,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Payment Link',
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total amount',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: home1,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: home1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: home1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList(List<Payment> payments, bool isReceived) {
    if (payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No payments found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: payments.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final payment = payments[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isReceived
                    ? successColor.withOpacity(0.2)
                    : warningColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  payment.name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isReceived ? successColor : warningColor,
                  ),
                ),
              ),
            ),
            title: Text(
              payment.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              DateFormat('MMM dd, yyyy').format(payment.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${payment.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isReceived ? successColor : warningColor,
                  ),
                ),
                if (!isReceived)
                  TextButton(
                    onPressed: () => _sendPaymentReminder(payment),
                    child: Text(
                      'Remind',
                      style: TextStyle(
                        fontSize: 12,
                        color: home1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            onTap: () => _showPaymentDetails(payment),
          );
        },
      ),
    );
  }

  void _createNewPaymentLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NewPaymentLinkForm(
            home1: home1,
            secondaryColor: home2,
          ),
        );
      },
    );
  }

  void _sendPaymentLinks() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send Payment Links',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: home1,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select recipients to send payment links to:'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Payment links sent successfully'),
                          backgroundColor: successColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: home1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPaymentReminder(Payment payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to ${payment.name}'),
        backgroundColor: successColor,
      ),
    );
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: home1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                payment.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(payment.date)),
              _buildDetailRow(
                'Status',
                payment.isPaid ? 'Paid' : 'Pending',
                payment.isPaid ? successColor : Colors.red,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: home1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class Payment {
  final String name;
  final double amount;
  final DateTime date;
  final bool isPaid;

  Payment(this.name, this.amount, this.date, this.isPaid);
}

class NewPaymentLinkForm extends StatefulWidget {
  final Color home1;
  final Color secondaryColor;

  const NewPaymentLinkForm({
    super.key,
    required this.home1,
    required this.secondaryColor,
  });

  @override
  State<NewPaymentLinkForm> createState() => _NewPaymentLinkFormState();
}

class _NewPaymentLinkFormState extends State<NewPaymentLinkForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedRecipientType = 'Member';
  String? _selectedRecipient;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Payment Link',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.home1,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRecipientType,
              items: const [
                DropdownMenuItem(value: 'Member', child: Text('Member')),
                DropdownMenuItem(value: 'Group', child: Text('Group')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRecipientType = value!;
                  _selectedRecipient = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Recipient Type',
                labelStyle: TextStyle(color: widget.home1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRecipient,
              hint: const Text('Select Recipient'),
              items: _selectedRecipientType == 'Member'
                  ? ['John Doe', 'Jane Smith', 'Mike Johnson']
                  .map((name) => DropdownMenuItem(
                value: name,
                child: Text(name),
              ))
                  .toList()
                  : ['Group A', 'Group B', 'Group C']
                  .map((name) => DropdownMenuItem(
                value: name,
                child: Text(name),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRecipient = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Recipient',
                labelStyle: TextStyle(color: widget.home1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
              ),
              validator: (value) =>
              value == null ? 'Please select a recipient' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: widget.home1),
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.home1),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Payment link created successfully'),
                        backgroundColor: widget.home1,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.home1,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Payment Link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}