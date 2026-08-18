import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/account_dues/rdcl_cust_list_bloc/rdcl_due_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/customer_list_bloc/customer_list_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/customer_list_model/customer_list_success.dart' as prefix0;

class RdclDueListBocPage extends StatefulWidget {
  const RdclDueListBocPage({super.key});

  @override
  State<RdclDueListBocPage> createState() => RdclDueListBocPageState();
}
class RdclDueListBocPageState extends State<RdclDueListBocPage> {
  String? branchid;
  String? agentPhoneNumber;
  String? agentIdValue;
  final searchController = TextEditingController();
  bool iconSwitch = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }
  Future<void> refresh()async{
    print("Here");
    searchController.clear();
    context.read<CustomerListBloc>().add(CustomerListFetchEvent("", branchid.toString(), "1", "10", ""),);

  }
  Future<void> loadSharedPrefs() async {
    final result  = await Future.wait([
      SharedPref.shared.getECollectMerchantBranchCode(),
      SharedPref.shared.getParentAgentMobNum(),
      SharedPref.shared.getAgentId(),
    ]);
    branchid = result[0];
    agentPhoneNumber = result[1];
    agentIdValue = result[2];

    if(!mounted) return;
    context.read<CustomerListBloc>().add(CustomerListFetchEvent("", branchid.toString(), "1", "10", ""),);


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

    context.read<CustomerListBloc>().add(CustomerListFetchEvent("", branchid.toString(), "1", "10", iconSwitch ? searchController.text : "",
      ),
    );
  }

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
                            state.customerListFailModel.customerListFailResponse.error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is CustomerListSuccessState) {
                  data = state.customerListSuccessModel.customerListSuccessResponse.customerList;

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
                      return Container(
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
                                  builder: (context) => RdclDueDetail(
                                    branchCode: branchid.toString(),
                                    customeName: customer?.custName ?? "",
                                    custPhoneNumber: agentPhoneNumber.toString(),
                                    custIdNew: customer?.custId.toString() ?? "",
                                    custAcNumber: customer?.rdclGlobalAccNo.toString() ?? "",
                                    custId: customer?.custId.toString() ?? "",
                                  ),
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
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.green.withValues(alpha: 0.1),
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
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.blue.withValues(alpha: 0.1),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.orange.withValues(alpha: 0.1),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      );
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
      title: Text(
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

