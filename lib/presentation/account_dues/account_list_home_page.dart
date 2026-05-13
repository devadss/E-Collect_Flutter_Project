import 'dart:io';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:collection_qr_flutter/presentation/account_dues/widgets/account_detail_new.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/colors.dart';
import '../../data/provider/agent_customer_details_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/model/agent_customer_details_model.dart';
import '../loan_integrated/loan_list.dart';

class AccountListHomePage extends StatefulWidget {
  const AccountListHomePage({super.key});

  @override
  State<AccountListHomePage> createState() => _AccountListHomePageState();
}

class _AccountListHomePageState extends State<AccountListHomePage>  {
  String? agentId;
  String? corpCode;
  bool? showShadowLoan = false;
  bool? showShadowAcc = true;
  final TextEditingController searchController = TextEditingController();
  List<Customer>? _filteredCustomers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCustomers(searchController.text);
  }

  void _filterCustomers(String query) {
    final provider = Provider.of<AgentCustomerDetailsProvider>(
      context,
      listen: false,
    );
    final originalList = provider.agentCustomerDetailsModel?.data ?? [];

    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = originalList;
      });
      return;
    }

    final filtered = originalList.where((customer) {
      final name = customer.custName.toLowerCase() ?? '';
      final accNo = customer.depGlobalAccNo.toString().toLowerCase() ?? '';
      final search = query.toLowerCase();

      return name.contains(search) || accNo.contains(search);
    }).toList();

    setState(() {
      _filteredCustomers = filtered;
    });
  }

  Future<void> _initializeData() async {
    try {
      final id = await SharedPref().getAgentOriginId();
      final crpCd = await SharedPref().getCorpCode();

      if (!mounted) return;

      setState(() {
        agentId = id;
        corpCode = crpCd;
        _isLoading = true;
      });

      final provider = Provider.of<AgentCustomerDetailsProvider>(
        context,
        listen: false,
      );

      await provider.getAgentCustomerDetails(agentId!);

      if (!mounted) return;

      setState(() {
        _filteredCustomers = provider.agentCustomerDetailsModel?.data;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Handle error appropriately
     // print("Error initializing data: $error");
    }
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
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),

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
          fillColor: Colors.grey.shade100,

          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // pill shape
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: home1.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildShimmerText(
      {double width = double.infinity, double height = 16}) {
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
  }

  Widget _buildShimmerList() {
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
      )
    );
  }

  Widget _buildCustomerList(List<Customer> customers) {
    return Expanded(

      child: customers.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return _buildCustomerItem(customer);
              },
            ).animate()
          .fadeIn(duration: 500.ms)
          .slideX(begin: -0.9),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text("No customers found", style: TextStyle(fontSize: 18, color: Colors.grey),),
        ],
      ),
    );
  }
  Widget _buildCustomerItem(Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _navigateToCustomerDetails(customer),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 Customer Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                        color: home1.withOpacity(0.2)),
                        child: Icon(Icons.person_rounded, size: 20, color: home1)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        customer.custName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🏦 Account Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Number",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: home1.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Primary",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: home1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// 🔢 Account Number Display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        color: home1.withOpacity(0.2)),
                        child: Icon(Icons.account_balance, size: 18, color: home1)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: home2.withOpacity(0.03)
                        ),
                        child: Text(
                          customer.depGlobalAccNo,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: customer.depGlobalAccNo));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied!'), duration: Duration(seconds: 1)),
                        );
                      },
                      child: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🎯 Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: () {
                          _navigateToCustomerDetails(customer);
                        },
                        icon: const Icon(Icons.payments_rounded, size: 18),
                        label: const Text(
                          'Collect',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: home1,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _navigateToCustomerDetails(customer);
                        },
                        icon: Icon(Icons.info_rounded, size: 18, color: home1),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: home1,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(color: home1.withOpacity(0.5)),
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
    );
  }

  void _navigateToCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailNew(
          custName: customer.custName,
          accNo: customer.depGlobalAccNo,
          scheme: customer.schName,
          custId: customer.custId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: white,
        body:TabBarView(children: [
          Consumer<AgentCustomerDetailsProvider>(
            builder: (context, provider, child) {
              if (_isLoading || provider.agentCustomerDetailsModel == null) {
                return Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 20),
                    _buildShimmerList(),
                  ],
                );
              }
              final customers = _filteredCustomers ?? provider.agentCustomerDetailsModel!.data;

              return Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 20),
                  _buildCustomerList(customers),
                ],
              );
            },
          ),
          LoanList()
        ])


      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 100,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Customer List",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.6),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SegmentedTabControl(
                indicatorPadding: const EdgeInsets.all(4),
                indicatorDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [home1, home1.withOpacity(0.85)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: home1.withOpacity(0.9),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                barDecoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                tabs: [
                  SegmentTab(
                    label: "RD",
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey.shade600,
                    selectedTextColor: Colors.white,
                  ),
                  SegmentTab(
                    label: "LOANS",
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey.shade600,
                    selectedTextColor: Colors.white,
                  ),
                ],
              ),
            )

          ],
        ),
      );
  }
}

