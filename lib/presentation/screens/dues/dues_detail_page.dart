import 'dart:io';
import 'package:collection_qr_flutter/presentation/screens/dues/qr/qr_code_home_page.dart';
import 'package:collection_qr_flutter/presentation/screens/dues/qr/qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/colors.dart';
import '../../../core/general.dart';
import '../../../data/provider/create_order_provider_new.dart';
import '../../../data/provider/due_list_provider.dart';
import '../../../data/repository/payment_link_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/due_list_model.dart';

class DuesDetailPage extends StatefulWidget {
  final String custName;
  final String custAcNumber;
  final String custPhoneNumber;
  final String custId;

  const DuesDetailPage({
    super.key,
    required this.custName,
    required this.custAcNumber,
    required this.custPhoneNumber,
    required this.custId,
  });

  @override
  State<DuesDetailPage> createState() => _DuesDetailPageState();
}

class _DuesDetailPageState extends State<DuesDetailPage> {
  List<bool> checkedItems = List.generate(10, (index) => false);
  TextEditingController amountController = TextEditingController();
  num previousCheckboxTotal = 0;
  DateTime? _dateTime;
  String? agentId;
  String? agentOriginId;
  String? agentMobile;
  String? agentName;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? customerNumber;
  String? sessionid;
  String? customerAccountNumber;
  String? corpCode;
  String? token;
  double maxValue = 0;

