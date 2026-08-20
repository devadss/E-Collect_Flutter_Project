import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/alerts.dart';
import '../../../core/utils.dart';
import '../../../data/provider/cash_transcation_provider.dart';
import '../../../data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../paymentlink_request_ui.dart';
import '../../profile/widgets/recipect_page.dart';
import '../../qr_code/widgets/generate_qr_code_page.dart';
//sdsd
class RdclDueDetailBlocPage extends StatefulWidget {
  final String branchCode;
  const RdclDueDetailBlocPage({super.key, required this.branchCode});

  @override
  State<RdclDueDetailBlocPage> createState() => RdclDueDetailBlocPageState();
}

class RdclDueDetailBlocPageState extends State<RdclDueDetailBlocPage> {
  final List<bool> _showDrops = [false];
  final List<bool> _isSelected = [false];
  final List<bool> _itemSelected = [false];
  bool didSearch = false;
  String? eCollectAgentNumber;
  String? subagentPhoneNumber;
  String? eCollectMerchantName;
  String? eCollectAgentEmail;
  String? eCollectCollectionType;
  String? eCollectAgentBranchCode;
  String? eCollectAgentMerchantID;
  String? eCollectAgentOriginId;
  String? eCollectAgentId;
  String? paymentSessionId;
  String? subAgentCodeNew;
  String? eCollectToken;
  String selectedMethod ="";
  bool _showSendIcon = false;
  String? token;
  TextEditingController searchController = TextEditingController();
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadSharedPrefs() async {
    final result  = await Future.wait([
      SharedPref.shared.getECollectMerchantName(),
      SharedPref.shared.getECollectUserID(),
      SharedPref.shared.getECollectUserID(),
      SharedPref.shared.getECollectUserNumber(),
      SharedPref.shared.getECollectUserEmail(),
      SharedPref.shared.getECollectMerchantBranchCode(),
      SharedPref.shared.getECollectMerchantID(),
      SharedPref.shared.getECollectUserType(),
      SharedPref.shared.getTokenValue(),
      SharedPref.shared.getECollectUserToken(),
    ]);
    if(!mounted) return;
    context.read<RdclDuelistBloc>().add(RdclDueListFetchEvent("", widget.branchCode, "", "",'1', '10'));

    //-------------------------------------
    eCollectMerchantName = result[0];
    eCollectAgentId = result[1];
    eCollectAgentOriginId = result[2];
    eCollectAgentNumber = result[3];
    eCollectAgentEmail = result[4];
    eCollectAgentBranchCode = result[5];
    eCollectAgentMerchantID = result[6];
    eCollectCollectionType = result[7];
    token = result[8];
    eCollectToken = result[9];
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
      required String? note})
  async {
    final cashPaymentProvider =
        Provider.of<CashTranscationProvider>(context, listen: false);
    final cash = await cashPaymentProvider.getTranscations(
        agentName: eCollectMerchantName,
        agentId: eCollectAgentId,
        agentOriginId: eCollectAgentOriginId,
        agentPhone: phoneNumber,
        agentEmail: eCollectAgentEmail,
        subAgentId: eCollectAgentMerchantID,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: custAcNumber,
        customerId: custId,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: eCollectCollectionType,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: subAgentCodeNew,
        collectionType: 'RDCL');
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
            var receiptModel = ReceiptDataModel(
              amount: success.amount.toString(),
              bankName: getBankNameFromCorpCode(eCollectCollectionType!) ??
                  "XYZ BANK",
              agentName: eCollectMerchantName ?? "Name",
              agentPhone: eCollectAgentNumber ?? "agentPhone",
              custName: customerName!,
              custPhone: custPhoneNumber!,
              custId: custId!,
              txnId: success.transactionId.toString(),
              txnType: "CASH",
              dat: '',
              tranType: '',
              accNo: '',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  receiptDataModel: receiptModel,
                ),
              ),
            );
          },
        ),
      );
    });
  }


  @override
  void initState() {
    super.initState();
    loadSharedPrefs();

  }

  Future<bool> paymentConfirmation(
    BuildContext context,
    String name,
    String accNo,
    String custId,
    String amt,
  ) async {
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
                  color: Colors.black.withValues(alpha: 0.2),
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
                      color: Colors.redAccent.withValues(alpha: 0.1),
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
                            phoneNumber: "$eCollectAgentNumber",
                            entityId: eCollectAgentId,
                            note: "Payment For Agent $eCollectMerchantName",
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

  bool chekValue(String value) {
    if (int.tryParse(value) == null) {
      return false;
    } else {
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
          //"RDCL-Due List",
          "Due List",
          style: TextStyle(
              color: home1, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
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
                                            "", widget.branchCode, "", "",'1', '10'),
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
                                              "", widget.branchCode, text, "", '0', '0'),
                                        );
                                  } else {
                                    context.read<RdclDuelistBloc>().add(
                                          RdclDueListFetchEvent(
                                              "", widget.branchCode, "", text,'0', '0'),
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
              )),
          BlocBuilder<RdclDuelistBloc, RdclDuelistState>(
            builder: (BuildContext context, RdclDuelistState state) {
              if (state is RdclDueListLoaderState) {
                return Expanded(
                    child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: home1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Loading")
                    ],
                  ),
                ));
              }

              if (state is RdclDueListFailState) {
                return Center(
                  child: Text("No Result Found"),
                );
              }
              if (state is RdclDueListSuccessState) {
                for (int x = 0;
                    x <
                        state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data.length;
                    x++) {
                  _showDrops.add(false);
                  _isSelected.add(false);
                  _itemSelected.add(false);
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: state.rdclDulistSuccess.rdclduesListSuccessModel
                        .rdclDuesList1?.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (_isSelected[index] == false) {
                              _isSelected[index] = true;
                              _showDrops[index] = true;
                            } else {
                              _itemSelected[index] = false;
                              _isSelected[index] = false;
                              _showDrops[index] = false;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 8),
                            decoration: BoxDecoration(
                              color: _itemSelected[index] == true
                                  ? home1.withAlpha(8)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _itemSelected[index] == true
                                    ? home1.withAlpha(40)
                                    : Colors.grey.withAlpha(30),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header Row
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(7),
                                              decoration: BoxDecoration(
                                                color: home1.withAlpha(12),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .account_balance_wallet_outlined,
                                                color: home1,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Account Number",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey.shade600,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    state
                                                            .rdclDulistSuccess
                                                            .rdclduesListSuccessModel
                                                            .rdclDuesList1
                                                            ?.data[index]
                                                            .accNo ??
                                                        "001",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: home1,
                                                      letterSpacing: -0.3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withAlpha(12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.currency_rupee,
                                                        size: 16,
                                                        color: Colors
                                                            .orange.shade700,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        state
                                                                .rdclDulistSuccess
                                                                .rdclduesListSuccessModel
                                                                .rdclDuesList1
                                                                ?.data[index]
                                                                .dueAmount
                                                                .toString() ??
                                                            "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors
                                                              .orange.shade700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            AnimatedRotation(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              turns:
                                                  _showDrops[index] ? 0.5 : 0,
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
                                          const SizedBox(height: 5),
                                          Divider(
                                              color: Colors.grey.shade200,
                                              height: 1),
                                          const SizedBox(height: 5),

                                          // Customer Name Row
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueAccent
                                                      .withAlpha(12),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                    Icons.person_outline,
                                                    color: Colors.blueAccent,
                                                    size: 18),
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
                                                  state
                                                          .rdclDulistSuccess
                                                          .rdclduesListSuccessModel
                                                          .rdclDuesList1
                                                          ?.data[index]
                                                          .name ??
                                                      "N/A",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Divider(
                                            color: Colors.grey.shade200,
                                          ),
                                          // Open Date Row
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.cyan.withAlpha(12),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    color: Colors.cyan,
                                                    size: 18),
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
                                                state
                                                        .rdclDulistSuccess
                                                        .rdclduesListSuccessModel
                                                        .rdclDuesList1
                                                        ?.data[index]
                                                        .openDate
                                                        .toString()
                                                        .substring(0, 11) ??
                                                    "N/A",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Divider(
                                              color: Colors.grey.shade200,
                                              height: 1),
                                          const SizedBox(height: 5),

                                          // Installment Details Header
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurpleAccent
                                                      .withAlpha(12),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                    Icons.receipt_outlined,
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                    size: 18),
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
                                          const SizedBox(height: 5),

                                          // Installment Stats Row
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withAlpha(35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Paid",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state
                                                                .rdclDulistSuccess
                                                                .rdclduesListSuccessModel
                                                                .rdclDuesList1
                                                                ?.data[index]
                                                                .paidInstallments
                                                                .toString() ??
                                                            "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors
                                                              .green.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withAlpha(35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Due",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state
                                                                .rdclDulistSuccess
                                                                .rdclduesListSuccessModel
                                                                .rdclDuesList1
                                                                ?.data[index]
                                                                .dueInstallments
                                                                .toString() ??
                                                            "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors
                                                              .orange.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey
                                                        .withAlpha(35),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Total",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state
                                                                .rdclDulistSuccess
                                                                .rdclduesListSuccessModel
                                                                .rdclDuesList1
                                                                ?.data[index]
                                                                .totalInstallment
                                                                .toString() ??
                                                            "0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.blueGrey
                                                              .shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Divider(
                                              color: Colors.grey.shade200,
                                              height: 1),
                                          const SizedBox(height: 10),

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
                                                    _itemSelected[index] =
                                                        !_itemSelected[index];
                                                  });
                                                  if (_itemSelected[index] ==
                                                      true) {
                                                    double modalSelectedAmount = state
                                                            .rdclDulistSuccess
                                                            .rdclduesListSuccessModel
                                                            .rdclDuesList1
                                                            ?.data[index]
                                                            .dueAmount ??
                                                        0.0;
                                                    controller =
                                                        TextEditingController(
                                                            text: modalSelectedAmount
                                                                .toStringAsFixed(
                                                                    2));
                                                     selectedMethod =
                                                        "Cash";

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        24)),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setModalState) {
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20,
                                                                bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom +
                                                                    20,
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    width: 40,
                                                                    height: 4,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),

                                                                  // Payment Method Row
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              home2.withAlpha(50),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          // border: Border.all(color: Colors.black54, width: 1),
                                                                        ),
                                                                        child: selectedMethod ==
                                                                                "QR Code"
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
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: Text(
                                                                                "Collect Payment Using",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.inter(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black87,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Divider(),
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
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            shape:
                                                                                const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                                                            ),
                                                                            builder: (ctx) =>
                                                                                Container(
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
                                                                                    leading: const Icon(Icons.currency_rupee_rounded, color: Colors.deepOrange),
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

                                                                                  const Divider(indent: 16, endIndent: 16),

                                                                                  /// UNCOMMENT AFTER PAYMENT LINK LIVE....
                                                                                  // uatTestMobileNumber.replaceAll("+91", "") != subagentPhoneNumber?.replaceAll("+91", "")?

                                                                                  ListTile(
                                                                                    leading: const Icon(Icons.link, color: Colors.deepOrange),
                                                                                    title: const Text(
                                                                                      "Link",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    trailing: const Icon(Icons.chevron_right),
                                                                                    onTap: () {
                                                                                      setModalState(() => selectedMethod = "Link");
                                                                                      Navigator.pop(ctx);
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 12),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(10),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(16),
                                                                                // color: home2.withAlpha(40)
                                                                                color: Colors.white),
                                                                            child:
                                                                                Text(
                                                                              // "",
                                                                              "Change Method > ",
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
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  Divider(),
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Text(
                                                                      "Installment Details",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            home2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),

                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Text(
                                                                      "Open Date: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].openDate.toString().substring(0, 11)}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Text(
                                                                      "Paid Installments: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[index].paidInstallments} Nos",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  Divider(),
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child: Text(
                                                                      "Edit Total Selected Amount",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            home2,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  TextFormField(
                                                                    controller:
                                                                        controller,
                                                                    keyboardType: const TextInputType
                                                                        .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          grey.shade200,
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        // borderSide: const BorderSide(color: deepTeal, width: 1.5),
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              14,
                                                                          vertical:
                                                                              12),
                                                                      prefixIcon: const Icon(
                                                                          Icons
                                                                              .currency_rupee,
                                                                          color:
                                                                              home2),
                                                                    ),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),

                                                                  CustomSliderButton(
                                                                    token:
                                                                        token ??
                                                                            "",
                                                                    label:
                                                                        "Slide to Collect Using $selectedMethod",
                                                                    backgroundColor:
                                                                        home1,
                                                                    buttonColor:
                                                                        Colors
                                                                            .white,
                                                                    onConfirmed:
                                                                        () async {
                                                                      if (selectedMethod ==
                                                                          "Cash") {
                                                                        bool
                                                                            confirmed =
                                                                            await paymentConfirmation(
                                                                          context,
                                                                          state
                                                                              .rdclDulistSuccess
                                                                              .rdclduesListSuccessModel
                                                                              .rdclDuesList1!
                                                                              .data[index]
                                                                              .name
                                                                              .toString(),
                                                                          state
                                                                              .rdclDulistSuccess
                                                                              .rdclduesListSuccessModel
                                                                              .rdclDuesList1!
                                                                              .data[index]
                                                                              .accNo,
                                                                          state
                                                                              .rdclDulistSuccess
                                                                              .rdclduesListSuccessModel
                                                                              .rdclDuesList1!
                                                                              .data[index]
                                                                              .custId,
                                                                          controller
                                                                              .text,
                                                                        );
                                                                        if (!confirmed) {
                                                                          return;
                                                                        }
                                                                      } else if (selectedMethod == "Link") {
                                                                        context.read<PaymentBloc>().add(QrPaymentEvent(QrPaymentRequestModel(
                                                                            agentDetails: AgentDetails(agentName: eCollectMerchantName!,
                                                                                agentId: eCollectAgentOriginId!, agentOrginId: eCollectAgentId!, agentPhone: eCollectAgentNumber!, agentEmail: eCollectAgentEmail!, agentBranch: int.parse(eCollectAgentBranchCode!)),
                                                                            customerDetails: CustomerDetails(customerName: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name, customerPhone: eCollectAgentNumber!, customerAccno: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo, customerId: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId, customerEmail: eCollectAgentEmail!),
                                                                            collectionType: eCollectCollectionType!,
                                                                            amount: double.parse(controller.text),
                                                                            note: 'Payment for Order',
                                                                            qrSource: 'MOB',
                                                                            source: 'COLLECTION',
                                                                            merchantId: int.parse(eCollectAgentMerchantID!)),eCollectToken!));

                                                                      } else {
                                                                        print(
                                                                            "QR API CALL");

                                                                        context.read<PaymentBloc>().add(QrPaymentEvent(QrPaymentRequestModel(
                                                                            agentDetails: AgentDetails(agentName: eCollectMerchantName!, agentId: eCollectAgentOriginId!, agentOrginId: eCollectAgentId!, agentPhone: eCollectAgentNumber!, agentEmail: eCollectAgentEmail!, agentBranch: int.parse(eCollectAgentBranchCode!)),
                                                                            customerDetails: CustomerDetails(customerName: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].name, customerPhone: eCollectAgentNumber!, customerAccno: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].accNo, customerId: state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1!.data[index].custId, customerEmail: eCollectAgentEmail!),
                                                                            collectionType: eCollectCollectionType!,
                                                                            amount: double.parse(controller.text),
                                                                            note: 'Payment for Order',
                                                                            qrSource: 'MOB',
                                                                            source: 'COLLECTION',
                                                                            merchantId: int.parse(eCollectAgentMerchantID!)),eCollectToken!));
                                                                            //merchantId: 1)));
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: _itemSelected[index]
                                                        ? home1
                                                        : Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        _itemSelected[index]
                                                            ? Icons.check_circle
                                                            : Icons
                                                                .circle_outlined,
                                                        size: 18,
                                                        color:
                                                            _itemSelected[index]
                                                                ? Colors.white
                                                                : Colors.grey
                                                                    .shade600,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        _itemSelected[index]
                                                            ? "Selected"
                                                            : "Select",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: _itemSelected[
                                                                  index]
                                                              ? Colors.white
                                                              : Colors.grey
                                                                  .shade700,
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
          ),
          BlocListener<PaymentBloc, PaymentState>(
            listener: (BuildContext context, PaymentState state) {
              if (state is QrPaymentLoaderState) {
                showProgressDialog(context);
              }
              if (state is QrPaymentSuccessState) {
                Navigator.pop(context);
                print(state.qrPaymentSuccess.paymentResponseSuccess.paymentUrl);
                selectedMethod == "Link"
                    ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PaymentLinkRequestUi(
                              customerMobileNumber: "",
                              paymentLink: state.qrPaymentSuccess
                                  .paymentResponseSuccess.paymentUrl,
                            )))
                    : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewQrCodePage(
                      paymentSessionId: state.qrPaymentSuccess
                          .paymentResponseSuccess.paymentUrl,
                      amount: controller.text,
                      custName: "",
                      custPhone: "custNumber",
                      custId: "CustId",
                    ),
                  ),
                );
              } else if (state is QrPaymentFailState) {
                Navigator.pop(context);
                showAlertDialog(
                    state.qrPaymentFail.paymentFailResponse.message, context);
                print(state.qrPaymentFail.paymentFailResponse.message);
              } else if (state is CashPaymentSuccessState) {
                Navigator.pop(context);
                showAlert(
                    state.cashPaymentSuccess.cashPaymentSuccessResponse
                        .status ==
                        "Y"
                        ? "SUCCESS"
                        : "FAILED",
                    state.cashPaymentSuccess.cashPaymentSuccessResponse.message,
                    context);
                print(state
                    .cashPaymentSuccess.cashPaymentSuccessResponse.message);
              } else if (state is CashPaymentFailState) {
                Navigator.pop(context);
                print(state.cashPaymentFail.payemtError);
              }
            },
            child: SizedBox(),
          ),

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
  bool isConfirmed = false;

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
              highlightColor: widget.buttonColor.withValues(alpha: 0.25),
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
                    isConfirmed = true;
                    _dragPosition = width - 70;
                  });

                  await widget.onConfirmed();

                  setState(() {
                    _dragPosition = 0.0;
                    isConfirmed = false;
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
