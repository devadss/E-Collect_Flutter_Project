import 'dart:io';
import 'package:e_Collect/core/utils.dart';
import 'package:e_Collect/presentation/account_dues/rd_dues/rd_cust_acc_details_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors.dart';
import '../../../data/customer_list_bloc/customer_list_bloc.dart';
import 'package:flutter/material.dart';
import '../../../domain/model/agent_customer_details_model.dart';
import '../../../domain/model/customer_list_model/customer_list_model.dart';

class RdDueDetailPage extends StatefulWidget {
  final String eCollectMerchantID;
  final String eCollectMerchantName;
  final String eCollectAgentNumber;
  final String eCollectAgentEmail;
  final String eCollectBranchID;
  final String eCollectAgentID;
  final String eCollectUserToken;
  final String eCollectExternalAgentId;
  final List<String> eCollectUrlList;

  const RdDueDetailPage(
      {super.key,
      required this.eCollectBranchID,
      required this.eCollectAgentID,
      required this.eCollectUserToken,
      required this.eCollectUrlList,
      required this.eCollectMerchantID,
      required this.eCollectMerchantName,
      required this.eCollectAgentNumber,
      required this.eCollectAgentEmail,
      required this.eCollectExternalAgentId});

  @override
  State<RdDueDetailPage> createState() => _RdDueDetailPageState();
}

