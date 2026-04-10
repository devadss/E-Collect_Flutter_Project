import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/alerts.dart';
import '../../core/utils.dart';
import '../../data/provider/cash_transcation_provider.dart';
import '../../data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../account_dues/widgets/rdcl_account_due_detail_page.dart';
import '../profile/widgets/recipect_page.dart';
import '../qr_code/widgets/generate_qr_code_page.dart';

class RdclDueListBlocPage extends StatefulWidget {
  final String branchCode;
  const RdclDueListBlocPage({super.key, required this.branchCode});

  @override
  State<RdclDueListBlocPage> createState() => _RdclDueListBlocPageState();
}


class _RdclDueListBlocPageState extends State<RdclDueListBlocPage> {



  final List<bool> _showDrops = [false];
  final List<bool> _isSelected = [false];
  final List<bool> _itemSelected = [false];
  bool didSearch = false;
  String? agentPhoneNumber;
  String? subagentPhoneNumber;
  String? agentName;
  String? agentEmail;
  String? corpCode;
  String? branchCode;
  String? subagentId;
  String? agentOriginId;
  String? agentId;
  String? paymentSessionId;
  String? subAgentCodeNew;
   bool _showSendIcon = false;
  String? token;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadSharedPrefs() async {
    final prefs = SharedPref();

    final name = await prefs.getParentAgentName();
    final id = await prefs.getAgentId();
    final originId = await prefs.getSubAgentCode();
    final subAgentID = await prefs.getSubAgentId();
    final code = await prefs.getCorpCode();
    final brCode = await prefs.getBranchCode();
    final email = await prefs.getEmail();
    final number = await prefs.getParentAgentMobNum();
    final tok = await prefs.getTokenValue();
    final subAgentCodeNewVal = await prefs.getSubAgentCodeNew();
    final subagentNum = await prefs.getSubAgentMobNum();

    if (!mounted) return;

    setState(() {
      agentName = name;
      agentId = id;
      agentOriginId = originId;
      subagentId = subAgentID;
      corpCode = code;
      branchCode = brCode;
      agentEmail = email;
      agentPhoneNumber = number;
      token = tok;
      subAgentCodeNew = subAgentCodeNewVal;
      subagentPhoneNumber = subagentNum;
    });
  }




