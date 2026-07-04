import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bucket/creation/merchant_bucket_creation.dart';

class AllGroupsPage extends StatefulWidget {
  const AllGroupsPage({super.key});

  @override
  State<AllGroupsPage> createState() => _AllGroupsPageState();
}

class _AllGroupsPageState extends State<AllGroupsPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String bc = "BR001";
  String cc = "CORP001";

  // 🔹 VERIFICATION STATE - Change this to true/false to test
  bool isVerified = true; // Set to false for unverified state

  // Dummy groups data
  final List<Map<String, dynamic>> dummyGroups = [
    {
      "groupId": 1,
      "groupName": "Alpha Investments",
      "defaultAmount": 5000,
      "defaultDueDate": DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      "status": "Active",
      "createdDate": DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      "corpCode": "CORP001"
    },
    {
      "groupId": 2,
      "groupName": "Beta Savings",
      "defaultAmount": 3000,
      "defaultDueDate": DateTime.now().add(const Duration(days: 12)).toIso8601String(),
      "status": "Inactive",
      "createdDate": DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
      "corpCode": "CORP001"
    },
    {
      "groupId": 3,
      "groupName": "Gamma Ventures",
      "defaultAmount": 7500,
      "defaultDueDate": DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      "status": "Active",
      "createdDate": DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      "corpCode": "CORP001"
    },
    {
      "groupId": 4,
      "groupName": "Delta Alliance",
      "defaultAmount": 2500,
      "defaultDueDate": DateTime.now().add(const Duration(days: 20)).toIso8601String(),
      "status": "Pending",
      "createdDate": DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      "corpCode": "CORP001"
    },
    {
      "groupId": 5,
      "groupName": "Epsilon Circle",
      "defaultAmount": 10000,
      "defaultDueDate": DateTime.now().add(const Duration(days: 8)).toIso8601String(),
      "status": "Active",
      "createdDate": DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      "corpCode": "CORP001"
    },
    {
      "groupId": 6,
      "groupName": "Zeta Partners",
      "defaultAmount": 4500,
      "defaultDueDate": DateTime.now().add(const Duration(days: 25)).toIso8601String(),
      "status": "Inactive",
      "createdDate": DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
      "corpCode": "CORP002"
    },
  ];

  List<Map<String, dynamic>> _filteredGroups = [];

  @override
  void initState() {
    super.initState();
    _filteredGroups = dummyGroups.where((d) => d["corpCode"] == cc).toList();
    _searchController.addListener(_filterGroups);
  }

  void _filterGroups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = dummyGroups
          .where((group) =>
      group["corpCode"] == cc &&
          group["groupName"].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: isVerified ? home2 : Colors.grey.shade400,
        onPressed: isVerified
            ? () {
        
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context)=>MerchantBucketCreationPage(selectedIndex: 889898493849, groupId: 1,) )
          );
        }
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(
          isVerified ? Icons.add : Icons.lock_outline,
          color: isVerified ? Colors.white : Colors.grey.shade600,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(

            centerTitle: true,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEA307B)
                // gradient: LinearGradient(
                //   colors: [home1, home2],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
              ),
            ),
            automaticallyImplyLeading: false,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSearching
                  ? const SizedBox()
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Buckets",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  if (!isVerified) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade300.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Locked",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade100,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: isVerified
                    ? () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) _searchController.clear();
                  });
                }
                    : null,
                color: isVerified ? Colors.white : Colors.white.withValues(alpha: 0.4),
              ),
            ],
            bottom: _isSearching && isVerified
                ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      hintText: "Search groups...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            )
                : null,
          ),
        ],
        body: isVerified
            ? (_filteredGroups.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          itemCount: _filteredGroups.length,
          itemBuilder: (context, index) {
            final group = _filteredGroups[index];
            final color = group["status"] == "Active"
                ? Colors.primaries[index % Colors.primaries.length]
                : Colors.grey;

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.98 + (0.02 * value),
                      child: child,
                    ),
                  ),
                );
              },
              child: _buildGroupCard(group, color, index),
            );
          },
        ))
            : _buildUnverifiedState(),
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group, Color color, int index) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: isVerified
            ? () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context)=>
            MerchantBucketCreationPage(selectedIndex: 0, groupId: 0,))
          );
        }
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              /// Avatar
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.business_center_outlined,
                    color: color.withValues(alpha: 0.9),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 18),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group["groupName"],
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (group["status"] == "Active")
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    /// Amount + Due
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "₹${group["defaultAmount"]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.event_available_rounded,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatCompactDate(group["defaultDueDate"]),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// Bottom Row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(group["createdDate"]),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        if (group["status"] == "Active")
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "In progress",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              /// Arrow
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnverifiedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Lock Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),

            /// Title
            Text(
              "Access Locked",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),

            /// Description
            Text(
              "Your account is currently under verification. Once the verification is complete, you'll be able to access all groups and features.",              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            /// Verification Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade50,
                    Colors.orange.shade100.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange.shade300.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Verification in progress. You'll get access to all groups once verified.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 72, color: home1.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          Text(
            _searchController.text.isEmpty
                ? "No groups created yet"
                : "No matching groups found",
            style: TextStyle(fontSize: 18, color: home1.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () => _searchController.clear(),
                child: const Text("Clear search"),
              ),
            ),
        ],
      ),
    );
  }
}

// Helper functions
String _formatCompactDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Tomorrow";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days left";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks week${weeks > 1 ? 's' : ''} left";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  } catch (e) {
    return dateStr;
  }
}

String _formatDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy').format(date);
  } catch (e) {
    return dateStr;
  }
}

// Color constants
const Color home1 = Color(0xFF6C63FF);
const Color home2 = Color(0xFF4A42D4);