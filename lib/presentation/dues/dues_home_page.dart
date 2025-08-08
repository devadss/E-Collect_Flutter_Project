import '../../core/colors.dart';
import '../../data/provider/due_under_agent_provider.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../presentation/dues/widgets/new_qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/alerts.dart' as EasyLoading;
import '../../data/repository/payment_link_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../domain/model/due_under_agent_model.dart';

class DuesHomePage extends StatefulWidget {
  const DuesHomePage({super.key});

  @override
  State<DuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<DuesHomePage> {
  final Map<String, Map<int, bool>> _checkboxStates = {};
  String? _expandedAccNo;
  String? token;
  String? agentOriginId;
  String? agentId;
  String? subagentId;
  String? agentPhoneNumber;
  String? agentName;
  String? agentEmail;
  String? corpCode;
  String? paymentSessionId;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getParentAgentName();
    final id = await SharedPref().getAgentId();
    final originId = await SharedPref().getAgentOriginId();
    final subAgentID = await SharedPref().getSubAgentId();
    final code = await SharedPref().getCorpCode();
    final email = await SharedPref().getEmail();
    final number = await SharedPref().getParentAgentMobNum();
    final tok = await SharedPref().getTokenValue();
    if (mounted) {
      setState(() {
        subagentId = subAgentID;
        agentName = name;
        agentEmail = email;
        agentId = id;
        agentOriginId = originId;
        corpCode = code;
        agentPhoneNumber = number;
        token = tok;
      });
    }
    final provider = Provider.of<DueUnderAgentProvider>(context, listen: false);
    await provider.getDuesUnderAgent(agentOriginId);
  }