  void updateTotalAmount() {
    final provider = Provider.of<DueListProvider>(context, listen: false);

    int manualAmount =
        int.tryParse(amountController.text) ?? 0; // Preserve manual input
    int checkboxTotal = 0;
    final duesData = provider.dueListModel?.duesList?.data;
    if (duesData != null) {
      for (Datum amt in duesData) {
        maxValue += double.parse(amt.dueAmount.toString());
      }
    }
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

  String _getLastThreeDigits(String phoneNumber) {
    return phoneNumber.length >= 3
        ? "*** *** ${phoneNumber.substring(phoneNumber.length - 3)}"
        : phoneNumber;
  }



  Future<void> createOrderNew() async {
    final createOrderNewProvider = Provider.of<CreateOrderProviderNew>(context , listen :false);
    await createOrderNewProvider.createOrderNew(double.tryParse(amountController.text).toString(),
      widget.custPhoneNumber.toString(), widget.custId.toString(), "");
    if(createOrderNewProvider.paymentGatewayOrderResponseModel != null){
   setState(() {
     sessionid = createOrderNewProvider.paymentGatewayOrderResponseModel!.paymentSessionId.toString();
   });
    }
  }

  void _proceedButtonClick() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Proceed Confirmation", style: _labelTextStyle()),
          content: Text(
            "Select the Payment Mode to proceed with the total amount of Rs. ${amountController
                .text}?",
            style: _valueTextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QrCodePage(amount: amountController.text,
                            token: token.toString(),
                            custName: widget.custName,
                            custAcNumber: widget.custAcNumber,
                            custPhoneNumber: widget.custPhoneNumber,
                            custId:widget.custId,
                            custEmail: "testuser@gmail.com", sessionid: sessionid.toString(),

                          )),
                );
              },
              child: Text("Qr Code", style: _valueTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                sendLinkFunction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teal700,
                foregroundColor: white,
              ),
              child: const Text('Send Link'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        agentName!,
        agentId!,
        agentOriginId!,
        agentMobile!,
        agentEmail!,
        widget.custName,
        widget.custPhoneNumber,
        widget.custAcNumber,
        "rahul.sharma@example.com",
        widget.custId,
        num.parse(amountController.text),
        "Payment for Order #12345",
        corpCode!,
        "",
        token.toString()
      // "John Doe",
      // "AGT12345",
      // "ORG98765",
      // "+919876543210",
      // "agent@example.com",
      // "Rahul Sharma",
      // "+919123456789",
      // "123456789012",
      // "rahul.sharma@example.com",
      // "CUS12345",
      // num.parse(amountController.text),
      // "Payment for Order #12345",
      // "CORP001",
      // "CARD98765",
    );

    send.fold(
          (error) {
        printLog("-------------------ERROR---------------------");
        printLog(error);
      },
          (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          Share.share("Here is your payment link: ${sendLink.linkUrl}");
        } else {
          printLog("Payment link is empty or null");
        }
      },
    );
  }

  @override
  void initState() {
    loadSharedPrefs();
    _dateTime = DateTime.now();
    printLog(
        "--------------------------------DATE TIME--------------------------");
    printLog(_dateTime);
    final provider = Provider.of<DueListProvider>(context, listen: false);
    provider.getDueList(widget.custAcNumber, "2025-03-25");
    createOrderNew();
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final phone = await SharedPref().getMobNum();
    final agentid = await SharedPref().getAgentId();
    final agentOrigin = await SharedPref().getAgentOriginId();
    final mail = await SharedPref().getEmail();
    final corp = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();

    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        agentName = name;
        agentMobile = phone;
        agentId = agentid;
        agentOriginId = agentOrigin;
        agentEmail = mail;
        corpCode = corp;
        token = tok;
      });
    }
  }

  void onAmountChanges(String amount) {
    if (amount.isNotEmpty) {
      double? amountValue = double.parse(amount);
      if (amountValue > maxValue) {
        amountController.value = TextEditingValue(
          text: maxValue.toStringAsFixed(2), // Format to avoid extra zeros
          selection: TextSelection.collapsed(offset: maxValue
              .toString()
              .length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: deepTeal,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new,
              color: white),
        ),
        centerTitle: true,
        backgroundColor: deepTeal,
        title: Text(
          "Due Details",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, fontSize: 22, color: white),
        ),
      ),
      body: Consumer<DueListProvider>(builder: (context, provider, child) {
        return provider.dueListModel == null
            ? const CircularProgressIndicator(color: deepTeal)
            : Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    border: Border.all(color: black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                          spreadRadius: 0,
                          color: white.withOpacity(0.25))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Customer Name", widget.custName),
                    _buildInfoRow("Account Number", widget.custAcNumber),
                    _buildInfoRow("Account Status", "Active"),
                    _buildInfoRow("Mobile Number",
                        _getLastThreeDigits(widget.custPhoneNumber)),
                  ],
                ),
              ),
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
                          Border.all(color: black, width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Due amount: Rs.${provider.dueListModel!
                                    .duesList!.data![index].dueAmount}",
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
                                      print("checked Items : $checkedItems");
                                      if (checkedItems.contains(true)) {
                                        // Show the bottom sheet if it's not open
                                        _showBottomBar(context);
                                      } else {
                                        // Close the bottom sheet when all checkboxes are unchecked
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    activeColor: teal700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                "Due date: ${provider.dueListModel!.duesList!
                                    .data![index].dueMonth}",
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
      // bottomNavigationBar:
      ///  bottomNavigationBar: checkedItems.contains(true) ? _showBottomBar(context) : null,
      // checkedItems.contains(true) ? _buildBottomBar() : null,
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
          _buildInfoRow("Customer Name", widget.custName),
          _buildInfoRow("Account Number", widget.custAcNumber),
          _buildInfoRow("Account Status", "Active"),
          _buildInfoRow(
              "Mobile Number", _getLastThreeDigits(widget.custPhoneNumber)),
        ],
      ),
    );
  }

  Future<void> _showBottomBar(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Moves up when keyboard appears
      enableDrag: false,
      // Prevents accidental swipe down
      backgroundColor: Colors.transparent,
      // Allows clicking outside
      builder: (context) =>
          GestureDetector(
            onTap: () {}, // Prevents closing when tapping outside
            behavior: HitTestBehavior.opaque,
            child: StatefulBuilder(
              builder: (context, setStateModal) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
                  child: _buildBottomBar(setStateModal), // Pass state updater
                );
              },
            ),
          ),
    );
  }


  Widget _buildBottomBar(StateSetter setStateModal) {
    return SingleChildScrollView(
      reverse: true, // Moves content up when keyboard opens
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [white, white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                  cursorColor: white,
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: grey, width: 1),
                    ),
                    filled: true,
                    fillColor: deepTeal,
                  ),
                  onChanged: onAmountChanges,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _proceedButtonClick,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
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
          Expanded(flex: 3, child: Text(value, style: _labelTextStyle())),
        ],
      ),
    );
  }

  TextStyle _labelTextStyle() =>
      GoogleFonts.inter(
          fontWeight: FontWeight.w600, fontSize: 16, color: black);

  TextStyle _valueTextStyle() =>
      GoogleFonts.inter(
          fontWeight: FontWeight.w500, fontSize: 16, color: black87);

  TextStyle _infoTextStyle() =>
      GoogleFonts.inter(
          fontWeight: FontWeight.w500, fontSize: 14, color: black87);

  TextStyle _bottomTextStyle() =>
      GoogleFonts.inter(
          fontWeight: FontWeight.w600, fontSize: 16, color: black);
}
