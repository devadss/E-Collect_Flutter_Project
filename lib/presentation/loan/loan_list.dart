import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/data/provider/integrated_loan_detail_provider.dart';
import 'package:e_Collect/data/provider/integration_loan_list_provider.dart';
import 'package:e_Collect/domain/model/integrated_loan_list_model.dart';
import 'package:flutter/material.dart';
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
  const LoanList({super.key, required this.eCollectBranchId, required this.eCollectAgentID, required this.eCollectLoanListingUrl, required this.eCollectMerchantName, required this.eCollectAgentOriginID, required this.eCollectAgentMobNum, required this.eCollectAgentEmail, required this.eCollectAgentBranchCode, required this.eCollectAgentMerchantID, required this.eCollectToken});

  @override
  State<LoanList> createState() => _LoanListState();
}

class _LoanListState extends State<LoanList> {
  IntegratedLoanListResponse? _integratedLoanListResponse;
  List<CustomerData>? _filteredList;
 // bool? showShadowAcc = false;
 // bool? showShadowLoan = true;

  String? _branchId;
  String? _loanListingUrl;
  String? _loanDetailUrl;
  String? _agentId;

   void loadSharedPrefs(BuildContext context)  {
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

  Future<void> fetchIntegratedLoans() async {
    context.read<CustomerListBloc>().add(LoanCustomerListFetchEvent(_loanListingUrl!, _agentId!, _branchId!, "",""));
    //  final integratedLoanProvider = Provider.of<IntegratedLoanListProvider>(context, listen: false);
    //  await integratedLoanProvider.fetchIntegratedLoans(_loanListingUrl, _agentId, _branchId, "", "");
    // setState(() {
    //   _integratedLoanListResponse =
    //       integratedLoanProvider.integratedLoanListResponse;
    //   _filteredList = _integratedLoanListResponse!.data;
    // });
  }

  Future<void> fetchIntegratedLoanDetails(String accNo) async {
    showProgressDialog(context);
    final integratedLoanDetailProvider =
        Provider.of<IntegratedLoanDetailProvider>(context, listen: false);
    await integratedLoanDetailProvider.getIntegratedLoanDetails(
        _loanDetailUrl!, "", _branchId.toString(), "", "", accNo);
    if (integratedLoanDetailProvider
            .integratedLoanListResponse?.loanDate.isNotEmpty ==
        true) {
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntegratedLoanDetail(
                     integratedLoanDetailModel:
                IntegratedLoanDetailModel(loanDate: integratedLoanDetailProvider
                    .integratedLoanListResponse?.loanDate
                    .toString() ??"",
                    name: integratedLoanDetailProvider.integratedLoanListResponse?.name?? "", custNo: integratedLoanDetailProvider.integratedLoanListResponse?.custNo ??"",
                    loanAmount: integratedLoanDetailProvider
                        .integratedLoanListResponse?.loanAmount
                        .toString() ??
                        "", loanNumber:  integratedLoanDetailProvider
                        .integratedLoanListResponse?.acno
                        .toString() ??
                        "",loanType: integratedLoanDetailProvider
                        .integratedLoanListResponse?.loanType
                        .toString() ??
                        "", loanPeriod: integratedLoanDetailProvider
                        .integratedLoanListResponse?.loanPeriod
                        .toString() ??
                        "",
                    loanInterest:integratedLoanDetailProvider
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
                    interestAmountReceipt:integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[1]
                        .currentReceipt,
                    penalInterestAmountReceived: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[2]
                        .totalReceived,
                    penalInterestAmountBalance:  integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[2].balance,
                    penalInterestAmountOverdue: integratedLoanDetailProvider
                        .integratedLoanListResponse!.receiptDetails[2].overdue,
                    penalInterestAmountReceipt: integratedLoanDetailProvider
                        .integratedLoanListResponse!
                        .receiptDetails[2]
                        .currentReceipt), ecollectMerchantModelData: EcollectMerchantModelData(
                  eCollectMerchantName: widget.eCollectMerchantName,
                  eCollectAgentId: widget.eCollectAgentID,
                  eCollectAgentOriginId: widget.eCollectAgentOriginID,
                  eCollectAgentNumber:widget. eCollectAgentMobNum,
                  eCollectAgentEmail: widget.eCollectAgentEmail,
                  eCollectAgentBranchCode:widget. eCollectAgentBranchCode,
                  eCollectAgentMerchantID: widget.eCollectAgentMerchantID,
                  eCollectCollectionType: "LOAN", eCollectToken: widget.eCollectToken)
                ,

                  ))).then((_) {
        if (!mounted) return;
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
    final query = filterValue.toLowerCase().trim();

    final data = _integratedLoanListResponse?.data ?? [];

    setState(() {
      if (query.isEmpty) {
        _filteredList = data;
      } else {
        _filteredList = data.where((item) {
          return item.custName.toLowerCase().contains(query) ||
              item.lnGlobalAccNo.toLowerCase().contains(query);
        }).toList();
      }
    });
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   child: Container(
            //     height: 50,
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade100,
            //       borderRadius: BorderRadius.circular(30), // modern pill shape
            //     ),
            //     child: TextField(
            //       onChanged: filterList, // ✅ your logic unchanged
            //       style: const TextStyle(fontSize: 14),
            //       decoration: InputDecoration(
            //         hintText: "Search account number...",
            //         hintStyle: TextStyle(color: Colors.grey.shade500),
            //
            //         prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
            //
            //         border: InputBorder.none, // remove box border
            //         contentPadding: const EdgeInsets.symmetric(
            //             vertical: 14, horizontal: 10),
            //       ),
            //     ),
            //   ),
            // ),

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


    Expanded(
              child: ListView.builder(
                  itemCount: _filteredList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        fetchIntegratedLoanDetails(
                            _filteredList![index].lnGlobalAccNo.toString());
                      },
                      child:

                    //   Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //   horizontal: 12,
                    //   vertical: 6,
                    // ),
                    // child: Container(
                    // decoration: BoxDecoration(
                    // color: Colors.white,
                    // borderRadius: BorderRadius.circular(18),
                    // border: Border.all(
                    // color: const Color(0xFFE8EBF0),
                    // ),
                    // boxShadow: [
                    // BoxShadow(
                    // color: Colors.black.withOpacity(0.035),
                    // blurRadius: 14,
                    // offset: const Offset(0, 4),
                    // ),
                    // ],
                    // ),
                    // child: Material(
                    // color: Colors.transparent,
                    // borderRadius: BorderRadius.circular(18),
                    // child: InkWell(
                    // borderRadius: BorderRadius.circular(18),
                    // splashColor: home1.withValues(alpha: 0.05),
                    // highlightColor: home1.withValues(alpha: 0.02),
                    // onTap: () {
                    // fetchIntegratedLoanDetails(
                    // _filteredList![index].lnGlobalAccNo.toString(),
                    // );
                    // },
                    // child: Padding(
                    // padding: const EdgeInsets.all(16),
                    // child: Column(
                    // children: [
                    // // --------------------------------------------------
                    // // Customer Header
                    // // --------------------------------------------------
                    // Row(
                    // children: [
                    // Container(
                    // width: 48,
                    // height: 48,
                    // decoration: BoxDecoration(
                    // color: home1.withValues(alpha: 0.08),
                    // borderRadius: BorderRadius.circular(14),
                    // ),
                    // child: Center(
                    // child: _filteredList?[index].custName == null
                    // ? _buildSkeleton(
                    // width: 22,
                    // height: 22,
                    // )
                    //     : Text(
                    // (_filteredList?[index].custName ?? "?")
                    //     .substring(0, 1)
                    //     .toUpperCase(),
                    // style: TextStyle(
                    // fontSize: 18,
                    // fontWeight: FontWeight.w800,
                    // color: home1,
                    // ),
                    // ),
                    // ),
                    // ),
                    //
                    // const SizedBox(width: 12),
                    //
                    // Expanded(
                    // child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // children: [
                    // _filteredList?[index].custName == null
                    // ? _buildSkeleton(
                    // width: 140,
                    // height: 17,
                    // )
                    //     : Text(
                    // _filteredList?[index].custName ?? "",
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                    // style: const TextStyle(
                    // fontSize: 15,
                    // fontWeight: FontWeight.w700,
                    // color: Color(0xFF172033),
                    // ),
                    // ),
                    //
                    // const SizedBox(height: 5),
                    //
                    // Row(
                    // children: [
                    // Container(
                    // width: 6,
                    // height: 6,
                    // decoration: const BoxDecoration(
                    // color: Color(0xFF22A06B),
                    // shape: BoxShape.circle,
                    // ),
                    // ),
                    // const SizedBox(width: 6),
                    // Flexible(
                    // child: Text(
                    // _filteredList?[index].schName ?? "",
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                    // style: const TextStyle(
                    // fontSize: 11,
                    // fontWeight: FontWeight.w500,
                    // color: Color(0xFF7B8495),
                    // ),
                    // ),
                    // ),
                    // ],
                    // ),
                    // ],
                    // ),
                    // ),
                    //
                    // // Active status
                    // Container(
                    // padding: const EdgeInsets.symmetric(
                    // horizontal: 9,
                    // vertical: 5,
                    // ),
                    // decoration: BoxDecoration(
                    // color: const Color(0xFFEAF8F0),
                    // borderRadius: BorderRadius.circular(20),
                    // ),
                    // child: const Row(
                    // mainAxisSize: MainAxisSize.min,
                    // children: [
                    // Icon(
                    // Icons.check_circle_rounded,
                    // size: 12,
                    // color: Color(0xFF159957),
                    // ),
                    // SizedBox(width: 4),
                    // Text(
                    // "Active",
                    // style: TextStyle(
                    // fontSize: 9,
                    // fontWeight: FontWeight.w700,
                    // color: Color(0xFF159957),
                    // ),
                    // ),
                    // ],
                    // ),
                    // ),
                    // ],
                    // ),
                    //
                    // const SizedBox(height: 16),
                    //
                    // // --------------------------------------------------
                    // // Account Information
                    // // --------------------------------------------------
                    // Container(
                    // padding: const EdgeInsets.symmetric(
                    // horizontal: 13,
                    // vertical: 12,
                    // ),
                    // decoration: BoxDecoration(
                    // color: const Color(0xFFF8F9FB),
                    // borderRadius: BorderRadius.circular(13),
                    // ),
                    // child: Row(
                    // children: [
                    // Expanded(
                    // child: _buildModernMetric(
                    // label: "Customer ID",
                    // value: _filteredList?[index].custId,
                    // icon: Icons.person_outline_rounded,
                    // ),
                    // ),
                    //
                    // _buildMetricDivider(),
                    //
                    // Expanded(
                    // child: _buildModernMetric(
                    // label: "Account",
                    // value: _filteredList?[index].lnGlobalAccNo,
                    // icon: Icons.account_balance_wallet_outlined,
                    // ),
                    // ),
                    //
                    // _buildMetricDivider(),
                    //
                    // Expanded(
                    // child: _buildModernMetric(
                    // label: "Scheme",
                    // value: _filteredList?[index].schCode,
                    // icon: Icons.layers_outlined,
                    // ),
                    // ),
                    // ],
                    // ),
                    // ),
                    //
                    // const SizedBox(height: 14),
                    //
                    // // --------------------------------------------------
                    // // Actions
                    // // --------------------------------------------------
                    // Row(
                    // children: [
                    // Expanded(
                    // child: OutlinedButton(
                    // onPressed: () {
                    // fetchIntegratedLoanDetails(
                    // _filteredList![index]
                    //     .lnGlobalAccNo
                    //     .toString(),
                    // );
                    // },
                    // style: OutlinedButton.styleFrom(
                    // foregroundColor: const Color(0xFF4E5768),
                    // side: const BorderSide(
                    // color: Color(0xFFDDE1E8),
                    // ),
                    // shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(11),
                    // ),
                    // padding: const EdgeInsets.symmetric(
                    // vertical: 11,
                    // ),
                    // ),
                    // child: const Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                    // Icon(
                    // Icons.visibility_outlined,
                    // size: 17,
                    // ),
                    // SizedBox(width: 7),
                    // Text(
                    // "Details",
                    // style: TextStyle(
                    // fontSize: 12,
                    // fontWeight: FontWeight.w700,
                    // ),
                    // ),
                    // ],
                    // ),
                    // ),
                    // ),
                    //
                    // const SizedBox(width: 10),
                    //
                    // Expanded(
                    // flex: 1,
                    // child: FilledButton(
                    // onPressed: () {
                    // fetchIntegratedLoanDetails(
                    // _filteredList![index]
                    //     .lnGlobalAccNo
                    //     .toString(),
                    // );
                    // },
                    // style: FilledButton.styleFrom(
                    // backgroundColor: home1,
                    // foregroundColor: Colors.white,
                    // elevation: 0,
                    // shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(11),
                    // ),
                    // padding: const EdgeInsets.symmetric(
                    // vertical: 11,
                    // ),
                    // ),
                    // child: const Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                    // Icon(
                    // Icons.payments_outlined,
                    // size: 17,
                    // ),
                    // SizedBox(width: 7),
                    // Text(
                    // "Collect",
                    // style: TextStyle(
                    // fontSize: 12,
                    // fontWeight: FontWeight.w700,
                    // ),
                    // ),
                    // ],
                    // ),
                    // ),
                    // ),
                    // ],
                    // ),
                    // ],
                    // ),
                    // ),
                    // ),
                    // ),
                    // ),
                    // )


                    Padding(
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
                    _filteredList![index].lnGlobalAccNo.toString(),
                    );
                    },
                    splashColor: home1.withValues(alpha: 0.04),
                    highlightColor: home1.withValues(alpha: 0.02),
                    child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                    color: const Color(0xFFE9ECF1),
                    ),
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: home1.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                    ),
                    child: Center(
                    child: _filteredList?[index].custName == null
                    ? _buildSkeleton(
                    width: 20,
                    height: 20,
                    )
                        : Text(
                    (_filteredList?[index].custName ?? "?")
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: home1,
                    ),
                    ),
                    ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    _filteredList?[index].custName == null
                    ? _buildSkeleton(
                    width: 130,
                    height: 16,
                    )
                        : Text(
                    _filteredList?[index].custName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF151922),
                    ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                    _filteredList?[index].schName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A91A0),
                    ),
                    ),
                    ],
                    ),
                    ),

                    // Status
                    Container(
                    padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                    ),
                    decoration: BoxDecoration(
                    color: const Color(0xFFEAF8F1),
                    borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                    mainAxisSize: MainAxisSize.min,
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
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF159957),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                    Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    const Text(
                    "Loan Account",
                    style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A91A0),
                    ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                    _filteredList?[index].lnGlobalAccNo ?? "—",
                    style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: Color(0xFF171A21),
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
                    color: const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                    Icons.arrow_forward_ios_rounded,
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
                    value: _filteredList?[index].custId,
                    ),
                    ),

                    Expanded(
                    child: _buildFintechInfo(
                    label: "Scheme",
                    value: _filteredList?[index].schCode,
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
                    _filteredList![index]
                        .lnGlobalAccNo
                        .toString(),
                    );
                    },
                    style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF424956),
                    side: const BorderSide(
                    color: Color(0xFFE1E4E9),
                    ),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    child: const Text(
                    "Details",
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
                    _filteredList![index]
                        .lnGlobalAccNo
                        .toString(),
                    );
                    },
                    style: FilledButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(
                    Icons.payments_outlined,
                    size: 17,
                    ),
                    SizedBox(width: 7),
                    Text(
                    "Collect Payment",
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
                    )


                    );
                  }),
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
