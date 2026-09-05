import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'complete_loan_list/non_integrated_all_list.dart';
import 'non_integrated_loan_due_list/non_integrated_loan_due.dart';

class NonIntegratedLoanPage extends StatefulWidget {
  final List<String> endPoint;
  final String branchCode;
  final String agentID;
  final String eCollectMerchantName;
  final String eCollectAgentMerchantID;
  final String eCollectToken;
  final String eCollectAgentID;
  final String eCollectAgentOriginID;
  final String eCollectAgentMobNum;
  final String eCollectAgentEmail;
  final String eCollectBranchCode;
  const NonIntegratedLoanPage(
      {super.key,
      required this.endPoint,
      required this.branchCode,
      required this.agentID,
      required this.eCollectMerchantName,
      required this.eCollectAgentMerchantID,
      required this.eCollectToken,
      required this.eCollectAgentID,
      required this.eCollectAgentOriginID,
      required this.eCollectAgentMobNum,
      required this.eCollectAgentEmail,
      required this.eCollectBranchCode});

  @override
  State<NonIntegratedLoanPage> createState() => _NonIntegratedLoanPageState();
}

class _NonIntegratedLoanPageState extends State<NonIntegratedLoanPage> {
  String? endPointValue;
  String? endPointValueTwo;

  @override
  void initState() {
    super.initState();

    for (var x in widget.endPoint) {
      if (x.contains("api/Account/get-all")) {
        endPointValue = x;
      }
      if (x.contains("api/Account/agent-due-list")) {
        endPointValueTwo = x;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade100,
            title: Text(
              "LOANS",
              style: TextStyle(color: home1, fontWeight: FontWeight.w700),
            ),
            bottom: TabBar(dividerColor: grey, tabs: [
              Tab(
                icon: Icon(Icons.payments_outlined),
                text: "Loan List",
              ),
              Tab(
                icon: Icon(Icons.payments_rounded),
                text: "Loan Due List",
              ),
            ]),
          ),
          body: TabBarView(children: [
            NonIntegratedAllLoansScreen(
              endPoint: endPointValue!,
              branchCode: widget.branchCode,
              agentID: widget.agentID,
              eCollectMerchantName: widget.eCollectMerchantName,
              eCollectAgentMerchantID: widget.eCollectAgentMerchantID,
              eCollectToken: widget.eCollectToken,
              eCollectAgentID: widget.agentID,
              eCollectAgentOriginID: widget.eCollectAgentID,
              eCollectAgentMobNum: widget.eCollectAgentMobNum,
              eCollectAgentEmail: widget.eCollectAgentEmail,
              eCollectAgentBranchCode: widget.eCollectBranchCode,
            ),
            NonIntegratedLoanDuePaymentsScreen(
              baseUrl: endPointValueTwo!,
              agentCode: widget.agentID,
              branchCode: widget.branchCode,
              productType: '',
              pageNo: 1,
              pageSize: 100,
              agentRouteCode: widget.agentID,
              eCollectMerchantName: widget.eCollectMerchantName,
              eCollectAgentMerchantID: widget.eCollectAgentMerchantID,
              eCollectToken: widget.eCollectToken,
              eCollectAgentID: widget.eCollectAgentMerchantID,
              eCollectAgentOriginID: widget.eCollectAgentMerchantID,
              eCollectAgentMobNum: widget.eCollectAgentMobNum,
              eCollectAgentEmail: widget.eCollectAgentEmail,
              eCollectAgentBranchCode: widget.eCollectBranchCode,
            )
          ]),
        ));
  }
}
