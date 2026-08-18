// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
//
// class IntegratedRDCLHomePage extends StatefulWidget {
//   final String userType;
//   const IntegratedRDCLHomePage({super.key, required this.userType});
//
//   @override
//   State<IntegratedRDCLHomePage> createState() => _IntegratedRDCLHomePageState();
// }
//
// class _IntegratedRDCLHomePageState extends State<IntegratedRDCLHomePage>
//     with SingleTickerProviderStateMixin {
//   static const Color whiteColor = Colors.white;
//   String? userName;
//   String? userType;
//   int selectedTabIndex = 0;
//   int currentBannerIndex = 0;
//   int todaysCount = 0;
//   bool isFilterApplied = false;
//   String currentFilterPeriod = 'Today';
//   String currentFromDate = '';
//   String currentToDate = '';
//
//   final List<String> bannerImages = [
//     "assets/images/cq1.webp",
//     "assets/images/cq2.webp",
//     "assets/images/cq3.webp",
//     "assets/images/cq4.webp",
//     "assets/images/cq5.webp",
//     "assets/images/cq6.webp",
//     "assets/images/cq7.webp",
//   ];
//
//   final CarouselSliderController _carouselController =
//   CarouselSliderController();
//   late AnimationController _animationController;
//   late Animation<double> fadeAnimation;
//   late Animation<double> scaleAnimation;
//   int index = 0;
//   Color? headerColor = Colors.blue;
//
//   void animationController() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOutBack,
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     animationController();
//     // Simulate header color change
//     headerColor = Colors.blue.shade700;
//     userName = "John Doe";
//     userType = widget.userType;
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void showDateRangeFilter() {
//     DateTime? fromDate;
//     DateTime? toDate;
//     int selectedIndex = 0;
//
//     showModalBottomSheet(
//       backgroundColor: whiteColor,
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: StatefulBuilder(
//             builder: (context, modalSetState) {
//               Widget buildDatePickers() {
//                 String fmt(DateTime d) =>
//                     "${d.day}/${d.month}/${d.year}";
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: _DatePickerButton(
//                         label: fromDate != null ? fmt(fromDate!) : 'From',
//                         icon: Icons.calendar_today_outlined,
//                         onTap: () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: fromDate ?? DateTime.now(),
//                             firstDate: DateTime(2000),
//                             lastDate: DateTime(2100),
//                           );
//                           if (picked != null) {
//                             modalSetState(() => fromDate = picked);
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _DatePickerButton(
//                         label: toDate != null ? fmt(toDate!) : 'To',
//                         icon: Icons.calendar_today_outlined,
//                         onTap: () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: toDate ?? DateTime.now(),
//                             firstDate: DateTime(2000),
//                             lastDate: DateTime(2100),
//                           );
//                           if (picked != null) {
//                             modalSetState(() => toDate = picked);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }
//
//               return Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       selectedIndex == 4
//                           ? 'Select Date Range'
//                           : 'Select Filter Type',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 16),
//
//                     // Filter Options
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: ToggleButtons(
//                         hoverColor: Colors.grey.shade300,
//                         splashColor: Colors.blue.withValues(alpha:0.7),
//                         fillColor: Colors.blue.withValues(alpha:0.1),
//                         selectedBorderColor: Colors.blue,
//                         isSelected: List.generate(5, (i) => i == selectedIndex),
//                         onPressed: (i) => modalSetState(() {
//                           selectedIndex = i;
//                           if (i != 4) {
//                             fromDate = null;
//                             toDate = null;
//                           }
//                         }),
//                         borderRadius: BorderRadius.circular(8),
//                         children: const [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Text('Today',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Text('This\nWeek',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Text('This\nMonth',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Text('Last\nMonth',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Text('Custom',
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Show date pickers for custom range
//                     if (selectedIndex == 4) buildDatePickers(),
//
//                     const SizedBox(height: 10),
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor: Colors.blue,
//                           foregroundColor: whiteColor,
//                           minimumSize: const Size.fromHeight(48),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isFilterApplied = true;
//                             currentFilterPeriod = 'TODAY';
//                             currentFromDate = '2026-01-01';
//                             currentToDate = '2026-01-30';
//                           });
//                           Navigator.pop(context);
//                         },
//                         child:
//                         Text(selectedIndex == 4 ? 'Apply Filter' : 'Apply'),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAnimatedHeader(BuildContext context, Size size) {
//     final formattedName = (userName != null && userName!.isNotEmpty)
//         ? userName![0].toUpperCase() + userName!.substring(1)
//         : "";
//
//     return AnimatedContainer(
//       duration: 500.ms,
//       curve: Curves.easeInOut,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: headerColor ?? Colors.blue,
//       ),
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// HEADER TEXT
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Welcome back",
//                     style: TextStyle(
//                       color: whiteColor.withValues(alpha:0.8),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Hi, $formattedName ",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: whiteColor,
//                       letterSpacing: 0.3,
//                     ),
//                   ).animate().fadeIn(duration: 900.ms).slideX(begin: -0.9),
//                   const SizedBox(height: 6),
//                   Text(
//                     "Here's your collection overview",
//                     style: TextStyle(
//                       color: whiteColor.withValues(alpha:0.75),
//                       fontSize: 12,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//
//             /// BANNER / CAROUSEL
//             _buildAnimatedBannerCarousel(size),
//
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedBannerCarousel(Size size) {
//     return SizedBox(
//       height: size.height * 0.15,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           CarouselSlider(
//             carouselController: _carouselController,
//             options: CarouselOptions(
//               height: size.height * 0.15,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               viewportFraction: 0.8,
//               autoPlayInterval: 3.seconds,
//               autoPlayAnimationDuration: 1200.ms,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   currentBannerIndex = index;
//                 });
//               },
//             ),
//             items: bannerImages.map((imagePath) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(
//                     image: AssetImage(imagePath),
//                     fit: BoxFit.fitWidth,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha:0.2),
//                       blurRadius: 5,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//               ).animate().scale(
//                 begin: const Offset(0.9, 0.9),
//                 duration: 500.ms,
//               );
//             }).toList(),
//           ),
//           Positioned(
//             bottom: 5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: bannerImages.asMap().entries.map((entry) {
//                 return AnimatedContainer(
//                   duration: 300.ms,
//                   width: currentBannerIndex == entry.key ? 20 : 8,
//                   height: 15,
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     color: currentBannerIndex == entry.key
//                         ? Colors.red
//                         : Colors.red.withValues(alpha:0.5),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTotalCollectionCard() {
//     String getFilterDisplayText() {
//       if (!isFilterApplied) return 'TODAY ';
//
//       switch (currentFilterPeriod) {
//         case 'TODAY':
//           return 'Today';
//         case 'THIS_WEEK':
//           return 'This Week';
//         case 'THIS_MONTH':
//           return 'Last 30 Days';
//         case 'LAST_MONTH':
//           return 'Last Month';
//         case 'CUSTOM':
//           return 'Custom ($currentFromDate to $currentToDate)';
//         default:
//           return 'Filtered';
//       }
//     }
//
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           shadowColor: Colors.black.withValues(alpha:0.08),
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// HEADER
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Total Collection",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//
//                     /// TAG
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.withValues(alpha:0.15),
//                             Colors.blue.withValues(alpha:0.5),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         selectedTabIndex == 0
//                             ? userType == "COLLECTION"
//                             ? "All"
//                             : 'All'
//                             : selectedTabIndex == 1
//                             ? 'Link'
//                             : selectedTabIndex == 2
//                             ? 'Cash'
//                             : "Transfer",
//                         style: TextStyle(
//                           color: whiteColor,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 /// AMOUNT
//                 Text(
//                   "₹12,345.67",
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 /// COUNT TEXT
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.blue.withAlpha(30)),
//                   child: Text(
//                     "${getFilterDisplayText()} : $todaysCount Nos",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//
//                 Divider(color: Colors.blue.withAlpha(50)),
//
//                 /// BUTTONS
//                 Row(
//                   children: [
//                     if (isFilterApplied)
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: _clearFilters,
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.redAccent,
//                             side: BorderSide(
//                               color: Colors.redAccent.withValues(alpha:0.5),
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: const Text("Clear"),
//                         ),
//                       ),
//                     if (isFilterApplied) const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: showDateRangeFilter,
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: whiteColor,
//                           backgroundColor: Colors.blue,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: const Text(
//                           "Filter",
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Future<void> _clearFilters() async {
//     setState(() {
//       isFilterApplied = false;
//       currentFilterPeriod = 'TODAY';
//       currentFromDate = '';
//       currentToDate = '';
//     });
//   }
//
//   Widget _buildTabBar() {
//     final isAgentLoan = widget.userType == "AGENT_LOAN";
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Container(
//         height: 80,
//         decoration: BoxDecoration(
//           color: whiteColor,
//           border: Border.all(color: Colors.blue, width: 1),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha:0.1),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: _buildTabItems(isAgentLoan),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildTabItems(bool isAgentLoan) {
//     if (isAgentLoan) {
//       return [
//         _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
//         _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
//       ];
//     } else {
//       return [
//         _buildAnimatedTabItem(0, Icons.all_out_rounded, "All"),
//         _buildAnimatedTabItem(2, Icons.currency_rupee, "Cash"),
//       ];
//     }
//   }
//
//   Widget _buildAnimatedTabItem(int index, IconData icon, String label) {
//     final isSelected = selectedTabIndex == index;
//
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 2),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(14),
//           onTap: () => setState(() => selectedTabIndex = index),
//           child: AnimatedContainer(
//             margin: EdgeInsets.all(7),
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeInOut,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             decoration: BoxDecoration(
//               gradient: isSelected
//                   ? LinearGradient(
//                 colors: [
//                   Colors.blue.withValues(alpha:0.8),
//                   Colors.blue.withValues(alpha:0.03),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//                   : LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   Colors.transparent,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isSelected
//                     ? Colors.blue.withAlpha(100)
//                     : Colors.grey.withValues(alpha:0.2),
//               ),
//               boxShadow: isSelected
//                   ? [
//                 BoxShadow(
//                   color: Colors.blue.withValues(alpha:0.25),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 )
//               ]
//                   : [],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 200),
//                   child: Icon(
//                     icon,
//                     key: ValueKey(isSelected),
//                     color: isSelected ? whiteColor : Colors.blue,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: isSelected ? whiteColor : Colors.blue,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContentCollectionSection() {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//             (context, index) {
//           switch (selectedTabIndex) {
//             case 0:
//               return _buildCashWithQrTransactionContent();
//             case 1:
//               return _buildLinkTransactionContent();
//             case 2:
//               return _buildCashTransactionContent();
//             default:
//               return const SizedBox();
//           }
//         },
//         childCount: 1,
//       ),
//     );
//   }
//
//   Widget _buildLinkTransactionContent() {
//     return _buildTransactionList(
//       transactions: [
//         _createSampleTransaction("Customer A"),
//         _createSampleTransaction("Customer B"),
//         _createSampleTransaction("Customer C"),
//       ],
//       icon: Icons.link_outlined,
//       iconColor: Colors.blue,
//     );
//   }
//
//   Widget _buildCashTransactionContent() {
//     return _buildTransactionList(
//       transactions: [
//         _createSampleTransaction("Cash Customer 1"),
//         _createSampleTransaction("Cash Customer 2"),
//       ],
//       icon: Icons.dangerous_outlined,
//       iconColor: Colors.orange,
//     );
//   }
//
//   Widget _buildCashWithQrTransactionContent() {
//     return _buildTransactionList(
//       transactions: [
//         _createSampleTransaction("All Transaction 1"),
//         _createSampleTransaction("All Transaction 2"),
//         _createSampleTransaction("All Transaction 3"),
//         _createSampleTransaction("All Transaction 4"),
//       ],
//       icon: Icons.all_out_rounded,
//       iconColor: Colors.blue,
//     );
//   }
//
//   dynamic _createSampleTransaction(String name) {
//     return {
//       'customerName': name,
//       'orderAmount': 500.0,
//       'orderStatus': 'SUCCESS',
//       'createdAt': DateTime.now().toString(),
//       'orderId': 'ORD${DateTime.now().millisecondsSinceEpoch}',
//       'customerId': 'CUS001',
//       'customerPhone': '9876543210',
//       'source': 'APP',
//       'paymentMode': 'PAYMENTLINK',
//       'collectionType': 'Collection',
//       'customerAccNo': 'ACC123456',
//     };
//   }
//
//   Widget _buildTransactionList({
//     required List<dynamic> transactions,
//     required IconData icon,
//     required Color iconColor,
//   }) {
//     return Column(
//       children: transactions.asMap().entries.map((entry) {
//         final index = entry.key;
//         final transaction = entry.value;
//
//         return _buildAnimatedTransactionCard(
//           icon: icon,
//           iconColor: iconColor,
//           title: transaction['customerName'] ?? "",
//           date: transaction['createdAt']?.substring(0, 16) ?? "",
//           amount: transaction['orderAmount']?.toDouble() ?? 0.0,
//           status: transaction['orderStatus'] ?? "PENDING",
//           transferId: transaction['orderId'] ?? "",
//           agentName: "John Doe",
//           accountNumber: transaction['customerAccNo'] ?? "",
//           transactionType: transaction['paymentMode'] ?? "",
//           agentPhone: "1234567890",
//           customerName: transaction['customerName'] ?? "",
//           customerId: transaction['customerId'] ?? "",
//           customerNumber: transaction['customerPhone'] ?? "",
//           tnxType: transaction['source'] ?? "",
//           paymentMode: transaction['paymentMode'] ?? "",
//           collectionType: transaction['collectionType'] ?? "",
//         ).animate(delay: (100 * index).ms);
//       }).toList(),
//     );
//   }
//
//   Widget _buildAnimatedTransactionCard({
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required String date,
//     required double amount,
//     required String status,
//     required String transferId,
//     required String agentName,
//     required String accountNumber,
//     required String transactionType,
//     required String agentPhone,
//     required String customerName,
//     required String customerId,
//     required String customerNumber,
//     required String tnxType,
//     required String paymentMode,
//     required String collectionType,
//   }) {
//     bool isSuccess = status.toLowerCase().contains("success") ||
//         status.toLowerCase().contains("paid") ||
//         status.toLowerCase().contains("completed");
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Card(
//         elevation: 0,
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(color: Colors.grey.shade200),
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             // Navigate to transaction detail
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 /// ICON
//                 Container(
//                   height: 42,
//                   width: 42,
//                   decoration: BoxDecoration(
//                     color: iconColor.withValues(alpha:0.08),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     paymentMode == "PAYMENTLINK"
//                         ? Icons.link
//                         : Icons.currency_rupee_rounded,
//                     color: iconColor,
//                     size: 20,
//                   ),
//                 ),
//
//                 const SizedBox(width: 14),
//
//                 /// LEFT CONTENT
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         date,
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       if (collectionType.isNotEmpty &&
//                           !collectionType.contains("null"))
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 3),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withValues(alpha:0.08),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             collectionType,
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       "₹${amount.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isSuccess
//                             ? Colors.green.withValues(alpha:0.08)
//                             : Colors.orange.withValues(alpha:0.08),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         status,
//                         style: TextStyle(
//                           color: isSuccess
//                               ? Colors.green.shade700
//                               : Colors.orange.shade700,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingList() {
//     return Column(
//       children: List.generate(
//         5,
//             (index) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _buildShimmerSummaryCard(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmerSummaryCard() {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.43,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(width: 24, height: 24, color: Colors.white),
//           const SizedBox(height: 8),
//           Container(width: 80, height: 16, color: Colors.white),
//           const SizedBox(height: 4),
//           Container(width: 60, height: 16, color: Colors.white),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String message,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 64,
//             color: Colors.grey[300],
//           ).animate().shake(duration: 600.ms),
//           const SizedBox(height: 16),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ).animate().fadeIn(duration: 300.ms),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.grey[500],
//                 ),
//               ).animate().fadeIn(duration: 400.ms),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             expandedHeight: size.height * 0.375,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               collapseMode: CollapseMode.pin,
//               background: _buildAnimatedHeader(context, size),
//             ),
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(80),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: _buildTabBar(),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: _buildTotalCollectionCard().animate(
//               effects: [
//                 FadeEffect(duration: 400.ms),
//                 SlideEffect(
//                   begin: const Offset(0, 0.2),
//                   duration: 500.ms,
//                   curve: Curves.easeOutCubic,
//                 ),
//               ],
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.only(top: 1, left: 16, right: 16),
//             sliver: _buildContentCollectionSection(),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _DatePickerButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const _DatePickerButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: OutlinedButton.icon(
//         onPressed: onTap,
//         icon: Icon(icon),
//         label: Text(label),
//         style: OutlinedButton.styleFrom(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//         ),
//       ),
//     );
//   }
// }