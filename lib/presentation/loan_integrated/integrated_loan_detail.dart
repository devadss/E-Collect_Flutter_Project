import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart' as utl;
import '../../data/provider/loan_cash_coolection_provider.dart';
import '../../data/storage/shared_pref_helper.dart';

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
  const IntegratedLoanDetail({super.key, required this.loanDate, required this.loanAmount, required this.loanNumber, required this.loanType, required this.loanPeriod, required this.loanInterest, required this.principalAmountReceived, required this.principalAmountBalance, required this.principalAmountOverdue, required this.principalAmountReceipt, required this.interestAmountReceived, required this.interestAmountBalance, required this.interestAmountOverdue, required this.interestAmountReceipt, required this.penalInterestAmountReceived, required this.penalInterestAmountBalance, required this.penalInterestAmountOverdue, required this.penalInterestAmountReceipt, required this.name, required this.custNo});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(textAlign:TextAlign.center
          ,"LOAN DETAILS", style:TextStyle(color: home2 , fontWeight: FontWeight.w700),),
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
                      spreadRadius: 2
                    )
                  ]
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                        decoration: BoxDecoration(
                          color: home1.withAlpha(40),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.supervised_user_circle_rounded, color: home1),
                        )),
                    SizedBox(width: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(widget.name, style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
          Text("CUST NO : ${widget.custNo}",style: TextStyle(fontSize: 12, color:home2, fontWeight: FontWeight.w700),),
        
        ],)
                  ],),
                )
        
              ),
              SizedBox(height: 20,),
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
                      color: Colors.
                        black12,
                      spreadRadius: 2, blurRadius: 8
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Loan Details", style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
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
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.date_range, color: home1,size: 20,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Date",style: TextStyle(color: home2,fontSize: 12)),
                          ],
                        )
                   ,
                        Text(widget.loanDate, style: TextStyle(fontSize: 12),)
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
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.currency_rupee, color: home1,size: 18,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Amount", style: TextStyle(color: home2,fontSize: 12),),
                          ],
                        )
                   ,
                        Text(widget.loanAmount,style: TextStyle(fontSize: 12))
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
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.numbers, color: home1,size: 20,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Number",style: TextStyle(color: home2,fontSize: 12)),
                          ],
                        )
                   ,
                        Text(widget.loanNumber,style: TextStyle(fontSize: 12))
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
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.account_balance_wallet, color: home1,size: 20,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Type",style: TextStyle(color: home2,fontSize: 12)),
                          ],
                        )
                   ,
                        Text(widget.loanType,style: TextStyle(fontSize: 12))
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
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.data_exploration, color: home1,size: 20,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Period",style: TextStyle(color: home2,fontSize: 12)),
                          ],
                        )
                   ,
                        Text(widget.loanPeriod,style: TextStyle(fontSize: 12))
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
                              borderRadius: BorderRadius.circular(5)
                            )
                                ,child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.integration_instructions_outlined, color: home1,size: 20,),
                                )),
                            SizedBox(width: 5,),
                            Text("Loan Interest",style: TextStyle(color: home2,fontSize: 12)),
                          ],
                        )
                   ,
                        Text(widget.loanInterest,style: TextStyle(fontSize: 12))
                      ],
                    ),
                ],),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(color: Colors.black12,
                    offset: Offset(1, 0),
                    blurRadius: 8, spreadRadius: 2)
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Particular : Principal amount", style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text("Total Received", style: TextStyle(color: Colors.green, fontSize: 12)),
                        Text(widget.principalAmountReceived.toString(), style: TextStyle(fontSize: 12,color: Colors.green, fontWeight: FontWeight.w500),),
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance", style: TextStyle(color: Colors.blue,fontSize: 12)),
                          Text(widget.principalAmountBalance.toString(),style: TextStyle(fontSize: 12,color: Colors.blue, fontWeight: FontWeight.w500),),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue", style: TextStyle(color: Colors.red,fontSize: 12)),
                          Text(widget.principalAmountOverdue.toString(),style: TextStyle(fontSize: 12,color: Colors.red, fontWeight: FontWeight.w500),),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt", style: TextStyle(color: home1,fontSize: 12)),
                          Text(widget.principalAmountReceipt.toString(),style: TextStyle(fontSize: 12),),
                        ],),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(color: Colors.black12,
                    offset: Offset(1, 0),
                    blurRadius: 8, spreadRadius: 2)
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Particular : Interest", style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text("Total Received", style: TextStyle(color: Colors.green,fontSize: 12 )),
                        Text(widget.interestAmountReceived.toString(),style: TextStyle(fontSize: 12,color: Colors.green, fontWeight: FontWeight.w500),),
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance", style: TextStyle(color: Colors.blue,fontSize: 12)),
                          Text(widget.interestAmountBalance.toString(),style: TextStyle(fontSize: 12,color: Colors.blue, fontWeight: FontWeight.w500),),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue", style: TextStyle(color: Colors.red,fontSize: 12)),
                          Text(widget.interestAmountOverdue.toString(),style: TextStyle(fontSize: 12,color: Colors.red, fontWeight: FontWeight.w500),),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt", style: TextStyle(color: home1,fontSize: 12)),
                          Text(widget.interestAmountReceipt.toString(),style: TextStyle(fontSize: 12,),),
                        ],),
        
        
        
        
        
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow:[
                      BoxShadow(color: Colors.black12,
                          offset: Offset(1, 0),
                          blurRadius: 8, spreadRadius: 2)
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Particular : Penal Interest", style: TextStyle(color: home2, fontWeight: FontWeight.w700),),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Received", style: TextStyle(color: Colors.green,fontSize: 12,)),
                          Text(widget.penalInterestAmountReceived.toString(),style: TextStyle(fontSize: 12,color: Colors.green, fontWeight: FontWeight.w500)),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Balance", style: TextStyle(color: Colors.blue,fontSize: 12)),
                          Text(widget.penalInterestAmountBalance.toString(),style: TextStyle(fontSize: 12,color: Colors.blue, fontWeight: FontWeight.w500)),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Overdue", style: TextStyle(color: Colors.red,fontSize: 12)),
                          Text(widget.penalInterestAmountOverdue.toString(),style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500)),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Current Receipt", style: TextStyle(color: home1,fontSize: 12)),
                          Text(widget.penalInterestAmountReceipt.toString(),style: TextStyle(fontSize: 12),),
                        ],),





                    ],
                  ),
                ),
              ),
SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: home1,
                      foregroundColor: Colors.white
                    ), child: Text("Generate QR")),
              ),
              SizedBox(height: 10,),
              SizedBox(

                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
shadowColor: Colors.white,
                  backgroundColor: Colors.white, foregroundColor: home1,
                  side: BorderSide(
                    color: home1
                  ),
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadiusGeometry.circular(10)
                  )
                ),child: Text("Collect Cash")),
              ),
              SizedBox(height: 10,),
              SizedBox(

                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
shadowColor: Colors.white,
                    backgroundColor: Colors.white, foregroundColor: home1,
                    side: BorderSide(
                        color: home1
                    ),
                    shape: RoundedRectangleBorder(

                        borderRadius: BorderRadiusGeometry.circular(10)
                    )
                ),child: Text("Send Payment Link")),
              ),
              SizedBox(height: 10,),
              SizedBox(

                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
shadowColor: Colors.white,
                    backgroundColor: Colors.white, foregroundColor: home1,
                    side: BorderSide(
                        color: home1
                    ),
                    shape: RoundedRectangleBorder(

                        borderRadius: BorderRadiusGeometry.circular(10)
                    )
                ),child: Text("Account Transfer")),
              )
            ],
          ),
        ),
      ),
    );
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
