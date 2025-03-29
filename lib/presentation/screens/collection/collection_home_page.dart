import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/presentation/search_filter_page.dart';
import 'package:provider/provider.dart';
import '../../../../../core/colors.dart';
import '../../../data/provider/due_list_provider.dart';

class CollectionHomePage extends StatefulWidget {

  const CollectionHomePage({super.key});

  @override
  State<CollectionHomePage> createState() => _CollectionHomePageState();
}

class _CollectionHomePageState extends State<CollectionHomePage> {
TextEditingController accountNumController = TextEditingController();
TextEditingController amountController = TextEditingController();
num previousCheckboxTotal = 0;
List<bool> checkedItems = List.generate(10, (index) => false);
  @override
  void initState() {
    super.initState();

  }

  Future<void> fetchCustDetails() async {
    final provider = Provider.of<DueListProvider>(context, listen: false);
    await provider.getDueList(accountNumController.text, "2025-03-25");
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
        _buildInfoRow("Customer Name", "sdfsdf"),
        _buildInfoRow("Account doubleber", "dfsd"),
        _buildInfoRow("Account Status", "Active"),
      // _buildInfoRow("Mobile doubleber", _getLastThreeDigits(widget.phNumber)),
      ],
    ),
  );
}
void updateTotalAmount() {
  final provider = Provider.of<DueListProvider>(context, listen: false);

  int manualAmount = int.tryParse(amountController.text) ?? 0; // Preserve manual input
  int checkboxTotal = 0;

  // Calculate the sum of selected due amounts
  for (int i = 0; i < checkedItems.length; i++) {
    if (checkedItems[i]) {
      // Convert dueAmount to int safely
      checkboxTotal += (provider.dueListModel!.duesList!.data![i].dueAmount as num).toInt();
    }
  }

  // Reset manual input if all checkboxes are unchecked
  if (checkboxTotal == 0) {
    manualAmount = 0;
    previousCheckboxTotal = 0;
  }

  num newTotal = checkboxTotal + (manualAmount - previousCheckboxTotal); // Maintain manual edits
  previousCheckboxTotal = checkboxTotal; // Store last calculated checkbox total

  setState(() {
    amountController.text = newTotal.toString();
  });
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: white,
      body:
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              height: MediaQuery.of(context).size.height *0.08,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: deepTeal,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 20,
                        spreadRadius: 0,
                        color: black.withOpacity(0.25)
                    )
                  ],
                  border: Border.all(color: black,width:0.5)
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Today's Collection : Rs.10,000",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: white
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: white,
                      border: Border.all(color: deepTeal, width: 1.5),
                      boxShadow:  const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child:  Padding(
                      padding:const  EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [

                          const Icon(Icons.search, color: deepTeal),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: accountNumController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(8),
                              ],
                              decoration: const InputDecoration(

                                suffixIcon: Icon(Icons.send),
                                border: InputBorder.none,
                                hintText: "Enter Account Number",
                                hintStyle: TextStyle(color:black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add some spacing between the input and search icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SearchFilterPage()));
                  },
                  child: const Icon(Icons.search, color: deepTeal, size: 40),
                ),
              ],
            )
          ],
        ),
      ));

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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          const Text("Proceed"),
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



