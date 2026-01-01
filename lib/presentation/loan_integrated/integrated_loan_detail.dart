import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart' as utl;
import '../../data/provider/loan_cash_coolection_provider.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../dues/widgets/new_qr_code_page.dart';
//THE LOAN CUSTOMER DETAILS PAGE 2 OF 2....

class IntegratedLoanDetail extends StatefulWidget {

  final String loanDate;
  final String name;
  final String custNo;
  final String loanAmount;
  final String loanNumber;
  final String loanType;
  final String loanPeriod;
  final String loanInterest;
  final double principalAmountReceived;
  final double principalAmountBalance;
  final double principalAmountOverdue;
  final double principalAmountReceipt;
  final double interestAmountReceived;
  final double interestAmountBalance;
  final double interestAmountOverdue;
  final double interestAmountReceipt;
  final double penalInterestAmountReceived;
  final double penalInterestAmountBalance;
  final double penalInterestAmountOverdue;
  final double penalInterestAmountReceipt;
  const IntegratedLoanDetail(
      {super.key,
      required this.loanDate,
      required this.loanAmount,
      required this.loanNumber,
      required this.loanType,
      required this.loanPeriod,
      required this.loanInterest,
      required this.principalAmountReceived,
      required this.principalAmountBalance,
      required this.principalAmountOverdue,
      required this.principalAmountReceipt,
      required this.interestAmountReceived,
      required this.interestAmountBalance,
      required this.interestAmountOverdue,
      required this.interestAmountReceipt,
      required this.penalInterestAmountReceived,
      required this.penalInterestAmountBalance,
      required this.penalInterestAmountOverdue,
      required this.penalInterestAmountReceipt,
      required this.name,
      required this.custNo});

  @override
  State<IntegratedLoanDetail> createState() => _IntegratedLoanDetailState();
}

class _IntegratedLoanDetailState extends State<IntegratedLoanDetail> {
  String? agentId;
  String? agent_Id;
  String? corpCode;
  String? agentEmail;
  String? agentIdValue;
  String? token;
  String? agentMobile;
  String? subAgentCodeNew;
  String? cid;
  String? subagentId;
  String? agentName;
  String? agentOriginId;
  String? paymentSessionId;
  String? branchCode;
  String? selectedAccNumber;
  TextEditingController editAmountController = TextEditingController();


  @override
  void initState() {

    super.initState();
    loadSharedPrefs();
    editAmountController.text = widget.loanAmount .toString();
  }

  void validateInput() {
    if (editAmountController.text.isEmpty) return;

    final value = double.parse(editAmountController.text);
    if (value != null && value > int.parse(widget.loanAmount)) {
      editAmountController.text = widget.loanAmount.toString();
      editAmountController.selection = TextSelection.fromPosition(
          TextPosition(offset: editAmountController.text.length));
    }
  }
  @override
  void dispose() {
    editAmountController.dispose();
    editAmountController.removeListener(validateInput);
    super.dispose();
  }
  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final agentid = await SharedPref().getAgentId();
    String custid = await SharedPref().getCustId();

    final crpCd = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final mail = await SharedPref().getEmail();
    final agentOrigin = await SharedPref().getSubAgentCode();
    final custId = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final phone = await SharedPref().getParentAgentMobNum();
    final name = await SharedPref().getAgentName();
    final brCode = await SharedPref().getBranchCode();