class _RdDueDetailPageState extends State<RdDueDetailPage> {
  String? agentId;
  String? corpCode;
  String? _rdListingUrl;
  String? rdDetailUrl;
  String? eCollectUserToken = "";
  bool? showShadowLoan = false;
  bool? showShadowAcc = true;
  bool _isProgressShowing = false;
  final TextEditingController searchController = TextEditingController();
  RdCustomerListSuccessModel? originalData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadSharedPrefs(context));
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context
        .read<CustomerListBloc>()
        .add(RdCustomerListFilterEvent(searchController.text));
  }

  Future<void> loadSharedPrefs(BuildContext context) async {
    for (var x in widget.eCollectUrlList) {
      if (x.contains("getRDCustomerunderAgentList")) _rdListingUrl = x;
      if (x.contains("")) rdDetailUrl = x;
    }
    context.read<CustomerListBloc>().add(RdCustomerListFetchEvent(
        _rdListingUrl!, widget.eCollectAgentID, widget.eCollectBranchID));
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search customers...",
          hintStyle: TextStyle(color: Colors.grey.shade500),

          /// 🔍 Prefix Icon
          prefixIcon: Icon(Icons.search, color: home1.withValues(alpha: 0.5)),

          /// ❌ Clear Button (modern UX)
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    searchController.clear();
                  },
                )
              : null,

          filled: true,
          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // pill shape
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: home1.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerList(List<Customer> customers) {
    return Expanded(
      child: customers.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return _buildCustomerItem(customer);
              },
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.9),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No customers found",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(Customer customer) {
    final accountNumber = customer.depGlobalAccNo;

    final initials = customer.custName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0].toUpperCase())
        .join();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _navigateToCustomerDetails(customer),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE8EBF0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─────────────────────────────
                  // CUSTOMER HEADER
                  // ─────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: home1.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: home1,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.custName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF172033),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Customer account',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8A93A5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Active
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 12,
                              color: Color(0xFF159957),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF159957),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ─────────────────────────────
                  // ACCOUNT NUMBER
                  // ─────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: Color(0xFF8A93A5),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ACCOUNT NUMBER',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8A93A5),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              accountNumber,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF20252D),
                                letterSpacing: 0.8,
                                fontFamily: Platform.isIOS
                                    ? 'Courier'
                                    : 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Copy
                      Material(
                        color: const Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: accountNumber),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Account number copied',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.copy_outlined,
                              size: 16,
                              color: Color(0xFF697386),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Subtle separator
                  Container(
                    height: 1,
                    color: const Color(0xFFF0F1F4),
                  ),

                  const SizedBox(height: 14),

                  // ─────────────────────────────
                  // ACTION
                  // ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            _navigateToCustomerDetails(customer);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: home1,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
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
                                'Collect Payment',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Material(
                        color: const Color(0xFFF4F5F7),
                        borderRadius: BorderRadius.circular(11),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(11),
                          onTap: () {
                            _navigateToCustomerDetails(customer);
                          },
                          child: const SizedBox(
                            height: 44,
                            width: 44,
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                              color: Color(0xFF4E5768),
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
      ),
    );
  }



  void _navigateToCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailNew(
          rdDetailsModel: RdDetailsModel(
              custName: customer.custName,
              accNo: customer.depGlobalAccNo,
              scheme: customer.schName,
              custId: customer.custId),
          ecollectMerchantModel: EcollectMerchantModel(
              eCollectMerchantName: widget.eCollectMerchantName,
              eCollectUserToken: widget.eCollectUserToken,
              eCollectAgentNumber: widget.eCollectAgentNumber,
              eCollectAgentEmail: widget.eCollectAgentEmail,
              eCollectCollectionType: "RD",
              eCollectAgentBranchCode: widget.eCollectBranchID,
              eCollectAgentMerchantID: widget.eCollectMerchantID,
              eCollectExternalAgentId: widget.eCollectExternalAgentId,
              eCollectAgentId: widget.eCollectAgentID),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: const Color(0xFFF7F8FA),
        body: BlocConsumer<CustomerListBloc, CustomerListState>(
          builder: (BuildContext context, CustomerListState state) {
            if (state is RdCustomerListSuccessState) {
              return Column(
                children: [
                  _buildSearchField(),
                  _buildCustomerList(state
                      .rdCustomerListSuccessModel.rdCustomerListModel.data),
                ],
              );
            } else if (state is RdCustomerListFilteredState) {
              final customers =
                  state.rdCustomerListSuccessModel.rdCustomerListModel.data;

              return Column(
                children: [
                  _buildSearchField(),
                  _buildCustomerList(customers),
                ],
              );
            } else if (state is RdCustomerListFailState) {
              return Center(
                child: const Text("No Data Found"),
              );
            }

            return SizedBox.shrink();
          },
          listener: (BuildContext context, CustomerListState state) {
            if (state is RdCustomerListLoaderState) {
              _isProgressShowing = true;
              showProgressDialog(context);
            }
            if (state is RdCustomerListSuccessState) {
              if (_isProgressShowing) {
                _isProgressShowing = false;
                Navigator.pop(context);
              }
            }
          },
        ));
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
            "Rd Customer List",
            style: TextStyle(
              color: home1,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/*  Widget _buildShimmerText(
      {double width = double.infinity, double height = 16})
  {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }*/

/*  Widget _buildShimmerList() {
    return Expanded(
        child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: white,
              border: Border.all(color: grey[100]!, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildShimmerText(width: 150),
                  const SizedBox(height: 10),
                  _buildShimmerText(width: 100),
                  const SizedBox(height: 10),
                  _buildShimmerText(width: 180),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }*/


// Widget _buildCustomerItem(Customer customer) {
//   final accountNumber = customer.depGlobalAccNo;
//   final initials = customer.custName
//       .trim()
//       .split(RegExp(r'\s+'))
//       .where((e) => e.isNotEmpty)
//       .take(2)
//       .map((e) => e[0].toUpperCase())
//       .join();
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//     child: Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () => _navigateToCustomerDetails(customer),
//         child: Ink(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Colors.grey.shade200,
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.035),
//                 blurRadius: 18,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // ─────────────────────────────
//                 // CUSTOMER HEADER
//                 // ─────────────────────────────
//                 Row(
//                   children: [
//                     Container(
//                       width: 44,
//                       height: 44,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: home1.withValues(alpha: 0.10),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         initials,
//                         style: TextStyle(
//                           color: home1,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 12),
//
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             customer.custName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF17191C),
//                               letterSpacing: -0.2,
//                             ),
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             'Customer account',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey.shade500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Status
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 9,
//                         vertical: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         color: home1.withValues(alpha: 0.08),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 6,
//                             height: 6,
//                             decoration: BoxDecoration(
//                               color: home1,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             'Active',
//                             style: TextStyle(
//                               color: home1,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 18),
//
//                 // ─────────────────────────────
//                 // ACCOUNT SECTION
//                 // ─────────────────────────────
//                 Container(
//                   padding: const EdgeInsets.all(13),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(
//                       color: Colors.grey.shade100,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'ACCOUNT NUMBER',
//                             style: TextStyle(
//                               fontSize: 9,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.grey.shade500,
//                               letterSpacing: 1.0,
//                             ),
//                           ),
//                           Text(
//                             'PRIMARY',
//                             style: TextStyle(
//                               fontSize: 9,
//                               fontWeight: FontWeight.w800,
//                               color: home1,
//                               letterSpacing: 0.7,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               accountNumber,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                                 color: const Color(0xFF202328),
//                                 letterSpacing: 1.2,
//                                 fontFamily:
//                                 Platform.isIOS ? 'Courier' : 'monospace',
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 8),
//
//                           Material(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(9),
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(9),
//                               onTap: () {
//                                 Clipboard.setData(
//                                   ClipboardData(text: accountNumber),
//                                 );
//
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Account number copied'),
//                                     duration: Duration(seconds: 1),
//                                   ),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(7),
//                                 child: Icon(
//                                   Icons.copy_rounded,
//                                   size: 16,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 // ─────────────────────────────
//                 // ACTIONS
//                 // ─────────────────────────────
//                 Row(
//                   children: [
//                     Expanded(
//                       child: FilledButton(
//                         onPressed: () {
//                           _navigateToCustomerDetails(customer);
//                         },
//                         style: FilledButton.styleFrom(
//                           backgroundColor: home1,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 13,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.arrow_upward_rounded,
//                               size: 17,
//                             ),
//                             SizedBox(width: 7),
//                             Text(
//                               'Collect Payment',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 10),
//
//                     Material(
//                       color: home1.withValues(alpha: 0.07),
//                       borderRadius: BorderRadius.circular(13),
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(13),
//                         onTap: () {
//                           _navigateToCustomerDetails(customer);
//                         },
//                         child: SizedBox(
//                           height: 46,
//                           width: 46,
//                           child: Icon(
//                             Icons.arrow_forward_rounded,
//                             color: home1,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }