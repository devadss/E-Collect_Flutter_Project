import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';

class DuesDetailPage extends StatefulWidget {
  const DuesDetailPage({super.key});

  @override
  State<DuesDetailPage> createState() => _DuesDetailPageState();
}

class _DuesDetailPageState extends State<DuesDetailPage> {
  List<bool> checkedItems = List.generate(10, (index) => false);
  TextEditingController amountController = TextEditingController();

  int get totalAmount => checkedItems.where((e) => e).length * 1000;

  void updateTotalAmount() {
    setState(() {
      amountController.text = totalAmount.toString();
    });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildCustomerInfo(),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: checkedItems.length,
                itemBuilder: (_, index) {
                  return _buildDueItem(index);
                },
              ),
            ),
          ],
        ),
      ),
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
        boxShadow: [
          BoxShadow(
            color: black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Customer Name", "Ainsteen"),
          _buildInfoRow("Account Number", "123456789012"),
          _buildInfoRow("Account Status", "Active"),
          _buildInfoRow("Mobile Number", "xxxxxxx999"),
        ],
      ),
    );
  }

  Widget _buildDueItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
          border: Border.all(color: deepTeal, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Due amount: Rs.1000", style: _infoTextStyle()),
            const SizedBox(height: 5),
            Row(
              children: [
                Text("Loan type: RD", style: _infoTextStyle()),
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
            Text("Due date: 22/03/2025", style: _infoTextStyle()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height *0.15,
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
                keyboardType: TextInputType.number,
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
              onPressed: () {},
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
          Expanded(
            flex: 2,
            child: Text(label, style: _labelTextStyle()),
          ),
          Text(":", style: _labelTextStyle()),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value, style: _valueTextStyle()),
          ),
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
