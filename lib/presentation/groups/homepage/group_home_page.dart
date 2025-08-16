import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_accout_detail_page.dart';
import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_details_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../group_homepage/detail_page/group_detail_page.dart';

class GroupHomePage extends StatefulWidget {
  const GroupHomePage({super.key});

  @override
  State<GroupHomePage> createState() => _GroupHomePageState();
}

class _GroupHomePageState extends State<GroupHomePage> {
  String? userName;

  int _selectedMonthIndex = DateTime.now().month - 1;
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final int currentYear = DateTime.now().year;

  // Monthly financial data
  final List<Map<String, dynamic>> monthlyData = [
    {
      "month": 0, // Jan
      "collected": 18000,
      "due": 4500,
      "newGroups": 1,
    },
    {
      "month": 1, // Feb
      "collected": 22000,
      "due": 5500,
      "newGroups": 0,
    },
    {
      "month": 2, // Mar
      "collected": 25000,
      "due": 6200,
      "newGroups": 2,
    },
    {
      "month": 3, // Apr
      "collected": 21000,
      "due": 5200,
      "newGroups": 0,
    },
    {
      "month": 4, // May
      "collected": 24500,
      "due": 6100,
      "newGroups": 1,
    },
    {
      "month": 5, // Jun
      "collected": 23000,
      "due": 5700,
      "newGroups": 0,
    },
    {
      "month": 6, // Jul
      "collected": 26000,
      "due": 6500,
      "newGroups": 1,
    },
    {
      "month": 7, // Aug (current month)
      "collected": 32000,
      "due": 8000,
      "newGroups": 1,
    },
  ];

  // All groups data with creation dates
  final List<Map<String, dynamic>> allGroups = [
    {
      "name": "Morning Yoga",
      "members": 12,
      "collected": 24500,
      "due": 5500,
      "status": "active",
      "created": DateTime(2024, 1, 15), // Jan
    },
    {
      "name": "Evening Batch",
      "members": 8,
      "collected": 18000,
      "due": 4000,
      "status": "active",
      "created": DateTime(2024, 3, 10), // Mar
    },
    {
      "name": "Weekend Special",
      "members": 15,
      "collected": 37500,
      "due": 7500,
      "status": "active",
      "created": DateTime(2024, 3, 25), // Mar
    },
    {
      "name": "Senior Citizens",
      "members": 7,
      "collected": 15000,
      "due": 3000,
      "status": "inactive",
      "created": DateTime(2024, 5, 5), // May
    },
    {
      "name": "Kids Yoga",
      "members": 10,
      "collected": 20000,
      "due": 5000,
      "status": "active",
      "created": DateTime(2024, 7, 1), // Jul
    },
    {
      "name": "Advanced Class",
      "members": 6,
      "collected": 30000,
      "due": 6000,
      "status": "active",
      "created": DateTime(2024, 8, 10), // Aug (current month)
    },
  ];

  // Get filtered groups based on selected month
  List<Map<String, dynamic>> get filteredGroups {
    if (_selectedMonthIndex == DateTime.now().month - 1) {
      return allGroups;
    }
    return allGroups.where((group) {
      return group["created"]
          .isBefore(DateTime(currentYear, _selectedMonthIndex + 2, 1));
    }).toList();
  }

  // Get current month data
  Map<String, dynamic> get currentMonthData {
    return monthlyData.firstWhere(
      (data) => data["month"] == _selectedMonthIndex,
      orElse: () => {
        "collected": 0,
        "due": 0,
        "newGroups": 0,
      },
    );
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    setState(() {
      userName = name;
    });
  }

