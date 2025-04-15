
import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:collection_qr_flutter/presentation/screens/dues/qr/qr_code_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/colors.dart';
import '../../../data/provider/due_under_agent_provider.dart';
import '../../../data/repository/payment_link_repository.dart';
import '../../../domain/model/due_under_agent_model.dart';


class DuesHomePage extends StatefulWidget {
  const DuesHomePage({super.key});

  @override
  State<DuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<DuesHomePage> {
  final Map<String, Map<int, bool>> _checkboxStates = {};
  String? agentOriginId;
  String? _expandedAccNo;
  String? token;
  String? name;
  String? custid;
  String? email;
  String? mobnum;


  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  Future<void> loadSharedPrefs() async {
    final id = await SharedPref.shared.getAgentOriginId();
    final tok = await SharedPref.shared.getTokenValue();
    final nam = await SharedPref.shared.getAgentName();
    final mobNum = await SharedPref.shared.getMobNum();
    final custId = await SharedPref.shared.getAgentOriginId();
    final emailValue = await SharedPref.shared.getEmail();
    if (mounted) {
      setState(() {
        agentOriginId = id;
        token = tok;
        name = nam;
        mobnum = mobNum;
        email = emailValue;
        custid = custId;
      });
    }
    print("DUE PAGE TOKEN : $token");
    print("DUE PAGE AGENT ID : $agentOriginId");
    final provider = Provider.of<DueUnderAgentProvider>(context, listen: false);
    provider.getDuesUnderAgent(agentOriginId);
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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


  Widget buildShimmerText({double width = double.infinity, double height = 16}) {
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
        title: Text(
          "Due List",
          style: GoogleFonts.inter(
              fontSize: 23, color: deepTeal, fontWeight: FontWeight.w700),
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
              final totalDue =
              dues.fold<num>(0, (sum, item) => sum + (item.dueAmount ?? 0));

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                  border:
                  Border.all(color: deepTeal.withOpacity(0.7), width: 1.5),
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
                        horizontal: 20, vertical: 12),
                    childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Number",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accNo,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: deepTeal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee,
                                size: 18, color: black87),
                            Text(
                              "Total Due: ₹$totalDue",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: dues.asMap().entries.map((entry) {
                      final dueIndex = entry.key;
                      final due = entry.value;

                      _checkboxStates.putIfAbsent(accNo, () => {});
                      _checkboxStates[accNo]!
                          .putIfAbsent(dueIndex, () => false);

                      final isEnabled =
                          _expandedAccNo == null || _expandedAccNo == accNo;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _checkboxStates[accNo]![dueIndex],
                              onChanged: isEnabled
                                  ? (bool? value) {
                                setState(() {
                                  // Uncheck all other account numbers
                                  _checkboxStates.forEach((key, map) {
                                    if (key != accNo) {
                                      map.updateAll((_, __) => false);
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

                                final controller = TextEditingController(
                                  text: modalSelectedAmount
                                      .toStringAsFixed(2),
                                );

                                String selectedMethod =
                                    "Link"; // Default selection

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  backgroundColor: white,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: 20,
                                            left: 20,
                                            right: 20,
                                            bottom: MediaQuery.of(context)
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
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10),
                                                        border: Border.all(
                                                            color:
                                                            black54,
                                                            width: 1),
                                                      ),
                                                      child: selectedMethod ==
                                                          "Link"
                                                          ? Image.asset(
                                                          "assets/images/web-link.png",
                                                          scale: 12)
                                                          : Image.asset(
                                                          "assets/images/qr-code.png",
                                                          scale: 12),
                                                    ),
                                                    const SizedBox(
                                                        width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            "Collect Payment Using",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style:
                                                            GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              color:
                                                              black87,
                                                              fontSize:
                                                              15,
                                                            ),
                                                          ),
                                                          Text(
                                                            selectedMethod,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style:
                                                            GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
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
                                                        width: 8),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context:
                                                          context,
                                                          shape:
                                                          const RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius.circular(
                                                                    20)),
                                                          ),
                                                          builder:
                                                              (ctx) =>
                                                              Column(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                                children: [
                                                                  ListTile(
                                                                    leading:
                                                                    const Icon(
                                                                        Icons.link),
                                                                    title: const Text(
                                                                        "Link"),
                                                                    onTap:
                                                                        () {
                                                                      setModalState(() =>
                                                                      selectedMethod =
                                                                      "Link");
                                                                      Navigator.pop(
                                                                          ctx);
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    leading:
                                                                    const Icon(
                                                                        Icons.qr_code),
                                                                    title: const Text(
                                                                        "QR Code"),
                                                                    onTap:
                                                                        () {
                                                                      setModalState(() =>
                                                                      selectedMethod =
                                                                      "QR Code");
                                                                      Navigator.pop(
                                                                          ctx);
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
                                                        style: GoogleFonts
                                                            .inter(
                                                          decoration:
                                                          TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                          deepTeal,
                                                          fontWeight:
                                                          FontWeight
                                                              .w800,
                                                          color: deepTeal,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: 15),
                                                Text(
                                                  "Installment Details",
                                                  style:
                                                  GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: deepTeal,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 12),
                                                Text(
                                                    "Open Date: ${due.openDate}",
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                                Text(
                                                    "Due Month: ${dueMonthValues.reverse[due.dueMonth]}",
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                                const SizedBox(
                                                    height: 20),
                                                Text(
                                                  "Edit Total Selected Amount",
                                                  style:
                                                  GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: grey[800],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                TextFormField(
                                                  controller: controller,
                                                  keyboardType:
                                                  const TextInputType
                                                      .numberWithOptions(
                                                      decimal: true),
                                                  decoration:
                                                  InputDecoration(
                                                    filled: true,
                                                    fillColor: teal600,
                                                    border:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10),
                                                      borderSide:
                                                      const BorderSide(
                                                          color:
                                                          deepTeal),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10),
                                                      borderSide:
                                                      const BorderSide(
                                                          color:
                                                          deepTeal,
                                                          width: 1.5),
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        14,
                                                        vertical: 12),
                                                    prefixIcon: const Icon(
                                                        Icons
                                                            .currency_rupee,
                                                        color: white),
                                                  ),
                                                  style:
                                                  GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 20),
                                                CustomSliderButton(
                                                  token: token!,
                                                  label:
                                                  "Slide to Collect Using $selectedMethod",
                                                  backgroundColor:
                                                  deepTeal,
                                                  buttonColor:
                                                  Colors.white,
                                                  onConfirmed: () async {
                                                    // final editedAmount = num.tryParse(controller.text.trim()) ?? 0;
                                                    selectedMethod ==
                                                        "Link"
                                                        ? sendLinkFunction()
                                                        : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => QrCodePage(
                                                                amount: controller
                                                                    .text,
                                                                token:
                                                                token!, custName: name!, custAcNumber: '', custPhoneNumber: mobnum!, custId: agentOriginId!, custEmail: email!,)));
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
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                  Border.all(color: teal500!, width: 1.5),
                                  color: grey[50],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Installment: ₹${due.installAmt}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Open Date: ${due.openDate}",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Due Month: ${dueMonthValues.reverse[due.dueMonth]}",
                                      style: GoogleFonts.inter(
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

  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        "Salim",
        "adsslWAIaPncFH6",
        "361",
        "+919944112208",
        "salim@gmail.com",
        "RAHUL E RAMESH",
        "8921503808",
        "08041127",
        "rahul.sharma@example.com",
        "2600",
        2000,
        "Payment for Order #12345",
        "BNKMYL",
        "",
        token!
      // agentName!,
      // agentId!,
      // agentOriginId!,
      // agentMobile!,
      // agentEmail!,
      // widget.custName,
      // widget.custPhoneNumber,
      // widget.custAcNumber,
      // "rahul.sharma@example.com",
      // widget.custId,
      // num.parse(amountController.text),
      // "Payment for Order #12345",
      // corpCode!,
      // "",
      // token.toString()
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
    Key? key,
    required this.onConfirmed,
    required this.label,
    required this.backgroundColor,
    required this.buttonColor,
    required this.token,
  }) : super(key: key);

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
                style: GoogleFonts.inter(
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
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                      child: child,
                    ),
                    child: Image.asset(
                      "assets/images/arrow.png",
                      key: const ValueKey('arrow-icon'),
                      scale: 20,
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
