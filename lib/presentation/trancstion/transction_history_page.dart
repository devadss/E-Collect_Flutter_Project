

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../profile/widgets/recipect_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  //final AgentTransaction agentTransaction;
  final String paymentStatus;
  final double amount;
  final String dat;
  final String accountNumber;
  final String transactionType;
  final String transferId;
  final String agentName;
  final String agentPhone;
  final String customerName;
  final String customerId;
  final String customerNumber;
  final String corpCode;
  final String tnxType;
  final String paymentMode;

  const TransactionHistoryPage({
    super.key,
    required this.paymentStatus,
    required this.amount,
    required this.transferId,
    required this.agentName,
    required this.agentPhone,
    required this.customerName,
    required this.customerId,
    required this.customerNumber, required this.corpCode,
    required this.tnxType,
    required this.paymentMode, required this.dat, required this.accountNumber, required this.transactionType,
    // required this.agentTransaction
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  bool isLoading = true;

  @override
  void initState() {
    print("status : ${widget.paymentStatus}");
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
    final isSuccess = widget.paymentStatus.toString().toLowerCase().contains("success")
    || widget.paymentStatus.toString().toLowerCase().contains("paid")
    ;
print("isSuccess : $isSuccess");
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            home1,
            home2.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      /// FLOATING CARD
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.65),
            Colors.white.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
         // color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: isLoading
            ? _buildShimmerHeader()
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// STATUS ICON
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: isSuccess
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess
                    ? Icons.check_circle_rounded
                    : Icons.access_time_rounded,
                color: isSuccess ? Colors.green : Colors.orange,
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            /// STATUS TEXT
            Text(
              "Payment ${widget.paymentStatus.toString().replaceAll("Status.", "")}",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            /// AMOUNT
            Text(
              "₹ ${widget.amount}",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildHeaderSection() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [home1, home2.withOpacity(0.8)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         color: white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 12,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: isLoading
  //           ? _buildShimmerHeader()
  //           : Column(
  //               children: [
  //                 Text(
  //                   // "Payment ${widget.agentTransaction.linkStatus.toString().replaceAll("Status.", "")}",
  //                   "Payment ${widget.paymentStatus.toString().replaceAll("Status.", "")}",
  //                   style: GoogleFonts.poppins(
  //                     color: Colors.grey[600],
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   // "₹${widget.agentTransaction.linkAmount}",
  //                   "₹${widget.amount}",
  //                   style: GoogleFonts.poppins(
  //                     color: home1,
  //                     fontSize: 28,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //     ),
  //   );
  // }

  Widget _buildDetailsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
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
          :
      // SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               "Transaction Information",
      //               style: GoogleFonts.poppins(
      //                 color: home1,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //             const SizedBox(height: 16),
      //             _buildDetailCard(),
      //             const SizedBox(height: 24),
      //             Text(
      //               "Customer Information",
      //               style: GoogleFonts.poppins(
      //                 color: home1,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //             const SizedBox(height: 16),
      //             _buildCustomerCard(),
      //            const SizedBox(height: 20),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               child: GestureDetector(
      //                 onTap: (){
      //                   Navigator.push(context, MaterialPageRoute(builder: (context)=> ReceiptPage(
      //                     amount: "${widget.amount}",
      //                     bankName: getBankNameFromCorpCode(widget.corpCode).toString(),
      //                     agentName: widget.agentName,
      //                     agentPhone: widget.agentPhone,
      //                     custName: widget.customerName,
      //                     custPhone: widget.customerNumber,
      //                     custId: widget.customerId,
      //                     txnId: widget.transferId.replaceAll("_MERCHANT", ""),
      //                     txnType: widget.tnxType, dat: widget.dat,
      //                   )));
      //                 },
      //                 child: Container(
      //                   height: 50,
      //                   width: double.infinity,
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(10),
      //                     color: home1,
      //                   ),
      //                   child: Center(
      //                     child: Text(
      //                       "Print",
      //                       style: GoogleFonts.poppins(
      //                           color: white,
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.w600),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TRANSACTION HEADER
            Text(
              "Transaction Information",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            /// CARD
            _buildDetailCard(),

            const SizedBox(height: 20),

            /// CUSTOMER HEADER
            Text(
              "Customer Information",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            /// CARD
            _buildCustomerCard(),

            const SizedBox(height: 28),
            /// PRINT BUTTON
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(
                          amount: "${widget.amount}",
                          bankName: getBankNameFromCorpCode(widget.corpCode).toString(),
                          agentName: widget.agentName,

                          agentPhone: widget.agentPhone,
                          custName: widget.customerName,
                          custPhone: widget.customerNumber,
                          custId: widget.customerId,
                          txnId: widget.transferId.replaceAll("_MERCHANT", ""),
                          txnType: widget.tnxType,
                          dat: widget.dat, tranType: widget.transactionType, accNo: widget.accountNumber,
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                
                      /// subtle gradient = modern look
                      gradient: LinearGradient(
                        colors: [
                          home1,
                          home2.withOpacity(0.85),
                        ],
                      ),
                
                      boxShadow: [
                        BoxShadow(
                          color: home1.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.print_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Print Receipt",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      )
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
          _buildDetailItem(
              // "Transfer ID", widget.agentTransaction.orderId ?? "N/A"
              "Transfer ID",
              widget.transferId.replaceAll("_MERCHANT", "")),
          _buildDetailItem("Transaction Type ", widget.transactionType.contains("CASH")? "CASH":"UPI"),
          _buildDetailItem("Amount", "₹${widget.amount}"),
          _buildDetailItem(
              "Agent Name",
              // widget.agentTransaction.linkCurrency
              //     .toString()
              //     .replaceAll("LinkCurrency.", "")
              widget.agentName),
          _buildDetailItem(
            "Agent Phone",
            widget.agentPhone,
            // widget.agentTransaction.linkPurpose
            //     .toString()
            //     .replaceAll("LinkPurpose.", "")
            //     .replaceAll("_", " "),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(10),
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
          _buildDetailItem("Customer Name", widget.customerName
              // widget.agentTransaction.customerName
              //     .toString()
              //     .replaceAll("CustomerName.", "")
              //     .replaceAll("_", " ")
              ),
          _buildDetailItem("Customer Acc No", widget.accountNumber),
          _buildDetailItem("Customer ID", widget.customerId
              // widget.agentTransaction.customerId ?? "N/A"
              ),
          _buildDetailItem("Phone Number", widget.customerNumber
              // widget.agentTransaction.customerPhone ?? "N/A"
              ),
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
      baseColor: Colors.grey[600]!,
      highlightColor: Colors.grey[300]!,
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
          ...List.generate(
              4,
              (index) => Padding(
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
          ...List.generate(
              3,
              (index) => Padding(
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