    setState(() {
      cid = custid;
      subAgentCodeNew = sub_AgentCodeNew;
      branchCode = brCode;
      agent_Id = agentid;
      agentId = id;
      corpCode = crpCd;
      agentIdValue = custId;
      token = tok;
      agentName = name;
      agentOriginId = agentOrigin;
      agentEmail = mail;
      agentMobile = phone;
      subagentId = subAgentId;
    });
    editAmountController.addListener(validateInput);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          "LOAN DETAILS",
          style: TextStyle(color: home2, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withAlpha(20),
                            offset: Offset(0, 1),
                            blurRadius: 8,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: home1.withAlpha(40),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.supervised_user_circle_rounded,
                                  color: home1),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                  color: home2, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "CUST NO : ${widget.custNo}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: home2,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 8)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loan Details",
                      style:
                          TextStyle(color: home2, fontWeight: FontWeight.w700),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.date_range,
                                    color: home1,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Loan Date",
                                style: TextStyle(color: home2, fontSize: 12)),
                          ],
                        ),
                        Text(
                          widget.loanDate,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    //  Divider(color: Colors.black12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.currency_rupee,
                                    color: home1,
                                    size: 18,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Loan Amount",
                              style: TextStyle(color: home2, fontSize: 12),
                            ),
                          ],
                        ),
                        Text(widget.loanAmount, style: TextStyle(fontSize: 12))
                      ],
                    ),
                    // Divider(color: Colors.black12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.numbers,
                                    color: home1,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Loan Number",
                                style: TextStyle(color: home2, fontSize: 12)),
                          ],
                        ),
                        Text(widget.loanNumber, style: TextStyle(fontSize: 12))
                      ],
                    ),
                    //  Divider(color: Colors.black12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: home1,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Loan Type",
                                style: TextStyle(color: home2, fontSize: 12)),
                          ],
                        ),
                        Text(widget.loanType, style: TextStyle(fontSize: 12))
                      ],
                    ),
                    // Divider(color: Colors.black12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.data_exploration,
                                    color: home1,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Loan Period",
                                style: TextStyle(color: home2, fontSize: 12)),
                          ],
                        ),
                        Text(widget.loanPeriod, style: TextStyle(fontSize: 12))
                      ],
                    ),
                    // Divider(color: Colors.black12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: home1.withAlpha(40),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.integration_instructions_outlined,
                                    color: home1,
                                    size: 20,
                                  ),
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Loan Interest",
                                style: TextStyle(color: home2, fontSize: 12)),
                          ],
                        ),
                        Text(widget.loanInterest,
                            style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1, 0),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Particular : Principal amount",
                        style: TextStyle(
                            color: home2, fontWeight: FontWeight.w700),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Received",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12)),
                          Text(
                            widget.principalAmountReceived.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                          Text(
                            widget.principalAmountBalance.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                          Text(
                            widget.principalAmountOverdue.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt",
                              style: TextStyle(color: home1, fontSize: 12)),
                          Text(
                            widget.principalAmountReceipt.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1, 0),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Particular : Interest",
                        style: TextStyle(
                            color: home2, fontWeight: FontWeight.w700),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Received",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12)),
                          Text(
                            widget.interestAmountReceived.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                          Text(
                            widget.interestAmountBalance.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                          Text(
                            widget.interestAmountOverdue.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt",
                              style: TextStyle(color: home1, fontSize: 12)),
                          Text(
                            widget.interestAmountReceipt.toString(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1, 0),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Particular : Penal Interest",
                        style: TextStyle(
                            color: home2, fontWeight: FontWeight.w700),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Received",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              )),
                          Text(widget.penalInterestAmountReceived.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                          Text(widget.penalInterestAmountBalance.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                          Text(widget.penalInterestAmountOverdue.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt",
                              style: TextStyle(color: home1, fontSize: 12)),
                          Text(
                            widget.penalInterestAmountReceipt.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true, // Already set
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom, // <-- important
                            ),
                            child: SizedBox(
                              height: 200,
                              // You can make it dynamic if needed
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        const Spacer(flex: 1),
                                        const Text(
                                          "QR Amount",
                                          style: TextStyle(
                                              color: home1,
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.w700),
                                        ),
                                        const Spacer(flex: 1),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            editAmountController
                                                .text =
                                                widget.loanAmount
                                                    .toString();
                                          },
                                          child: const Icon(
                                            Icons.cancel_rounded,
                                            size: 30,
                                            color: home2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10),
                                    child: TextField(
                                      keyboardType:
                                      TextInputType.number,
                                      controller:
                                      editAmountController,
                                      decoration:
                                      const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.currency_rupee,
                                            color: home1,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .all(Radius
                                                  .circular(
                                                  10))),
                                          labelText:
                                          "Enter collection amount"),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        //Navigator.pop(context);
                                        generateQrPaymentSession();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: home1,
                                          foregroundColor:
                                          Colors.white),
                                      child: const Text("Submit"))
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: home1,
                        foregroundColor: Colors.white),
                    child: Text("Generate QR")),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true, // Already set
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom, // <-- important
                            ),
                            child: SizedBox(
                              height: 200,
                              // You can make it dynamic if needed
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        const Spacer(flex: 1),
                                        const Text(
                                          "Collection Amount",
                                          style: TextStyle(
                                              color: home1,
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.w700),
                                        ),
                                        const Spacer(flex: 1),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            editAmountController
                                                .text =
                                                widget.loanAmount
                                                    .toString();
                                          },
                                          child: const Icon(
                                            Icons.cancel_rounded,
                                            size: 30,
                                            color: home2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10),
                                    child: TextField(
                                      keyboardType:
                                      TextInputType.number,
                                      controller:
                                      editAmountController,
                                      decoration:
                                      const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons
                                                .currency_rupee,
                                            color: home1,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .all(Radius
                                                  .circular(
                                                  10))),
                                          labelText:
                                          "Enter collection amount"),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        paymentConfirmation(context, agentName!,
                                            widget.loanNumber, widget.custNo, editAmountController.text);

                                      },
                                      style:
                                      ElevatedButton.styleFrom(
                                          backgroundColor:
                                          home1,
                                          foregroundColor:
                                          Colors.white),
                                      child: const Text("Submit"))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.white,
                        backgroundColor: Colors.white,
                        foregroundColor: home1,
                        side: BorderSide(color: home1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10))),
                    child: Text("Collect Cash")),
              ),
              SizedBox(
                height: 10,
              ),

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //           shadowColor: Colors.white,
              //           backgroundColor: Colors.white,
              //           foregroundColor: home1,
              //           side: BorderSide(color: home1),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadiusGeometry.circular(10))),
              //       child: Text("Send Payment Link")),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //           shadowColor: Colors.white,
              //           backgroundColor: Colors.white,
              //           foregroundColor: home1,
              //           side: BorderSide(color: home1),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadiusGeometry.circular(10))),
              //       child: Text("Account Transfer")),
              // )
            ],
          ),
        ),
      ),
    );
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
                  "Do you wish to proceed with the payment ?",
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
                          loanCashCollection();

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


  Future<void> loanCashCollection() async {
    utl.showProgressDialog(context);
    final loanCashProvider =
    Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agent_Id.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.name,
        "",
        widget.loanNumber,
        widget.custNo,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB", "CASH", "", "LOAN");
    if (loanCashProvider.loanCashCollectionResponse != null) {
      Navigator.pop(context);
      print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context,
                loanCashProvider.loanCashCollectionResponse!.status == "Y"
                    ? true
                    : false,
                loanCashProvider.loanCashCollectionResponse!.message
                    .toString());
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context, false, loanCashProvider.loanCollectionErr.toString());
          });
    }
  }

  Future<void> generateQrPaymentSession() async {
    utl.showProgressDialog(context);
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
        agentOriginId: agentOriginId,
        agentEmail: agentEmail,
        customerName: widget.name,
        customerPhone: "",
        customerAccno: widget.loanNumber,
        customerId: widget.custNo,
        customerEmail: "",
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        amount: editAmountController.text,
        agentPhone: agentMobile,
        agentId: agent_Id,
        note: "Payment For Agent ${widget.loanType}",
        subAgentId: subagentId,
        agentName: agentName,
        subAgentBranchCode: subAgentCodeNew,
        collectionType: 'LOAN');
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
            builder: (context) => NewQrCodePage(
              paymentSessionId: paymentSessionId!,
              amount: editAmountController.text ?? "",
              token: token!,
              custName: widget.name ?? "custName",
              custPhone: "",
              custId: widget.custNo,
            ),
          ),
        ).then((_){Navigator.pop(context);});
        if (!mounted) return;
        if (result == "fetch_balance") {
          Navigator.pop(context);
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        // EasyLoading.showToast("Session id is null");
      }
    });
  }

