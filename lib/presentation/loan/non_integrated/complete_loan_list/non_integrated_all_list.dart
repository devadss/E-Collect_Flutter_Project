
import 'package:flutter/material.dart';

import 'non_integrated_detail/non_integrated_loan_detail_page.dart';

class NonIntegratedAllLoansScreen extends StatefulWidget {
const NonIntegratedAllLoansScreen({super.key});

@override
State<NonIntegratedAllLoansScreen> createState() =>
_NonIntegratedAllLoansScreenState();
}

class _NonIntegratedAllLoansScreenState
extends State<NonIntegratedAllLoansScreen> {
final List<Map<String, dynamic>> loans = [
{
'name': 'Manju',
'loanId': '903U28828',
'outstanding': '₹2,00,000',
'emi': '₹16,667',
'frequency': 'Monthly',
'dueDate': 'Jul 1, 2026',
'reminder': true,
'daysBefore': '2 days before',
'channels': 'SMS • WhatsApp • Call',
'status': 'Active',
'statusColor': Color(0xFF16A34A),
},
{
'name': 'www',
'loanId': '122221',
'outstanding': '₹12,22,222',
'emi': '₹13,580',
'frequency': 'Daily',
'dueDate': 'Aug 20, 2026',
'reminder': true,
'daysBefore': '1 day before',
'channels': 'SMS • WhatsApp • Call',
'status': 'Active',
'statusColor': Color(0xFF16A34A),
},
{
'name': 'Ravi',
'loanId': '445566',
'outstanding': '₹85,000',
'emi': '₹8,500',
'frequency': 'Monthly',
'dueDate': 'Sep 10, 2026',
'reminder': false,
'daysBefore': '2 days before',
'channels': 'SMS',
'status': 'Active',
'statusColor': Color(0xFF16A34A),
},
];

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5F7FA),

// ============================================================
// APP BAR
// ============================================================

appBar: AppBar(
backgroundColor: Colors.white,
elevation: 0,
surfaceTintColor: Colors.white,
titleSpacing: 20,
centerTitle: false,
title: const Text(
'Loans',
style: TextStyle(
color: Color(0xFF111827),
fontSize: 20,
fontWeight: FontWeight.w700,
letterSpacing: -0.3,
),
),
actions: [
_HeaderButton(
icon: Icons.search_rounded,
onTap: () {},
),
_HeaderButton(
icon: Icons.tune_rounded,
onTap: () {},
),
const SizedBox(width: 10),
],
),

// ============================================================
// BODY
// ============================================================

body: ListView(
padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
children: [
// ==========================================================
// PORTFOLIO SUMMARY
// ==========================================================

_PortfolioSummary(
loanCount: loans.length,
),

const SizedBox(height: 26),

// ==========================================================
// SECTION HEADER
// ==========================================================

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'All loans',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.2,
),
),
Text(
'${loans.length} active',
style: TextStyle(
fontSize: 12,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
),
),
],
),

const SizedBox(height: 11),

// ==========================================================
// LOANS
// ==========================================================

...loans.map(
(loan) => Padding(
padding: const EdgeInsets.only(bottom: 12),
child: LoanCard(
loan: loan,
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => NonIntegratedLoanDetailsScreen(),
),
);
},
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

class _HeaderButton extends StatelessWidget {
final IconData icon;
final VoidCallback onTap;

const _HeaderButton({
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
size: 21,
color: const Color(0xFF374151),
),
);
}
}

// ======================================================================
// PORTFOLIO SUMMARY
// ======================================================================

class _PortfolioSummary extends StatelessWidget {
final int loanCount;

const _PortfolioSummary({
required this.loanCount,
});

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
Icons.account_balance_outlined,
color: Colors.white,
size: 17,
),
),
const SizedBox(width: 10),
const Text(
'Loan portfolio',
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
'₹15,07,222',
style: TextStyle(
color: Colors.white,
fontSize: 30,
fontWeight: FontWeight.w700,
letterSpacing: -1,
),
),

const SizedBox(height: 4),

const Text(
'Total outstanding',
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
child: _PortfolioMetric(
value: '$loanCount',
label: 'Active loans',
),
),
Container(
width: 1,
height: 30,
color: Colors.white.withOpacity(0.08),
),
Expanded(
child: _PortfolioMetric(
value: '₹38,747',
label: 'Total EMI',
),
),
],
),
],
),
);
}
}

