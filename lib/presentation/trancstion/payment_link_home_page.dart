// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../core/colors.dart';
//
// class PaymentLinkHomePage extends StatefulWidget {
//   const PaymentLinkHomePage({super.key});
//
//   @override
//   State<PaymentLinkHomePage> createState() => _PaymentLinkHomePageState();
// }
//
// class _PaymentLinkHomePageState extends State<PaymentLinkHomePage> {
//   // Sample data - replace with your actual data source
//   final List<Payment> receivedPayments = [
//     Payment('John Doe', 150.00, DateTime.now().subtract(const Duration(days: 2)), true),
//     Payment('Jane Smith', 200.00, DateTime.now().subtract(const Duration(days: 5)), true),
//     Payment('Group A', 350.00, DateTime.now().subtract(const Duration(days: 10)), true),
//     Payment('Mike Johnson', 100.00, DateTime.now().subtract(const Duration(days: 15)), true),
//   ];
//
//   final List<Payment> duePayments = [
//     Payment('Sarah Williams', 180.00, DateTime.now().add(const Duration(days: 5)), false),
//     Payment('Group B', 420.00, DateTime.now().add(const Duration(days: 7)), false),
//     Payment('David Brown', 90.00, DateTime.now().add(const Duration(days: 3)), false),
//   ];
//
//   // Theme colors
// // Home 1 secondary
//   final Color successColor = const Color(0xFF00B894); // Home 2 success
//   final Color warningColor = const Color(0xFFFDCB6E); // Home 2 warning
//   final Color backgroundColor = const Color(0xFFF5F6FA); // Light background
//
//   @override
//   Widget build(BuildContext context) {
//     double totalReceived = receivedPayments.fold(0, (sum, payment) => sum + payment.amount);
//     double totalDue = duePayments.fold(0, (sum, payment) => sum + payment.amount);
//
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: const Text('Payment Links', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: white,
//         elevation: 0,
//         centerTitle: true,
//
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Summary Cards
//             Row(
//               children: [
//                 _buildSummaryCard(
//                   'Received',
//                   totalReceived,
//                   successColor,
//                   Icons.check_circle,
//                 ),
//                 const SizedBox(width: 16),
//                 _buildSummaryCard(
//                   'Due',
//                   totalDue,
//                   warningColor,
//                   Icons.pending_actions,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Received Payments Section
//             _buildSectionHeader('Received Payments', receivedPayments.length),
//             const SizedBox(height: 8),
//             _buildPaymentsList(receivedPayments, true),
//             const SizedBox(height: 24),
//
//             // Due Payments Section
//             _buildSectionHeader('Due Payments', duePayments.length),
//             const SizedBox(height: 8),
//             _buildPaymentsList(duePayments, false),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _createNewPaymentLink,
//         backgroundColor: home1,
//         child: const Icon(Icons.add, color: Colors.white),
//         tooltip: 'Create Payment Link',
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, color: color, size: 20),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 '\$${amount.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Total amount',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, int count) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: home1,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: home1.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               count.toString(),
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: home1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentsList(List<Payment> payments, bool isReceived) {
//     if (payments.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Text(
//             'No payments found',
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: payments.length,
//         separatorBuilder: (context, index) => Divider(
//           height: 1,
//           indent: 16,
//           endIndent: 16,
//           color: Colors.grey[200],
//         ),
//         itemBuilder: (context, index) {
//           final payment = payments[index];
//           return ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             leading: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: isReceived
//                     ? successColor.withOpacity(0.2)
//                     : warningColor.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   payment.name[0],
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isReceived ? successColor : warningColor,
//                   ),
//                 ),
//               ),
//             ),
//             title: Text(
//               payment.name,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//             subtitle: Text(
//               DateFormat('MMM dd, yyyy').format(payment.date),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '\$${payment.amount.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                     color: isReceived ? successColor : warningColor,
//                   ),
//                 ),
//                 if (!isReceived)
//                   TextButton(
//                     onPressed: () => _sendPaymentReminder(payment),
//                     child: const Text(
//                       'Remind',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: home1,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                   ),
//               ],
//             ),
//             onTap: () => _showPaymentDetails(payment),
//           );
//         },
//       ),
//     );
//   }
//
//   void _createNewPaymentLink() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: const NewPaymentLinkForm(
//             home1: home1,
//             home2: home2,
//           ),
//         );
//       },
//     );
//   }
//
//   void _sendPaymentLinks() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Send Payment Links',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: home1,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text('Select recipients to send payment links to:'),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: const Text('Payment links sent successfully'),
//                           backgroundColor: successColor,
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: home1,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('Send'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _sendPaymentReminder(Payment payment) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Reminder sent to ${payment.name}'),
//         backgroundColor: successColor,
//       ),
//     );
//   }
//
//   void _showPaymentDetails(Payment payment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 30,
//                 spreadRadius: 0,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header with gradient
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [home1, home2],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(24),
//                     topRight: Radius.circular(24),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     // Status indicator with icon
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         payment.isPaid ? Icons.check_circle : Icons.pending,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       payment.isPaid ? 'Payment Received' : 'Payment Pending',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       payment.name,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Content area
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     // Amount with large display
//                     Text(
//                       '\$${payment.amount.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.w800,
//                         color: home1,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Details in cards
//                     _buildDetailCard(
//                       icon: Icons.calendar_today,
//                       title: 'Date',
//                       value: DateFormat('MMM dd, yyyy').format(payment.date),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildDetailCard(
//                       icon: Icons.account_circle,
//                       title: 'Recipient',
//                       value: payment.name,
//                     ),
//                     const SizedBox(height: 12),
//                     _buildDetailCard(
//                       icon: payment.isPaid ? Icons.verified : Icons.pending_actions,
//                       title: 'Status',
//                       value: payment.isPaid ? 'Paid' : 'Pending',
//                       valueColor: payment.isPaid ? successColor : warningColor,
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // Action buttons - Conditional based on payment status
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               side: BorderSide(color: home1.withOpacity(0.3)),
//                             ),
//                             child: const Text(
//                               'Close',
//                               style: TextStyle(
//                                 color: home1,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               if (payment.isPaid) {
//                                 _sharePaymentDetails(payment);
//                               } else {
//                                 _sendPaymentReminder(payment);
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: payment.isPaid ? home1 : warningColor,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               payment.isPaid ? 'Share' : 'Remind',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     Color? valueColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey[100]!,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: home1.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: home1,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: valueColor ?? Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sharePaymentDetails(Payment payment) {
//     // Implementation for sharing payment details
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sharing payment details for ${payment.name}'),
//         backgroundColor: home1,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
//
//   // void _showPaymentDetails(Payment payment) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => Dialog(
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(16),
//   //       ),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             const Text(
//   //               'Payment Details',
//   //               style: TextStyle(
//   //                 fontSize: 18,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: home1,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 8),
//   //             Text(
//   //               payment.name,
//   //               style: const TextStyle(
//   //                 fontSize: 16,
//   //                 fontWeight: FontWeight.w600,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 16),
//   //             _buildDetailRow('Amount', '\$${payment.amount.toStringAsFixed(2)}'),
//   //             _buildDetailRow('Date', DateFormat('MMM dd, yyyy').format(payment.date)),
//   //             _buildDetailRow(
//   //               'Status',
//   //               payment.isPaid ? 'Paid' : 'Pending',
//   //               payment.isPaid ? successColor : Colors.red,
//   //             ),
//   //             const SizedBox(height: 24),
//   //             Center(
//   //               child: ElevatedButton(
//   //                 onPressed: () => Navigator.pop(context),
//   //                 style: ElevatedButton.styleFrom(
//   //                   foregroundColor: Colors.white,
//   //                   backgroundColor: home1,
//   //                   shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(12),
//   //                   ),
//   //                 ),
//   //                 child: const Text('Close'),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor ?? Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Payment {
//   final String name;
//   final double amount;
//   final DateTime date;
//   final bool isPaid;
//
//   Payment(this.name, this.amount, this.date, this.isPaid);
// }
//
// class NewPaymentLinkForm extends StatefulWidget {
//   final Color home1;
//   final Color home2;
//
//   const NewPaymentLinkForm({
//     super.key,
//     required this.home1,
//     required this.home2,
//   });
//
//   @override
//   State<NewPaymentLinkForm> createState() => _NewPaymentLinkFormState();
// }
//
// class _NewPaymentLinkFormState extends State<NewPaymentLinkForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountController = TextEditingController();
//   String _selectedRecipientType = 'Member';
//   String? _selectedRecipient;
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Create New Payment Link',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: widget.home1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _selectedRecipientType,
//               items: const [
//                 DropdownMenuItem(value: 'Member', child: Text('Member')),
//                 DropdownMenuItem(value: 'Group', child: Text('Group')),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedRecipientType = value!;
//                   _selectedRecipient = null;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Recipient Type',
//                 labelStyle: TextStyle(color: widget.home1),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _selectedRecipient,
//               hint: const Text('Select Recipient'),
//               items: _selectedRecipientType == 'Member'
//                   ? ['John Doe', 'Jane Smith', 'Mike Johnson']
//                   .map((name) => DropdownMenuItem(
//                 value: name,
//                 child: Text(name),
//               ))
//                   .toList()
//                   : ['Group A', 'Group B', 'Group C']
//                   .map((name) => DropdownMenuItem(
//                 value: name,
//                 child: Text(name),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedRecipient = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Recipient',
//                 labelStyle: TextStyle(color: widget.home1),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//               ),
//               validator: (value) =>
//               value == null ? 'Please select a recipient' : null,
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Amount',
//                 labelStyle: TextStyle(color: widget.home1),
//                 prefixText: '\$ ',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: widget.home1),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter an amount';
//                 }
//                 if (double.tryParse(value) == null) {
//                   return 'Please enter a valid number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text('Payment link created successfully'),
//                         backgroundColor: widget.home1,
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.home1,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Create Payment Link',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:lottie/lottie.dart';
import '../../core/colors.dart';

const Color successColor = Color(0xFF00B894);
const Color warningColor = amber;
const Color backgroundColor = white;
const Color cardColor = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);

class PaymentLinkHomePage extends StatefulWidget {
  const PaymentLinkHomePage({super.key});

  @override
  State<PaymentLinkHomePage> createState() => _PaymentLinkHomePageState();
}

class _PaymentLinkHomePageState extends State<PaymentLinkHomePage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  final List<Payment> receivedPayments = [
    Payment('John Doe', 150.00,
        DateTime.now().subtract(const Duration(days: 2)), true),
    Payment('Jane Smith', 200.00,
        DateTime.now().subtract(const Duration(days: 5)), true),
    Payment('Group A', 350.00,
        DateTime.now().subtract(const Duration(days: 10)), true),
    Payment('Mike Johnson', 100.00,
        DateTime.now().subtract(const Duration(days: 15)), true),
  ];

  final List<Payment> duePayments = [
    Payment('Sarah Williams', 180.00,
        DateTime.now().add(const Duration(days: 5)), false),
    Payment(
        'Group B', 420.00, DateTime.now().add(const Duration(days: 7)), false),
    Payment('David Brown', 90.00, DateTime.now().add(const Duration(days: 3)),
        false),
  ];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
      _fadeController.forward();
    });

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalReceived =
        receivedPayments.fold(0, (sum, payment) => sum + payment.amount);
    double totalDue =
        duePayments.fold(0, (sum, payment) => sum + payment.amount);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: _buildAppBar(),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _buildWelcomeHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildSummaryCards(totalReceived, totalDue),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                  'Received Payments', receivedPayments.length),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _buildPaymentsList(receivedPayments, true),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: _buildSectionHeader('Due Payments', duePayments.length),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _buildPaymentsList(duePayments, false),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        floatingActionButton: _buildAnimatedFAB(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: const Text('Payment Links',
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textPrimary,
              fontSize: 24,
              letterSpacing: -0.5)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Badge(
            backgroundColor: home1,
            smallSize: 8,
            child: Icon(Iconsax.notification, color: textPrimary, size: 24),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Transform.translate(
      offset: Offset(0, _scrollOffset * 0.4),
      child: Opacity(
        opacity: (1 - _scrollOffset / 150).clamp(0.4, 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeController,
                child: const Text(
                  'Welcome back, Alex!',
                  style: TextStyle(
                    fontSize: 16,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FadeTransition(
                opacity: _fadeController,
                child: const Text(
                  'Manage your payment links seamlessly',
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double totalReceived, double totalDue) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
                child: _buildSummaryCard(
              'Received',
              totalReceived,
              successColor,
              Iconsax.tick_circle,
              const [Color(0xFF00B894), Color(0xFF00C6A7)],
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildSummaryCard(
              'Due',
              totalDue,
              warningColor,
              Iconsax.clock,
              const [Color(0xFFFDCB6E), Color(0xFFFFD180)],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color,
      IconData icon, List<Color> gradientColors) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 50),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                tween: Tween(begin: 0.0, end: amount),
                builder: (context, value, child) {
                  return Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: title == "Due Payments" ? errorColor : textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [home1.withOpacity(0.8), home2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsList(List<Payment> payments, bool isReceived) {
    if (payments.isEmpty) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/empty.json',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 16),
              Text(
                'No payments found',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: black),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: payments.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: black87,
            ),
            itemBuilder: (context, index) {
              return AnimatedPaymentListItem(
                payment: payments[index],
                isReceived: isReceived,
                index: index,
                onTap: () => _showPaymentDetails(payments[index]),
                onRemind: () => _sendPaymentReminder(payments[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 100),
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: _createNewPaymentLink,
        backgroundColor: home1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Iconsax.add, color: Colors.white, size: 28),
        elevation: 8,
      ),
    );
  }

  void _createNewPaymentLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          decoration: const BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const NewPaymentLinkForm(
            home1: home1,
            home2: home2,
          ),
        );
      },
    );
  }

  void _sendPaymentReminder(Payment payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to ${payment.name}'),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: AnimatedPaymentDetailsDialog(payment: payment),
      ),
    );
  }
}

class AnimatedPaymentListItem extends StatefulWidget {
  final Payment payment;
  final bool isReceived;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRemind;

  const AnimatedPaymentListItem({
    super.key,
    required this.payment,
    required this.isReceived,
    required this.index,
    required this.onTap,
    required this.onRemind,
  });

  @override
  State<AnimatedPaymentListItem> createState() =>
      _AnimatedPaymentListItemState();
}

class _AnimatedPaymentListItemState extends State<AnimatedPaymentListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.index * 150)),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.5, 0.0),
            end: Offset.zero,
          ).animate(_animation),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.isReceived
                            ? [
                                successColor.withOpacity(0.2),
                                successColor.withOpacity(0.1)
                              ]
                            : [
                                warningColor.withOpacity(0.2),
                                warningColor.withOpacity(0.1)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.isReceived
                            ? successColor.withOpacity(0.3)
                            : warningColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.payment.name[0],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color:
                              widget.isReceived ? successColor : warningColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.payment.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy')
                              .format(widget.payment.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${widget.payment.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color:
                              widget.isReceived ? successColor : warningColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (!widget.isReceived)
                        TextButton(
                          onPressed: widget.onRemind,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'Remind',
                            style: TextStyle(
                              fontSize: 12,
                              color: home1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Keep Payment and NewPaymentLinkForm classes as before, but update NewPaymentLinkForm with modern styling

class AnimatedPaymentDetailsDialog extends StatefulWidget {
  final Payment payment;

  const AnimatedPaymentDetailsDialog({super.key, required this.payment});

  @override
  State<AnimatedPaymentDetailsDialog> createState() =>
      _AnimatedPaymentDetailsDialogState();
}

class _AnimatedPaymentDetailsDialogState
    extends State<AnimatedPaymentDetailsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [home1, home2],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Status indicator with icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.payment.isPaid
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.payment.isPaid
                          ? 'Payment Received'
                          : 'Payment Pending',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.payment.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content area
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Amount with large display
                    Text(
                      '\$${widget.payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: home1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Details in cards
                    _buildDetailCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'Date',
                      value: DateFormat('MMM dd, yyyy')
                          .format(widget.payment.date),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: Icons.account_circle_rounded,
                      title: 'Recipient',
                      value: widget.payment.name,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: widget.payment.isPaid
                          ? Icons.verified_rounded
                          : Icons.pending_actions_rounded,
                      title: 'Status',
                      value: widget.payment.isPaid ? 'Paid' : 'Pending',
                      valueColor:
                          widget.payment.isPaid ? successColor : warningColor,
                    ),

                    const SizedBox(height: 24),

                    // Action buttons - Conditional based on payment status
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: home1.withOpacity(0.3)),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: home1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (widget.payment.isPaid) {
                                // Share functionality
                              } else {
                                // Remind functionality
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  widget.payment.isPaid ? home1 : warningColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.payment.isPaid ? 'Share' : 'Remind',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: home1.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: home1,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? textPrimary,
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

class Payment {
  final String name;
  final double amount;
  final DateTime date;
  final bool isPaid;

  Payment(this.name, this.amount, this.date, this.isPaid);
}

class NewPaymentLinkForm extends StatefulWidget {
  final Color home1;
  final Color home2;

  const NewPaymentLinkForm({
    super.key,
    required this.home1,
    required this.home2,
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
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Payment Link',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: widget.home1,
              ),
            ),
            const SizedBox(height: 24),
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
                        content:
                            const Text('Payment link created successfully'),
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: white, fontSize: 15),
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

/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../../core/colors.dart';

// Color scheme

const Color successColor = Color(0xFF00B894); // Green
const Color warningColor = Color(0xFFFDCB6E); // Yellow
const Color backgroundColor = Color(0xFFF8F9FA); // Light background
const Color cardColor = Color(0xFFFFFFFF); // White
const Color textPrimary = Color(0xFF2D3436); // Dark gray
const Color textSecondary = Color(0xFF636E72); // Medium gray

class PaymentLinkHomePage extends StatefulWidget {
  const PaymentLinkHomePage({super.key});

  @override
  State<PaymentLinkHomePage> createState() => _PaymentLinkHomePageState();
}

class _PaymentLinkHomePageState extends State<PaymentLinkHomePage> {
  // Sample data
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

  @override
  Widget build(BuildContext context) {
    double totalReceived = receivedPayments.fold(0, (sum, payment) => sum + payment.amount);
    double totalDue = duePayments.fold(0, (sum, payment) => sum + payment.amount);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text('Payment Links',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  fontSize: 24
              )
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              const Text(
                'Hello, Alex!',
                style: TextStyle(
                  fontSize: 18,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your payment links',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              Row(
                children: [
                  _buildSummaryCard(
                    'Received',
                    totalReceived,
                    successColor,
                    Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 16),
                  _buildSummaryCard(
                    'Due',
                    totalDue,
                    warningColor,
                    Icons.pending_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Received Payments Section
              _buildSectionHeader('Received Payments', receivedPayments.length),
              const SizedBox(height: 16),
              _buildPaymentsList(receivedPayments, true),
              const SizedBox(height: 32),

              // Due Payments Section
              _buildSectionHeader('Due Payments', duePayments.length),
              const SizedBox(height: 16),
              _buildPaymentsList(duePayments, false),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNewPaymentLink,
          backgroundColor: home1,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: home1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: home1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsList(List<Payment> payments, bool isReceived) {
    if (payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.payments_rounded,
                size: 48,
                color: textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No payments found',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: payments.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey[100],
        ),
        itemBuilder: (context, index) {
          final payment = payments[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isReceived
                      ? [successColor.withOpacity(0.2), successColor.withOpacity(0.1)]
                      : [warningColor.withOpacity(0.2), warningColor.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  payment.name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: isReceived ? successColor : warningColor,
                  ),
                ),
              ),
            ),
            title: Text(
              payment.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              DateFormat('MMM dd, yyyy').format(payment.date),
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${payment.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isReceived ? successColor : warningColor,
                  ),
                ),
                if (!isReceived)
                  TextButton(
                    onPressed: () => _sendPaymentReminder(payment),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Remind',
                      style: TextStyle(
                        fontSize: 13,
                        color: home1,
                        fontWeight: FontWeight.w700,
                      ),
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
          decoration: const BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const NewPaymentLinkForm(
            home1: home1,
            home2: home2,
          ),
        );
      },
    );
  }

  void _sendPaymentReminder(Payment payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to ${payment.name}'),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [home1, home2],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Status indicator with icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        payment.isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      payment.isPaid ? 'Payment Received' : 'Payment Pending',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      payment.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content area
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Amount with large display
                    Text(
                      '\$${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: home1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Details in cards
                    _buildDetailCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'Date',
                      value: DateFormat('MMM dd, yyyy').format(payment.date),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: Icons.account_circle_rounded,
                      title: 'Recipient',
                      value: payment.name,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: payment.isPaid ? Icons.verified_rounded : Icons.pending_actions_rounded,
                      title: 'Status',
                      value: payment.isPaid ? 'Paid' : 'Pending',
                      valueColor: payment.isPaid ? successColor : warningColor,
                    ),

                    const SizedBox(height: 24),

                    // Action buttons - Conditional based on payment status
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: home1.withOpacity(0.3)),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: home1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (payment.isPaid) {
                                _sharePaymentDetails(payment);
                              } else {
                                _sendPaymentReminder(payment);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: payment.isPaid ? home1 : warningColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              payment.isPaid ? 'Share' : 'Remind',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: home1.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: home1,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sharePaymentDetails(Payment payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing payment details for ${payment.name}'),
        backgroundColor: home1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
  final Color home2;

  const NewPaymentLinkForm({
    super.key,
    required this.home1,
    required this.home2,
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
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Payment Link',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: widget.home1,
              ),
            ),
            const SizedBox(height: 24),
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
}*/
