import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/auth/mobile_number_page.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

import '../../../data/storage/shared_pref_helper.dart';

class GroupHomePageUI extends StatefulWidget {
  const GroupHomePageUI({super.key});

  @override
  State<GroupHomePageUI> createState() => _GroupHomePageUIState();
}

class _GroupHomePageUIState extends State<GroupHomePageUI> {
  String userBranchCode = "BR001";
  String userCorpCode = "CORP001";
  String groupUserName = "";
  bool isExpanded = false;
  final int availableMembers = 25;
  final int selectedMonthIndex = DateTime.now().month - 1;
  final int currentYear = DateTime.now().year;
  final data = [
    {
      'month': 'Jan',
      'settlement': 50000,
      'paid': 42000,
      'due': 8000,
    },
    {
      'month': 'Feb',
      'settlement': 48000,
      'paid': 45000,
      'due': 3000,
    },
    {
      'month': 'Mar',
      'settlement': 53000,
      'paid': 47000,
      'due': 6000,
    },
  ];

  final List<String> months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
  final Map<String, dynamic> monthData = {
    "collected": 32000,
    "due": 8000,
  };

  // 🔹 VERIFICATION STATE - Change this to true/false to test
  bool isVerified = false; // Set to false for unverified state

  // Dummy groups data
  final List<Map<String, dynamic>> groups = [
    {
      "groupName": "Group A",
      "defaultAmount": 5000,
      "defaultDueDate": DateTime.now().add(const Duration(days: 5)),
      "status": "Active",
      "createdDate": DateTime.now().subtract(const Duration(days: 30))
    },
    {
      "groupName": "Group B",
      "defaultAmount": 3000,
      "defaultDueDate": DateTime.now().add(const Duration(days: 12)),
      "status": "Inactive",
      "createdDate": DateTime.now().subtract(const Duration(days: 45))
    },
    {
      "groupName": "Group C",
      "defaultAmount": 7500,
      "defaultDueDate": DateTime.now().add(const Duration(days: 3)),
      "status": "Active",
      "createdDate": DateTime.now().subtract(const Duration(days: 15))
    },
    {
      "groupName": "Group D",
      "defaultAmount": 2500,
      "defaultDueDate": DateTime.now().add(const Duration(days: 20)),
      "status": "Pending",
      "createdDate": DateTime.now().subtract(const Duration(days: 60))
    },
  ];
  void getSharedData() async {
    var name  = await SharedPref.shared.getECollectMerchantName();
setState(() {
  groupUserName  = name;
});



  }

