import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/data/provider/integrated_loan_detail_provider.dart';
import 'package:collection_qr_flutter/data/provider/integration_loan_list_provider.dart';
import 'package:collection_qr_flutter/domain/model/integrated_loan_list_model.dart';
import 'package:collection_qr_flutter/presentation/loan_integrated/integrated_loan_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart';
import '../../data/storage/shared_pref_helper.dart';
//THE LOAN CUSTOMER LISTING PAGE 1 OF 2....
class LoanList extends StatefulWidget {

  const LoanList({super.key});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  IntegratedLoanListResponse? _integratedLoanListResponse;
  List<CustomerData>? _filteredList;
  bool? showShadowAcc = false;
  bool? showShadowLoan=true;

  String? _branchId;
  String? _subAgentId;

  Future<void> loadSharedPrefs(BuildContext context) async {
    final subAgentId = await SharedPref().getSubAgentId(); //63
    final branchId = await SharedPref().getSubAgentCodeNew(); //01
    final subAgentCode = await SharedPref().getSubAgentCode(); //1021

    setState(() {
      _branchId = branchId;
      _subAgentId= subAgentId;
    });
    fetchIntegratedLoans();
  }
  Future<void> fetchIntegratedLoans() async {
    final integratedLoanProvider =
        Provider.of<IntegratedLoanListProvider>(context, listen: false);
    await integratedLoanProvider.fetchIntegratedLoans(_subAgentId, _branchId,"","");
    setState(() {
      _integratedLoanListResponse =
          integratedLoanProvider.integratedLoanListResponse;
      _filteredList = _integratedLoanListResponse!.data;
    });
  }

