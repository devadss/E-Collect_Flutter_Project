import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/colors.dart';
import '../../../domain/model/agent_transction_model.dart';

class TransactionHistoryPage extends StatefulWidget {
  final AgentTransaction agentTransaction;

  const TransactionHistoryPage({super.key, required this.agentTransaction});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Transaction Details",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 23, color: deepTeal),
        ),
      ),
      backgroundColor: white,
      body: Column(
        children: [
          // Top Gradient Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [deepTeal, yellowGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your payment ${widget.agentTransaction.linkStatus.toString().startsWith("Status") &&
                            widget.agentTransaction.linkStatus != null ?
                        widget.agentTransaction.linkStatus.toString().replaceAll("Status.", "") :
                        widget.agentTransaction.linkStatus.toString().startsWith("Status") &&
                            widget.agentTransaction.linkStatus == null ?
                        widget.agentTransaction.linkStatus.toString().replaceAll('null', ""):
                        widget.agentTransaction.linkStatus
                        }",
                        style: GoogleFonts.inter(
                          color: black54,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "₹ ${widget.agentTransaction.linkAmount}",
                        style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: teal700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Transaction Details Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Status",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildDetailRow("Transfer ID",
                      "${widget.agentTransaction.orderId?.startsWith("null")==true ? widget.agentTransaction.orderId?.replaceAll("null", "") : widget.agentTransaction.orderId}"),
                  widget.agentTransaction.linkStatus == null
                      ? const SizedBox()
                      : buildDetailRow(
                          "Status",
                          widget.agentTransaction.linkStatus
                              .toString()
                              .replaceAll("Status.", "")),
                  buildDetailRow(
                      "Amount", "Rs.${widget.agentTransaction.linkAmount}"),
                  buildDetailRow(
                      "Currency",
                      widget.agentTransaction.linkCurrency
                          .toString()
                          .replaceAll("LinkCurrency.", "")),
                  buildDetailRow(
                      "Purpose",
                      widget.agentTransaction.linkPurpose
                          .toString()
                          .replaceAll("LinkPurpose.", "")
                          .replaceAll("_", " ")),
                  buildDetailRow(
                      "Customer",
                      widget.agentTransaction.customerName
                          .toString()
                          .replaceAll("CustomerName.", "")
                          .replaceAll("_", " ")),
                  buildDetailRow(
                      "Customer ID", "${widget.agentTransaction.customerId}"),
                  buildDetailRow("Customer Phone",
                      "${widget.agentTransaction.customerPhone

                      }"),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for transaction details
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: grey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
        ],
      ),
    );
  }
}
