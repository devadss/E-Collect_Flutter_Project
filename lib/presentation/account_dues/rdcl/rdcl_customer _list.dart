import 'package:e_Collect/core/colors.dart';
import 'package:e_Collect/presentation/account_dues/rdcl/rdcl_due_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/customer_list_bloc/customer_list_bloc.dart';
import '../../../domain/model/customer_list_model/customer_list_success.dart'
    as prefix0;


class RdclListModel{
  String? branchid;
  String? agentPhoneNumber;
  String? agentIdValue;
  String? eCollectMerchantName;
  String? eCollectAgentEmail;
  String? eCollectAgentBranchCode;
  String? eCollectAgentMerchantID;
  String? eCollectAgentOriginId;
  String? eCollectAgentId;
  String? eCollectToken;
  List<String>? eCollectUrlList;
  RdclListModel({
    required this.branchid,
    required this.agentPhoneNumber,
    required this.agentIdValue,
    required this.eCollectMerchantName,
    required this.eCollectAgentEmail,
    required this.eCollectAgentBranchCode,
    required this.eCollectAgentMerchantID,
    required this.eCollectAgentOriginId,
    required this.eCollectAgentId,
    required this.eCollectToken,
    required this.eCollectUrlList,
});
}

class RdclDueListBocPage extends StatefulWidget {
  final RdclListModel rdclListModel;
  const RdclDueListBocPage(
      {super.key, required this.rdclListModel});

  @override
  State<RdclDueListBocPage> createState() => RdclDueListBocPageState();
}

class RdclDueListBocPageState extends State<RdclDueListBocPage> {
  String? _rdclDetailUrl;
  String? _rdclUrl;
  static const String rdcLCustomerListCode = "getRdclCustomerunderAgentList";
  static const String rdcLCustomerDetailCode = "GetRdclDuesListunderAgent";
  final searchController = TextEditingController();
  bool iconSwitch = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  Future<void> loadSharedPrefs() async {
    for (var x in widget.rdclListModel.eCollectUrlList!) {
      if (x.contains(rdcLCustomerListCode)) {

          _rdclUrl = x;

      } else if (x.contains(rdcLCustomerDetailCode)) {

          _rdclDetailUrl = x;

      }
    }

    if (!mounted) return;
    context.read<CustomerListBloc>().add(
          CustomerListFetchEvent(
              _rdclUrl!, "", widget.rdclListModel.branchid.toString(), "0", "0", ""),
        );
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() {
      iconSwitch = !iconSwitch;
      if (!iconSwitch) {
        searchController.clear();
      }
    });

