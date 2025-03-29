import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/presentation/screens/collection/search_filter_page.dart';
import 'package:provider/provider.dart';
import '../../../../../core/colors.dart';

import '../../../data/provider/agent_customer_details_provider.dart';
import '../../../data/provider/due_list_provider.dart';
import '../../../domain/model/agent_customer_details_model.dart'as agent;
import '../../../domain/model/due_list_model.dart';
import '../dues/qr/qr_code_home_page.dart';

class CollectionHomePage extends StatefulWidget {
  const CollectionHomePage({super.key});

  @override
  State<CollectionHomePage> createState() => _CollectionHomePageState();
}

class _CollectionHomePageState extends State<CollectionHomePage> {
  TextEditingController accountNumController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  num previousCheckboxTotal = 0;
  agent.AgentCustomerDetailsModel? agentCustomerDetailsModel = agent.AgentCustomerDetailsModel();
  DuesList? duesList = DuesList();
  String accno="";
  String name = "";
  String type = "";

  List<bool> checkedItems = List.generate(3, (index) => false);

  @override
  void initState() {
    super.initState();
    fetchCustName();
    duesList?.data?.clear();
    accountNumController.addListener(() {
      setState(() {}); // Trigger UI update when text changes
    });


  }

  void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
  @override
  void dispose() {
    accountNumController.dispose();
    super.dispose();
  }
  void showInSnackBar(String value) {
    var snackBar =
    SnackBar(
      content: Text(value,
          style:GoogleFonts.inter(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700
          )
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchCustName() async {

    final provider =
    Provider.of<AgentCustomerDetailsProvider>(context, listen: false);

    await provider.getAgentCustomerDetails("361");

    if (!mounted) return; // ✅ Prevent setState if widget is disposed

    setState(() {
      agentCustomerDetailsModel = provider.agentCustomerDetailsModel;
    });
  }

  Future<void> fetchCustDetails() async {
    showProgressDialog(context);
    final provider = Provider.of<DueListProvider>(context, listen: false);
    await provider.getDueList(accountNumController.text, "2025-03-25");

    print("DUELIST : ${provider.dueListModel!.duesList!.data}");

    if (provider.dueListModel?.duesList?.data?.isEmpty == true) {
      Navigator.pop(context);
      showInSnackBar("No results found!");
    } else {
      setState(() {
        if (duesList?.data?.isNotEmpty == true) {
          print("Clearing existing due list...");
          duesList?.data?.clear();
        }
        duesList = provider.dueListModel?.duesList;

        // 🔹 Trim input for safe comparison
        String data = accountNumController.text.trim();

        if (agentCustomerDetailsModel?.customerList?.data != null) {
          print("Searching for account number: $data");

          for (agent.Datum customer in agentCustomerDetailsModel!.customerList!.data!) {
            print("Checking customer account: ${customer.accNo}");

            if (customer.accNo?.trim() == data) {  // 🔹 Ensure trimming
              Navigator.pop(context);
              print("✅ Match found! Updating values.");

              accno = customer.accNo.toString();
              name = customer.custName.toString();
              type = "RD";

              break; // Exit loop after finding a match
            }else{
             // Navigator.pop(context);
            }
          }
        } else {
          Navigator.pop(context);
          print("❌ agentCustomerDetailsModel.customerList.data is null");
        }
      });
    }
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
          _buildInfoRow("Customer Name", name),
          _buildInfoRow("Account Number", accno),
          _buildInfoRow("Account Status", "Active"),
          // _buildInfoRow("Mobile doubleber", _getLastThreeDigits(widget.phNumber)),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Today's Collection Box
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: deepTeal,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: black.withOpacity(0.25),
                    )
                  ],
                  border: Border.all(color: black, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    "Today's Collection : Rs.10,000",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Search Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: white,
                        border: Border.all(color: deepTeal, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: deepTeal),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.start,
                                controller: accountNumController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      if(accountNumController.text.length == 8){
                                        fetchCustDetails();
                                       // accountNumController.clear();
                                      }else{
                                        null;
                                      }
                                    },
                                    child: accountNumController
                                                .text.length ==
                                            8
                                        ? const Icon(
                                            Icons.arrow_forward_outlined)
                                        : SizedBox(),
                                  ), // Show only if condition is met
                                  border: InputBorder.none,
                                  hintText: "Enter Account Number",
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      var page =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchFilterPage(),
                        ),
                      );
                      if (page != null) {
                        print("Selected Account Number: $page"); // ✅ Use accNo here
                        setState(() {
                          accountNumController.text = page;
                          fetchCustDetails();
                        });
                      }
                    },
                    child: const Icon(Icons.search, color: deepTeal, size: 40),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              duesList?.data !=null?
              _buildCustomerInfo():const SizedBox(),

              const SizedBox(height: 15),
              duesList?.data !=null?
              Expanded(
                child: ListView.builder(
                  itemCount: duesList!.data!.length,
                  // Update with actual data count
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white,
                        border: Border.all(color: deepTeal, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due amount: Rs. ${duesList!.data![index].dueAmount}",
                              style: _infoTextStyle(),
                            ),
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
                                        checkedItems[index] = value ?? false;
                                        updateTotalAmount();
                                      });
                                    },
                                    activeColor: teal700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Due date: ${duesList!.data![index].dueMonth}",
                              style: _infoTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ):const SizedBox(),

            ],
          ),
        ),
      ),
      bottomNavigationBar:
      checkedItems.contains(true) ?
      _buildBottomBar() : null,
    );
  }

/*  Widget build(BuildContext context) {

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
                    child:
                    Padding(
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
            ),
            Column(
              children: [
                //_buildCustomerInfo(),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount:1,
                    // provider.dueListModel!.duesList!.data!.length,
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
                                //  "Due amount: Rs.${provider.dueListModel!.duesList!.data![index].dueAmount}",
                                  "Due amount: Rs. ",
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
                                  "Due date: ",
                                  // "Due date: ${provider.dueListModel!.duesList!.data![index].dueMonth}",
                                  style: _infoTextStyle()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ));

  }*/
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
                        payAbleAmount: amountController.text, accountNumber: '', agentId: '',
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