/*  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final agentid = await SharedPref().getAgentId();
    String custid = await SharedPref().getCustId();

    final crpCd = await SharedPref().getCorpCode();
    final tok = await SharedPref.shared.getTokenValue();
    final mail = await SharedPref().getEmail();
    final agentOrigin = await SharedPref().getAgentOriginId();
    final custId = await SharedPref().getAgentId();
    final subAgentId = await SharedPref().getSubAgentId();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final phone = await SharedPref().getParentAgentMobNum();
    final name = await SharedPref().getAgentName();
    final brCode = await SharedPref().getBranchCode();

    setState(() {
      cid = custid;
      subAgentCodeNew = sub_AgentCodeNew;
      branchCode = brCode;
      agent_Id = agentid;
      agentId = id;
      corpCode = crpCd;
      agentIdValue = custId;
      token = tok;
      agentName = name;
      agentOriginId = agentOrigin;
      agentEmail = mail;
      agentMobile = phone;
      subagentId = subAgentId;
    });
    editAmountController.addListener(validateInput);
  }
  Future<void> loanCashCollection() async {
    utl.showProgressDialog(context);
    final loanCashProvider =
    Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agentId.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.name,
        widget.custNo,
        widget.loanNumber,
        widget.,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB", "CASH", "");
    if (loanCashProvider.loanCashCollectionResponse != null) {
      Navigator.pop(context);
      print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context,
                loanCashProvider.loanCashCollectionResponse!.status == "Y"
                    ? true
                    : false,
                loanCashProvider.loanCashCollectionResponse!.message
                    .toString());
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context, false, loanCashProvider.loanCollectionErr.toString());
          });
    }
  }*/

  AlertDialog linkShareAlert(BuildContext context, bool status, String msg) {
    return AlertDialog(
      icon: status == true
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
              size: 30,
            ),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Center(
          child: status == true ? const Text("Success") : const Text("Error")),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Text(
              msg,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(" OK "))
          ],
        ),
      ),
    );
  }
}
