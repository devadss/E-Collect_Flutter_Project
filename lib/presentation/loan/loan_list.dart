import 'package:e_Collect/core/alerts.dart';
import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/data/provider/integrated_loan_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_finder/location_finder.dart';
import 'package:provider/provider.dart';
import '../../core/utils.dart';
import '../../data/customer_list_bloc/customer_list_bloc.dart';
import 'integrated_loan_detail.dart';

//THE LOAN CUSTOMER LISTING PAGE 1 OF 2....
class LoanList extends StatefulWidget {
  final String eCollectMerchantName;
  final String eCollectBranchId;
  final String eCollectAgentMerchantID;
  final String eCollectToken;
  final String eCollectAgentID;
  final String eCollectAgentOriginID;
  final String eCollectAgentMobNum;
  final String eCollectAgentEmail;
  final String eCollectAgentBranchCode;
  final List<String> eCollectLoanListingUrl;
  const LoanList(
      {super.key,
      required this.eCollectBranchId,
      required this.eCollectAgentID,
      required this.eCollectLoanListingUrl,
      required this.eCollectMerchantName,
      required this.eCollectAgentOriginID,
      required this.eCollectAgentMobNum,
      required this.eCollectAgentEmail,
      required this.eCollectAgentBranchCode,
      required this.eCollectAgentMerchantID,
      required this.eCollectToken});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  //IntegratedLoanListResponse? _integratedLoanListResponse;
  // List<CustomerData>? _filteredList;
  // bool? showShadowAcc = false;
  // bool? showShadowLoan = true;

  String? _branchId;
  String? _loanListingUrl;
  String? _loanDetailUrl;
  String? _agentId;
  bool iscustListDialog = false;
  bool iscustDetailDialog = false;
  void loadSharedPrefs(BuildContext context) {
    for (var x in widget.eCollectLoanListingUrl) {
      if (x.contains("getLoanCustUnderAgent")) _loanListingUrl = x;
      if (x.contains("getLoanAccountHolder")) {
        _loanDetailUrl = x;
      } else {
        _loanDetailUrl = "https://mftctest.digicob.in/getLoanAccountHolder";
      }
    }
    _branchId = widget.eCollectBranchId;
    _agentId = widget.eCollectAgentID;
    fetchIntegratedLoans();
  }

  Future<void> fetchIntegratedLoans() async =>
      context.read<CustomerListBloc>().add(LoanCustomerListFetchEvent(
          _loanListingUrl!, _agentId!, _branchId!, "", ""));

  void fetchIntegratedLoanDetails(String accNo) {
    context.read<CustomerListBloc>().add(LoanDetailListFetchEvent(
        _loanDetailUrl!, "", _branchId.toString(), "", "", accNo));
  }

  @override
  void initState() {
    loadSharedPrefs(context);
    super.initState();
  }

