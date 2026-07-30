import 'package:flutter/material.dart';

class IntegratedRDCLCustomerList extends StatefulWidget {
  const IntegratedRDCLCustomerList({super.key});

  @override
  State<IntegratedRDCLCustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<IntegratedRDCLCustomerList> {
  String? branchid;
  String? agentPhoneNumber;
  String? agentIdValue;
  final searchController = TextEditingController();
  bool iconSwitch = false;
  final FocusNode _searchFocusNode = FocusNode();

  // Simulated data for UI preview
  final List<Map<String, String>> mockCustomers = [
    {
      'custName': 'John Doe',
      'rdclGlobalAccNo': 'ACC-2024-001',
      'schName': 'Gold Savings Scheme',
    },
    {
      'custName': 'Jane Smith',
      'rdclGlobalAccNo': 'ACC-2024-002',
      'schName': 'Silver Investment Plan',
    },
    {
      'custName': 'Robert Johnson',
      'rdclGlobalAccNo': 'ACC-2024-003',
      'schName': 'Premium Wealth Management',
    },
    {
      'custName': 'Maria Garcia',
      'rdclGlobalAccNo': 'ACC-2024-004',
      'schName': 'Basic Savings Account',
    },
    {
      'custName': 'David Wilson',
      'rdclGlobalAccNo': 'ACC-2024-005',
      'schName': 'Retirement Plus Scheme',
    },
  ];

  @override
  void initState() {
    super.initState();
    // No API calls in UI-only version
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
    // Search functionality without API
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
            child: buildCustomerList(),
          ),
        ],
      ),
    );
  }

  Widget buildCustomerList() {
    // Filter customers based on search
    final filteredCustomers = mockCustomers.where((customer) {
      final searchText = searchController.text.toLowerCase();
      if (searchText.isEmpty) return true;
      return customer['custName']!.toLowerCase().contains(searchText);
    }).toList();

    if (filteredCustomers.isEmpty) {
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
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = filteredCustomers[index];
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
                // Navigation without API
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
                            customer['custName'] ?? "",
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
                                customer['rdclGlobalAccNo'] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF1A237E), // home1 color
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
                                customer['schName'] ?? "",
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
            prefixIcon: Icon(
              Icons.search_rounded,
              color: const Color(0xFF1A237E), // home1 color
              size: 24,
            ),
            suffixIcon: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  iconSwitch ? Icons.close_rounded : Icons.send_rounded,
                  key: ValueKey(iconSwitch),
                  color: iconSwitch ? Colors.red : const Color(0xFF1A237E), // home1 color
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
          color: const Color(0xFF1A237E), // home1 color
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}