  Future<void> getCashTrans(
      {required String? token,
        required String? customerName,
        required String? custPhoneNumber,
        required String? custAcNumber,
        required String? custId,
        required String? custEmail,
        required String? amount,
        required String? phoneNumber,
        required String? entityId,
        required String? note}) async
  {
    final cashPaymentProvider =
    Provider.of<CashTranscationProvider>(context, listen: false);
    final cash = await cashPaymentProvider.getTranscations(
        agentName: agentName,
        agentId: agentId,
        agentOriginId: agentOriginId,
        agentPhone: phoneNumber,
        agentEmail: agentEmail,
        subAgentId: subagentId,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: custAcNumber,
        customerId: custId,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: subAgentCodeNew, collectionType: 'RDCL');
    cash.fold((err) {
      Navigator.pop(context);
      //print("getCashTrans $err");
    }, (success) {
      Navigator.pop(context);
      // print("getCashTrans $success");
      showDialog(
        context: context,
        builder: (context) => TransactionSuccessDialog(
          success: success,
          onViewReceipt: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  amount: success.amount.toString(),
                  bankName: getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
                  agentName: agentName ?? "Name",
                  agentPhone: agentPhoneNumber ?? "agentPhone",
                  custName: customerName!,
                  custPhone: custPhoneNumber!,
                  custId: custId!,
                  txnId: success.transactionId.toString(),
                  txnType: "CASH", dat: '',
                ),
              ),
            );
          },
        ),
      );
    });
  }
  Future<void> getPaymentSessionId(
      {required String? token,
        required String? customerName,
        required String? custPhoneNumber,
        required String? custAcNumber,
        required String? custId,
        required String? custEmail,
        required String? amount,
        required String? phoneNumber,
        required String? entityId,
        required String? note,
        required String? subAgentBranchCode})
  async {
    showProgressDialog(context);
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
        agentOriginId: agentOriginId,
        agentEmail: agentEmail,
        customerName: customerName,
        customerPhone: custPhoneNumber,
        customerAccno: custAcNumber,
        customerId: custId,
        customerEmail: custEmail,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        amount: amount,
        agentPhone: agentPhoneNumber,
        agentId: agentId,
        note: "Payment For Agent $agentName",
        subAgentId: subagentId,
        agentName: agentName,
        subAgentBranchCode: subAgentBranchCode, collectionType: 'RDCL');
    paymentSession.fold((error) {

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
            builder: (context) => NewQrCodePage(
              paymentSessionId: paymentSessionId!,
              amount: amount ?? "",
              token: token!,
              custName: customerName ?? "custName",
              custPhone: custPhoneNumber ?? "custNumber",
              custId: custId ?? "CustId",
            ),
          ),
        );
        if (!mounted) return;
        if (result == "fetch_balance") {
          // Navigator.pop(context);
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);

        showToast(message: "Session id is null", color: black);
      }
    });
  }
  @override
  void initState() {
    super.initState();
    context.read<RdclDuelistBloc>().add(RdclDueListFetchEvent("", widget.branchCode, "", ""));
    loadSharedPrefs();
  }
  Future<bool> paymentConfirmation(
      BuildContext context,
      String name,
      String accNo,
      String custId,
      String amt,
      )
  async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Payment Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Do you wish to proceed with the payment?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false); // 🚫 User said NO
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: home1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: home1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          getCashTrans(
                            token: token,
                            customerName: name,
                            custPhoneNumber: "",
                            custAcNumber: accNo,
                            custId: custId,
                            custEmail: "",
                            phoneNumber: "$agentPhoneNumber",
                            entityId: agentId,
                            note: "Payment For Agent $agentName",
                            amount: amt,
                          );
                          Navigator.pop(context, true); // ✅ User confirmed
                          Navigator.pop(context, true); // ✅ User confirmed
                          showProgressDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // default to false if dismissed
  }
