
import 'package:flutter/material.dart';

class NonIntegratedLoanDuePaymentsScreen extends StatefulWidget {
const NonIntegratedLoanDuePaymentsScreen({super.key});

@override
State<NonIntegratedLoanDuePaymentsScreen> createState() =>
_NonIntegratedLoanDuePaymentsScreenState();
}

class _NonIntegratedLoanDuePaymentsScreenState
extends State<NonIntegratedLoanDuePaymentsScreen> {
final List<Map<String, dynamic>> buckets = [
{
'title': 'Current',
'subtitle': 'On time',
'customers': '2 customers',
'amount': '₹67,19,405',
'color': const Color(0xFF16A34A),
},
{
'title': '1–30',
'subtitle': 'DPD',
'customers': '2 customers',
'amount': '₹13,613',
'color': const Color(0xFFF59E0B),
},
{
'title': '61–90',
'subtitle': 'DPD',
'customers': '1 customer',
'amount': '₹16,667',
'color': const Color(0xFFDC2626),
},
];

final List<Map<String, dynamic>> customers = [
{
'name': 'Manju',
'account': '903U28828',
'amount': '₹16,667',
'overdue': '65 days overdue',
'status': 'SMA-2',
'statusLabel': '61–90 DPD',
'color': const Color(0xFFDC2626),
'initial': 'M',
},
{
'name': 'www',
'account': '122221',
'amount': '₹13,580',
'overdue': '15 days overdue',
'status': 'SMA-0',
'statusLabel': '1–30 DPD',
'color': const Color(0xFFF59E0B),
'initial': 'W',
},
];

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5F7FA),
appBar: AppBar(
backgroundColor: Colors.white,
elevation: 0,
surfaceTintColor: Colors.white,
centerTitle: false,
titleSpacing: 20,
title: const Text(
'Due Payments',
style: TextStyle(
color: Color(0xFF111827),
fontSize: 20,
fontWeight: FontWeight.w700,
letterSpacing: -0.3,
),
),
actions: [
_HeaderIconButton(
icon: Icons.search_rounded,
onTap: () {},
),
const SizedBox(width: 4),
_HeaderIconButton(
icon: Icons.tune_rounded,
onTap: () {},
),
const SizedBox(width: 12),
],
),
body: ListView(
padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
children: [
// ============================================================
// SUMMARY CARD
// ============================================================

_CollectionSummaryCard(),

const SizedBox(height: 24),

// ============================================================
// BUCKET HEADER
// ============================================================

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Payment ageing',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.2,
),
),
Text(
'3 buckets',
style: TextStyle(
fontSize: 12,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
),
),
],
),

const SizedBox(height: 12),

// ============================================================
// BUCKETS
// ============================================================

SizedBox(
height: 132,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: buckets.length,
separatorBuilder: (_, __) => const SizedBox(width: 10),
itemBuilder: (context, index) {
return DpdBucketCard(
bucket: buckets[index],
);
},
),
),

const SizedBox(height: 28),

// ============================================================
// CUSTOMER HEADER
// ============================================================

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Customers',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.2,
),
),
TextButton(
onPressed: () {},
style: TextButton.styleFrom(
padding: EdgeInsets.zero,
minimumSize: Size.zero,
tapTargetSize: MaterialTapTargetSize.shrinkWrap,
),
child: const Text(
'View all',
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
),
),
),
],
),

const SizedBox(height: 10),

// ============================================================
// CUSTOMER CARDS
// ============================================================

...customers.map(
(customer) => Padding(
padding: const EdgeInsets.only(bottom: 12),
child: DueCustomerCard(
customer: customer,
onTap: () {},
),
),
),
],
),
);
}
}

// ======================================================================
// HEADER BUTTON
// ======================================================================

class _HeaderIconButton extends StatelessWidget {
final IconData icon;
final VoidCallback onTap;

const _HeaderIconButton({
required this.icon,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return IconButton(
onPressed: onTap,
splashRadius: 22,
icon: Icon(
icon,
size: 22,
color: const Color(0xFF374151),
),
);
}
}

// ======================================================================
// COLLECTION SUMMARY
// ======================================================================

class _CollectionSummaryCard extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: const Color(0xFF111827),
borderRadius: BorderRadius.circular(18),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 32,
height: 32,
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.10),
borderRadius: BorderRadius.circular(9),
),
child: const Icon(
Icons.account_balance_wallet_outlined,
color: Colors.white,
size: 17,
),
),
const SizedBox(width: 10),
const Text(
'Outstanding collections',
style: TextStyle(
color: Color(0xFFD1D5DB),
fontSize: 13,
fontWeight: FontWeight.w500,
),
),
],
),

const SizedBox(height: 18),

const Text(
'₹67,49,685',
style: TextStyle(
color: Colors.white,
fontSize: 30,
fontWeight: FontWeight.w700,
letterSpacing: -1,
),
),

const SizedBox(height: 5),

const Text(
'Total amount to collect',
style: TextStyle(
color: Color(0xFF9CA3AF),
fontSize: 12,
),
),

const SizedBox(height: 20),

Container(
height: 1,
color: Colors.white.withOpacity(0.08),
),

const SizedBox(height: 16),

