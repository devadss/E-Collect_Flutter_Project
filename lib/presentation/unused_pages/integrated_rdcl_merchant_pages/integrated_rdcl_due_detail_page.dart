// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';
//
// // ==================== PAGE WIDGET ====================
// class IntegratedRDCLDueDetailPage extends StatefulWidget {
//   final String branchCode;
//   const IntegratedRDCLDueDetailPage({super.key, required this.branchCode});
//
//   @override
//   State<IntegratedRDCLDueDetailPage> createState() => _IntegratedRDCLDueDetailPageState();
// }
//
// class _IntegratedRDCLDueDetailPageState extends State<IntegratedRDCLDueDetailPage> {
//   final List<bool> _showDrops = [false];
//   final List<bool> _isSelected = [false];
//   final List<bool> _itemSelected = [false];
//   bool didSearch = false;
//   String selectedMethod="";
//   bool _showSendIcon = false;
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   bool chekValue(String value) {
//     if (int.tryParse(value) == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           "Due List",
//           style: TextStyle(
//               color: home1, fontSize: 25, fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: Column(
//         children: [
//           // ==================== SEARCH BAR ====================
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.06),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: searchController,
//                 onChanged: (value) {
//                   setState(() {
//                     _showSendIcon = value.isNotEmpty;
//                   });
//                 },
//                 style: const TextStyle(fontSize: 14),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "Search by name...",
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 13,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search_rounded,
//                     color: Colors.grey.shade500,
//                   ),
//                   suffixIcon: _showSendIcon
//                       ? Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // CLEAR BUTTON
//                       GestureDetector(
//                         onTap: () {
//                           searchController.clear();
//                           setState(() {
//                             _showSendIcon = false;
//                             didSearch = false;
//                           });
//                           // API call removed
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             size: 16,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       // SEND BUTTON
//                       GestureDetector(
//                         onTap: () {
//                           final text = searchController.text;
//                           setState(() {
//                             didSearch = true;
//                           });
//                           // API call removed
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: home1,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.arrow_forward_rounded,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                     ],
//                   )
//                       : null,
//                 ),
//               ),
//             ),
//           ),
//
//           // ==================== LIST VIEW ====================
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10, // Replace with actual data length
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (_isSelected[index] == false) {
//                         _isSelected[index] = true;
//                         _showDrops[index] = true;
//                       } else {
//                         _itemSelected[index] = false;
//                         _isSelected[index] = false;
//                         _showDrops[index] = false;
//                       }
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 7, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: _itemSelected[index] == true
//                             ? home1.withAlpha(8)
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: _itemSelected[index] == true
//                               ? home1.withAlpha(40)
//                               : Colors.grey.withAlpha(30),
//                           width: 1,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withAlpha(8),
//                             blurRadius: 12,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _showDrops[index] = !_showDrops[index];
//                               });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // ==================== HEADER ROW ====================
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.all(7),
//                                         decoration: BoxDecoration(
//                                           color: home1.withAlpha(12),
//                                           borderRadius:
//                                           BorderRadius.circular(14),
//                                         ),
//                                         child: Icon(
//                                           Icons.account_balance_wallet_outlined,
//                                           color: home1,
//                                           size: 24,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Account Number",
//                                               style: TextStyle(
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey.shade600,
//                                                 letterSpacing: 0.3,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               "001", // Replace with actual data
//                                               style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: home1,
//                                                 letterSpacing: -0.3,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             "Total Due",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.grey.shade600,
//                                               letterSpacing: 0.3,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12, vertical: 6),
//                                             decoration: BoxDecoration(
//                                               color: Colors.orange.withAlpha(12),
//                                               borderRadius:
//                                               BorderRadius.circular(12),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Icon(
//                                                   Icons.currency_rupee,
//                                                   size: 16,
//                                                   color: Colors.orange.shade700,
//                                                 ),
//                                                 const SizedBox(width: 2),
//                                                 Text(
//                                                   "0", // Replace with actual data
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w700,
//                                                     color:
//                                                     Colors.orange.shade700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(width: 8),
//                                       AnimatedRotation(
//                                         duration:
//                                         const Duration(milliseconds: 200),
//                                         turns: _showDrops[index] ? 0.5 : 0,
//                                         child: Icon(
//                                           Icons.keyboard_arrow_down,
//                                           color: Colors.grey.shade600,
//                                           size: 24,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//
//                                   // ==================== EXPANDED DETAILS ====================
//                                   if (_showDrops[index]) ...[
//                                     const SizedBox(height: 5),
//                                     Divider(
//                                         color: Colors.grey.shade200, height: 1),
//                                     const SizedBox(height: 5),
//
//                                     // Customer Name Row
//                                     Row(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             color: Colors.blueAccent
//                                                 .withAlpha(12),
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                           ),
//                                           child: Icon(
//                                               Icons.person_outline,
//                                               color: Colors.blueAccent,
//                                               size: 18),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Text(
//                                           "Customer Name",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Expanded(
//                                           child: Text(
//                                             "N/A", // Replace with actual data
//                                             overflow: TextOverflow.clip,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey.shade800,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Divider(color: Colors.grey.shade200),
//
//                                     // Open Date Row
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             color: Colors.cyan.withAlpha(12),
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                           ),
//                                           child: Icon(
//                                               Icons.calendar_today_outlined,
//                                               color: Colors.cyan,
//                                               size: 18),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Text(
//                                           "Open Date",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Text(
//                                           "N/A", // Replace with actual data
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.grey.shade800,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Divider(color: Colors.grey.shade200, height: 1),
//                                     const SizedBox(height: 5),
//
//                                     // Installment Details Header
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             color: Colors.deepPurpleAccent
//                                                 .withAlpha(12),
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                           ),
//                                           child: Icon(Icons.receipt_outlined,
//                                               color: Colors.deepPurpleAccent,
//                                               size: 18),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Text(
//                                           "Installment Details",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.grey.shade800,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//
//                                     // Installment Stats Row
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 12, horizontal: 8),
//                                             decoration: BoxDecoration(
//                                               color: Colors.green.withAlpha(35),
//                                               borderRadius:
//                                               BorderRadius.circular(12),
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 Text(
//                                                   "Paid",
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                     Colors.grey.shade600,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 4),
//                                                 Text(
//                                                   "0", // Replace with actual data
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w700,
//                                                     color:
//                                                     Colors.green.shade800,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 12, horizontal: 8),
//                                             decoration: BoxDecoration(
//                                               color: Colors.orange.withAlpha(35),
//                                               borderRadius:
//                                               BorderRadius.circular(12),
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 Text(
//                                                   "Due",
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                     Colors.grey.shade600,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 4),
//                                                 Text(
//                                                   "0", // Replace with actual data
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w700,
//                                                     color:
//                                                     Colors.orange.shade800,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 12, horizontal: 8),
//                                             decoration: BoxDecoration(
//                                               color: Colors.blueGrey
//                                                   .withAlpha(35),
//                                               borderRadius:
//                                               BorderRadius.circular(12),
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 Text(
//                                                   "Total",
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                     Colors.grey.shade600,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 4),
//                                                 Text(
//                                                   "0", // Replace with actual data
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w700,
//                                                     color:
//                                                     Colors.blueGrey.shade800,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Divider(color: Colors.grey.shade200, height: 1),
//                                     const SizedBox(height: 10),
//
//                                     // ==================== PAYMENT SELECTION ROW ====================
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             "Select for payment",
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.grey.shade700,
//                                             ),
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _itemSelected[index] =
//                                               !_itemSelected[index];
//                                             });
//                                             if (_itemSelected[index] == true) {
//                                               // Show modal bottom sheet
//                                               _showPaymentModal(index);
//                                             }
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 16, vertical: 8),
//                                             decoration: BoxDecoration(
//                                               color: _itemSelected[index]
//                                                   ? home1
//                                                   : Colors.grey.shade100,
//                                               borderRadius:
//                                               BorderRadius.circular(30),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Icon(
//                                                   _itemSelected[index]
//                                                       ? Icons.check_circle
//                                                       : Icons.circle_outlined,
//                                                   size: 18,
//                                                   color: _itemSelected[index]
//                                                       ? Colors.white
//                                                       : Colors.grey.shade600,
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   _itemSelected[index]
//                                                       ? "Selected"
//                                                       : "Select",
//                                                   style: TextStyle(
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w600,
//                                                     color: _itemSelected[index]
//                                                         ? Colors.white
//                                                         : Colors.grey.shade700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ==================== PAYMENT MODAL BOTTOM SHEET ====================
//   void _showPaymentModal(int index) {
//     double modalSelectedAmount = 0.0; // Replace with actual data
//     final controller =
//     TextEditingController(text: modalSelectedAmount.toStringAsFixed(2));
//     String selectedMethod = "Cash";
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 top: 20,
//                 left: 20,
//                 right: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Drag Handle
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // ==================== PAYMENT METHOD ROW ====================
//                   Row(
//                     children: [
//                       Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                           color: home2.withAlpha(50),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: selectedMethod == "QR Code"
//                             ? Image.asset(
//                           "assets/icons/qr-code.png",
//                           scale: 12,
//                           color: home2,
//                         )
//                             : Image.asset(
//                           "assets/images/rupee_6414183.png",
//                           scale: 10,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             FittedBox(
//                               fit: BoxFit.scaleDown,
//                               child: Text(
//                                 "Collect Payment Using",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.inter(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             Divider(),
//                             Text(
//                               selectedMethod,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                         onTap: () {
//                           _showPaymentMethodSelector(context, setModalState);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Colors.white,
//                           ),
//                           child: Text(
//                             "",
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.inter(
//                               decoration: TextDecoration.underline,
//                               decorationColor: home2,
//                               fontWeight: FontWeight.w800,
//                               color: home2,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Divider(),
//
//                   // ==================== INSTALLMENT DETAILS ====================
//                   SizedBox(
//                     width: double.infinity,
//                     child: Text(
//                       "Installment Details",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: home2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Text(
//                       "Open Date: N/A", // Replace with actual data
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Text(
//                       "Paid Installments: 0 Nos", // Replace with actual data
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Divider(),
//
//                   // ==================== AMOUNT INPUT ====================
//                   SizedBox(
//                     width: double.infinity,
//                     child: Text(
//                       "Edit Total Selected Amount",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: home2,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: controller,
//                     keyboardType: const TextInputType.numberWithOptions(
//                         decimal: true),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: grey,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 14, vertical: 12),
//                       prefixIcon: const Icon(Icons.currency_rupee, color: home2),
//                     ),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // ==================== SLIDER BUTTON ====================
//                   CustomSliderButton(
//                     token: "",
//                     label: "Slide to Collect Using $selectedMethod",
//                     backgroundColor: home1,
//                     buttonColor: Colors.white,
//                     onConfirmed: () async {
//                       // Payment logic removed
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // ==================== PAYMENT METHOD SELECTOR ====================
//   void _showPaymentMethodSelector(
//       BuildContext context, StateSetter setModalState) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) => Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Divider(indent: 16, endIndent: 16),
//             ListTile(
//               leading: const Icon(Icons.currency_rupee_rounded,
//                   color: Colors.deepOrange),
//               title: const Text(
//                 "Cash",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {
//                 setModalState(() => selectedMethod = "Cash");
//                 Navigator.pop(ctx);
//               },
//             ),
//             const Divider(indent: 16, endIndent: 16),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ==================== CUSTOM SLIDER BUTTON ====================
// class CustomSliderButton extends StatefulWidget {
//   final Future<void> Function() onConfirmed;
//   final String label;
//   final Color backgroundColor;
//   final Color buttonColor;
//   final String token;
//
//   const CustomSliderButton({
//     super.key,
//     required this.onConfirmed,
//     required this.label,
//     required this.backgroundColor,
//     required this.buttonColor,
//     required this.token,
//   });
//
//   @override
//   State<CustomSliderButton> createState() => _CustomSliderButtonState();
// }
//
// class _CustomSliderButtonState extends State<CustomSliderButton> {
//   double _dragPosition = 0.0;
//   bool isConfirmed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width - 40;
//
//     return Container(
//       width: width,
//       height: 70,
//       decoration: BoxDecoration(
//         color: widget.backgroundColor,
//         borderRadius: BorderRadius.circular(35),
//         boxShadow: const [
//           BoxShadow(
//               color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
//         ],
//       ),
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         children: [
//           Center(
//             child: Shimmer.fromColors(
//               baseColor: Colors.white,
//               highlightColor: widget.buttonColor.withValues(alpha: 0.25),
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   widget.label,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 12,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: _dragPosition,
//             child: GestureDetector(
//               onHorizontalDragUpdate: (details) {
//                 setState(() {
//                   _dragPosition += details.delta.dx;
//                   _dragPosition = _dragPosition.clamp(0.0, width - 70);
//                 });
//               },
//               onHorizontalDragEnd: (_) async {
//                 if (_dragPosition > (width - 70) * 0.5) {
//                   setState(() {
//                     isConfirmed = true;
//                     _dragPosition = width - 70;
//                   });
//
//                   await widget.onConfirmed();
//
//                   setState(() {
//                     _dragPosition = 0.0;
//                     isConfirmed = false;
//                   });
//                 } else {
//                   setState(() {
//                     _dragPosition = 0.0;
//                   });
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5),
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: widget.buttonColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: AnimatedSwitcher(
//                     duration: const Duration(seconds: 1),
//                     transitionBuilder: (child, animation) => RotationTransition(
//                       turns: Tween(
//                         begin: 0.75,
//                         end: 1.0,
//                       ).animate(animation),
//                       child: child,
//                     ),
//                     child: Image.asset(
//                       "assets/icons/arrow.png",
//                       key: const ValueKey('arrow-icon'),
//                       scale: 20,
//                       color: home2,
//                       fit: BoxFit.scaleDown,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ==================== CONSTANTS (Placeholder) ====================
// // Replace these with your actual color constants
// const Color home1 = Color(0xFF1A73E8);
// const Color home2 = Color(0xFF0D47A1);
// const Color deepTeal = Color(0xFF00897B);
// const Color grey = Color(0xFF9E9E9E);
// const Color black = Color(0xFF000000);
// const Color white = Color(0xFFFFFFFF);
// const Color black54 = Color(0x8A000000);
// const Color black87 = Color(0xDD000000);