bool chekValue(String value){
    if(int.tryParse(value)==null){
      return false;
    }else{
      return true;
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "RDCL-Due List",
          style: TextStyle(
              color: home1, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade200,
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Colors.grey.shade300),
            //   ),
            //   child: TextField(
            //     controller: searchController,
            //     onChanged: (value) {
            //       setState(() {
            //         _showSendIcon = value.isNotEmpty;
            //       });
            //     },
            //     style: TextStyle(fontSize: 16),
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "Search by name",
            //       hintStyle: TextStyle(color: Colors.grey.shade500),
            //
            //       prefixIcon: Icon(Icons.search, color: Colors.grey),
            //
            //       suffixIcon: _showSendIcon
            //           ? Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           // Clear button
            //           InkWell(
            //             onTap: () {
            //               searchController.clear();
            //               setState(() {
            //                 _showSendIcon = false;
            //                 didSearch = false;
            //               });
            //               context.read<RdclDuelistBloc>().add(
            //                 RdclDueListFetchEvent("", widget.branchCode, "", ""),
            //               );
            //             },
            //             child: Icon(Icons.close, color: home1),
            //           ),
            //
            //           SizedBox(width: 8),
            //
            //           // Search button
            //           InkWell(
            //             onTap: () {
            //               final text = searchController.text;
            //
            //               setState(() {
            //                 didSearch = true;
            //               });
            //
            //               if (chekValue(text)) {
            //                 context.read<RdclDuelistBloc>().add(
            //                   RdclDueListFetchEvent("", widget.branchCode, text, ""),
            //                 );
            //               } else {
            //                 context.read<RdclDuelistBloc>().add(
            //                   RdclDueListFetchEvent("", widget.branchCode, "", text),
            //                 );
            //               }
            //             },
            //             child: Icon(Icons.send, color: home1),
            //           ),
            //
            //           SizedBox(width: 8),
            //         ],
            //       )
            //           : null,
            //     ),
            //   ),
            // )
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    _showSendIcon = value.isNotEmpty;
                  });
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  hintText: "Search by name...",
                  hintStyle: TextStyle(

                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),

                  /// SEARCH ICON
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade500,
                  ),

                  /// ACTIONS
                  suffixIcon: _showSendIcon
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// CLEAR
                      GestureDetector(
                        onTap: () {
                          searchController.clear();
                          setState(() {
                            _showSendIcon = false;
                            didSearch = false;
                          });

                          context.read<RdclDuelistBloc>().add(
                            RdclDueListFetchEvent(
                                "", widget.branchCode, "", ""),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      /// SEND
                      GestureDetector(
                        onTap: () {
                          final text = searchController.text;

                          setState(() {
                            didSearch = true;
                          });

                          if (chekValue(text)) {
                            context.read<RdclDuelistBloc>().add(
                              RdclDueListFetchEvent(
                                  "", widget.branchCode, text, ""),
                            );
                          } else {
                            context.read<RdclDuelistBloc>().add(
                              RdclDueListFetchEvent(
                                  "", widget.branchCode, "", text),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: home1,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),
                    ],
                  )
                      : null,
                ),
              ),
            )
          ),
          BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
            builder: (BuildContext context, RdclDuelistState state) {

              if(state is RdclDueListLoaderState){
                return Expanded(child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: home1,),
                      SizedBox(height: 10,),
                      Text("Loading")
                    ],
                  ),
                ));
              }

              if(state is RdclDueListFailState){
                return Center(child: Text("No Result Found"),);
              }
              if(state is RdclDueListSuccessState){
                for(int x =0; x < state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data.length; x++){
                  _showDrops.add(false);
                  _isSelected.add(false);
                  _itemSelected.add(false);

                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelected[index] == false) {
                              _isSelected[index] = true;
                              _showDrops[index] = true;

                            } else {
                              _itemSelected[index] =false;
                              _isSelected[index] = false;
                              _showDrops[index] = false;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                         /* Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: home1.withAlpha(30),
                                      blurRadius: 8,
                                      spreadRadius: 3)
                                ],
                                border: Border.all(color: home1.withAlpha(50)),
                                borderRadius: BorderRadius.circular(16),
                                color:
                                _itemSelected[index]== true?home1.withAlpha(10):

                                Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withAlpha(30),
                                            borderRadius: BorderRadius.circular(10)
                                          )
                                          ,
                                          child: Icon(Icons.account_balance, color: Colors.green,)),
                                       SizedBox(width: 10,),
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                         Text(
                                           "Account Number",
                                           style: TextStyle(
                                               color: Colors.grey,
                                               fontWeight: FontWeight.w700, fontSize: 12),
                                         ),
                                         Container(
                                           padding: EdgeInsets.all(5),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(10),
                                               color: home1.withAlpha(10)
                                           ),
                                           child: Text(
                                             state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].accNo??"001",
                                             style: TextStyle(
                                               fontSize: 17,
                                                 color: home1,
                                                 fontWeight: FontWeight.w700),
                                           ),
                                         ),
                                       ],),
                                      Spacer(flex: 1,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Due",
                                            style: TextStyle(fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(10)
                                              ,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange.shade50)
                                              ,child: Text(
                                            state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueAmount.toString() ?? "", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.orange, fontSize: 17),))
                                          // Row(children: [
                                          //   Container(
                                          //       padding: EdgeInsets.all(10)
                                          //       ,
                                          //       decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.circular(10),
                                          //           color: Colors.blue.shade50
                                          //       ),
                                          //       child: Icon(Icons.attach_money, color: Colors.blue,)),
                                          //   SizedBox(width: 10,),
                                          //
                                          // ],),
                                        ],
                                      ),


                                     // Spacer(flex: 1,),
                                      _showDrops[index] == false
                                          ? Icon(
                                        Icons
                                            .arrow_drop_down_sharp,
                                        color: home2,
                                      )
                                          : Icon(
                                        Icons.arrow_drop_up_outlined,
                                        color: home2,
                                      )

                                    ],

                                  ),
                                  // SizedBox(
                                  //   height: 3,
                                  // ),
                                  // Text(
                                  //   "Total Due",
                                  //   style: TextStyle(
                                  //       color: Colors.grey,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                 // SizedBox(height: 5,),

                                  //   SizedBox(height: 10,),
                                 // Divider(),
                                  _showDrops[index] == true
                                      ? Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Installment : ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueInstallments??"001"}",
                                          style: TextStyle(

                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700),
                                             ),
                                      Checkbox(
                                          activeColor: home1,
                                          checkColor: Colors.white,
                                          value: (_itemSelected[index]),
                                          onChanged: (value) {
                                            setState(() {
                                              _itemSelected[index] = value!;
                                            });
                                            if(_itemSelected[index]== true){
                                              double modalSelectedAmount = state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueAmount??0.0;
                                              final controller =
                                              TextEditingController(
                                                text: modalSelectedAmount
                                                    .toStringAsFixed(2),
                                              );
                                              String selectedMethod =
                                                  "Cash"; // Default selection
                                              showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                  top: Radius.circular(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                                backgroundColor: white,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder: (
                                                        context,
                                                        setModalState,
                                                        ) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          top: 20,
                                                          left: 20,
                                                          right: 20,
                                                          bottom: MediaQuery.of(
                                                            context,
                                                          )
                                                              .viewInsets
                                                              .bottom +
                                                              20,
                                                        ),
                                                        child:
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                        10,
                                                                      ),
                                                                      border:
                                                                      Border
                                                                          .all(
                                                                        color:
                                                                        black54,
                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    // selectedMethod == "Link"
                                                                    //     ? Image.asset(
                                                                    //         "assets/icons/web-link.png",
                                                                    //         scale:
                                                                    //             12,
                                                                    //         color:
                                                                    //             home2,
                                                                    //       )
                                                                    //            :
                                                                    selectedMethod ==
                                                                        "QR Code"
                                                                        ? Image
                                                                        .asset(
                                                                      "assets/icons/qr-code.png",
                                                                      scale: 12,
                                                                      color: home2,
                                                                    )
                                                                        : Image
                                                                        .asset(
                                                                      "assets/images/rupee_6414183.png",
                                                                      scale: 10,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        FittedBox(
                                                                          fit:BoxFit.scaleDown,
                                                                          child: Text(
                                                                            "Collect Payment Using",
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                            style: GoogleFonts
                                                                                .inter(
                                                                              fontWeight:
                                                                              FontWeight.w500,
                                                                              color:
                                                                              black87,
                                                                              fontSize:
                                                                              15,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          selectedMethod,
                                                                          overflow:
                                                                          TextOverflow.ellipsis,
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                            fontWeight:
                                                                            FontWeight.w700,
                                                                            color:
                                                                            black,
                                                                            fontSize:
                                                                            15,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                        context:
                                                                        context,
                                                                        backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                        shape:
                                                                        const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                24),
                                                                          ),
                                                                        ),
                                                                        builder:
                                                                            (ctx) =>
                                                                            Container(
                                                                              padding: const EdgeInsets
                                                                                  .symmetric(
                                                                                  vertical:
                                                                                  16),
                                                                              child:
                                                                              Column(
                                                                                mainAxisSize:
                                                                                MainAxisSize.min,
                                                                                children: [
                                                                                  // drag handle
                                                                                  Container(
                                                                                    width: 40,
                                                                                    height: 5,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.grey.shade300,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 16),
                                                                                  // ListTile(
                                                                                  //   leading: const Icon(Icons.link, color: Colors.blueAccent),
                                                                                  //   title: const Text(
                                                                                  //     "Link",
                                                                                  //     style: TextStyle(
                                                                                  //       fontWeight: FontWeight.w600,
                                                                                  //       fontSize: 16,
                                                                                  //     ),
                                                                                  //   ),
                                                                                  //   trailing: const Icon(Icons.chevron_right),
                                                                                  //   onTap: () {
                                                                                  //     setModalState(() => selectedMethod = "Link");
                                                                                  //     Navigator.pop(ctx);
                                                                                  //   },
                                                                                  // ),
                                                                                  const Divider(
                                                                                      indent: 16,
                                                                                      endIndent: 16),
                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.qr_code, color: Colors.green),
                                                                                    title: const Text(
                                                                                      "QR Code",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: const Icon(Icons.chevron_right),
                                                                                    onTap: () {
                                                                                      //print("selected method = $selectedMethod");
                                                                                      setModalState(() => selectedMethod = "QR Code");
                                                                                      Navigator.pop(ctx);
                                                                                    },
                                                                                  ),
                                                                                  const Divider(
                                                                                      indent: 16,
                                                                                      endIndent: 16),
                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.money, color: Colors.deepOrange),
                                                                                    title: const Text(
                                                                                      "Cash",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: const Icon(Icons.chevron_right),
                                                                                    onTap: () {
                                                                                      //print("selected method = $selectedMethod");
                                                                                      setModalState(() => selectedMethod = "Cash");
                                                                                      Navigator.pop(ctx);
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 12),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                      );
                                                                    },
                                                                    child: FittedBox(
                                                                      fit: BoxFit.scaleDown,
                                                                      child: Text(
                                                                        "Change Method >",
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                          decorationColor:
                                                                          home2,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                          color:
                                                                          home2,
                                                                          fontSize:
                                                                          12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              const FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child:  Text(
                                                                  "Installment Details",
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    color: home2,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Text(
                                                                "Open Dates: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].openDate.toString().substring(0,11)}",
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              Text(
                                                                // "Paid Installments: ${provider.rdclDueUnderAgentModel?.data[index].paidInstallments}",
                                                                "Paid Installments: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].paidInstallments}",
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                "Edit Total Selected Amount",
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color:
                                                                  grey[800],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                controller,
                                                                keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                                  decimal: true,
                                                                  signed: true,
                                                                ),
                                                                decoration:
                                                                InputDecoration(
                                                                  filled: true,
                                                                  fillColor:
                                                                  home2,
                                                                  border:
                                                                  OutlineInputBorder(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                      10,
                                                                    ),
                                                                    borderSide:
                                                                    const BorderSide(
                                                                      color:
                                                                      deepTeal,
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                  OutlineInputBorder(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                      10,
                                                                    ),
                                                                    borderSide:
                                                                    const BorderSide(
                                                                      color:
                                                                      deepTeal,
                                                                      width: 1.5,
                                                                    ),
                                                                  ),
                                                                  contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                    14,
                                                                    vertical: 12,
                                                                  ),
                                                                  prefixIcon:
                                                                  const Icon(
                                                                    Icons
                                                                        .currency_rupee,
                                                                    color: white,
                                                                  ),
                                                                ),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  color: white,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              CustomSliderButton(
                                                                  token: token ??"",
                                                                  label:
                                                                  "Slide to Collect Using $selectedMethod",
                                                                  backgroundColor:
                                                                  home2,
                                                                  buttonColor:
                                                                  Colors.white,
                                                                  onConfirmed: () async {
                                                                    if (selectedMethod == "Cash") {
                                                                      bool confirmed = await paymentConfirmation(
                                                                        context,
                                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name.toString(),
                                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo,
                                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId,

                                                                        controller.text,
                                                                      );

                                                                      if (!confirmed) {
                                                                        // User cancelled the confirmation
                                                                        return;
                                                                      }
                                                                    } else {
                                                                      //print("Selected QR");
                                                                      // ✅ This runs only after confirmation (or if non-cash method)
                                                                      getPaymentSessionId(
                                                                        token: token,
                                                                        customerName:state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name,
                                                                        custPhoneNumber: "",
                                                                        custAcNumber: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo,
                                                                        custId:state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId,
                                                                        custEmail: "",
                                                                        phoneNumber: "$agentPhoneNumber",
                                                                        entityId: agentId,
                                                                        note: "Payment For Agent $agentName",
                                                                        amount: controller.text,
                                                                        subAgentBranchCode: subAgentCodeNew,
                                                                      );
                                                                    }


                                                                  }

                                                                *//*  onConfirmed:
                                                                  () async {
                                                                // selectedMethod ==
                                                                //         "Link"
                                                                //     ? sendLinkFunction(
                                                                //         provider.rdclDueUnderAgentModel!.data[
                                                                //             index],
                                                                //         controller
                                                                //             .text)
                                                                //     :

                                                                selectedMethod ==
                                                                            "Cash"
                                                                        ?
                                                                        paymentConfirmation(
                                                                            context,
                                                                            due
                                                                                .name,
                                                                            due
                                                                                .accNo,
                                                                            due
                                                                                .custId,
                                                                            controller
                                                                                .text)
                                                                        // getCashTrans(
                                                                        //             token:
                                                                        //                 token,
                                                                        //             //customerName: provider.rdclDueUnderAgentModel?.data[index].name,
                                                                        //             customerName:
                                                                        //                 due.name,
                                                                        //             custPhoneNumber:
                                                                        //                 "",
                                                                        //             // custAcNumber: provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                                        //             custAcNumber:
                                                                        //                 due.accNo,
                                                                        //             //custId: provider.rdclDueUnderAgentModel?.data[index].custId,
                                                                        //             custId:due.custId,
                                                                        //
                                                                        //             custEmail:
                                                                        //                 "",
                                                                        //             phoneNumber:
                                                                        //                 "$agentPhoneNumber",
                                                                        //             entityId:
                                                                        //                 agentId,
                                                                        //             note:
                                                                        //                 "Payment For Agent $agentName",
                                                                        //             amount:
                                                                        //                 controller.text,
                                                                        //           )
                                                                        : print(
                                                                            "Selecetd QR");
                                                                getPaymentSessionId(
                                                                  token: token,
                                                                  // customerName: provider.rdclDueUnderAgentModel?.data[index].name,
                                                                  customerName:
                                                                      due.name,
                                                                  custPhoneNumber:
                                                                      "",
                                                                  //custAcNumber: provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                                  custAcNumber:
                                                                      due.accNo,
                                                                  // custId: provider.rdclDueUnderAgentModel?.data[index].custId,
                                                                  custId: due
                                                                      .custId,
                                                                  custEmail: "",
                                                                  phoneNumber:
                                                                      "$agentPhoneNumber",
                                                                  entityId:
                                                                      agentId,
                                                                  note:
                                                                      "Payment For Agent $agentName",
                                                                  amount:
                                                                      controller
                                                                          .text,
                                                                  subAgentBranchCode:
                                                                      subAgentCodeNew,
                                                                );
                                                              },*//*
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          })
                                    ],
                                  )
                                      : SizedBox.shrink(),
                                  _showDrops[index] == true
                                      ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100.withAlpha(30))
                                                ,child: Icon(Icons.person, color: Colors.blueAccent,)),
                                            SizedBox(width: 10,),

                                            Text("Name", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),),
                                            Spacer(flex: 1,),
                                            Text(state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].name??"001")
                                          ],
                                         ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50),
                                        child: Divider(),
                                      )
                                    ],
                                  )

                                      : SizedBox.shrink(),
                                  _showDrops[index] == true
                                      ?
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.cyan.shade100.withAlpha(30))
                                              ,child: Icon(Icons.date_range, color: Colors.cyan,)),
                                          SizedBox(width: 10,),
                                          Text("Open Date",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey)),
                                          Spacer(flex: 1,),
                                          Text("${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].openDate.toString().substring(0,11)??"001"}")
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50),
                                        child: Divider(),
                                      )
                                    ],
                                  )
                                      : SizedBox.shrink(),
                                  _showDrops[index] == true
                                      ?
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text("Installment Details", style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700),),
                                      ):SizedBox.shrink(),
                                  _showDrops[index] == true
                                      ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepPurpleAccent.shade100.withAlpha(30))
                                          ,child: Icon(Icons.date_range, color: Colors.deepPurpleAccent,)),
                                      SizedBox(width: 10,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey.shade100),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Paid Installment", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 12),),
                                            Text("${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].paidInstallments??"001"}",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 1,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.grey.shade100),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Due Installment",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 12)),
                                            Text("${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueInstallments??"001"}",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 1,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey.shade100),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Total",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 12)),
                                            Text("${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].totalInstallment??"001"}",style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                      : SizedBox.shrink(),

                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _itemSelected[index] == true ? home1.withAlpha(8) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _itemSelected[index] == true ? home1.withAlpha(40) : Colors.grey.withAlpha(30),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(8),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showDrops[index] = !_showDrops[index];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header Row
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: home1.withAlpha(12),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Icon(
                                                Icons.account_balance_wallet_outlined,
                                                color: home1,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Account Number",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey.shade600,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].accNo ?? "001",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w700,
                                                      color: home1,
                                                      letterSpacing: -0.3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total Due",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withAlpha(12),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.currency_rupee,
                                                        size: 16,
                                                        color: Colors.orange.shade700,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueAmount.toString() ?? "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.orange.shade700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            AnimatedRotation(
                                              duration: const Duration(milliseconds: 200),
                                              turns: _showDrops[index] ? 0.5 : 0,
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.grey.shade600,
                                                size: 24,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Expanded Details
                                        if (_showDrops[index]) ...[
                                          const SizedBox(height: 16),
                                          Divider(color: Colors.grey.shade200, height: 1),
                                          const SizedBox(height: 16),

                                          // Customer Name Row
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueAccent.withAlpha(12),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Icon(Icons.person_outline, color: Colors.blueAccent, size: 18),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Customer Name",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                child: Text(
                                                  overflow: TextOverflow.clip,
                                                  state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].name ?? "N/A",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Open Date Row
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.cyan.withAlpha(12),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Icon(Icons.calendar_today_outlined, color: Colors.cyan, size: 18),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Open Date",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].openDate.toString().substring(0, 11) ?? "N/A",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Divider(color: Colors.grey.shade200, height: 1),
                                          const SizedBox(height: 16),

                                          // Installment Details Header
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurpleAccent.withAlpha(12),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Icon(Icons.receipt_outlined, color: Colors.deepPurpleAccent, size: 18),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Installment Details",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Installment Stats Row
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withAlpha(8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Paid",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].paidInstallments?.toString() ?? "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.green.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withAlpha(8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Due",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueInstallments?.toString() ?? "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.orange.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey.withAlpha(8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Total",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].totalInstallment?.toString() ?? "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.blueGrey.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Divider(color: Colors.grey.shade200, height: 1),
                                          const SizedBox(height: 16),

                                          // Payment Selection Row
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Select for payment",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _itemSelected[index] = !_itemSelected[index];
                                                  });
                                                  if (_itemSelected[index] == true) {
                                                    double modalSelectedAmount = state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].dueAmount ?? 0.0;
                                                    final controller = TextEditingController(text: modalSelectedAmount.toStringAsFixed(2));
                                                    String selectedMethod = "Cash";

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                                      ),
                                                      backgroundColor: Colors.white,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context, setModalState) {
                                                            return Padding(
                                                              padding: EdgeInsets.only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20,
                                                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                                                              ),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Container(
                                                                    width: 40,
                                                                    height: 4,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey.shade300,
                                                                      borderRadius: BorderRadius.circular(2),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 20),

                                                                  // Payment Method Row
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height: 60,
                                                                        width: 60,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(color: Colors.black54, width: 1),
                                                                        ),
                                                                        child: selectedMethod == "QR Code"
                                                                            ? Image.asset(
                                                                          "assets/icons/qr-code.png",
                                                                          scale: 12,
                                                                          color: home2,
                                                                        )
                                                                            : Image.asset(
                                                                          "assets/images/rupee_6414183.png",
                                                                          scale: 10,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: Text(
                                                                                "Collect Payment Using",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black87,
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              selectedMethod,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 8),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          showModalBottomSheet(
                                                                            context: context,
                                                                            backgroundColor: Colors.white,
                                                                            shape: const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                                                            ),
                                                                            builder: (ctx) => Container(
                                                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 40,
                                                                                    height: 5,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.grey.shade300,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 16),
                                                                                  const Divider(indent: 16, endIndent: 16),
                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.qr_code, color: Colors.green),
                                                                                    title: const Text(
                                                                                      "QR Code",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: const Icon(Icons.chevron_right),
                                                                                    onTap: () {
                                                                                      setModalState(() => selectedMethod = "QR Code");
                                                                                      Navigator.pop(ctx);
                                                                                    },
                                                                                  ),
                                                                                  const Divider(indent: 16, endIndent: 16),
                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.money, color: Colors.deepOrange),
                                                                                    title: const Text(
                                                                                      "Cash",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: const Icon(Icons.chevron_right),
                                                                                    onTap: () {
                                                                                      setModalState(() => selectedMethod = "Cash");
                                                                                      Navigator.pop(ctx);
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 12),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: FittedBox(
                                                                          fit: BoxFit.scaleDown,
                                                                          child: Text(
                                                                            "Change Method >",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: GoogleFonts.inter(
                                                                              decoration: TextDecoration.underline,
                                                                              decorationColor: home2,
                                                                              fontWeight: FontWeight.w800,
                                                                              color: home2,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 15),

                                                                  const FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text(
                                                                      "Installment Details",
                                                                      style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: home2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 12),

                                                                  Text(
                                                                    "Open Dates: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].openDate.toString().substring(0, 11)}",
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  Text(
                                                                    "Paid Installments: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].paidInstallments}",
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  const SizedBox(height: 20),

                                                                  Text(
                                                                    "Edit Total Selected Amount",
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey[800],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),

                                                                  TextFormField(
                                                                    controller: controller,
                                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: home2,
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        borderSide: const BorderSide(color: deepTeal),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        borderSide: const BorderSide(color: deepTeal, width: 1.5),
                                                                      ),
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                                      prefixIcon: const Icon(Icons.currency_rupee, color: Colors.white),
                                                                    ),
                                                                    style: const TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 20),

                                                                  CustomSliderButton(
                                                                    token: token ?? "",
                                                                    label: "Slide to Collect Using $selectedMethod",
                                                                    backgroundColor: home2,
                                                                    buttonColor: Colors.white,
                                                                    onConfirmed: () async {
                                                                      if (selectedMethod == "Cash") {
                                                                        bool confirmed = await paymentConfirmation(
                                                                          context,
                                                                          state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name.toString(),
                                                                          state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo,
                                                                          state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId,
                                                                          controller.text,
                                                                        );
                                                                        if (!confirmed) return;
                                                                      } else {
                                                                        getPaymentSessionId(
                                                                          token: token,
                                                                          customerName: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name,
                                                                          custPhoneNumber: "",
                                                                          custAcNumber: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo,
                                                                          custId: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId,
                                                                          custEmail: "",
                                                                          phoneNumber: "$agentPhoneNumber",
                                                                          entityId: agentId,
                                                                          note: "Payment For Agent $agentName",
                                                                          amount: controller.text,
                                                                          subAgentBranchCode: subAgentCodeNew,
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: _itemSelected[index] ? home1 : Colors.grey.shade100,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        _itemSelected[index] ? Icons.check_circle : Icons.circle_outlined,
                                                        size: 18,
                                                        color: _itemSelected[index] ? Colors.white : Colors.grey.shade600,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        _itemSelected[index] ? "Selected" : "Select",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: _itemSelected[index] ? Colors.white : Colors.grey.shade700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return SizedBox.shrink();


            },
          )
        ],
      ),
    );
  }
}

class CustomSliderButton extends StatefulWidget {
  final Future<void> Function() onConfirmed;
  final String label;
  final Color backgroundColor;
  final Color buttonColor;
  final String token;

  const CustomSliderButton({
    super.key,
    required this.onConfirmed,
    required this.label,
    required this.backgroundColor,
    required this.buttonColor,
    required this.token,
  });

  @override
  State<CustomSliderButton> createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;

    return Container(
      width: width,
      height: 70,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: widget.buttonColor.withOpacity(0.25),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragPosition += details.delta.dx;
                  _dragPosition = _dragPosition.clamp(0.0, width - 70);
                });
              },
              onHorizontalDragEnd: (_) async {
                if (_dragPosition > (width - 70) * 0.5) {
                  setState(() {
                    _isConfirmed = true;
                    _dragPosition = width - 70;
                  });

                  await widget.onConfirmed();

                  setState(() {
                    _dragPosition = 0.0;
                    _isConfirmed = false;
                  });
                } else {
                  setState(() {
                    _dragPosition = 0.0;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: Tween(
                        begin: 0.75,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                    child: Image.asset(
                      "assets/icons/arrow.png",
                      key: const ValueKey('arrow-icon'),
                      scale: 20,
                      color: home2,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