class _PortfolioMetric extends StatelessWidget {
final String value;
final String label;

const _PortfolioMetric({
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
// LOAN CARD
// ======================================================================

class LoanCard extends StatelessWidget {
final Map<String, dynamic> loan;
final VoidCallback? onTap;

const LoanCard({
super.key,
required this.loan,
this.onTap,
});

@override
Widget build(BuildContext context) {
final Color statusColor = loan['statusColor'];

return Material(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(16),
child: Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
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
_CustomerAvatar(
name: loan['name'],
color: statusColor,
),

const SizedBox(width: 11),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
loan['name'],
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
),
),
const SizedBox(height: 3),
Text(
'Loan • ${loan['loanId']}',
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
),
),
],
),
),

_StatusChip(
label: loan['status'],
color: statusColor,
),

const SizedBox(width: 5),

const Icon(
Icons.chevron_right_rounded,
size: 20,
color: Color(0xFF9CA3AF),
),
],
),

const SizedBox(height: 18),

// ========================================================
// OUTSTANDING
// ========================================================

const Text(
'OUTSTANDING',
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.w600,
color: Color(0xFF9CA3AF),
letterSpacing: 0.7,
),
),

const SizedBox(height: 4),

Text(
loan['outstanding'],
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
letterSpacing: -0.5,
),
),

const SizedBox(height: 17),

// ========================================================
// EMI INFORMATION
// ========================================================

Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: const Color(0xFFF9FAFB),
borderRadius: BorderRadius.circular(10),
),
child: Row(
children: [
Expanded(
child: _LoanMetric(
label: 'EMI',
value: loan['emi'],
),
),
Container(
width: 1,
height: 30,
color: const Color(0xFFE5E7EB),
),
Expanded(
child: _LoanMetric(
label: 'Frequency',
value: loan['frequency'],
),
),
Container(
width: 1,
height: 30,
color: const Color(0xFFE5E7EB),
),
Expanded(
child: _LoanMetric(
label: 'Due date',
value: loan['dueDate'],
),
),
],
),
),

const SizedBox(height: 14),

// ========================================================
// REMINDER
// ========================================================

Row(
children: [
Container(
width: 30,
height: 30,
decoration: BoxDecoration(
color: loan['reminder']
? const Color(0xFFFFF7ED)
    : const Color(0xFFF3F4F6),
borderRadius: BorderRadius.circular(8),
),
child: Icon(
loan['reminder']
? Icons.notifications_active_outlined
    : Icons.notifications_off_outlined,
size: 16,
color: loan['reminder']
? const Color(0xFFF59E0B)
    : const Color(0xFF9CA3AF),
),
),

const SizedBox(width: 9),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
loan['reminder']
? 'Payment reminder enabled'
    : 'Payment reminder disabled',
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
color: loan['reminder']
? const Color(0xFF374151)
    : const Color(0xFF6B7280),
),
),
if (loan['reminder']) ...[
const SizedBox(height: 2),
Text(
'${loan['daysBefore']} • ${loan['channels']}',
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 10,
color: Colors.grey.shade500,
),
),
],
],
),
),

const Icon(
Icons.chevron_right_rounded,
size: 18,
color: Color(0xFFD1D5DB),
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

// ======================================================================
// CUSTOMER AVATAR
// ======================================================================

class _CustomerAvatar extends StatelessWidget {
final String name;
final Color color;

const _CustomerAvatar({
required this.name,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: color.withOpacity(0.10),
shape: BoxShape.circle,
),
alignment: Alignment.center,
child: Text(
name.isNotEmpty ? name[0].toUpperCase() : '?',
style: TextStyle(
color: color,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
);
}
}

// ======================================================================
// STATUS CHIP
// ======================================================================

class _StatusChip extends StatelessWidget {
final String label;
final Color color;

const _StatusChip({
required this.label,
required this.color,
});

@override
Widget build(BuildContext context) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 5,
),
decoration: BoxDecoration(
color: color.withOpacity(0.09),
borderRadius: BorderRadius.circular(7),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 5,
height: 5,
decoration: BoxDecoration(
color: color,
shape: BoxShape.circle,
),
),
const SizedBox(width: 5),
Text(
label,
style: TextStyle(
color: color,
fontSize: 10,
fontWeight: FontWeight.w700,
),
),
],
),
);
}
}

// ======================================================================
// LOAN METRIC
// ======================================================================

class _LoanMetric extends StatelessWidget {
final String label;
final String value;

const _LoanMetric({
required this.label,
required this.value,
});

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 8),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
label,
style: TextStyle(
fontSize: 9,
color: Colors.grey.shade500,
fontWeight: FontWeight.w500,
),
),
const SizedBox(height: 4),
Text(
value,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 11,
color: Color(0xFF374151),
fontWeight: FontWeight.w700,
),
),
],
),
);
}
}