  void filterList(String filterValue) {
    // final query = filterValue.toLowerCase().trim();
    //
    // final data = _integratedLoanListResponse?.data ?? [];
    //
    // setState(() {
    //   if (query.isEmpty) {
    //     _filteredList = data;
    //   } else {
    //     _filteredList = data.where((item) {
    //       return item.custName.toLowerCase().contains(query) ||
    //           item.lnGlobalAccNo.toLowerCase().contains(query);
    //     }).toList();
    //   }
    // });
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
          const Text(
            "Loan List",
            style: TextStyle(
              color: home1,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE5E8ED),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.025),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: filterList,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF20242C),
                  ),
                  cursorColor: home1,
                  decoration: InputDecoration(
                    hintText: "Search account number",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9AA1AE),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: Color(0xFF737B89),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Clear search if you have a controller.
                      },
                      icon: const Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: Color(0xFF737B89),
                      ),
                      tooltip: "Filter",
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            BlocConsumer<CustomerListBloc, CustomerListState>(
              builder: (BuildContext context, CustomerListState state) {
                if (state is LoanCustomerListSuccessState) {
                  var data = state.loanCustomerListSuccessModel
                      .loanCustomerListSuccessModel.data;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                fetchIntegratedLoanDetails(
                                    data[index].lnGlobalAccNo.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 7,
                                ),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      fetchIntegratedLoanDetails(
                                        data[index].lnGlobalAccNo.toString(),
                                      );
                                    },
                                    splashColor: home1.withValues(alpha: 0.04),
                                    highlightColor:
                                        home1.withValues(alpha: 0.02),
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFFE9ECF1),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ------------------------------------------------------------
                                          // HEADER
                                          // ------------------------------------------------------------
                                          Row(
                                            children: [
                                              // Customer avatar
                                              Container(
                                                width: 42,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                  color: home1.withValues(
                                                      alpha: 0.09),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: data[index].custName ==
                                                          null
                                                      ? _buildSkeleton(
                                                          width: 20,
                                                          height: 20,
                                                        )
                                                      : Text(
                                                          (data[index].custName ??
                                                                  "?")
                                                              .substring(0, 1)
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: home1,
                                                          ),
                                                        ),
                                                ),
                                              ),

                                              const SizedBox(width: 11),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    data[index].custName == null
                                                        ? _buildSkeleton(
                                                            width: 130,
                                                            height: 16,
                                                          )
                                                        : Text(
                                                            data[index]
                                                                    .custName ??
                                                                "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF151922),
                                                            ),
                                                          ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      data[index].schName ?? "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFF8A91A0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Status
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 9,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFEAF8F1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 6,
                                                      color: Color(0xFF159957),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Active",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xFF159957),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 22),

                                          // ------------------------------------------------------------
                                          // ACCOUNT / BALANCE HERO
                                          // ------------------------------------------------------------
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Loan Account",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF8A91A0),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      data[index]
                                                              .lnGlobalAccNo ??
                                                          "—",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.2,
                                                        color:
                                                            Color(0xFF171A21),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Arrow
                                              Container(
                                                width: 34,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF5F6F8),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 13,
                                                  color: Color(0xFF687080),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 18),

                                          // ------------------------------------------------------------
                                          // ACCOUNT METADATA
                                          // ------------------------------------------------------------
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildFintechInfo(
                                                  label: "Customer ID",
                                                  value: data[index].custId,
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildFintechInfo(
                                                  label: "Scheme",
                                                  value: data[index].schCode,
                                                ),
                                              ),
                                              Expanded(
                                                child: _buildFintechInfo(
                                                  label: "Type",
                                                  value: "Loan",
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 18),

                                          // ------------------------------------------------------------
                                          // ACTIONS
                                          // ------------------------------------------------------------
                                          Row(
                                            children: [
                                              // Details
                                              Expanded(
                                                child: SizedBox(
                                                  height: 44,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      fetchIntegratedLoanDetails(
                                                        data[index]
                                                            .lnGlobalAccNo
                                                            .toString(),
                                                      );
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          const Color(
                                                              0xFF424956),
                                                      side: const BorderSide(
                                                        color:
                                                            Color(0xFFE1E4E9),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Details",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 10),

                                              // Primary action
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  height: 44,
                                                  child: FilledButton(
                                                    onPressed: () {
                                                      fetchIntegratedLoanDetails(
                                                        data[index]
                                                            .lnGlobalAccNo
                                                            .toString(),
                                                      );
                                                    },
                                                    style:
                                                        FilledButton.styleFrom(
                                                      backgroundColor: home1,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .payments_outlined,
                                                          size: 17,
                                                        ),
                                                        SizedBox(width: 7),
                                                        Text(
                                                          "Collect Payment",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                              ));
                        }),
                  );
                } else if (state is LoanCustomerListFailState) {
                  return Text("Error fetching data");
                }
                return Text("");
              },
              listener: (BuildContext context, CustomerListState state) async {
                if (state is LoanCustomerListLoaderState) {
                  if (iscustListDialog == false) {
                    showProgressDialog(context);
                    iscustListDialog = true;
                  }
                  print("LoanCustomerListLoaderState");
                }
                  if (state is LoanCustomerListSuccessState) {
                    if (iscustListDialog == true) {
                      Navigator.pop(context);
                      iscustListDialog = false;

                    }
                    print("LoanCustomerListSuccessState");
                  }else if(state is LoanCustomerListFailState){
                    if (iscustListDialog == true) {
                      Navigator.pop(context);
                      iscustListDialog = false;
                    }
                    print("LoanCustomerListFailState");
                  }


                  if(state is LoanDetailListLoaderState){
                    if(iscustDetailDialog == false){
                      showProgressDialog(context);
                      iscustDetailDialog = true;
                    }
                  }

                if (state is LoanDetailListSuccessState){
                  if(iscustDetailDialog == true){
                   Navigator.pop(context);
                    iscustDetailDialog = false;
                  }
                  final data = state.loanDetailListSuccessModel.loanDetailListSuccessModel;
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IntegratedLoanDetail(
                                integratedLoanDetailModel:
                                    IntegratedLoanDetailModel(
                                        loanDate:
                                            data.loanDate.toString() ?? "",
                                        name: data.name ?? "",
                                        custNo: data.custNo ?? "",
                                        loanAmount:
                                            data.loanAmount.toString() ?? "",
                                        loanNumber: data.acno.toString() ?? "",
                                        loanType:
                                            data.loanType.toString() ?? "",
                                        loanPeriod:
                                            data.loanPeriod.toString() ?? "",
                                        loanInterest:
                                            data.interestRate.toString() ?? "",
                                        principalAmountReceived: data
                                            .receiptDetails[0].totalReceived,
                                        principalAmountBalance:
                                            data.receiptDetails[0].balance,
                                        principalAmountOverdue:
                                            data.receiptDetails[0].overdue,
                                        principalAmountReceipt: data
                                            .receiptDetails[0].currentReceipt,
                                        interestAmountReceived: data
                                            .receiptDetails[1].totalReceived,
                                        interestAmountBalance:
                                            data.receiptDetails[1].balance,
                                        interestAmountOverdue:
                                            data.receiptDetails[1].overdue,
                                        interestAmountReceipt: data
                                            .receiptDetails[1].currentReceipt,
                                        penalInterestAmountReceived: data
                                            .receiptDetails[2].totalReceived,
                                        penalInterestAmountBalance:
                                            data.receiptDetails[2].balance,
                                        penalInterestAmountOverdue:
                                            data.receiptDetails[2].overdue,
                                        penalInterestAmountReceipt: data
                                            .receiptDetails[2].currentReceipt),
                                ecollectMerchantModelData:
                                    EcollectMerchantModelData(
                                        eCollectMerchantName:
                                            widget.eCollectMerchantName,
                                        eCollectAgentId: widget.eCollectAgentID,
                                        eCollectAgentOriginId:
                                            widget.eCollectAgentOriginID,
                                        eCollectAgentNumber:
                                            widget.eCollectAgentMobNum,
                                        eCollectAgentEmail:
                                            widget.eCollectAgentEmail,
                                        eCollectAgentBranchCode:
                                            widget.eCollectAgentBranchCode,
                                        eCollectAgentMerchantID:
                                            widget.eCollectAgentMerchantID,
                                        eCollectCollectionType: "LOAN",
                                        eCollectToken: widget.eCollectToken),
                              )));
                  fetchIntegratedLoans();
                }else if(state is LoanDetailListFailState){
                  if(iscustDetailDialog == true){
                    Navigator.pop(context);
                    iscustDetailDialog = false;
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildFintechInfo({
  required String label,
  required String? value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9299A7),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value ?? "—",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF303641),
        ),
      ),
    ],
  );
}

// Widget _buildMetricDivider() {
//   return Container(
//     width: 1,
//     height: 28,
//     margin: const EdgeInsets.symmetric(horizontal: 6),
//     color: const Color(0xFFE1E4EA),
//   );
// }

// Widget _buildModernMetric({
//   required String label,
//   required String? value,
//   required IconData icon,
// })
// {
//   if (value == null) {
//     return _buildSkeleton(width: 60, height: 32);
//   }
//
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Icon(icon, size: 12, color: home1.withValues(alpha: 0.6)),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade500,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 6),
//       Container(
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: home2.withValues(alpha: 0.03)),
//         child: Text(
//           textAlign: TextAlign.center,
//           value,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade900,
//             letterSpacing: 0.9,
//           ),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ),
//       ),
//     ],
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
