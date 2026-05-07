// import '../../core/colors.dart';
// import '../../core/general.dart';
// import '../../data/provider/due_list_provider.dart';
// import '../../data/repository/payment_link_repository.dart';
// import '../../presentation/qr_code/qr_code_home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../../data/storage/shared_pref_helper.dart';
//
// class DuesDetailPage extends StatefulWidget {
//   final String custName;
//   final String custAcNumber;
//   final String custPhoneNumber;
//   final String custId;
//   const DuesDetailPage({
//     super.key,
//     required this.custName,
//     required this.custAcNumber,
//     required this.custPhoneNumber,
//     required this.custId,
//   });
//
//   @override
//   State<DuesDetailPage> createState() => _DuesDetailPageState();
// }
//
// class _DuesDetailPageState extends State<DuesDetailPage> {
//   List<bool> checkedItems = List.generate(10, (index) => false);
//   TextEditingController amountController = TextEditingController();
//   num previousCheckboxTotal = 0;
//   DateTime? _dateTime;
//   String? agentId;
//   String? agentOriginId;
//   String? agentMobile;
//   String? agentName;
//   String? agentEmail;
//   String? customerEmail;
//   String? customerName;
//   String? customerNumber;
//   String? customerAccountNumber;
//   String? corpCode;
//
//   void updateTotalAmount() {
//     final provider = Provider.of<DueListProvider>(context, listen: false);
//
//     int manualAmount =
//         int.tryParse(amountController.text) ?? 0; // Preserve manual input
//     int checkboxTotal = 0;
//
//     // Calculate the sum of selected due amounts
//     for (int i = 0; i < checkedItems.length; i++) {
//       if (checkedItems[i]) {
//         // Convert dueAmount to int safely
//         checkboxTotal +=
//             (provider.dueListModel!.duesList!.data![i].dueAmount as num)
//                 .toInt();
//       }
//     }
//
//     // Reset manual input if all checkboxes are unchecked
//     if (checkboxTotal == 0) {
//       manualAmount = 0;
//       previousCheckboxTotal = 0;
//     }
//
//     num newTotal = checkboxTotal +
//         (manualAmount - previousCheckboxTotal); // Maintain manual edits
//     previousCheckboxTotal =
//         checkboxTotal; // Store last calculated checkbox total
//
//     setState(() {
//       amountController.text = newTotal.toString();
//     });
//   }
//
//   String _getLastThreeDigits(String phoneNumber) {
//     return phoneNumber.length >= 3
//         ? "*** *** ${phoneNumber.substring(phoneNumber.length - 3)}"
//         : phoneNumber;
//   }
//
//   void _proceedButtonClick() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Proceed Confirmation", style: TextStyle(fontWeight: FontWeight.w700,color: black,fontSize: 18)),
//           content: Text(
//             "Select the Payment Mode to proceed with the total amount of Rs. ${amountController.text}?",
//             style: _valueTextStyle(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => QrCodeHomePage(
//                             payAbleAmount: amountController.text, accountNumber: '', agentId: '',
//                           )),
//                 );
//               },
//               child: Text("QR Code", style: _valueTextStyle()),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 sendLinkFunction();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: teal700,
//                 foregroundColor: white,
//               ),
//               child: const Text("Send Link"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> sendLinkFunction() async {
//     final send = await PaymentLinkRepository().getPaymentLink(
//         agentName!,
//         agentId!,
//         agentOriginId!,
//         agentMobile!,
//         agentEmail!,
//         widget.custName,
//         widget.custPhoneNumber,
//         widget.custAcNumber,
//         "rahul.sharma@example.com",
//         widget.custId,
//         num.parse(amountController.text),
//         "Payment for Order #12345",
//         corpCode!,
//         ""
//         // "John Doe",
//         // "AGT12345",
//         // "ORG98765",
//         // "+919876543210",
//         // "agent@example.com",
//         // "Rahul Sharma",
//         // "+919123456789",
//         // "123456789012",
//         // "rahul.sharma@example.com",
//         // "CUS12345",
//         // num.parse(amountController.text),
//         // "Payment for Order #12345",
//         // "CORP001",
//         // "CARD98765",
//         );
//
//     send.fold(
//       (error) {
//         print("-------------------ERROR---------------------");
//         print(error);
//       },
//       (sendLink) {
//         if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
//           Share.share("Here is your payment link: ${sendLink.linkUrl}");
//         } else {
//           print("Payment link is empty or null");
//         }
//       },
//     );
//   }
//
//   @override
//   @override
//   void initState() {
//     super.initState();
//     loadSharedPrefs();
//     _dateTime = DateTime.now();
//
//     print(
//         "--------------------------------DATE TIME--------------------------");
//     print(_dateTime);
//     // Format today's date as 'YYYY-MM-DD'
//     String todayDate = "${_dateTime?.year}-${_dateTime?.month.toString().padLeft(2, '0')}-${_dateTime?.day.toString().padLeft(2, '0')}";
//     print("--------------------------TODAYS DATE----------------------------");
//     print(todayDate);
//
//     final provider = Provider.of<DueListProvider>(context, listen: false);
//     provider.getDueList(widget.custAcNumber, todayDate);
//   }
//
//   // void initState() {
//   //   loadSharedPrefs();
//   //   _dateTime = DateTime.now();
//   //   print(
//   //       "--------------------------------DATE TIME--------------------------");
//   //   print(_dateTime);
//   //   final provider = Provider.of<DueListProvider>(context, listen: false);
//   //   provider.getDueList(widget.custAcNumber, "2025-03-25");
//   //   super.initState();
//   // }
//
//   Future<void> loadSharedPrefs() async {
//     final name = await SharedPref().getAgentName();
//     final phone = await SharedPref().getMobNum();
//     final agentid = await SharedPref().getAgentId();
//     final agentOrigin = await SharedPref().getAgentOriginId();
//     final mail = await SharedPref().getEmail();
//     final corp = await SharedPref().getCorpCode();
//
//     // Trigger rebuild after fetching the userName
//     if (mounted) {
//       setState(() {
//         agentName = name;
//         agentMobile = phone;
//         agentId = agentid;
//         agentOriginId = agentOrigin;
//         agentEmail = mail;
//         corpCode = corp;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: white,
//         title: Text(
//           "Due Details",
//           style: TextStyle(
//               fontWeight: FontWeight.w700, fontSize: 22, color: teal700),
//         ),
//       ),
//       body: Consumer<DueListProvider>(builder: (context, provider, child) {
//         return provider.dueListModel == null
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: deepTeal,
//                 ),
//               )
//             : Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: Column(
//                   children: [
//                     _buildCustomerInfo(),
//                     const SizedBox(height: 15),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount:
//                             provider.dueListModel!.duesList!.data!.length,
//                         itemBuilder: (_, index) {
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: white,
//                                 border:
//                                     Border.all(color: deepTeal, width: 0.5)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       "Due amount: Rs.${provider.dueListModel!.duesList!.data![index].dueAmount}",
//                                       style: _infoTextStyle()),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     children: [
//                                       Text("Loan type: RD",
//                                           style: _infoTextStyle()),
//                                       const Spacer(),
//                                       Transform.scale(
//                                         scale: 1.2,
//                                         child: Checkbox(
//                                           value: checkedItems[index],
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               checkedItems[index] = value!;
//                                               updateTotalAmount();
//                                             });
//                                           },
//                                           activeColor: teal700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                       "Due date: ${provider.dueListModel!.duesList!.data![index].dueMonth}",
//                                       style: _infoTextStyle()),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//       }),
//       bottomNavigationBar:
//           checkedItems.contains(true) ? _buildBottomBar() : null,
//     );
//   }
//
//   Widget _buildCustomerInfo() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//        color: deepTeal,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: black, width: 2),
//         boxShadow:  [
//           BoxShadow(
//             color: black.withOpacity(0.25),
//             blurRadius: 10,
//             spreadRadius: 0,
//             offset:const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildInfoRow("Customer Name", widget.custName),
//           _buildInfoRow("Account Number", widget.custAcNumber),
//           _buildInfoRow("Account Status", "Active"),
//           _buildInfoRow(
//               "Mobile Number", _getLastThreeDigits(widget.custPhoneNumber)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomBar() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.15,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [deepTeal,teal700!, teal500!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 "Total Amount :",
//                 style: _bottomTextStyle(),
//               ),
//             ),
//             SizedBox(
//               width: 120,
//               child: TextField(
//                 controller: amountController,
//                 keyboardType:
//                     const TextInputType.numberWithOptions(decimal: true),
//                 style: const TextStyle(
//                     color: white, fontSize: 16, fontWeight: FontWeight.w700),
//                 textAlign: TextAlign.center,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none
//                   ),
//                   filled: true,
//                   fillColor: teal600!.withOpacity(0.3),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: _proceedButtonClick,
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 backgroundColor: white,
//                 foregroundColor: teal700,
//                 textStyle: TextStyle(
//                     fontWeight: FontWeight.w600, fontSize: 15),
//               ),
//               child: const Text("Proceed"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Expanded(flex: 2, child: Text(label, style: _labelTextStyle())),
//           Text(":", style: _labelTextStyle()),
//           const SizedBox(width: 8),
//           Expanded(flex: 3, child: Text(value, style: _labelTextStyle())),
//         ],
//       ),
//     );
//   }
//
//   TextStyle _labelTextStyle() => TextStyle(
//       fontWeight: FontWeight.w600, fontSize: 16, color: white);
//   TextStyle _valueTextStyle() => TextStyle(
//       fontWeight: FontWeight.w500, fontSize: 16, color: black87);
//   TextStyle _infoTextStyle() => TextStyle(
//       fontWeight: FontWeight.w500, fontSize: 14, color: black87);
//   TextStyle _bottomTextStyle() => TextStyle(
//       fontWeight: FontWeight.w600, fontSize: 16, color: white);
// }