  Future<void> getPaymentSessionId(
      String? token,
      String? customerName,
      String? custPhoneNumber,
      String? custAcNumber,
      String? custId,
      String? custEmail,
      String? amount,String?
      phoneNumber,String?
      entityId,String? note)async{
    print("--------------------TOKEN---------------------");
    print(token);
    print("---------------------AMOUNT--------------------");
    print(amount);
    print("---------------------PHONENUMBER--------------------");
    print(phoneNumber);
    print("---------------------ENTITYID--------------------");
    print(entityId);
    print("---------------------NOTE--------------------");
    print(note);
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
    agentOriginId
        :agentId,
    agentEmail
        :agentEmail,
    customerName
        :customerName,
    customerPhone
        :custPhoneNumber,
    customerAccno
        : custAcNumber,
    customerId
        : custId,
    customerEmail
        : custEmail,
    corpCode
        :corpCode,
    cardRefNum: "",
    token: token,
    amount: amount,
    agentPhone: agentPhoneNumber,
    agentId: agentId,
    note: "Payment For Agent $agentName",
    subAgentId: subagentId,
    agentName: agentName, subAgentBranchCode: '');
    paymentSession.fold(
        (error){
          print("---------------------------------ERROR PAYMENT---------------------------");
          print(error);
        },
        (sessionId)async{
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
                builder:
                    (context) => NewQrCodePage(
                  paymentSessionId: paymentSessionId!,
                  amount: amount ?? "",
                  token: token!,
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
            EasyLoading.showToast(message: "Session id is null",color: black);
          }
        }
    );
  }

  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer.fromColors(
              baseColor: grey[300]!,
              highlightColor: grey[100]!,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  border: Border.all(color: grey[300]!, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: black45,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildShimmerText(width: 150), // Name
                      const SizedBox(height: 10),
                      buildShimmerText(width: 100), // Customer ID
                      const SizedBox(height: 10),
                      buildShimmerText(width: 180), // Account Number
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildShimmerText({
    double width = double.infinity,
    double height = 16,
  }) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500), // Ensures smooth animation
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        centerTitle: true,
        title: const Text(
          "Due List",
          style: TextStyle(
            fontSize: 23,
            color: home2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<DueUnderAgentProvider>(
        builder: (context, provider, child) {
          final data = provider.agentModel?.duesList1?.data ?? [];

          if (provider.agentModel == null) return buildShimmerList();

          final groupedData = <String, List<dynamic>>{};
          for (var due in data) {
            groupedData.putIfAbsent(due.accNo!, () => []).add(due);
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: groupedData.keys.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final accNo = groupedData.keys.elementAt(index);
              final dues = groupedData[accNo]!;
              final totalDue = dues.fold<num>(
                0,
                (sum, item) => sum + (item.dueAmount ?? 0),
              );

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                  border: Border.all(color: home2.withOpacity(0.7), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      color: black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: transparent,
                    highlightColor: transparent,
                    dividerColor: transparent,
                  ),
                  child: ExpansionTile(
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedAccNo = expanded ? accNo : null;
                      });
                    },
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Number",
                          style: TextStyle(
                            fontSize: 13,
                            color: grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accNo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: home1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              size: 18,
                              color: black87,
                            ),
                            Text(
                              "Total Due: ₹$totalDue",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children:
                        dues.asMap().entries.map((entry) {
                          final dueIndex = entry.key;
                          final due = entry.value;

                          _checkboxStates.putIfAbsent(accNo, () => {});
                          _checkboxStates[accNo]!.putIfAbsent(
                            dueIndex,
                            () => false,
                          );

                          final isEnabled =
                              _expandedAccNo == null || _expandedAccNo == accNo;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _checkboxStates[accNo]![dueIndex],
                                  onChanged:
                                      isEnabled
                                          ? (bool? value) {
                                            setState(() {
                                              // Uncheck all other account numbers
                                              _checkboxStates.forEach((
                                                key,
                                                map,
                                              ) {
                                                if (key != accNo) {
                                                  map.updateAll(
                                                    (_, __) => false,
                                                  );
                                                }
                                              });

                                              // Update current checkbox state
                                              _checkboxStates[accNo]![dueIndex] =
                                                  value ?? false;
                                              _expandedAccNo = accNo;
                                            });

                                            // Calculate the selected amount only for current group
                                            num modalSelectedAmount = 0;
                                            final map = _checkboxStates[accNo];
                                            if (map != null) {
                                              map.forEach((i, isChecked) {
                                                if (isChecked) {
                                                  modalSelectedAmount +=
                                                      dues[i].installAmt ?? 0;
                                                }
                                              });
                                            }

                                            final hasAnyChecked =
                                                modalSelectedAmount > 0;

                                            if (!hasAnyChecked) return;

                                            final controller =
                                                TextEditingController(
                                                  text: modalSelectedAmount
                                                      .toStringAsFixed(2),
                                                );

                                            String selectedMethod =
                                                "Link"; // Default selection

                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                        bottom:
                                                            MediaQuery.of(
                                                                  context,
                                                                )
                                                                .viewInsets
                                                                .bottom +
                                                            20,
                                                      ),
                                                      child: SingleChildScrollView(
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
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    border: Border.all(
                                                                      color:
                                                                          black54,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      selectedMethod ==
                                                                              "Link"
                                                                          ? Image.asset(
                                                                            "assets/icons/web-link.png",
                                                                            scale:
                                                                                12,
                                                                            color:
                                                                                home2,
                                                                          )
                                                                          : Image.asset(
                                                                            "assets/icons/qr-code.png",
                                                                            scale:
                                                                                12,
                                                                            color:
                                                                                home2,
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
                                                                      Text(
                                                                        "Collect Payment Using",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              black87,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        selectedMethod,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.inter(
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
                                                                      shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                            20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      builder:
                                                                          (
                                                                            ctx,
                                                                          ) => Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              ListTile(
                                                                                leading: const Icon(
                                                                                  Icons.link,
                                                                                ),
                                                                                title: const Text(
                                                                                  "Link",
                                                                                ),
                                                                                onTap: () {
                                                                                  setModalState(
                                                                                    () =>
                                                                                        selectedMethod =
                                                                                            "Link",
                                                                                  );
                                                                                  Navigator.pop(
                                                                                    ctx,
                                                                                  );
                                                                                },
                                                                              ),
                                                                              ListTile(
                                                                                leading: const Icon(
                                                                                  Icons.qr_code,
                                                                                ),
                                                                                title: const Text(
                                                                                  "QR Code",
                                                                                ),
                                                                                onTap: () {
                                                                                  setModalState(
                                                                                    () =>
                                                                                        selectedMethod =
                                                                                            "QR Code",
                                                                                  );
                                                                                  Navigator.pop(
                                                                                    ctx,
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    "Change Method >",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
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
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            const Text(
                                                              "Installment Details",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: home2,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Text(
                                                              "Open Date: ${due.openDate}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              "Due Month: ${dueMonthValues.reverse[due.dueMonth]}",
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
                                                                  const TextInputType.numberWithOptions(
                                                                    decimal:
                                                                        true,
                                                                    signed:
                                                                        true,
                                                                  ),
                                                              decoration: InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    home2,
                                                                border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                        color:
                                                                            deepTeal,
                                                                      ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                        color:
                                                                            deepTeal,
                                                                        width:
                                                                            1.5,
                                                                      ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          14,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                prefixIcon:
                                                                    const Icon(
                                                                      Icons
                                                                          .currency_rupee,
                                                                      color:
                                                                          white,
                                                                    ),
                                                              ),
                                                              style: const TextStyle(
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
                                                              token: token!,
                                                              label:
                                                                  "Slide to Collect Using $selectedMethod",
                                                              backgroundColor:
                                                                  home2,
                                                              buttonColor:
                                                                  Colors.white,
                                                              onConfirmed: () async {
                                                                // final editedAmount = num.tryParse(controller.text.trim()) ?? 0;
                                                                selectedMethod ==
                                                                        "Link"
                                                                    ? sendLinkFunction(
                                                                      provider
                                                                          .agentModel!
                                                                          .duesList1!
                                                                          .data![index],
                                                                      controller
                                                                          .text,
                                                                    )
                                                                    :getPaymentSessionId(token,
                                                                    provider.agentModel?.duesList1?.data?[index].name,
                                                                    provider.agentModel?.duesList1?.data?[index].phone,
                                                                    provider.agentModel?.duesList1?.data?[index].accNo,
                                                                    provider.agentModel?.duesList1?.data?[index].custId,
                                                                    provider.agentModel?.duesList1?.data?[index].email,
                                                                    controller.text, "$agentPhoneNumber", agentId, "Payment For Agent $agentName");

                                                                    // : Navigator.push(
                                                                    //   context,
                                                                    //   MaterialPageRoute(
                                                                    //     builder:
                                                                    //         (
                                                                    //           context,
                                                                    //         ) => QrCodePage(
                                                                    //           amount:
                                                                    //               controller.text,
                                                                    //           token:
                                                                    //               token!,
                                                                    //           custEmail:
                                                                    //               provider.agentModel?.duesList1?.data?[index].email ??
                                                                    //               "",
                                                                    //           custPhoneNumber:
                                                                    //               provider.agentModel?.duesList1?.data?[index].phone ??
                                                                    //               "phone",
                                                                    //           custId:
                                                                    //               provider.agentModel?.duesList1?.data?[index].custId ??
                                                                    //               "CustID",
                                                                    //           custAcNumber:
                                                                    //               provider.agentModel?.duesList1?.data?[index].accNo ??
                                                                    //               "CustACCNo",
                                                                    //           custName:
                                                                    //               provider.agentModel?.duesList1?.data?[index].name ??
                                                                    //               "NAME",
                                                                    //         ),
                                                                    //   ),
                                                                    // );
                                                                //Navigator.pop(context);
                                                              },
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
                                          : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: home1,
                                        width: 1.5,
                                      ),
                                      color: grey[50],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Installment: ₹${due.installAmt}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Open Date: ${due.openDate}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Due Month: ${dueMonthValues.reverse[due.dueMonth]}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> sendLinkFunction(
    DueUnderAgnet custDetails,
    String amount,
  ) async {
    if (agentName == null ||
        agentId == null ||
        agentOriginId == null ||
        token == null) {
      print("One or more required fields are null.");
      return; // or handle the error appropriately
    }
    final send = await PaymentLinkRepository().getPaymentLink(
      agentName:  agentName!,
     agentId:  agentId!,
     agentOriginId:  agentOriginId!,
     agentPhone:  agentPhoneNumber!,
     agentEmail:  agentEmail!,
     customerName:  custDetails.name!,
     customerPhone:  custDetails.phone!,
     customerAccountNumber:  custDetails.accNo!,
     customerEmail:  custDetails.email!,
     customerId:  custDetails.custId!,
     linkAmount:  num.parse(amount),
     note:  "Payment for Order #1234",
     corpCode:  corpCode!,
     cardRefNum:  "",
     token:  token!,
     subAgentId:  subagentId!
    );

    send.fold(
      (error) {
        print("-------------------ERROR---------------------");
        print(error);
      },
      (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          Share.share("Here is your payment link: ${sendLink.linkUrl}");
        } else {
          print("Payment link is empty or null");
        }
      },
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
                    transitionBuilder:
                        (child, animation) => RotationTransition(
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