Row(
children: [
Expanded(
child: _SummaryMetric(
value: '5',
label: 'Customers due',
),
),
Container(
width: 1,
height: 30,
color: Colors.white.withOpacity(0.08),
),
Expanded(
child: _SummaryMetric(
value: '₹30,280',
label: 'Overdue',
),
),
],
),
],
),
);
}
}

class _SummaryMetric extends StatelessWidget {
final String value;
final String label;

const _SummaryMetric({
required this.value,
required this.label,
});

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 10),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
value,
style: const TextStyle(
color: Colors.white,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
const SizedBox(height: 3),
Text(
label,
style: const TextStyle(
color: Color(0xFF9CA3AF),
fontSize: 11,
),
),
],
),
);
}
}

// ======================================================================
// DPD BUCKET CARD
// ======================================================================

class DpdBucketCard extends StatelessWidget {
final Map<String, dynamic> bucket;

const DpdBucketCard({
super.key,
required this.bucket,
});

@override
Widget build(BuildContext context) {
final Color color = bucket['color'];

return Container(
width: 158,
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(15),
border: Border.all(
color: const Color(0xFFE5E7EB),
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 8,
height: 8,
decoration: BoxDecoration(
color: color,
shape: BoxShape.circle,
),
),
const SizedBox(width: 7),
Text(
bucket['title'],
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
),
),
const SizedBox(width: 4),
Expanded(
child: Text(
bucket['subtitle'],
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
fontWeight: FontWeight.w500,
),
),
),
],
),

const Spacer(),

Text(
bucket['amount'],
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.2,
),
),

const SizedBox(height: 4),

Text(
bucket['customers'],
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
),
),
],
),
);
}
}

// ======================================================================
// CUSTOMER CARD
// ======================================================================

class DueCustomerCard extends StatelessWidget {
final Map<String, dynamic> customer;
final VoidCallback? onTap;

const DueCustomerCard({
super.key,
required this.customer,
this.onTap,
});

@override
Widget build(BuildContext context) {
final Color color = customer['color'];

return Material(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(16),
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: const Color(0xFFE5E7EB),
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// ========================================================
// CUSTOMER HEADER
// ========================================================

Row(
children: [
Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: color.withOpacity(0.10),
shape: BoxShape.circle,
),
alignment: Alignment.center,
child: Text(
customer['initial'],
style: TextStyle(
color: color,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
),

const SizedBox(width: 11),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
customer['name'],
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
),
),
const SizedBox(height: 3),
Text(
'Loan • ${customer['account']}',
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
),
),
],
),
),

Container(
padding: const EdgeInsets.symmetric(
horizontal: 9,
vertical: 5,
),
decoration: BoxDecoration(
color: color.withOpacity(0.09),
borderRadius: BorderRadius.circular(7),
),
child: Text(
customer['status'],
style: TextStyle(
color: color,
fontSize: 10,
fontWeight: FontWeight.w700,
),
),
),
],
),

const SizedBox(height: 18),

// ========================================================
// AMOUNT
// ========================================================

Row(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'AMOUNT DUE',
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.w600,
color: Colors.grey.shade500,
letterSpacing: 0.7,
),
),
const SizedBox(height: 4),
Text(
customer['amount'],
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.4,
),
),
],
),
),
Text(
customer['overdue'],
style: TextStyle(
fontSize: 11,
color: color,
fontWeight: FontWeight.w600,
),
),
],
),

const SizedBox(height: 16),

// ========================================================
// STATUS
// ========================================================

Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 11,
vertical: 9,
),
decoration: BoxDecoration(
color: const Color(0xFFF9FAFB),
borderRadius: BorderRadius.circular(9),
),
child: Row(
children: [
Icon(
Icons.schedule_rounded,
size: 14,
color: color,
),
const SizedBox(width: 7),
Text(
customer['statusLabel'],
style: const TextStyle(
fontSize: 11,
color: Color(0xFF4B5563),
fontWeight: FontWeight.w500,
),
),
const Spacer(),
const Icon(
Icons.chevron_right_rounded,
size: 17,
color: Color(0xFF9CA3AF),
),
],
),
),

const SizedBox(height: 14),

// ========================================================
// ACTIONS
// ========================================================

Row(
children: [
Expanded(
child: SizedBox(
height: 42,
child: OutlinedButton.icon(
onPressed: () {},
icon: const Icon(
Icons.phone_outlined,
size: 16,
),
label: const Text(
'Call',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),
style: OutlinedButton.styleFrom(
foregroundColor: const Color(0xFF374151),
side: const BorderSide(
color: Color(0xFFE5E7EB),
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
),
),
),

const SizedBox(width: 9),

Expanded(
child: SizedBox(
height: 42,
child: OutlinedButton.icon(
onPressed: () {},
icon: const Icon(
Icons.chat_bubble_outline_rounded,
size: 16,
),
label: const Text(
'WhatsApp',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),
style: OutlinedButton.styleFrom(
foregroundColor: const Color(0xFF374151),
side: const BorderSide(
color: Color(0xFFE5E7EB),
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
),
),
),

const SizedBox(width: 9),

SizedBox(
height: 42,
width: 46,
child: IconButton(
onPressed: onTap,
style: IconButton.styleFrom(
backgroundColor: const Color(0xFF111827),
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
icon: const Icon(
Icons.arrow_forward_rounded,
size: 18,
),
),
),
],
),
],
),
),
),
);
}
}

