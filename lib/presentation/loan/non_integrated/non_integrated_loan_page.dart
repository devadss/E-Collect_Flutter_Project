import 'package:flutter/material.dart';

import 'complete_loan_list/non_integrated_all_list.dart';
import 'non_integrated_loan_due_list/non_integrated_loan_due.dart';

class NonIntegratedLoanPage extends StatefulWidget {
  const NonIntegratedLoanPage({super.key});

  @override
  State<NonIntegratedLoanPage> createState() => _NonIntegratedLoanPageState();
}

class _NonIntegratedLoanPageState extends State<NonIntegratedLoanPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("LOANS"),
        bottom: TabBar(tabs: [
          Tab(icon: Icon(Icons.payments_outlined),text:"Loan List",),
          Tab(icon: Icon(Icons.payments_rounded),text:"Loan Due List",),
        ]),
      ),
      body: TabBarView(children: [
        NonIntegratedAllLoansScreen(),NonIntegratedLoanDuePaymentsScreen()

      ]),
    ));
  }
}