  Future<void> fetchIntegratedLoanDetails(String accNo) async {
    showProgressDialog(context);
    final integratedLoanDetailProvider =
        Provider.of<IntegratedLoanDetailProvider>(context, listen: false);
    await integratedLoanDetailProvider.getIntegratedLoanDetails(
        "", "01", "", "", accNo);
    if (integratedLoanDetailProvider
            .integratedLoanListResponse?.loanDate.isNotEmpty ==
        true) {

       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  IntegratedLoanDetail(
                    name: integratedLoanDetailProvider
                            .integratedLoanListResponse?.name ??
                        "",
                    custNo: integratedLoanDetailProvider
                            .integratedLoanListResponse?.custNo ??
                        "",
                    loanDate: integratedLoanDetailProvider
                            .integratedLoanListResponse?.loanDate
                            .toString() ??
                        "",
                    loanAmount: integratedLoanDetailProvider
                            .integratedLoanListResponse?.loanAmount
                            .toString() ??
                        "",
                    loanNumber: integratedLoanDetailProvider
                            .integratedLoanListResponse?.acno
                            .toString() ??
                        "",
                    loanType: integratedLoanDetailProvider
                            .integratedLoanListResponse?.loanType
                            .toString() ??
                        "",
                    loanPeriod: integratedLoanDetailProvider
                            .integratedLoanListResponse?.loanPeriod
                            .toString() ??
                        "",
                    loanInterest: integratedLoanDetailProvider
                            .integratedLoanListResponse?.interestRate
                            .toString() ??
                        "",
                    principalAmountReceived: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[0]
                        .totalReceived,
                    principalAmountBalance: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[0].balance,
                    principalAmountOverdue: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[0].overdue,
                    principalAmountReceipt: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[0]
                        .currentReceipt,
                    interestAmountReceived: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[1]
                        .totalReceived,
                    interestAmountBalance: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[1].balance,
                    interestAmountOverdue: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[1].overdue,
                    interestAmountReceipt: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[1]
                        .currentReceipt,
                    penalInterestAmountReceived: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[2]
                        .totalReceived,
                    penalInterestAmountBalance: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[2].balance,
                    penalInterestAmountReceipt: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[2]
                        .currentReceipt,
                    penalInterestAmountOverdue: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[2].overdue,
                  ))).then((_){Navigator.pop(context);});

    }
  }

  @override
  void initState() {
    loadSharedPrefs(context);


    super.initState();
  }

  void filterList(String filterValue) {
    //print("filterValue $filterValue");
    if (filterValue.isEmpty) {
      _filteredList = _integratedLoanListResponse!.data;
    } else {
      setState(() {
        _filteredList = _integratedLoanListResponse!.data.where((item) {
          return item.custName.toLowerCase().contains(filterValue) || item.lnGlobalAccNo.toLowerCase().contains(filterValue);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: Center(
      //     child:
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         InkWell(
      //           onTap: (){
      //             setState(() {
      //               showShadowLoan = false;
      //               showShadowAcc = true;
      //               Navigator.pop(context);
      //             });
      //           },
      //           child: Container(
      //             decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //                 boxShadow: [
      //                   BoxShadow(color:
      //                   showShadowAcc == true?
      //                   Colors.black12: Colors.white, blurRadius: 9, spreadRadius: 1),
      //
      //                 ]
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: const Text(
      //                 "RD List",
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.w700,
      //                   fontSize: 23,
      //                   color: home2,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         InkWell(
      //           onTap: (){
      //             setState(() {
      //               showShadowLoan = true;
      //               showShadowAcc = false;
      //             });
      //
      //           },
      //           child: Container(
      //
      //             decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //                 boxShadow: [
      //                   BoxShadow(color:
      //                   showShadowLoan == true?
      //                   home1.withAlpha(60):Colors.white, blurRadius: 8, spreadRadius: 2),
      //
      //                 ]
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: const Text(
      //                 "Loan List",
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.w700,
      //                   fontSize: 23,
      //                   color: home2,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],),
      //
      //     // Text(
      //     //   textAlign: TextAlign.center,
      //     //   "LOANS",
      //     //   style: TextStyle(
      //     //       color: home2, fontSize: 22, fontWeight: FontWeight.w700),
      //     // ),
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child:
          //   Container(
          //     width: double.infinity,
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.black12.withAlpha(10),
          //             offset: Offset(0, 1),
          //             spreadRadius: 3,
          //             blurRadius: 9),
          //       ],
          //     ),
          //     child: TextField(
          //       // controller: _searchController,
          //       onChanged: filterList,
          //       decoration: InputDecoration(
          //           prefixIcon: Icon(Icons.search),
          //           labelStyle: TextStyle(color: Colors.black),
          //           label: Text(
          //             "Search account number",
          //             style: TextStyle(fontSize: 12),
          //           ),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           )),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30), // modern pill shape
              ),
              child: TextField(
                onChanged: filterList, // ✅ your logic unchanged
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search account number...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),

                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),

                  border: InputBorder.none, // remove box border
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              textAlign: TextAlign.start,
              "Active Loans",
              style: TextStyle(color: home2, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _filteredList?.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {

                      fetchIntegratedLoanDetails(
                          _filteredList![index].lnGlobalAccNo.toString());

                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child:
                      // Card(
                      //   elevation: 2,
                      //   shadowColor: Colors.black26,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         // Customer Name
                      //         _filteredList?[index].custName == null
                      //             ? LinearProgressIndicator(
                      //                 color: Colors.black12,
                      //                 backgroundColor:
                      //                     Colors.black26.withAlpha(10),
                      //                 borderRadius: BorderRadius.circular(5),
                      //                 minHeight: 20,
                      //               )
                      //             : Text(
                      //                 _filteredList?[index].custName ?? "",
                      //                 style: TextStyle(
                      //                   color: home1,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16,
                      //                 ),
                      //               ),
                      //         const SizedBox(height: 4),
                      //         // Scheme Name
                      //         _filteredList?[index].schName == null
                      //             ? LinearProgressIndicator(
                      //                 color: Colors.black12,
                      //                 backgroundColor:
                      //                     Colors.black26.withAlpha(10),
                      //                 borderRadius: BorderRadius.circular(5),
                      //                 minHeight: 10,
                      //               )
                      //             : Text(
                      //                 _filteredList?[index].schName ?? "",
                      //                 style: TextStyle(
                      //                     color: home2,
                      //                     fontSize: 11,
                      //                     fontWeight: FontWeight.w500),
                      //               ),
                      //         const Divider(height: 20, thickness: 1.2),
                      //
                      //         // Info Labels Row
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: const [
                      //             Text(
                      //               "Customer ID",
                      //               style: TextStyle(
                      //                 color: Colors.black54,
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //             Text(
                      //               "Account Number",
                      //               style: TextStyle(
                      //                 color: Colors.black54,
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //             Text(
                      //               "Scheme Code",
                      //               style: TextStyle(
                      //                 color: Colors.black54,
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 4),
                      //
                      //         // Data Row
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             _filteredList?[index].custId == null
                      //                 ? CircularProgressIndicator(
                      //                     color: Colors.black12,
                      //                     backgroundColor:
                      //                         Colors.black26.withAlpha(10),
                      //                   )
                      //                 : Text(
                      //                     _filteredList?[index].custId ?? "",
                      //                     style: TextStyle(
                      //                       color: home1,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 11,
                      //                     ),
                      //                   ),
                      //             _filteredList?[index].lnGlobalAccNo == null
                      //                 ? CircularProgressIndicator(
                      //                     color: Colors.black12,
                      //                     backgroundColor:
                      //                         Colors.black26.withAlpha(10),
                      //                   )
                      //                 : Text(
                      //                     _filteredList?[index].lnGlobalAccNo ??
                      //                         "",
                      //                     style: TextStyle(
                      //                       color: home1,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 11,
                      //                     ),
                      //                   ),
                      //             _filteredList?[index].schCode == null
                      //                 ? CircularProgressIndicator(
                      //                     color: Colors.black12,
                      //                     backgroundColor:
                      //                         Colors.black26.withAlpha(10),
                      //                   )
                      //                 : Text(
                      //                     _filteredList?[index].schCode ?? "",
                      //                     style: TextStyle(
                      //                       color: home1,
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 11,
                      //                     ),
                      //                   ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🔹 Customer Name
                              _filteredList?[index].custName == null
                                  ? _buildSkeleton(width: 140, height: 16)
                                  : Text(
                                _filteredList?[index].custName ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: home1,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// 🔹 Scheme Name
                              _filteredList?[index].schName == null
                                  ? _buildSkeleton(width: 100, height: 12)
                                  : Text(
                                _filteredList?[index].schName ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// 🔹 Info Chips Row (Modern replacement for table)
                              Wrap(

                                spacing: 15,
                                runSpacing: 8,
                                children: [
                                  _buildInfoChip(
                                    label: "Customer ID",
                                    value: _filteredList?[index].custId,
                                  ),
                                  _buildInfoChip(
                                    label: "Account",
                                    value: _filteredList?[index].lnGlobalAccNo,
                                  ),
                                  _buildInfoChip(
                                    label: "Scheme",
                                    value: _filteredList?[index].schCode,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

Widget _buildInfoChip({required String label, String? value}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: home1.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
    ),
    child: value == null
        ? _buildSkeleton(width: 60, height: 12)
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: home1,
          ),
        ),
      ],
    ),
  );
}
Widget _buildSkeleton({double width = 100, double height = 12}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(6),
    ),
  );
}
