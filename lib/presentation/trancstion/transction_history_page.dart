// import '../../core/colors.dart';
// import '../../domain/model/agent_transction_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';
//
// class TransactionHistoryPage extends StatefulWidget {
//   final AgentTransaction agentTransaction;
//
//   const TransactionHistoryPage({super.key, required this.agentTransaction});
//
//   @override
//   State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
// }
//
// class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
//   bool isLoading = true; // Simulates loading state
//
//   @override
//   void initState() {
//     super.initState();
//     // Simulate a delay before showing actual data
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Transaction Details",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 23,
//             color: deepTeal,
//           ),
//         ),
//       ),
//       backgroundColor: white,
//       body: Column(
//         children: [
//           _buildGradientHeader(),
//           const SizedBox(height: 20),
//           _buildTransactionDetails(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGradientHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [deepTeal, yellowGreen],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: const [
//                 BoxShadow(
//                   color: black12,
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: isLoading
//                 ? _buildShimmerHeader() // Shimmer Effect for Header
//                 : Column(
//               children: [
//                 Text(
//                   "Your payment ${widget.agentTransaction.linkStatus.toString().replaceAll("Status.", "")}",
//                   style: TextStyle(
//                     color: black54,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "₹ ${widget.agentTransaction.linkAmount}",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: teal700,
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
//   Widget _buildTransactionDetails() {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: const BoxDecoration(
//           color: white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Payment Status",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 15),
//             isLoading
//                 ? _buildShimmerDetails() // Shimmer Effect for Details
//                 : Column(
//               children: [
//                 _buildDetailRow("Transfer ID", "${widget.agentTransaction.orderId}"),
//                 _buildDetailRow("Status", widget.agentTransaction.linkStatus.toString().replaceAll("Status.", "")),
//                 _buildDetailRow("Amount", "Rs.${widget.agentTransaction.linkAmount}"),
//                 _buildDetailRow("Currency", widget.agentTransaction.linkCurrency.toString().replaceAll("LinkCurrency.", "")),
//                 _buildDetailRow("Purpose", widget.agentTransaction.linkPurpose.toString().replaceAll("LinkPurpose.", "").replaceAll("_", " ")),
//                 _buildDetailRow("Customer", widget.agentTransaction.customerName.toString().replaceAll("CustomerName.", "").replaceAll("_", " ")),
//                 _buildDetailRow("Customer ID", "${widget.agentTransaction.customerId}"),
//                 _buildDetailRow("Customer Phone", "${widget.agentTransaction.customerPhone}"),
//               ],
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 16,
//               color: black87,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Shimmer Placeholder for Header
//   Widget _buildShimmerHeader() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: [
//           Container(
//             width: 180,
//             height: 20,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             width: 100,
//             height: 30,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Shimmer Placeholder for Details
//   Widget _buildShimmerDetails() {
//     return Column(
//       children: List.generate(7, (index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: 120,
//                 height: 16,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               Container(
//                 width: 100,
//                 height: 16,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/colors.dart';
import '../../domain/model/agent_transction_model.dart';

class TransactionHistoryPage extends StatefulWidget {
  final AgentTransaction agentTransaction;

  const TransactionHistoryPage({super.key, required this.agentTransaction});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Transaction Details",
          style: GoogleFonts.poppins(
            color: home2,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          Expanded(
            child: _buildDetailsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [home1, home2.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? _buildShimmerHeader()
            : Column(
          children: [
            Text(
              "Payment ${widget.agentTransaction.linkStatus.toString().replaceAll("Status.", "")}",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₹${widget.agentTransaction.linkAmount}",
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: isLoading
          ? _buildShimmerDetails()
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction Information",
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(),
            const SizedBox(height: 24),
            Text(
              "Customer Information",
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildCustomerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem("Transfer ID", widget.agentTransaction.orderId ?? "N/A"),
          _buildDetailItem("Amount", "₹${widget.agentTransaction.linkAmount}"),
          _buildDetailItem(
              "Currency",
              widget.agentTransaction.linkCurrency.toString().replaceAll("LinkCurrency.", "")),
          _buildDetailItem(
            "Purpose",
            widget.agentTransaction.linkPurpose.toString()
                .replaceAll("LinkPurpose.", "")
                .replaceAll("_", " "),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem("Customer Name",
              widget.agentTransaction.customerName.toString()
                  .replaceAll("CustomerName.", "")
                  .replaceAll("_", " ")),
          _buildDetailItem("Customer ID", widget.agentTransaction.customerId ?? "N/A"),
          _buildDetailItem("Phone Number", widget.agentTransaction.customerPhone ?? "N/A"),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Status.success":
        return Colors.green;
      case "Status.failed":
        return Colors.red;
      case "Status.pending":
        return Colors.orange;
      default:
        return home1;
    }
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 100,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerDetails() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(4, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 24),
          Container(
            width: 180,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}