  @override
  void initState() {
    getSharedData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const totalCollected = 100;
    const totalDue = 50;
    final activeGroups = groups.where((g) => g["status"] == "Active").length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Welcome Card
              _buildWelcomeCard(),
              const SizedBox(height: 24),

              /// 🔹 Verification Banner (shown when not verified)
              if (!isVerified) _buildVerificationBanner(),
              if (!isVerified) const SizedBox(height: 24),

              /// 🔹 Monthly Financial Summary (shown only when verified)
              if (isVerified) ...[
                Container(
                  height: 340,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem(Colors.blue, "Settlement"),
                          const SizedBox(width: 20),
                          _legendItem(Colors.green, "Paid"),
                          const SizedBox(width: 20),
                          _legendItem(Colors.red, "Due"),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Chart
                      Expanded(
                        child: Chart(
                          data: data,
                          variables: {
                            'month': Variable(
                              accessor: (Map map) => map['month'].toString(),
                            ),
                            'settlement': Variable(
                              accessor: (Map map) => map['settlement'] as num,
                            ),
                            'paid': Variable(
                              accessor: (Map map) => map['paid'] as num,
                            ),
                            'due': Variable(
                              accessor: (Map map) => map['due'] as num,
                            ),
                          },
                          marks: [
                            LineMark(
                              position: Varset('month') * Varset('settlement'),
                              color: ColorEncode(value: Colors.blue),
                            ),
                            PointMark(
                              position: Varset('month') * Varset('settlement'),
                              color: ColorEncode(value: Colors.blue),
                            ),
                            LineMark(
                              position: Varset('month') * Varset('paid'),
                              color: ColorEncode(value: Colors.green),
                            ),
                            PointMark(
                              position: Varset('month') * Varset('paid'),
                              color: ColorEncode(value: Colors.green),
                            ),
                            LineMark(
                              position: Varset('month') * Varset('paid'),
                              color: ColorEncode(value: Colors.green),
                            ),
                            PointMark(
                              position: Varset('month') * Varset('paid'),
                              color: ColorEncode(value: Colors.green),
                            ),
                            LineMark(
                              position: Varset('month') * Varset('due'),
                              color: ColorEncode(value: Colors.red),
                            ),
                            PointMark(
                              position: Varset('month') * Varset('due'),
                              color: ColorEncode(value: Colors.red),
                            ),
                          ],
                          axes: [
                            Defaults.horizontalAxis,
                            Defaults.verticalAxis,
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                // Text(
                //   "${months[selectedMonthIndex]} $currentYear Financials",
                //   style: const TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // const SizedBox(height: 16),
                //
                // GridView.count(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   crossAxisCount: 2,
                //   childAspectRatio: 1.15,
                //   crossAxisSpacing: 14,
                //   mainAxisSpacing: 14,
                //   children: [
                //     _modernStatCard(
                //       title: "Total Collected",
                //       value: "₹${monthData["collected"]}",
                //       color: Colors.teal,
                //       icon: Icons.arrow_downward,
                //     ),
                //     _modernStatCard(
                //       title: "Pending Dues",
                //       value: "₹${monthData["due"]}",
                //       color: Colors.orange,
                //       icon: Icons.arrow_upward,
                //     ),
                //     _modernStatCard(
                //       title: "Active Groups",
                //       value: activeGroups.toString(),
                //       color: const Color(0xFF6C63FF),
                //       icon: Icons.group,
                //     ),
                //     _modernStatCard(
                //       title: "Active Members",
                //       value: availableMembers.toString(),
                //       color: const Color(0xFFEA307B),
                //       icon: Icons.groups,
                //     ),
                //   ],
                // ),
                //
                // const SizedBox(height: 24),
              ],

              /// 🔹 Cumulative Overview (shown only when verified)
              if (isVerified) ...[
                _buildCumulativeOverview(totalCollected, totalDue),
                const SizedBox(height: 24),
              ],

              /// 🔹 Groups Section - Conditional based on verification
              if (isVerified) ...[
                _buildGroupsSection(),
                const SizedBox(height: 20),
              ] else ...[
                _buildUnverifiedGroupsSection(),
                const SizedBox(height: 20),
              ],

              /// 🔹 Expandable Payment Section (always visible but disabled when unverified)
              _buildPaymentSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(decoration: BoxDecoration(
      //
      //   borderRadius: BorderRadius.circular(10),
      //   color: Colors.white
      // ),),
    );
  }

  /// ================= UI COMPONENTS =================

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _modernCardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEA307B),
                  home2,
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFFEA307B)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  groupUserName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                if (!isVerified) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Pending Verification",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                SharedPref.shared.setECollectMerchantUserName("");
                SharedPref.shared.setECollectToken("");
                SharedPref.shared.setECollectRefreshToken("");
                SharedPref.shared.setECollectRefreshToken("");
                SharedPref.shared.setECollectUserNumber("");
                SharedPref.shared.setECollectMerchantID("");
                SharedPref.shared.setECollectUserID("");
                SharedPref.shared.setECollectLoginStatus(false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> MobileNumberVerificationPage()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.orange.shade100.withValues(alpha:0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.shade300.withValues(alpha:0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha:0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              color: Colors.orange.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verification Pending",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your account is under review. You'll get full access once verified.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.orange.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  Widget _buildCumulativeOverview(int totalCollected, int totalDue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha:0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [home1.withValues(alpha:0.1), home1.withValues(alpha:0.05)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFFEA307B),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Monthly Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFEA307B).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getMonthYear(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFEA307B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.shade50,
                  Colors.teal.shade50.withValues(alpha:0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.teal.withValues(alpha:0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Collected",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal.shade700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹$totalCollected",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withValues(alpha:0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.teal,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Collection Progress",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "${((totalCollected / (totalCollected + totalDue)) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEA307B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: totalCollected / (totalCollected + totalDue)),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFEA307B)),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade50,
                  Colors.orange.shade50.withValues(alpha:0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withValues(alpha:0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pending Dues",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹$totalDue",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha:0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.pending_actions_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Your Groups",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFFEA307B).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${groups.length}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEA307B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return _buildGroupCard(groups[index]);
          },
        ),
      ],
    );
  }

  Widget _buildUnverifiedGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Your Groups",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "0",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Greyed out placeholder groups
        ...List.generate(3, (index) => _buildGreyedGroupCard()),
      ],
    );
  }

  Widget _buildGreyedGroupCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Locked",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 32,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Locked",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Created",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade200,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Due Date",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 16,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      "Access Locked",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: isVerified ? () => setState(() => isExpanded = !isExpanded) : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration().copyWith(
              color: isVerified ? Colors.white : Colors.grey.shade50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Send Payment Link",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isVerified ? Colors.black : Colors.grey.shade500,
                      ),
                    ),
                    if (!isVerified) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ],
                ),
                Icon(
                  isVerified
                      ? (isExpanded ? Icons.expand_less : Icons.expand_more)
                      : Icons.lock_outline,
                  color: isVerified ? Colors.black : Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: (isVerified && isExpanded)
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: _buildPaymentUI(),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ... (rest of your existing methods remain the same)

  Widget _buildGroupCard(Map<String, dynamic> group) {
    // Your existing group card implementation
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [

            group["status"] == "Inactive"?
            Colors.grey.withValues(alpha: 0.2):
                group["status"] == "Pending"?
                    Colors.orange.withValues(alpha: 0.2):
            Colors.white,
            Colors.grey.shade50.withValues(alpha:0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha:0.8),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add your onTap functionality here
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row (Name + Status)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group["groupName"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _modernStatusBadge(group["status"]),
                  ],
                ),
                const SizedBox(height: 16),
                /// Amount Highlight with modern styling
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEA307B).withValues(alpha:0.7),
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "${group["defaultAmount"]}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: home1,
                          letterSpacing: -0.5,
                          height: 1,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFFEA307B).withValues(alpha:0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 14,
                              color: Color(0xFFEA307B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Monthly",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFEA307B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                /// Modern Info Row with better visual hierarchy
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _modernInfoItem(
                        icon: Icons.calendar_today_rounded,
                        label: "Created",
                        value: _formatDate(group["createdDate"]),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.shade200,
                      ),
                      _modernInfoItem(
                        icon: Icons.event_available_rounded,
                        label: "Due Date",
                        value: _formatDate(group["defaultDueDate"]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                /// Optional: Quick action indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
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
  }

  Widget _modernStatusBadge(String status) {
    Color badgeColor;
    Color textColor;
    IconData icon;

    switch(status.toLowerCase()) {
      case 'active':
        badgeColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_rounded;
        break;
      case 'inactive':
        badgeColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
        icon = Icons.circle_rounded;
        break;
      case 'pending':
        badgeColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.pending_rounded;
        break;
      default:
        badgeColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            badgeColor,
            badgeColor.withValues(alpha:0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: textColor.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: Color(0xFFEA307B),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentUI() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 5),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: home1, width: 1.5),
                ),
                counterText: "",
                prefixIcon: Icon(Icons.phone_android, color: Color(0xFFEA307B), size: 22),
                labelText: "Mobile Number",
                labelStyle: TextStyle(color: Colors.grey.shade600),
                fillColor: Colors.grey.shade50,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              maxLength: 8,

              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: home1, width: 1.5),
                ),
                prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFFEA307B), size: 22),
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.grey.shade600),
                fillColor: Colors.grey.shade50,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: home1, width: 1.5),
                ),
                labelText: "Note (optional)",
                labelStyle: TextStyle(color: Colors.grey.shade600),
                hintText: "Add a note for this payment...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                fillColor: Colors.grey.shade50,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: home2,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                shadowColor: home1.withValues(alpha:0.3),
              ),
              onPressed: isVerified
                  ? () {
                // Handle payment link generation
              }
                  : null,
              child: Text(
                isVerified ? "Generate Payment Link" : "Access Locked",
                style:  TextStyle(

                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          if (!isVerified) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Verification required to generate payment links",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withValues(alpha:0.08),
            blurRadius: 7,
            spreadRadius: 4
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

// Helper widget for stat cards
Widget _modernStatCard({
  required String title,
  required String value,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [
          Colors.white,
          color.withValues(alpha:0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.04),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row (Icon + optional trend)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            /// Small trend indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "+2%",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        /// Value
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        /// Title
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}

// Add this helper method in your widget class
String _getMonthYear() {
  final now = DateTime.now();
  return DateFormat('MMM yyyy').format(now);
}

BoxDecoration _modernCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.05),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

// Define the color constant (you had this in your original code)
const Color home1 = Color(0xFF6C63FF);