  Future<Object?> _showLogoutConfirmation(BuildContext context) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: _buildModernDialog(context),
        );
      },
    );
  }

  Widget _buildModernDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.98),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            home1.withOpacity(0.2),
                            home2.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        size: 36,
                        color: home1,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Confirm Logout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: home2,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Are you sure you want to sign out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: home2.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: home2,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: home1,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: home1.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _performLogout(context);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performLogout(BuildContext context) {}

  Future<void> _showSettingsDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Settings title
              const Row(
                children: [
                  Icon(Icons.settings_rounded, color: home1, size: 24),
                   SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: home2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Settings options
              _buildSettingsOption(
                icon: Icons.account_balance_sharp,
                title: 'Bank Details',
                subtitle: 'Edit your Bank Details',
                onTap: () {
                  // Implement theme change
                  Navigator.pop(context);
                  //_showThemeSelector(context);
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> BankDetailsScreen(
                   status:"EDIT"
                 )));
                },
              ),

              _buildSettingsOption(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Manage alerts',
                onTap: () {
                  // Implement notifications settings
                },
              ),

              _buildSettingsOption(
                icon: Icons.security_rounded,
                title: 'Privacy',
                subtitle: 'Data protection',
                onTap: () {
                  // Implement privacy settings
                },
              ),

              _buildSettingsOption(
                icon: Icons.help_rounded,
                title: 'Help & Support',
                subtitle: 'Get assistance',
                onTap: () {
                  // Implement help center
                },
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: home1.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: home1),
      ),
      title: Text(
        title,
        style:const  TextStyle(
          fontWeight: FontWeight.w600,
          color: home2,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: home2.withOpacity(0.6),
        ),
      ),
      trailing:
          Icon(Icons.chevron_right_rounded, color: home2.withOpacity(0.5)),
      onTap: onTap,
    );
  }

  Future<void> _showThemeSelector(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Theme',
            style: TextStyle(color: home2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('Default', home1, home2),
              _buildThemeOption('Dark', Colors.grey[900]!, Colors.white),
              _buildThemeOption('Blue', Colors.blue, Colors.white),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: home2),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  Widget _buildThemeOption(String name, Color primary, Color secondary) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(name),
      onTap: () {
        // Implement theme change logic
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthData = currentMonthData;
    final groups = filteredGroups;
    final totalCollected =
        groups.fold<num>(0, (sum, group) => sum + (group["collected"] as num));
    final totalDue =
        groups.fold<num>(0, (sum, group) => sum + (group["due"] as num));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: home2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: home2),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Welcome Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: home1, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: home1.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 30, color: home1),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontSize: 14,
                              color: home2.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            userName.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: home2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showSettingsDialog(context);
                      },
                      icon: const Icon(Icons.settings, color: home1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Month Selector
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side:const BorderSide(color: home1, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      "Select Month",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: home2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(months.length, (index) {
                          final isSelected = index == _selectedMonthIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMonthIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? home1 : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected ? home1 : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                months[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : home2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Financial Summary
            Text(
              "${months[_selectedMonthIndex]} $currentYear Financials",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: home2,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  "Collected",
                  "₹${monthData["collected"]}",
                  home1,
                  Icons.trending_up,
                ),
                _buildStatCard(
                  "Pending Dues",
                  "₹${monthData["due"]}",
                  Colors.orange,
                  Icons.trending_down,
                ),
                _buildStatCard(
                  "New Groups",
                  "${monthData["newGroups"]}",
                  Colors.green,
                  Icons.group_add,
                ),
                _buildStatCard(
                  "Active Groups",
                  "${groups.length}",
                  home2,
                  Icons.groups,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Financial Overview
            const Text(
              "Cumulative Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: home2,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: home1, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Collected",
                          style: TextStyle(
                            fontSize: 14,
                            color: home2.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          "₹$totalCollected",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: home1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: totalCollected / (totalCollected + totalDue),
                      backgroundColor: Colors.grey.shade200,
                      color: home1,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pending Dues",
                          style: TextStyle(
                            fontSize: 14,
                            color: home2.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          "₹$totalDue",
                          style:const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Groups Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Groups (${groups.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: home2,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: home1,
                  ),
                  child: const Text("View All"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Groups List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return _buildGroupCard(
                  group["name"] as String,
                  group["members"] as int,
                  group["collected"] as num,
                  group["due"] as num,
                  group["status"] as String,
                  group["created"] as DateTime,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: home1, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: home2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(String name, int members, num collected, num due,
      String status, DateTime created) {
    final isNewGroup =
        created.month - 1 == _selectedMonthIndex && created.year == currentYear;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: home1, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: home1.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(Icons.group, size: 24, color: home1),
              ),
              if (isNewGroup)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "N",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: home2,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "$members members • Created ${_formatDate(created)}",
              style: TextStyle(
                fontSize: 12,
                color: home2.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "₹${collected.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: home1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  " / ",
                  style: TextStyle(
                    fontSize: 12,
                    color: home2.withOpacity(0.3),
                  ),
                ),
                Text(
                  "₹${due.toStringAsFixed(0)} due",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status == "active"
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status == "active" ? "Active" : "Inactive",
            style: TextStyle(
              color: status == "active" ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GroupDetailPage()));
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
