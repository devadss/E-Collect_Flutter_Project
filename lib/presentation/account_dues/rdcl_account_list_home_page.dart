import 'package:collection_qr_flutter/presentation/account_dues/widgets/rdcl_account_due_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/colors.dart';
import '../../data/provider/rdcl_cust_list_provider.dart';
import '../../data/provider/rdcl_due_under_agent_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../dues/rdcl_due_home_page.dart';

class RdclAccountListHomePage extends StatefulWidget {
  const RdclAccountListHomePage({super.key});

  @override
  State<RdclAccountListHomePage> createState() => _AccountListHomePageState();
}

class _AccountListHomePageState extends State<RdclAccountListHomePage>
    with TickerProviderStateMixin {
  String? agentId;
  String? corpCode;
  String? branchCode;
  String? agentBranchCode;
  String? selectedFilterType;
  String? agentPhoneNumber;
  final GlobalKey _filterIconKey = GlobalKey();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSharedPrefs();
    });
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _fadeController.forward();
        _scaleController.forward();
      } else {
        _fadeController.reverse();
        _scaleController.reverse();
      }
    });
    super.initState();
  }
  void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
  @override
  void dispose() {
    _searchFocusNode.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final crpCd = await SharedPref().getCorpCode();
    final brCode = await SharedPref().getBranchCode();
    final number = await SharedPref().getParentAgentMobNum();
    if (mounted) {
      setState(() {
        agentId = id;
        agentPhoneNumber = number;
        corpCode = crpCd;
        branchCode = brCode;
      });
      print(
          "----------------------------------AGENT ORIGIN ID---------------------------");
      print(agentId);
      print("branchCode = $branchCode");
      final rdclDueUnderAgentProvider =
          Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
      await rdclDueUnderAgentProvider.getRdclDueList(agentId!, "","");
      setState(() {
        agentBranchCode = rdclDueUnderAgentProvider.rdclDueUnderAgentModel!.data[0].brCode;

      });
      final provider =
          Provider.of<RdclCustListProvider>(context, listen: false);
      //await provider.getRdclCustomerunderAgent(agentId!, "");
      print(
          "bRanch code : ${rdclDueUnderAgentProvider.rdclDueUnderAgentModel!.data[0].brCode}");
      await provider.getRdclCustomerunderAgent(
          "", rdclDueUnderAgentProvider.rdclDueUnderAgentModel!.data[0].brCode);
    }
  }


  // Filter customers based on search query
  List<dynamic> _filterCustomers(List<dynamic> allCustomers, String query) {
    if (query.isEmpty) return allCustomers;

    return allCustomers.where((customer) {
      final accNo = customer.rdclGlobalAccNo?.toLowerCase() ?? '';
      final name = customer.custName?.toLowerCase() ?? '';
      return accNo.contains(query.toLowerCase()) ||
          name.contains(query.toLowerCase());
    }).toList();
  }

  Widget buildShimmerText(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500), // Ensures smooth animation
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
  }

  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: white,
                border: Border.all(color: grey[300]!, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: black45,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(height: 10),
                    buildShimmerText(width: 100), // Customer ID
                    const SizedBox(height: 10),
                    buildShimmerText(width: 180), // Account Number
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<RdclCustListProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Customer List",
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 23, color: home2),
            )),
        backgroundColor: white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: home2.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: home2.withOpacity(0.2)),
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isSearchFocused = hasFocus;
                    });
                  },
                  child: TextField(
                    controller: _searchController, focusNode: _searchFocusNode,

                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      hintStyle: TextStyle(
                        color: grey[600],
                        fontSize: 14,
                      ),
                      prefixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isSearchFocused
                            ? const Icon(Icons.search, color: home2, size: 24)
                            : ShakeTransition(
                                duration: const Duration(milliseconds: 1500),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: home2.withOpacity(0.7),
                                  size: 24,
                                ),
                              ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: home2),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isSearchFocused
                                  ?
                              IconButton(
                                key: _filterIconKey,
                                icon: const Icon(Icons.tune_rounded,
                                    color: home2),
                                onPressed: () {
                                  final RenderBox renderBox =
                                  _filterIconKey.currentContext!
                                      .findRenderObject()
                                  as RenderBox;
                                  final Offset offset = renderBox
                                      .localToGlobal(Offset.zero);
                                  final Size size = renderBox.size;

                                  showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      offset.dx,
                                      offset.dy + size.height,
                                      offset.dx + size.width,
                                      offset.dy,
                                    ),
                                    items: [
                                      PopupMenuItem<String>(
                                        value: 'agent',
                                        child: Text('Filter by Agent ID', style: TextStyle(
                                            color: selectedFilterType != "agentid"?Colors.black:home1),),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'branch',
                                        child:
                                        Text('Filter by Branch ID',style: TextStyle(
                                            color: selectedFilterType != "branchid"?Colors.black:home1)),
                                      ),
                                    ],
                                  ).then((value) async {
                                    if (value == 'agent') {
                                      showProgressDialog(context);
                                      setState(() {
                                        selectedFilterType = "agentid";
                                      });
                                      await provider.getRdclCustomerunderAgent(
                                          agentId, "");
                                      print("Filter by Agent ID");


                                      Navigator.pop(context);
                                    } else if (value == 'branch') {
                                      showProgressDialog(context);
                                      await provider.getRdclCustomerunderAgent(
                                          "", agentBranchCode);
                                      setState(() {
                                        selectedFilterType = "branchid";
                                      });
                                      print("Filter by Branch ID");
                                      Navigator.pop(context);

                                    }
                                  });
                                },
                              )
                              // BounceTransition(
                              //         duration:
                              //             const Duration(milliseconds: 1000),
                              //         child: IconButton(
                              //           icon: const Icon(Icons.tune_rounded,
                              //               color: home2),
                              //           onPressed: () {},
                              //         ),
                              //       )
                                  : const SizedBox.shrink(),
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    style: const TextStyle(
                      color: black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<RdclCustListProvider>(
                builder: (context, provider, child) {
                  final allCustomers =
                      provider.rdclCustomerListModel?.data ?? [];
                  final filteredCustomers =
                      _filterCustomers(allCustomers, _searchController.text);

                  if (provider.rdclCustomerListModel == null) {
                    return buildShimmerList();
                  } else if (filteredCustomers.isEmpty) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? "No customers found"
                            : "No results found for '${_searchController.text}'",
                        style: TextStyle(color: grey[600]),
                      ),
                    );
                  }


                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RdclAccountDueDetailsPage(
                                  custName: customer.custName,
                                  custAcNumber: customer.rdclGlobalAccNo ??
                                      "RDCL GLOBAL ACC NO",
                                  custPhoneNumber: agentPhoneNumber!,
                                  custId: customer.custId ?? "CUSTID",
                                  custEmail: "",
                                  corpCode: corpCode.toString(),
                                  indexValue: index, branchCode: branchCode.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white,
                              border: Border.all(color: home1, width: 1.2),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    customer.custName ?? "CUST NAME",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Account Number : ${customer.rdclGlobalAccNo ?? "ACC No"}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 30,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: home1, width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/money.png",
                                                color: home2,
                                                scale: 25,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                "View details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: home2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Scheme Name : ${customer.schName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: filteredCustomers.length,
                  );
                },
              ),
            ),
          ],
        ));
  }
}