import 'dart:io';
import 'dart:math';
import 'package:collection_qr_flutter/core/alerts.dart';
import 'package:collection_qr_flutter/presentation/paymentlink_request_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/colors.dart';
import '../../../data/provider/due_list_provider.dart';
import '../../../data/provider/transaction_provider.dart';
import '../../../data/repository/payment_link_repository.dart';
import '../../../data/repository/payment_session_id_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../dues/widgets/new_qr_code_page.dart';

class AccountDueDetailsPage extends StatefulWidget {
  final String corpCode;
  final String custName;
  final String custAcNumber;
  final String custPhoneNumber;
  final String custId;
  final String custEmail;

  const AccountDueDetailsPage({
    super.key,
    required this.custName,
    required this.custAcNumber,
    required this.custPhoneNumber,
    required this.custId,
    required this.custEmail, required this.corpCode,
  });

  @override
  State<AccountDueDetailsPage> createState() => _AccountDueDetailsPageState();
}

class _AccountDueDetailsPageState extends State<AccountDueDetailsPage> {
  List<bool> checkedItems = List.generate(10, (index) => false);
  TextEditingController amountController = TextEditingController();
  num previousCheckboxTotal = 0;
  DateTime? _dateTime;
  String? agentId;
  String? subagentId;
  String? agentOriginId;
  String? agentMobile;
  String? agentName;
  String? agentEmail;
  String? customerEmail;
  String? customerName;
  String? customerNumber;
  String? customerAccountNumber;
  String? subAgentCodeNew;
  String? corpCode;
  String? token;
  String? paymentSessionId;
  String orderID = "";

  void updateTotalAmount() {
    final provider = Provider.of<DueListProvider>(context, listen: false);

    int manualAmount = int.tryParse(amountController.text) ?? 0;
    int checkboxTotal = 0;
    int maxDueAmount = 0;

    for (int i = 0; i < provider.dueListModel!.duesList!.data!.length; i++) {
      maxDueAmount +=
          (provider.dueListModel!.duesList!.data![i].dueAmount as num).toInt();
      if (checkedItems[i]) {
        checkboxTotal +=
            (provider.dueListModel!.duesList!.data![i].dueAmount as num)
                .toInt();
      }
    }

    // Ensure manual amount + selected account_dues do not exceed the total possible due
    num newTotal = checkboxTotal + (manualAmount - previousCheckboxTotal);
    previousCheckboxTotal = checkboxTotal;

    if (newTotal > maxDueAmount) {
      newTotal = maxDueAmount; // Restrict max limit
    }

    setState(() {
      amountController.text = newTotal.toString();
    });
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
              onPressed: () async {
                print("--------------------TOKEN---------------------");
                print(token);
                print("---------------------AMOUNT--------------------");
                print(amountController.text);
                print("---------------------PHONENUMBER--------------------");
                print(agentMobile);
                print("---------------------ENTITYID--------------------");
                print(agentId);
                final paymentSession = await CreatePaymentSessionIdRepository()
                    .getPaymentSessionId(
                    agentOriginId
                    :agentOriginId,
                    agentEmail
                    :agentEmail,
                    customerName
                    :widget.custName,
                    customerPhone
                    :widget.custPhoneNumber,
                    customerAccno
                    :widget.custAcNumber,
                    customerId
                    :widget.custId,
                    customerEmail
                    :widget.custEmail,
                    corpCode
                    :widget.corpCode,
                    cardRefNum: "",
                    token: token,
                    amount: amountController.text,
                    agentPhone: agentMobile,
                    agentId: agentId,
                    note: "Payment For Agent $agentName",
                    subAgentId: subagentId,
                    agentName: agentName, subAgentBranchCode: subAgentCodeNew, collectionType: 'RDCL');
                paymentSession.fold((error) {
                  print(
                      "---------------------------------ERROR PAYMENT---------------------------");
                  print(error);
                }, (sessionId) async {
                  paymentSessionId = sessionId.paymentSessionId ?? "";
                  if (paymentSessionId!.isNotEmpty &&
                      paymentSessionId != null &&
                      paymentSessionId != "") {
                    if (!mounted) return;
                    Navigator.pop(context);

                    if (!mounted) return;
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewQrCodePage(
                              paymentSessionId: paymentSessionId!,
                              amount: amountController.text ?? "",
                              token: token!,custName: customerName ?? "custName",
                              custPhone: widget.custPhoneNumber,
                              custId: widget.custId,
                            ),
                      ),
                    );
                    if (!mounted) return;
                    if (result == "fetch_balance") {
                      Navigator.pop(context);
                    }
                  } else {
                    if (!mounted) return;
                    Navigator.pop(context);
                    EasyLoading.showToast("Session id is null");
                  }
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => QrCodePage(
                //             amount: amountController.text,
                //             token: token.toString(),
                //           custName: widget.custName,
                //           custAcNumber: widget.custAcNumber,
                //           custId: widget.custId,
                //           custPhoneNumber: widget.custPhoneNumber,
                //           custEmail: widget.custEmail,
                //         )));
              },
              child: Text("QR Code", style: _valueTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                sendLinkFunction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: home2,
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
       agentName:  agentName!,
      agentId:   agentId!,
      agentOriginId:   agentOriginId!,
       agentPhone:  agentMobile!,
      agentEmail:   agentEmail!,
       customerName:  widget.custName,
      customerPhone:   widget.custPhoneNumber,
      customerAccountNumber:   widget.custAcNumber,
       customerEmail:  widget.custEmail,
       customerId:  widget.custId,
       linkAmount:  num.parse(amountController.text),
       note:  "Payment for Order #12345",
       corpCode:  corpCode!,
       cardRefNum:  "",
       token:  token.toString(),subAgentId:  subagentId!);

    send.fold(
          (error) {
        print("-------------------ERROR---------------------");
        print(error);
      },
          (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          print("1");
          //Share.share("Here is your payment link: ${sendLink.linkUrl}");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>PaymentLinkRequestUi(customerMobileNumber: customerNumber.toString(),
              paymentLink: sendLink.linkUrl.toString())));
        } else {
          print("Payment link is empty or null");
        }
      },
    );
  }

  @override
  void initState() {
    loadSharedPrefs();
    _dateTime = DateTime.now();
    print(
        "--------------------------------DATE TIME--------------------------");
    print(_dateTime);
    // final provider = Provider.of<DueListProvider>(context, listen: false);
    // provider.getDueList(widget.custAcNumber, _dateTime.toString());
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final phone = await SharedPref().getParentAgentMobNum();
    final id = await SharedPref().getAgentId();
    final subAgentID = await SharedPref().getSubAgentId();
    final agentOrigin = await SharedPref().getAgentOriginId();
    final mail = await SharedPref().getEmail();
    final corp = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final sub_AgentCodeNew = await SharedPref.shared.getSubAgentCodeNew();


    // Trigger rebuild after fetching the userName
    if (mounted) {
      setState(() {
        agentName = name;
        agentMobile = phone;
        subagentId = subAgentID;
        agentId = id;
        agentOriginId = agentOrigin;
        agentEmail = mail;
        corpCode = corp;
        token = tok;
        subAgentCodeNew = sub_AgentCodeNew;
      });
    }
    final provider = Provider.of<DueListProvider>(context, listen: false);
    await provider.getDueList(widget.custAcNumber, _dateTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: Platform.isIOS
              ? const Icon(Icons.arrow_back_ios, color: home2)
              : const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Account Due Details",
          style: GoogleFonts.poppins(
            color: home2,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<DueListProvider>(
        builder: (context, provider, child) {
          return provider.dueListModel == null
              ? _buildShimmerEffect()
              : Column(
            children: [
              _buildCustomerInfoCard(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildDueList(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: home2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: home1.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildInfoRow("Customer Name", widget.custName),
          const Divider(height: 20, thickness: 1),
          _buildInfoRow("Account Number", widget.custAcNumber),
          const Divider(height: 20, thickness: 1),
          _buildInfoRow("Mobile", widget.custPhoneNumber),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: home2,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: home1,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (label == "Mobile")
                  IconButton(
                    icon: const Icon(Icons.call, color: home1, size: 20),
                    onPressed: () => _callNumber(value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueList(DueListProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: provider.dueListModel!.duesList!.data!.length,
        itemBuilder: (_, index) {
          final due = provider.dueListModel!.duesList!.data![index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: home1.withOpacity(0.1)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  checkedItems[index] = !checkedItems[index];
                  updateTotalAmount();
                });
                if (checkedItems.contains(true)) {
                  _showBottomBar(context);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child:
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text("Due Amount: ₹${due.dueAmount}",
                              style: GoogleFonts.poppins(
                                color: home1,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: checkedItems[index],
                            onChanged: (bool? value) {
                              setState(() {
                                checkedItems[index] = value!;
                                updateTotalAmount();
                              });
                              if (checkedItems.contains(true)) {
                                _showBottomBar(context);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            activeColor: home1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Loan Type: RD",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Due Date: ${due.dueMonth}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBottomBar(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Amount Due",
                        style: GoogleFonts.poppins(
                          color: home1,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(
                          color: home1,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: const Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: home1.withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: home1.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: home1, width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          int enteredAmount = int.tryParse(value) ?? 0;
                          int maxDueAmount = 0;
              
                          final provider =
                          Provider.of<DueListProvider>(context, listen: false);
                          for (var due in provider.dueListModel!.duesList!
                              .data!) {
                            maxDueAmount += (due.dueAmount as num).toInt();
                          }
              
                          if (enteredAmount > maxDueAmount) {
                            setState(() {
                              amountController.text = maxDueAmount.toString();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: home1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                  color: home1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:(){ 
                                if(amountController.text.isNotEmpty ){
                                  _proceedButtonClick(); 
                                }else{
                                  showToast(
                                      message: "Amount field cannot be empty",
                                      color: Colors.orange
                                  );
                                }
                                },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: home1,
                                foregroundColor: white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Proceed",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    int enteredAmount = int.tryParse(value) ?? 0;
                    int maxDueAmount = 0;

                    final provider =
                    Provider.of<DueListProvider>(context, listen: false);
                    for (var due in provider.dueListModel!.duesList!.data!) {
                      maxDueAmount += (due.dueAmount as num).toInt();
                    }

                    if (enteredAmount > maxDueAmount) {
                      setState(() {
                        amountController.text =
                            maxDueAmount.toString(); // Limit input
                      });
                    }
                  },
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
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (){
                  if(amountController.text.isNotEmpty){
                    _proceedButtonClick();
                  }else{
                    showToast(message: "Amount field cannot be empty", color: Colors.orange);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: white,
                  foregroundColor: teal700,
                  textStyle: const TextStyle(
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

  // Widget _buildInfoRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       children: [
  //         Expanded(flex: 2, child: Text(label, style: _labelTextStyle())),
  //         Text(":", style: _labelTextStyle()),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           flex: 3,
  //           child: Row(
  //             children: [
  //               Text(value, style: _labelTextStyle()),
  //               if (label == "Mobile Number") // Only add button for phone
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                       icon: const Icon(Icons.call, color: Colors.green),
  //                       onPressed: () => _callNumber(value),
  //                     ),
  //                   ],
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _callNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    // Check permission for CALL_PHONE
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        debugPrint("Permission denied for CALL_PHONE");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Call permission is required")),
        );
        return;
      }
    }

    try {
      bool launched =
      await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  Future<void> fetchTransaction() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.fetchTransaction(
        "", "", agentId.toString(), token.toString());
  }

  String formatNumberWithCommas(double? number) {
    final formatter =
    NumberFormat("#,##,##0.00", "en_IN"); // Indian numbering system

    return formatter.format(number ?? 0.0); // Default to 0.0 if number is null
  }

  TextStyle _labelTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);

  TextStyle _valueTextStyle() =>
      const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: black87);

  TextStyle _infoTextStyle() =>
      const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 14, color: black87);

  TextStyle _bottomTextStyle() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: black);
}

String generateRandom12DigitNumber() {
  final random = Random();
  double randomNumber = random.nextDouble();
  int min = 100000000000;
  int max = 999999999999;
  int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
  return scaledNumber.toString();
}

String generateRandom6DigitNumber() {
  final random = Random();
  double randomNumber = random.nextDouble();
  int min = 100000;
  int max = 999999;
  int scaledNumber = (randomNumber * (max - min + 1)).toInt() + min;
  return scaledNumber.toString();
}
