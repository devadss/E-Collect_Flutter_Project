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
  bool? showShadowLoan = true;

  String? _branchId;
  String? _loanListingUrl;
  String? _loanDetailUrl;
  String? _agentId;

  Future<void> loadSharedPrefs(BuildContext context) async {
    final subAgentId = await SharedPref().getSubAgentId(); //63
    final branchId = await SharedPref().getECollectBranchID(); //01
    final agentID = await SharedPref().getECollectAgentID(); //1021
    final loanListingUrl = await SharedPref().getECollectUrlList(); //1021

    setState(() {

      for(var x in loanListingUrl){
        if(x.contains("getLoanCustUnderAgent")){
          setState(() {
            _loanListingUrl = x;
          });
          print((x));
        }
      }
      for(var x in loanListingUrl){
        if(x.contains("getLoanAccountHolder")){
          setState(() {
            _loanDetailUrl = x;
          });
          print((x));
        }else{
          _loanDetailUrl = "https://mftctest.digicob.in/getLoanAccountHolder";
        }
      }

      print("LOAN LIST URL : $_loanListingUrl");
      print("LOAN detail URL : $_loanDetailUrl");
      print("agentID : $agentID");
      print("branchId : $branchId");
     // _loanListingUrl = "https://mftctest.digicob.in/getLoanCustUnderAgent";
     // _loanDetailUrl = "https://mftctest.digicob.in/getLoanAccountHolder";
      _branchId = "01";
      _agentId = "1005";
    });
    if (printStatementStatus) {
      print("Loan _branchId = $_branchId");
      print("Loan _subAgentId = $_agentId");
    }

    fetchIntegratedLoans();
  }

  Future<void> fetchIntegratedLoans() async {
    final integratedLoanProvider =
        Provider.of<IntegratedLoanListProvider>(context, listen: false);
    await integratedLoanProvider.fetchIntegratedLoans(

        _loanListingUrl,
        _agentId, _branchId, "", "");
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
      _loanDetailUrl!,
        "", _branchId.toString(), "", "",

        accNo);
    if (integratedLoanDetailProvider
            .integratedLoanListResponse?.loanDate.isNotEmpty ==
        true) {
      if(!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntegratedLoanDetail(
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
                  ))).then((_) {
                    if(!mounted) return;
        Navigator.pop(context);
      });
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
          return item.custName.toLowerCase().contains(filterValue) ||
              item.lnGlobalAccNo.toLowerCase().contains(filterValue);
        }).toList();
      });
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
      toolbarHeight: 50,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Loan List",
            style: TextStyle(
              color: home1,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(height: 8),
          // Container(
          //   padding: const EdgeInsets.all(6),
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade200.withValues(alpha:0.6),
          //     borderRadius: BorderRadius.circular(40),
          //   ),
          //   child: SegmentedTabControl(
          //     indicatorPadding: const EdgeInsets.all(4),
          //     indicatorDecoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [home1, home1.withValues(alpha:0.85)],
          //       ),
          //       borderRadius: BorderRadius.circular(30),
          //       boxShadow: [
          //         BoxShadow(
          //           color: home1.withValues(alpha:0.9),
          //           blurRadius: 10,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     barDecoration: BoxDecoration(
          //       color: Colors.transparent,
          //       borderRadius: BorderRadius.circular(40),
          //     ),
          //     // tabs: [
          //     //   SegmentTab(
          //     //     label: "RD",
          //     //     color: Colors.transparent,
          //     //     backgroundColor: Colors.transparent,
          //     //     textColor: Colors.grey.shade600,
          //     //     selectedTextColor: Colors.white,
          //     //   ),
          //     //   SegmentTab(
          //     //     label: "LOANS",
          //     //     color: Colors.transparent,
          //     //     backgroundColor: Colors.transparent,
          //     //     textColor: Colors.grey.shade600,
          //     //     selectedTextColor: Colors.white,
          //     //   ),
          //     // ],
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                  ),
                ),
              ),
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
                              horizontal: 10, vertical: 5),
                          child: Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(
                                  color: Colors.grey.shade100, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    // Add tap handling if needed
                                  },
                                  splashColor: home1.withValues(alpha: 0.08),
                                  highlightColor: home1.withValues(alpha: 0.04),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// 🔹 Header Row with Customer + Menu
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Avatar + Name Section
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  /// Modern Avatar
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          home1.withValues(
                                                              alpha: 0.15),
                                                          home1.withValues(
                                                              alpha: 0.05),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    child: Center(
                                                      child: _filteredList?[
                                                                      index]
                                                                  .custName ==
                                                              null
                                                          ? _buildSkeleton(
                                                              width: 24,
                                                              height: 24)
                                                          : Text(
                                                              _filteredList?[
                                                                          index]
                                                                      .custName
                                                                      .substring(
                                                                          0, 1)
                                                                      .toUpperCase() ??
                                                                  "?",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: home1,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 14),

                                                  /// Name & Scheme
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _filteredList?[index]
                                                                    .custName ==
                                                                null
                                                            ? _buildSkeleton(
                                                                width: 140,
                                                                height: 18)
                                                            : Text(
                                                                _filteredList?[
                                                                            index]
                                                                        .custName ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                  height: 1.3,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                        const SizedBox(
                                                            height: 6),
                                                        _filteredList?[index]
                                                                    .schName ==
                                                                null
                                                            ? _buildSkeleton(
                                                                width: 100,
                                                                height: 12)
                                                            : Row(
                                                                children: [
                                                                  Container(
                                                                    width: 6,
                                                                    height: 6,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .green
                                                                          .shade500,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                    _filteredList?[index]
                                                                            .schName ??
                                                                        "",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// Menu Button
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                    Icons.more_horiz_rounded,
                                                    size: 20,
                                                    color:
                                                        Colors.grey.shade700),
                                                onPressed: () {
                                                  // Show options menu
                                                },
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        /// 🔹 Stats Row - Modern Metrics Display
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                home1.withValues(alpha: 0.04),
                                                home1.withValues(alpha: 0.02),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: home1.withValues(
                                                    alpha: 0.08)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: _buildModernMetric(
                                                  label: "Customer ID",
                                                  value: _filteredList?[index]
                                                      .custId,
                                                  icon: Icons
                                                      .person_outline_rounded,
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                height: 30,
                                                color: Colors.grey.shade200,
                                              ),
                                              Expanded(
                                                child: _buildModernMetric(
                                                  label: "Account",
                                                  value: _filteredList?[index]
                                                      .lnGlobalAccNo,
                                                  icon: Icons
                                                      .account_balance_wallet_rounded,
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                height: 30,
                                                color: Colors.grey.shade200,
                                              ),
                                              Expanded(
                                                child: _buildModernMetric(
                                                  label: "Scheme",
                                                  value: _filteredList?[index]
                                                      .schCode,
                                                  icon: Icons.code_rounded,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        /// 🔹 Action Buttons Row
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  fetchIntegratedLoanDetails(
                                                      _filteredList![index]
                                                          .lnGlobalAccNo
                                                          .toString());
                                                },
                                                icon: Icon(
                                                    Icons.visibility_rounded,
                                                    size: 18,
                                                    color: home1),
                                                label: const Text('Details'),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: home1,
                                                  side: BorderSide(
                                                      color: home1.withValues(
                                                          alpha: 0.3)),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: FilledButton.icon(
                                                onPressed: () {
                                                  fetchIntegratedLoanDetails(
                                                      _filteredList![index]
                                                          .lnGlobalAccNo
                                                          .toString());
                                                },
                                                icon: Icon(
                                                    Icons.payments_rounded,
                                                    size: 18),
                                                label: const Text('Collect'),
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: home1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
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
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildModernMetric({
  required String label,
  required String? value,
  required IconData icon,
}) {
  if (value == null) {
    return _buildSkeleton(width: 60, height: 32);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        
        children: [
          Icon(icon, size: 12, color: home1.withValues(alpha: 0.6)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,

              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: home2.withValues(alpha: 0.03)),
        child: Text(
          textAlign: TextAlign.center,
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
            letterSpacing: 0.9,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}

// Widget _buildInfoChip({required String label, String? value}) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//     decoration: BoxDecoration(
//       color: home1.withValues(alpha:0.08),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: value == null
//         ? _buildSkeleton(width: 60, height: 12)
//         : Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: home1,
//           ),
//         ),
//       ],
//     ),
//   );
// }
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