    context.read<CustomerListBloc>().add(
          CustomerListFetchEvent(
            _rdclUrl!,
            "",
            widget.rdclListModel.branchid.toString(),
            "0",
            "0",
            iconSwitch ? searchController.text : "",
          ),
        );
  }

  // Widget _buildInfoIcon(IconData icon) {
  //   return SizedBox(
  //     width: 42,
  //     child: Align(
  //       alignment: Alignment.topCenter,
  //       child: Container(
  //         width: 38,
  //         height: 38,
  //         decoration: BoxDecoration(
  //           color: home1.withValues(alpha: 0.07),
  //           borderRadius: BorderRadius.circular(11),
  //         ),
  //         child: Icon(
  //           icon,
  //           size: 19,
  //           color: home1,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildLabel(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       fontSize: 9,
  //       fontWeight: FontWeight.w800,
  //       letterSpacing: 0.9,
  //       color: Colors.grey.shade500,
  //     ),
  //   );
  // }
  //
  // Widget _buildBadge(String text) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 9,
  //       vertical: 5,
  //     ),
  //     decoration: BoxDecoration(
  //       color: home1.withValues(alpha: 0.07),
  //       borderRadius: BorderRadius.circular(7),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         fontSize: 10,
  //         fontWeight: FontWeight.w800,
  //         letterSpacing: 0.7,
  //         color: home1,
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildSearchContainer(),
          Expanded(
            child: BlocBuilder<CustomerListBloc, CustomerListState>(
              builder: (context, state) {
                prefix0.CustomerList? data;

                if (state is CustomerListLoaderState) {
                  return Center(
                    child: buildLoader(),
                  );
                }

                if (state is CustomerListFailState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Oops! Something went wrong",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.customerListFailModel.customerListFailResponse
                                .error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is CustomerListSuccessState) {
                  data = state.customerListSuccessModel
                      .customerListSuccessResponse.customerList;

                  if (data?.data == null || data!.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.people_outline_rounded,
                              color: Colors.grey[400],
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "No customers found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try adjusting your search",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    // itemCount: data.totalCount ?? 0,
                    itemCount: data.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final customer = data?.data?[index];
                      return
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF101828).withValues(alpha: 0.035),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RdclDueDetail(
                                      rdclDetailModel: RdclDetailModel(
                                        customerNumber:
                                        widget.rdclListModel.agentPhoneNumber.toString(),
                                        baseUrl: _rdclDetailUrl!,
                                        customerAccountNumber:
                                        customer!.rdclGlobalAccNo.toString(),
                                        custId: customer?.custId.toString(),
                                        eCollectAgentNumber:
                                        widget.rdclListModel.agentPhoneNumber,
                                        eCollectMerchantName:
                                        widget.rdclListModel.eCollectMerchantName,
                                        eCollectAgentEmail:
                                        widget.rdclListModel.eCollectAgentEmail,
                                        eCollectCollectionType: 'RDCL',
                                        eCollectAgentBranchCode:
                                        widget.rdclListModel.eCollectAgentBranchCode,
                                        eCollectAgentMerchantID:
                                        widget.rdclListModel.eCollectAgentMerchantID,
                                        eCollectAgentOriginId:
                                        widget.rdclListModel.eCollectAgentOriginId,
                                        eCollectAgentId:
                                        widget.rdclListModel.eCollectAgentId,
                                        eCollectToken:
                                        widget.rdclListModel.eCollectToken,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(18, 17, 16, 17),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // ───────────────────────────────────────
                                    // PRODUCT + CUSTOMER
                                    // ───────────────────────────────────────
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: home1.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_outlined,
                                            color: home1,
                                            size: 20,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "RDCL ACCOUNT",
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1.0,
                                                  color: home1,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                customer?.custName?.trim() ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF171A1F),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 22,
                                          color: Colors.grey.shade400,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    // ───────────────────────────────────────
                                    // ACCOUNT NUMBER
                                    // ───────────────────────────────────────
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 13,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FA),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(
                                            "ACCOUNT NUMBER",
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.0,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),

                                          const SizedBox(height: 5),

                                          Text(
                                            customer?.rdclGlobalAccNo ?? "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.2,
                                              color: Color(0xFF18212B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // ───────────────────────────────────────
                                    // SCHEME + CODE
                                    // ───────────────────────────────────────
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                "SCHEME",
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1.0,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),

                                              const SizedBox(height: 5),

                                              Text(
                                                customer?.schName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF343A40),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [

                                            Text(
                                              "CODE",
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.0,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text(
                                              customer?.schCode ?? "",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF343A40),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );


                      /* Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RdclDueDetail(
                                          rdclDetailModel: RdclDetailModel(
                                              customerNumber: widget.rdclListModel.agentPhoneNumber.toString(),
                                              baseUrl: _rdclDetailUrl!,
                                              customerAccountNumber: customer!.rdclGlobalAccNo.toString(),
                                              custId: customer?.custId.toString(),
                                              eCollectAgentNumber: widget.rdclListModel.agentPhoneNumber,
                                              eCollectMerchantName: widget.rdclListModel.eCollectMerchantName,
                                              eCollectAgentEmail: widget.rdclListModel.eCollectAgentEmail,
                                              eCollectCollectionType: 'RDCL',
                                              eCollectAgentBranchCode: widget.rdclListModel.eCollectAgentBranchCode,
                                              eCollectAgentMerchantID: widget.rdclListModel.eCollectAgentMerchantID,
                                              eCollectAgentOriginId: widget.rdclListModel.eCollectAgentOriginId,
                                              eCollectAgentId: widget.rdclListModel.eCollectAgentId,
                                              eCollectToken: widget.rdclListModel.eCollectToken),
                                        )
                                    ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Customer Name Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.green
                                              .withValues(alpha: 0.1),
                                        ),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.green.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          customer?.custName ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Account Number Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.blue
                                              .withValues(alpha: 0.1),
                                        ),
                                        child: Icon(
                                          Icons.account_balance_rounded,
                                          color: Colors.blue.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Account Number",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              customer?.rdclGlobalAccNo ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: home1,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Scheme Name Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.orange
                                              .withValues(alpha: 0.1),
                                        ),
                                        child: Icon(
                                          Icons.category_rounded,
                                          color: Colors.orange.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Scheme Name",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              customer?.schName ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );*/
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Column buildLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: home1.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: home1,
              strokeWidth: 3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Loading customers...",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Container buildSearchContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
        ),
        child: TextField(
          controller: searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: "Search customers by name...",
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
            ),
            prefixIcon: Icon(Icons.search_rounded, color: home1, size: 24),
            suffixIcon: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  iconSwitch ? Icons.close_rounded : Icons.send_rounded,
                  key: ValueKey(iconSwitch),
                  color: iconSwitch ? Colors.red : home1,
                  size: 22,
                ),
              ),
              onPressed: _handleSearch,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onSubmitted: (_) => _handleSearch(),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        "Customer List",
        style: TextStyle(
          color: home1,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
