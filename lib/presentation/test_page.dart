import 'package:collection_qr_flutter/presentation/profile/profile_home_page.dart';
import 'package:flutter/material.dart';

import '../core/colors.dart';
import 'account_dues/account_list_home_page.dart';
import 'account_dues/rdcl_cust_list_bloc/customer _list.dart';
import 'dues/rdcl_due_list_bloc_page.dart';
import 'home/home_page.dart';
import 'merchant/pages/all-groups.dart';
import 'merchant/pages/group_home_page.dart';
import 'merchant/pages/payment_link_page.dart';
import 'merchant/pages/settlement_page.dart';

// import 'package:flutter/material.dart';
//
// class PaymentSuccessScreen extends StatefulWidget {
//   const PaymentSuccessScreen({super.key});
//
//   @override
//   State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
// }
//
// class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('', style: TextStyle(color: Colors.white),),
//
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 1.0),
//             child: Image.asset(
//               'assets/images/b_assured logo.png',
//               height: 50,
//               width: 80,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//
//           CircleAvatar(
//             radius: 65,
//             backgroundColor: Colors.white,
//            // child: Image.asset("assets/images/check.png", width: 150, height: 150,),
//             child: Icon(Icons.check_circle, color: Colors.green,size: 100,),
//           ),
//           const Text(
//             "Payment Successful",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//           Center(child: Text("Your bill payment has been processed successfully.")),
//           SizedBox(height: 20,),
//           Text("B-Connect Transaction ID", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w700),),
//           Text("CC015334BAAG00034083"),
//           SizedBox(height: 20,),
//           Text("Amount Paid",style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w700),),
//           Text("₹7,0,700.00",style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),),
// Spacer(flex: 1,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(onPressed: (){},
//                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEA307B,), foregroundColor: Colors.white),
//                   child: Text("View Receipt")),
//               ElevatedButton(onPressed: (){},
//                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEA307B,), foregroundColor: Colors.white),
//                   child: Text("Done")),
//             ],
//           ),
//           SizedBox(height: 30,)
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ComplaintRegistrationScreen extends StatefulWidget {
//   const ComplaintRegistrationScreen({super.key});
//
//   @override
//   State<ComplaintRegistrationScreen> createState() =>
//       _ComplaintRegistrationScreenState();
// }
//
// class _ComplaintRegistrationScreenState
//     extends State<ComplaintRegistrationScreen> {
//   // Complaint Type
//   String _complaintType = 'Transaction';
//
//   // Search Criteria
//   String _searchCriteria = 'Transaction ID';
//
//   // Controllers
//   final _transactionIdController = TextEditingController();
//   final _mobileNumberController = TextEditingController();
//   final _complaintDescriptionController = TextEditingController();
//
//   // Dates
//   DateTime? _fromDate;
//   DateTime? _toDate;
//
//   // Disposition
//   String? _selectedDisposition;
//
//   // Form Key
//   final _formKey = GlobalKey<FormState>();
//
//   // Disposition Items
//   final List<String> _dispositionItems = [
//     'Transaction Successful, Amount Debited but services not received',
//     'Transaction Successful, Amount Debited but Service Disconnected or Service Stopped',
//     'Transaction Successful, Amount Debited but LPSC Late Payment Surcharge Charges add in next bill',
//     'Erroneously paid in wrong account',
//     'Duplicate Payment',
//     'Erroneously paid the wrong amount',
//     'Payment information not received from Biller or Delay in receiving payment information from the Biller',
//     'Bill Paid but Amount not adjusted or still showing due amount',
//   ];
//
//   List<String> _filteredDispositionItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredDispositionItems = _dispositionItems;
//   }
//
//   void _filterDispositions(String query) {
//     setState(() {
//       _filteredDispositionItems = _dispositionItems
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   void dispose() {
//     _transactionIdController.dispose();
//     _mobileNumberController.dispose();
//     _complaintDescriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//       });
//     }
//   }
//
//   void _registerComplaint() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const ComplaintSuccessScreen(),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFEA307B),
//         title: const Text('Complaint Registration', style: TextStyle(color: Colors.white),),
//
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 1.0),
//             child: Image.asset(
//               'assets/images/bbppl.png',
//               height: 50,
//               width: 80,
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Complaint Type Section
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Complaint Type',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               title: const Text('Transaction'),
//                               leading: Radio<String>(
//                                 value: 'Transaction',
//                                 groupValue: _complaintType,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _complaintType = value!;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           Expanded(
//                             child: ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               title: const Text('Service'),
//                               leading: Radio<String>(
//                                 value: 'Service',
//                                 groupValue: _complaintType,
//                                 onChanged: null,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Search Criteria Section
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Search Criteria',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: const Text('B-Connect Transaction ID'),
//                         leading: Radio<String>(
//                           value: 'Transaction ID',
//                           groupValue: _searchCriteria,
//                           onChanged: (value) {
//                             setState(() {
//                               _searchCriteria = value!;
//                               _fromDate = null;
//                               _toDate = null;
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: const Text('Mobile Number + Date Range'),
//                         leading: Radio<String>(
//                           value: 'Mobile',
//                           groupValue: _searchCriteria,
//                           onChanged: (value) {
//                             setState(() {
//                               _searchCriteria = value!;
//                               _transactionIdController.clear();
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Dynamic Fields
//                       if (_searchCriteria == 'Transaction ID') ...[
//                         TextFormField(
//                           controller: _transactionIdController,
//                           decoration: const InputDecoration(
//                             labelText: 'B-Connect Transaction ID *',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter Transaction ID';
//                             }
//                             return null;
//                           },
//                         ),
//                       ] else ...[
//                         TextFormField(
//                           controller: _mobileNumberController,
//                           decoration: const InputDecoration(
//                             labelText: 'Mobile Number *',
//                             border: OutlineInputBorder(),
//                             filled: true,
//                           ),
//                           keyboardType: TextInputType.phone,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter Mobile Number';
//                             }
//                             if (value.length < 10) {
//                               return 'Please enter a valid Mobile Number';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         InkWell(
//                           onTap: () => _selectDate(context, true),
//                           child: InputDecorator(
//                             decoration: const InputDecoration(
//                               labelText: 'From Date *',
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                             child: Text(
//                               _fromDate != null
//                                   ? DateFormat('dd/MM/yyyy').format(_fromDate!)
//                                   : 'Select Date',
//                               style: TextStyle(
//                                 color: _fromDate != null
//                                     ? Colors.black
//                                     : Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         InkWell(
//                           onTap: () => _selectDate(context, false),
//                           child: InputDecorator(
//                             decoration: const InputDecoration(
//                               labelText: 'To Date *',
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                             child: Text(
//                               _toDate != null
//                                   ? DateFormat('dd/MM/yyyy').format(_toDate!)
//                                   : 'Select Date',
//                               style: TextStyle(
//                                 color: _toDate != null
//                                     ? Colors.black
//                                     : Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                         if (_fromDate != null && _toDate != null)
//                           if (_fromDate!.isAfter(_toDate!))
//                             const Padding(
//                               padding: EdgeInsets.only(top: 8.0),
//                               child: Text(
//                                 'From Date cannot be after To Date',
//                                 style: TextStyle(color: Colors.red, fontSize: 12),
//                               ),
//                             ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Complaint Disposition Section
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Complaint Disposition',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       DropdownButtonFormField<String>(
//                         isExpanded: true,
//                         initialValue: _selectedDisposition,
//                         hint: const Text('Select Complaint Disposition'),
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           filled: true,
//                         ),
//                         items: _filteredDispositionItems.map((item) {
//                           return DropdownMenuItem(
//                             value: item,
//                             child:
//                             SizedBox(
//                               width: double.infinity,
//                               child: Text(
//                                 style: TextStyle(fontSize: 12),
//                                 item,
//                                 softWrap: true,
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedDisposition = value;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select Complaint Disposition';
//                           }
//                           return null;
//                         },
//                         onTap: () {
//                           // Reset filter when opening dropdown
//                           _filteredDispositionItems = _dispositionItems;
//                         },
//                       ),
//                       // Searchable dropdown alternative
//                       const SizedBox(height: 8),
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Search Disposition',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           prefixIcon: Icon(Icons.search),
//                         ),
//                         onChanged: _filterDispositions,
//                       ),
//                       if (_selectedDisposition != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.check_circle,
//                                     color: Colors.green, size: 16),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Selected: $_selectedDisposition',
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Complaint Description Section
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Complaint Description',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       TextFormField(
//                         controller: _complaintDescriptionController,
//                         decoration: InputDecoration(
//                           labelText: 'Complaint Description',
//                           border: const OutlineInputBorder(),
//                           filled: true,
//                           helperText: '${_complaintDescriptionController.text.length}/250',
//                           helperStyle: const TextStyle(fontSize: 12),
//                         ),
//                         maxLines: 3,
//                         minLines: 3,
//                         maxLength: 250,
//                         buildCounter: (context,
//                             {required currentLength,
//                               required isFocused,
//                               required maxLength}) {
//                           return Text(
//                             '$currentLength/$maxLength',
//                             style: const TextStyle(fontSize: 12),
//                           );
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter Complaint Description';
//                           }
//                           if (value.length < 10) {
//                             return 'Description must be at least 10 characters';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           setState(() {});
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Register Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _registerComplaint,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     backgroundColor: const Color(0xFFEA307B),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text(
//                     'REGISTER COMPLAINT',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ComplaintSuccessScreen extends StatelessWidget {
//   const ComplaintSuccessScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complaint Registration'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             // Success Icon
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.green.shade50,
//               ),
//               padding: const EdgeInsets.all(20),
//               child: const Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 80,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Complaint Registered Successfully',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             // Details Card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     _buildDetailRow('Complaint Assigned', 'Yes'),
//                     const Divider(height: 24),
//                     _buildDetailRow('Complaint ID', 'CMP2026000123'),
//                     const Divider(height: 24),
//                     _buildDetailRow(
//                         'B-Connect Transaction ID', 'CC015334BAAG00034083'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//             // Done Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text(
//                   'Done',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Return to previous page
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Return to previous page'),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 200,
          backgroundColor: Colors.white,
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 2,
            collapseMode: CollapseMode.pin,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                ),
                Text('Hi Welcome back , '),
                Text(
                  "Ainsteen varghese",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )
              ],
            ),

            centerTitle: false,
            // background: Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10), color: Colors.white),
            //
            // ),
          ),
        ),
        SliverFillRemaining()
      ],
    ));
  }
}
