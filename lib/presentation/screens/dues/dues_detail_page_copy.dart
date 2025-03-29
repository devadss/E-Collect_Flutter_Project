/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/presentation/qr_code_home_page.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../data/provider/due_list_provider.dart';

class DuesDetailPage extends StatefulWidget {
  final String name;
  final String agentId;
  final String acNumber;
  final String phNumber;

  const DuesDetailPage({
    super.key,
    required this.name,
    required this.acNumber,
    required this.phNumber,
    required this.agentId,
  });

  @override
  State<DuesDetailPage> createState() => _DuesDetailPageState();
}

class _DuesDetailPageState extends State<DuesDetailPage> {
  List<bool> checkedItems = List.generate(10, (index) => false);
  TextEditingController amountController = TextEditingController();
  num previousCheckboxTotal = 0;

  void updateTotalAmount() {
    final provider = Provider.of<DueListProvider>(context, listen: false);

    int manualAmount =
        int.tryParse(amountController.text) ?? 0; // Preserve manual input
    int checkboxTotal = 0;

    // Calculate the sum of selected due amounts
    for (int i = 0; i < checkedItems.length; i++) {
      if (checkedItems[i]) {
        // Convert dueAmount to int safely
        checkboxTotal +=
            (provider.dueListModel!.duesList!.data![i].dueAmount as num)
                .toInt();
      }
    }

    // Reset manual input if all checkboxes are unchecked
    if (checkboxTotal == 0) {
      manualAmount = 0;
      previousCheckboxTotal = 0;
    }

    num newTotal = checkboxTotal +
        (manualAmount - previousCheckboxTotal); // Maintain manual edits
    previousCheckboxTotal =
        checkboxTotal; // Store last calculated checkbox total

    setState(() {
      amountController.text = newTotal.toString();
    });
  }

  String _getLastThreeDigits(String phonedoubleber) {
    return phonedoubleber.length >= 3
        ? "*** *** ${phonedoubleber.substring(phonedoubleber.length - 3)}"
        : phonedoubleber;
  }

  void _proceedButtonClick() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Proceed Confirmation", style: _labelTextStyle()),
          content: Text(
            "Select the Payment Mode to proceed with the total amount of Rs. ${amountController.text}?",
            style: _valueTextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrCodeHomePage(
                            payAbleAmount: amountController.text,
                            accountNumber: widget.acNumber,
                            agentId: widget.agentId,
                          )),
                );
              },
              child: Text("Qr Code", style: _valueTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teal700,
                foregroundColor: white,
              ),
              child: const Text("Send Link"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    final provider = Provider.of<DueListProvider>(context, listen: false);
    provider.getDueList(widget.acNumber, "2025-03-25");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "Due Details",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 22, color: teal700),
        ),
      ),
      body: Consumer<DueListProvider>(builder: (context, provider, child) {
        return provider.dueListModel == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: deepTeal,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _buildCustomerInfo(),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            provider.dueListModel!.duesList!.data!.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: white,
                                border:
                                    Border.all(color: deepTeal, width: 0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Due amount: Rs.${provider.dueListModel!.duesList!.data![index].dueAmount}",
                                      style: _infoTextStyle()),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text("Loan type: RD",
                                          style: _infoTextStyle()),
                                      const Spacer(),
                                      Transform.scale(
                                        scale: 1.2,
                                        child: Checkbox(
                                          value: checkedItems[index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              checkedItems[index] = value!;
                                              updateTotalAmount();
                                            });
                                          },
                                          activeColor: teal700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      "Due date: ${provider.dueListModel!.duesList!.data![index].dueMonth}",
                                      style: _infoTextStyle()),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      }),
      bottomNavigationBar:
          checkedItems.contains(true) ? _buildBottomBar() : null,
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: teal700!, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Customer Name", widget.name),
          _buildInfoRow("Account doubleber", widget.acNumber),
          _buildInfoRow("Account Status", "Active"),
          _buildInfoRow(
              "Mobile doubleber", _getLastThreeDigits(widget.phNumber)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [teal700!, teal500!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Total Amount :",
                style: _bottomTextStyle(),
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                    color: white, fontSize: 16, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: teal600!.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _proceedButtonClick,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: white,
                foregroundColor: teal700,
                textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
              child: const Text("Proceed"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: _labelTextStyle())),
          Text(":", style: _labelTextStyle()),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(value, style: _valueTextStyle())),
        ],
      ),
    );
  }

  TextStyle _labelTextStyle() => GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 16, color: black87);

  TextStyle _valueTextStyle() => GoogleFonts.inter(
      fontWeight: FontWeight.w500, fontSize: 16, color: teal700!);

  TextStyle _infoTextStyle() => GoogleFonts.inter(
      fontWeight: FontWeight.w500, fontSize: 14, color: black87);

  TextStyle _bottomTextStyle() => GoogleFonts.inter(
      fontWeight: FontWeight.w600, fontSize: 16, color: white);
}
*/
