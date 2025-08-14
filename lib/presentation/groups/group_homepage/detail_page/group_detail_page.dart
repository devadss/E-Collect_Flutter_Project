import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_accout_detail_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({super.key});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  bool isActive = false;
  int _selectedTab = 0;

  // Expanded financial data
  final double collectedAmount = 24500;
  final double dueAmount = 5500;
  final double totalAmount = 30000;
  final double lastMonthCollection = 22000;
  final double growthRate = 11.36; // percentage

  // Group details
  final String groupName = "Morning Batch";
  final String createdDate = "15 March 2024";
  final String meetingSchedule = "Mon, Wed, Fri at 9:00 AM";
  final int totalMeetings = 72;
  final String location = "Main Yoga Hall";

  // Members data with more details
  final List<Map<String, dynamic>> members = [
    {
      "name": "John Doe",
      "amount": 500,
      "nextDate": "01/09/25",
      "joined": "10/01/24",
      "attendance": "90%",
      "status": "active"
    },
    {
      "name": "Jane Smith",
      "amount": 750,
      "nextDate": "05/09/25",
      "joined": "12/02/24",
      "attendance": "88%",
      "status": "active"
    },
    {
      "name": "Robert Johnson",
      "amount": 600,
      "nextDate": "03/09/25",
      "joined": "05/03/24",
      "attendance": "85%",
      "status": "inactive"
    },
    {
      "name": "Emily Davis",
      "amount": 450,
      "nextDate": "02/09/25",
      "joined": "15/04/24",
      "attendance": "95%",
      "status": "active"
    },
    {
      "name": "Indhuleka",
      "amount": 500,
      "nextDate": "01/09/25",
      "joined": "10/04/24",
      "attendance": "92%",
      "status": "active"
    },
    {
      "name": "M Test",
      "amount": 550,
      "nextDate": "07/09/25",
      "joined": "15/05/24",
      "attendance": "85%",
      "status": "active"
    },
    {
      "name": "Nidhin Thomas",
      "amount": 800,
      "nextDate": "04/09/25",
      "joined": "22/03/24",
      "attendance": "78%",
      "status": "active"
    },
    {
      "name": "Parvathi",
      "amount": 650,
      "nextDate": "06/09/25",
      "joined": "05/06/24",
      "attendance": "95%",
      "status": "active"
    },
    {
      "name": "Arjun Menon",
      "amount": 900,
      "nextDate": "10/09/25",
      "joined": "08/07/24",
      "attendance": "82%",
      "status": "inactive"
    },
    {
      "name": "Priya Ramesh",
      "amount": 700,
      "nextDate": "12/09/25",
      "joined": "18/07/24",
      "attendance": "89%",
      "status": "active"
    },
    {
      "name": "Vishnu Varma",
      "amount": 480,
      "nextDate": "08/09/25",
      "joined": "25/08/24",
      "attendance": "87%",
      "status": "active"
    },
    {
      "name": "Sneha Krishnan",
      "amount": 1000,
      "nextDate": "15/09/25",
      "joined": "30/08/24",
      "attendance": "93%",
      "status": "active"
    }
  ];

  // Monthly collection data for chart
  final List<Map<String, dynamic>> monthlyData = [
    {"month": "Jan", "amount": 18000},
    {"month": "Feb", "amount": 22000},
    {"month": "Mar", "amount": 25000},
    {"month": "Apr", "amount": 21000},
    {"month": "May", "amount": 24500},
    {"month": "Jun", "amount": 23000},
    {"month": "Jul", "amount": 26000},
    {"month": "Aug", "amount": 24500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: home2),
        title: Text(
          "Group Details",
          style: TextStyle(
              color: home2, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      fontSize: 14,
                      color: isActive ? home1 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isActive,
                      activeColor: home1,
                      inactiveThumbColor: home2.withOpacity(0.5),
                      inactiveTrackColor: Colors.grey[300],
                      onChanged: (val) {
                        setState(() {
                          isActive = val;
                        });
                        isActive == true?
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> BankAccoutDetailPage())):"";
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTabButton(0, "Overview"),
                _buildTabButton(1, "Members"),
                _buildTabButton(2, "Analytics"),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: _selectedTab == 0
                    ? _buildOverviewTab()
                    : _selectedTab == 1
                        ? _buildMembersTab()
                        : _buildAnalyticsTab()),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: Container(
        height: 60, // defined space
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: isSelected ? home1.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: black)),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTab = index;
            });
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: home1.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.2,
                  color: isSelected ? home1 : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: isSelected ? 28 : 0,
                decoration: BoxDecoration(
                  color: isSelected ? home1 : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (!isActive) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pause_circle_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "Group is Inactive",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Activate the group to start collecting payments",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isActive = true;
                  });
                },
                child: const Text(
                  "Activate Group",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Info Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: home1.withOpacity(0.1),
                        child: Icon(Icons.group, size: 30, color: home1),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  groupName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: home2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.edit, size: 18, color: home1),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Created on $createdDate",
                              style: TextStyle(
                                fontSize: 12,
                                color: home2.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        Icons.calendar_today,
                        "Schedule",
                        meetingSchedule,
                      ),
                      _buildDetailItem(
                        Icons.meeting_room,
                        "Location",
                        location,
                      ),
                      _buildDetailItem(
                        Icons.event_available,
                        "Total Sessions",
                        "$totalMeetings",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Financial Summary
          Text(
            "Financial Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: home2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Total Collected",
                  "₹$collectedAmount",
                  home1,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Pending Dues",
                  "₹$dueAmount",
                  Colors.orange,
                  Icons.trending_down,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Total Expected",
                  "₹$totalAmount",
                  home2,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Growth Rate",
                  "$growthRate%",
                  Colors.green,
                  Icons.bar_chart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          Text(
            "Recent Activity",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: home2,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActivityItem("New member joined", "Today 10:30 AM"),
                  const Divider(height: 24),
                  _buildActivityItem(
                      "Monthly collection completed", "Yesterday"),
                  const Divider(height: 24),
                  _buildActivityItem("Session cancelled", "2 days ago"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search and Add Member
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search members...",
                    prefixIcon: Icon(Icons.search, color: home2),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: home1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Members List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: home1.withOpacity(0.1),
                    child: Text(
                      member['name'][0],
                      style: TextStyle(
                        color: home1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    member['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: home2,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12, color: home2.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            "Joined ${member['joined']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: home2.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${member['amount']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: home1,
                        ),
                      ),
                      Text(
                        member['nextDate'],
                        style: TextStyle(
                          fontSize: 12,
                          color: home2.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to member details
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    if (!isActive) {
      return _buildInactiveMessage();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collection Chart
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Monthly Collection",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: home2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: monthlyData.map((data) {
                        final height = (data['amount'] / 30000) * 150;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 24,
                              height: height,
                              decoration: BoxDecoration(
                                color: home1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['month'],
                              style: TextStyle(
                                fontSize: 12,
                                color: home2.withOpacity(0.6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Performance Metrics
          Text(
            "Performance Metrics",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: home2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildMetricCard(
                "Average Attendance",
                "89%",
                Icons.people,
                Colors.green,
              ),
              _buildMetricCard(
                "New Members",
                "4",
                Icons.person_add,
                home1,
              ),
              _buildMetricCard(
                "Completion Rate",
                "92%",
                Icons.check_circle,
                Colors.blue,
              ),
              _buildMetricCard(
                "Sessions Conducted",
                "$totalMeetings",
                Icons.event_available,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveMessage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pause_circle_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "Group is Inactive",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Activate the group to view this section",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: home1),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: home2.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: home2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: home2.withOpacity(0.6),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: home1.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.notifications_none, size: 20, color: home1),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: home2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: home2.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: home2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: home2.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
