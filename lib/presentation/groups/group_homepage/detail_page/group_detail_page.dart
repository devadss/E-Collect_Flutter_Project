import 'package:collection_qr_flutter/data/provider/group/group_delte/group_delete_provider.dart';
import 'package:collection_qr_flutter/data/provider/group/member_list/member_list_provider.dart';
import 'package:collection_qr_flutter/domain/model/group/members_listing/members_listing_model.dart';
import 'package:collection_qr_flutter/presentation/groups/member/member_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/colors.dart';
import '../../../../data/provider/group/delete_member/delete_member_provider.dart';
import '../../../../data/provider/group/group_status/group_status_provider.dart';
import '../../creation/create_group_page.dart';
import '../../member/member_update_page.dart';

class GroupDetailPage extends StatefulWidget {
  final String amount;
  final String dueDate;
  final String groupName;
  final String groupStatus;
  final int groupId;

  const GroupDetailPage({
    super.key,
    required this.amount,
    required this.dueDate,
    required this.groupId,
    required this.groupName,
    required this.groupStatus,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> with SingleTickerProviderStateMixin {
  bool? isActive;
  int _selectedTab = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Expanded financial data
  final double collectedAmount = 24500;
  final double dueAmount = 5500;
  final double totalAmount = 30000;
  final double lastMonthCollection = 22000;
  final double growthRate = 11.36; // percentage

  // Group details
  final String createdDate = "15 March 2024";
  final String meetingSchedule = "Mon, Wed, Fri at 9:00 AM";
  final int totalMeetings = 72;
  final String location = "Main Yoga Hall";
  List<Member> members = [];

  @override
  void initState() {
    super.initState();
    print("groupStatus ${widget.groupStatus}");

    widget.groupStatus == "Active" ? isActive = true : isActive = false;
    getMembers();
    updateStatus();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> updateStatus() async {
    final statusProvider =
    Provider.of<GroupStatusProvider>(context, listen: false);
    if(widget.groupStatus == "null"){
      await statusProvider.getGroupStatus(widget.groupId);
      setState(() {

      });
    }
    print("currentGroupStatus ${statusProvider.currentGroupStatus}");
    if (statusProvider.currentGroupStatus != null &&
        statusProvider.currentGroupStatus.isNotEmpty) {
      if (!statusProvider.currentGroupStatus.containsKey(widget.groupId)) {
        if (widget.groupStatus == "Active") {
          // Trust widget data and set it without API call
          //  statusProvider.updateGroupStatus(widget.groupId, true);
        } else {
          // If widget says not active, optionally fetch real status from API
          if (statusProvider.currentGroupStatus != null &&
              statusProvider.currentGroupStatus.isNotEmpty) {
            //  _loadGroupStatus();
          }
        }
      }
    }
  }

  Future<void> _loadGroupStatus() async {
    final statusProvider =
    Provider.of<GroupStatusProvider>(context, listen: false);

    // Only fetch if we don't already have the status
    if (!statusProvider.currentGroupStatus.containsKey(widget.groupId)) {
      final result = await statusProvider.getGroupStatus(widget.groupId);

      result.match(
            (error) {
          // Handle error, maybe keep default isActive value
        },
            (success) {
          bool apiStatus = (success.currentStatus?.toLowerCase() == "active");
          statusProvider.updateGroupStatus(widget.groupId, apiStatus);
        },
      );
    }
  }

  Future<void> getMembers() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showProgressDialog(context);
    });
    var memberProvider =
    Provider.of<MemberListProvider>(context, listen: false);
    await memberProvider.getMemberByGroup(widget.groupId);
    setState(() {
      members = memberProvider.memberListResponse!.data;
    });
    if (memberProvider.memberListResponse != null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> deleteGroup() async {
    var deleteGroupProvider =
    Provider.of<GroupDeleteProvider>(context, listen: false);
    await deleteGroupProvider.deleteGroup(widget.groupId);
    if (deleteGroupProvider.deleteGroupResponse!.status == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(deleteGroupProvider.deleteGroupResponse!.message)),
      );
      Navigator.pop(context, "Refresh");
    }
  }

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

  Future<void> _editGroup() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Group', style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to edit this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: home2)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Edit', style: TextStyle(color: white)),
          ),
        ],
      ),
    );

    if (result == true) {
      final data = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroupPage(
            groupName: widget.groupName,
            amount: widget.amount,
            dueDate: widget.dueDate,
            groupId: widget.groupId,
          ),
        ),
      );
      if (data == "Refresh") {
        Navigator.pop(context, "Refresh");
        setState(() {});
      }
    }
  }

  Future<void> _deleteGroup() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Group', style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text(
            'Are you sure you want to delete this group? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel', style: TextStyle(color: home2)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "Refresh");
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: white,
          elevation: 0,
          iconTheme: const IconThemeData(color: home2),
          title:const Text(
            "Group Details",
            style: TextStyle(
              color: home2,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: home2),
              onPressed: _editGroup,
            ),
            IconButton(
              icon:const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteGroup,
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Switch with Provider
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Consumer<GroupStatusProvider>(
                    builder: (context, statusProvider, child) {
                      bool currentStatus =
                          statusProvider.currentGroupStatus[widget.groupId] ?? isActive!;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: currentStatus ? home1.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentStatus ? "Active" : "Inactive",
                              style: TextStyle(
                                fontSize: 14,
                                color: currentStatus ? home1 : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: currentStatus,
                                activeColor: home1,
                                inactiveThumbColor: home2.withOpacity(0.5),
                                inactiveTrackColor: Colors.grey[300],
                                onChanged: (val) async {
                                  statusProvider.updateGroupStatus(widget.groupId, val);
                                  final result = await statusProvider.getGroupStatus(widget.groupId);

                                  result.match(
                                        (error) {
                                      statusProvider.updateGroupStatus(widget.groupId, !val);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error.message ?? "Something went wrong")),
                                      );
                                    },
                                        (success) async {
                                      bool apiStatus = (success.currentStatus?.toLowerCase() == "active");
                                      statusProvider.updateGroupStatus(widget.groupId, apiStatus);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(0, "Overview"),
                      _buildTabButton(1, "Members"),
                      _buildTabButton(2, "Analytics"),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _selectedTab == 0
                      ? _buildOverviewTab()
                      : _selectedTab == 1
                      ? _buildMembersTab()
                      : _buildAnalyticsTab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: _selectedTab == index ? home1 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedTab == index ? white : home2,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<GroupStatusProvider>(
      builder: (context, statusProvider, child) {
        bool currentStatus = statusProvider.currentGroupStatus[widget.groupId] ?? isActive!;

        if (!currentStatus) {
          return _buildInactiveMessage();
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Info Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: home1),
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: home1.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child:const Icon(Icons.group, size: 30, color: home1),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.groupName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: home2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Created on $createdDate",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: home2.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFEEF2F6)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailItem(
                            Icons.currency_rupee,
                            "Default Amount",
                            "₹${widget.amount}",
                          ),
                          _buildDetailItem(
                            Icons.calendar_today,
                            "Due Date",
                            "Every ${widget.dueDate}",
                          ),
                          _buildDetailItem(
                            Icons.people,
                            "Members",
                            "${members.length}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Financial Summary
              const Text(
                "Financial Summary",
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: home2,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildFinancialCard(
                      "Collected",
                      "₹$collectedAmount",
                      home1,
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFinancialCard(
                      "Due",
                      "₹$dueAmount",
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: home1),
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 16,
                          color: home2.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹$totalAmount",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: home2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: collectedAmount / totalAmount,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(home1),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${((collectedAmount / totalAmount) * 100).toStringAsFixed(1)}% Collected",
                            style: TextStyle(
                              fontSize: 12,
                              color: home2.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            "${((dueAmount / totalAmount) * 100).toStringAsFixed(1)}% Due",
                            style: TextStyle(
                              fontSize: 12,
                              color: home2.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancialCard(String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: home1),
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              title,
              style: TextStyle(
                fontSize: 14,
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

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding:  EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: home1),
                 SizedBox(height: 16),
                Text(
                  "Please wait...",
                  style: TextStyle(
                    fontSize: 16,
                    color: home2,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildMembersTab() {
    var deleteMember = Provider.of<DeleteMemberProvider>(context, listen: false);

    // Add state for search functionality
    String searchQuery = '';
    List<Member> filteredMembers = members.where((member) {
      return searchQuery.isEmpty ||
          member.memberName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member.mobileNumber.contains(searchQuery);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search and Add Member
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search members...",
                      prefixIcon: Icon(Icons.search, color: home2),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: home1,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: home1.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (conPage) => MemberPage(
                          groupId: widget.groupId,
                          amount: double.parse(widget.amount),
                          dueDate: widget.dueDate,
                          status: '',
                          memberName: '',
                          memberNumber: '',
                          contactId: 0,
                        ),
                      ),
                    );
                    if (result == "Reload") {
                      getMembers();
                    }
                  },
                  icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (filteredMembers.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                      searchQuery.isEmpty ? Icons.group : Icons.search_off,
                      size: 64,
                      color: home2.withOpacity(0.3)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    searchQuery.isEmpty ? "No members yet" : "No members found",
                    style: TextStyle(
                      fontSize: 16,
                      color: home2.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    searchQuery.isEmpty
                        ? "Add your first member to get started"
                        : "Try a different search term",
                    style: TextStyle(
                      fontSize: 14,
                      color: home2.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMembers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                return Dismissible(
                  key: Key(member.memberId.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Confirm Delete', style: TextStyle(fontWeight: FontWeight.w600)),
                        content: const Text('Are you sure you want to delete this member?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel', style: TextStyle(color: home2)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                              await deleteMember.deleteMember(member.memberId);
                              if (deleteMember.deleteMemberResponse?.status == true) {
                                await getMembers();
                                setState(() {});
                              } else {
                                await getMembers();
                                setState(() {});
                              }
                            },
                            child: const Text('Delete', style: TextStyle(color: white)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    bool success = true;
                    if (success) {
                      setState(() {
                        members.removeWhere((m) => m.memberId == member.memberId);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${member.memberName} deleted'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: home1.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            member.memberName[0],
                            style: const TextStyle(
                              color: home1,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        member.memberName,
                        style: const TextStyle(
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
                              Icon(Icons.phone, size: 12, color: home2.withOpacity(0.6)),
                              const SizedBox(width: 4),
                              Text(
                                member.mobileNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: home2.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: home2.withOpacity(0.6)),
                              const SizedBox(width: 4),
                              Text(
                                "Joined ${member.dueDate}",
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
                            "₹${member.amount}",
                            style:const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: home1,
                            ),
                          ),
                          Text(
                            member.dueDate.timeZoneName,
                            style: TextStyle(
                              fontSize: 12,
                              color: home2.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateMemberPage(
                              groupId: widget.groupId,
                              amount: member.amount,
                              dueDate: member.dueDate,
                              memberName: member.memberName,
                              memberNumber: member.mobileNumber.replaceAll(" ", ""),
                              memberId: member.memberId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Widget _buildMembersTab() {
  //   var deleteMember = Provider.of<DeleteMemberProvider>(context, listen: false);
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         // Search and Add Member
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: white,
  //                   borderRadius: BorderRadius.circular(12),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.05),
  //                       blurRadius: 8,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     hintText: "Search members...",
  //                     prefixIcon: Icon(Icons.search, color: home2),
  //                     border: InputBorder.none,
  //                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: home1,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: home1.withOpacity(0.3),
  //                     blurRadius: 8,
  //                     offset: const Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: IconButton(
  //                 onPressed: () async {
  //                   final result = await Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (conPage) => MemberPage(
  //                         groupId: widget.groupId,
  //                         amount: double.parse(widget.amount),
  //                         dueDate: widget.dueDate,
  //                         status: '',
  //                         memberName: '',
  //                         memberNumber: '',
  //                         contactId: 0,
  //                       ),
  //                     ),
  //                   );
  //                   if (result == "Reload") {
  //                     getMembers();
  //                   }
  //                 },
  //                 icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //
  //         if (members.isEmpty)
  //           Container(
  //             padding: const EdgeInsets.all(40),
  //             child: Column(
  //               children: [
  //                 Icon(Icons.group, size: 64, color: home2.withOpacity(0.3)),
  //                 const SizedBox(height: 16),
  //                 Text(
  //                   "No members yet",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: home2.withOpacity(0.5),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "Add your first member to get started",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: home2.withOpacity(0.4),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         else
  //           ListView.separated(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: members.length,
  //             separatorBuilder: (context, index) => const SizedBox(height: 12),
  //             itemBuilder: (context, index) {
  //               final member = members[index];
  //               return Dismissible(
  //                 key: Key(member.memberId.toString()),
  //                 direction: DismissDirection.endToStart,
  //                 background: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.red,
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   alignment: Alignment.centerRight,
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   child: const Icon(Icons.delete, color: Colors.white),
  //                 ),
  //                 confirmDismiss: (direction) async {
  //                   return await showDialog(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                       backgroundColor: white,
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //                       title: const Text('Confirm Delete', style: TextStyle(fontWeight: FontWeight.w600)),
  //                       content: const Text('Are you sure you want to delete this member?'),
  //                       actions: [
  //                         TextButton(
  //                           onPressed: () => Navigator.of(context).pop(false),
  //                           child: const Text('Cancel', style: TextStyle(color: home2)),
  //                         ),
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.red,
  //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                           ),
  //                           onPressed: () async {
  //                             Navigator.of(context).pop(true);
  //                             await deleteMember.deleteMember(member.memberId);
  //                             if (deleteMember.deleteMemberResponse?.status == true) {
  //                               await getMembers();
  //                               setState(() {});
  //                             } else {
  //                               await getMembers();
  //                               setState(() {});
  //                             }
  //                           },
  //                           child: const Text('Delete', style: TextStyle(color: white)),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 onDismissed: (direction) async {
  //                   bool success = true;
  //                   if (success) {
  //                     setState(() {
  //                       members.removeAt(index);
  //                     });
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text('${member.memberName} deleted'),
  //                         behavior: SnackBarBehavior.floating,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: white,
  //                     borderRadius: BorderRadius.circular(12),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.05),
  //                         blurRadius: 8,
  //                         offset: const Offset(0, 2),
  //                       ),
  //                     ],
  //                   ),
  //                   child: ListTile(
  //                     contentPadding: const EdgeInsets.all(12),
  //                     leading: Container(
  //                       width: 50,
  //                       height: 50,
  //                       decoration: BoxDecoration(
  //                         color: home1.withOpacity(0.1),
  //                         shape: BoxShape.circle,
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           member.memberName[0],
  //                           style: TextStyle(
  //                             color: home1,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     title: Text(
  //                       member.memberName,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         color: home2,
  //                       ),
  //                     ),
  //                     subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(height: 4),
  //                         Row(
  //                           children: [
  //                             Icon(Icons.phone, size: 12, color: home2.withOpacity(0.6)),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               member.mobileNumber,
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: home2.withOpacity(0.6),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 2),
  //                         Row(
  //                           children: [
  //                             Icon(Icons.calendar_today, size: 12, color: home2.withOpacity(0.6)),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               "Joined ${member.dueDate}",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: home2.withOpacity(0.6),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     trailing: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         Text(
  //                           "₹${member.amount}",
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: home1,
  //                           ),
  //                         ),
  //                         Text(
  //                           member.dueDate.timeZoneName,
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             color: home2.withOpacity(0.6),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => UpdateMemberPage(
  //                             groupId: widget.groupId,
  //                             amount: member.amount,
  //                             dueDate: member.dueDate,
  //                             memberName: member.memberName,
  //                             memberNumber: member.mobileNumber.replaceAll(" ", ""),
  //                             memberId: member.memberId,
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAnalyticsTab() {
    return Consumer<GroupStatusProvider>(
      builder: (context, statusProvider, child) {
        bool currentStatus = statusProvider.currentGroupStatus[widget.groupId] ?? isActive!;

        if (!currentStatus) {
          return _buildInactiveMessage();
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection Chart
              Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Monthly Collection",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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
                                    gradient: const LinearGradient(
                                      colors: [home1, home2],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
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
              const Text(
                "Performance Metrics",
                style: TextStyle(
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
      },
    );
  }

  Widget _buildInactiveMessage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pause_circle_outline, size: 64, color: home2.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              "Group is Inactive",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: home2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Activate the group to view this content",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: home2.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: home1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () async {
                final statusProvider = Provider.of<GroupStatusProvider>(context, listen: false);
                final result = await statusProvider.getGroupStatus(widget.groupId);

                result.match(
                      (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message ?? "Failed to activate group")),
                    );
                  },
                      (success) {
                    bool apiStatus = (success.currentStatus?.toLowerCase() == "active");
                    statusProvider.updateGroupStatus(widget.groupId, apiStatus);
                  },
                );
              },
              child: const Text("Activate Group", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: home1.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: home1),
        ),
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: home2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
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


// import 'package:collection_qr_flutter/data/provider/group/group_delte/group_delete_provider.dart';
// import 'package:collection_qr_flutter/data/provider/group/member_list/member_list_provider.dart';
// import 'package:collection_qr_flutter/domain/model/group/members_listing/members_listing_model.dart';
// import 'package:collection_qr_flutter/presentation/groups/member/member_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/colors.dart';
// import '../../../../data/provider/group/delete_member/delete_member_provider.dart';
// import '../../../../data/provider/group/group_status/group_status_provider.dart';
// import '../../creation/create_group_page.dart';
// import '../../member/member_update_page.dart';
//
// class GroupDetailPage extends StatefulWidget {
//   final String amount;
//   final String dueDate;
//   final String groupName;
//   final String groupStatus;
//   final int groupId;
//
//   const GroupDetailPage({
//     super.key,
//     required this.amount,
//     required this.dueDate,
//     required this.groupId,
//     required this.groupName,
//     required this.groupStatus,
//   });
//
//   @override
//   State<GroupDetailPage> createState() => _GroupDetailPageState();
// }
//
// class _GroupDetailPageState extends State<GroupDetailPage> {
//   bool? isActive;
//
//   final int _selectedTab = 0;
//
//   // Expanded financial data
//   final double collectedAmount = 24500;
//   final double dueAmount = 5500;
//   final double totalAmount = 30000;
//   final double lastMonthCollection = 22000;
//   final double growthRate = 11.36; // percentage
//
//   // Group details
//   final String createdDate = "15 March 2024";
//   final String meetingSchedule = "Mon, Wed, Fri at 9:00 AM";
//   final int totalMeetings = 72;
//   final String location = "Main Yoga Hall";
//   List<Member> members = [];
//
//   @override
//   void initState() {
//     super.initState();
//     print("groupStatus ${widget.groupStatus}");
//
//     widget.groupStatus == "Active" ? isActive = true : isActive = false;
//     getMembers();
//     updateStatus();
//
//
//   }
//
//   Future<void> updateStatus() async {
//     final statusProvider =
//     Provider.of<GroupStatusProvider>(context, listen: false);
//     if(widget.groupStatus == "null"){
//       await statusProvider.getGroupStatus(widget.groupId);
//       setState(() {
//
//       });
//     }
//     print("currentGroupStatus ${statusProvider.currentGroupStatus}");
//     if (statusProvider.currentGroupStatus != null &&
//         statusProvider.currentGroupStatus.isNotEmpty) {
//       if (!statusProvider.currentGroupStatus.containsKey(widget.groupId)) {
//         if (widget.groupStatus == "Active") {
//           // Trust widget data and set it without API call
//           //  statusProvider.updateGroupStatus(widget.groupId, true);
//         } else {
//           // If widget says not active, optionally fetch real status from API
//           if (statusProvider.currentGroupStatus != null &&
//               statusProvider.currentGroupStatus.isNotEmpty) {
//             //  _loadGroupStatus();
//           }
//         }
//       }
//     }
//   }
//
//   Future<void> _loadGroupStatus() async {
//     final statusProvider =
//         Provider.of<GroupStatusProvider>(context, listen: false);
//
//     // Only fetch if we don't already have the status
//     if (!statusProvider.currentGroupStatus.containsKey(widget.groupId)) {
//       final result = await statusProvider.getGroupStatus(widget.groupId);
//
//       result.match(
//         (error) {
//           // Handle error, maybe keep default isActive value
//         },
//         (success) {
//           bool apiStatus = (success.currentStatus?.toLowerCase() == "active");
//           statusProvider.updateGroupStatus(widget.groupId, apiStatus);
//         },
//       );
//     }
//   }
//
//   Future<void> getMembers() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showProgressDialog(context);
//     });
//     var memberProvider =
//         Provider.of<MemberListProvider>(context, listen: false);
//     await memberProvider.getMemberByGroup(widget.groupId);
//     setState(() {
//       members = memberProvider.memberListResponse!.data;
//     });
//     if (memberProvider.memberListResponse != null) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   Future<void> deleteGroup() async {
//     var deleteGroupProvider =
//         Provider.of<GroupDeleteProvider>(context, listen: false);
//     await deleteGroupProvider.deleteGroup(widget.groupId);
//     if (deleteGroupProvider.deleteGroupResponse!.status == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(deleteGroupProvider.deleteGroupResponse!.message)),
//       );
//       Navigator.pop(context, "Refresh");
//     }
//   }
//
//   // Monthly collection data for chart
//   final List<Map<String, dynamic>> monthlyData = [
//     {"month": "Jan", "amount": 18000},
//     {"month": "Feb", "amount": 22000},
//     {"month": "Mar", "amount": 25000},
//     {"month": "Apr", "amount": 21000},
//     {"month": "May", "amount": 24500},
//     {"month": "Jun", "amount": 23000},
//     {"month": "Jul", "amount": 26000},
//     {"month": "Aug", "amount": 24500},
//   ];
//
//   Future<void> _editGroup() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Group'),
//         content: const Text('Are you sure you want to edit'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//
//     if (result == true) {
//       final data = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CreateGroupPage(
//             groupName: widget.groupName,
//             amount: widget.amount,
//             dueDate: widget.dueDate,
//             groupId: widget.groupId,
//           ),
//         ),
//       );
//       if (data == "Refresh") {
//         Navigator.pop(context, "Refresh");
//
//         setState(() {});
//       }
//     }
//   }
//
//   Future<void> _deleteGroup() async {
//     final confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Group'),
//         content: const Text(
//             'Are you sure you want to delete this group? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       deleteGroup();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, "Refresh");
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: white,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: white,
//           elevation: 0.5,
//           iconTheme: const IconThemeData(color: home2),
//           title: const Text(
//             "Group Details",
//             style: TextStyle(
//               color: home2,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: home2),
//               onPressed: _editGroup,
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: _deleteGroup,
//             ),
//           ],
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Status Switch with Provider
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8, right: 16),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Consumer<GroupStatusProvider>(
//                       builder: (context, statusProvider, child) {
//                         // Get the actual status from provider if available
//                         bool currentStatus =
//                             statusProvider.currentGroupStatus[widget.groupId] ??
//                                 isActive!;
//
//                         return Text(
//                           currentStatus ? "Active" : "Inactive",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: currentStatus ? home1 : Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     Consumer<GroupStatusProvider>(
//                       builder: (context, statusProvider, child) {
//                         // Get the actual status from provider if available
//                         bool currentStatus =
//                             statusProvider.currentGroupStatus[widget.groupId] ??
//                                 isActive!;
//
//                         return Transform.scale(
//                           scale: 0.8,
//                           child: Switch(
//                             value: currentStatus,
//                             activeColor: home1,
//                             inactiveThumbColor: home2.withOpacity(0.5),
//                             inactiveTrackColor: Colors.grey[300],
//                             onChanged: (val) async {
//                               // Update UI optimistically
//                               statusProvider.updateGroupStatus(
//                                   widget.groupId, val);
//
//                               // Call API through provider
//                               final result = await statusProvider
//                                   .getGroupStatus(widget.groupId);
//
//                               result.match(
//                                 (error) {
//                                   // Revert on failure
//                                   statusProvider.updateGroupStatus(
//                                       widget.groupId, !val);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content: Text(error.message ??
//                                             "Something went wrong")),
//                                   );
//                                 },
//                                 (success) async {
//                                   // Update based on API response
//                                   bool apiStatus =
//                                       (success.currentStatus?.toLowerCase() ==
//                                           "active");
//                                   statusProvider.updateGroupStatus(
//                                       widget.groupId, apiStatus);
//                                 },
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Tab Bar
//             Container(
//               color: Colors.white,
//               child: const Row(
//                 children: [
//                   //_buildTabButton(0, "Overview"),
//                   //_buildTabButton(1, "Members"),
//                   //_buildTabButton(2, "Analytics"),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: _selectedTab == 0
//                     ? _buildOverviewTab()
//                     : _selectedTab == 1
//                         ? _buildMembersTab()
//                         : _buildAnalyticsTab(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildOverviewTab() {
//     return Consumer<GroupStatusProvider>(
//       builder: (context, statusProvider, child) {
//         bool currentStatus =
//             statusProvider.currentGroupStatus[widget.groupId] ?? isActive!;
//
//         if (!currentStatus) {
//           return Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.pause_circle_outline,
//                       size: 64, color: Colors.grey),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Group is Inactive",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Activate the group to start collecting payments",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: home1,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32,
//                         vertical: 12,
//                       ),
//                     ),
//                     onPressed: () async {
//                       final statusProvider = Provider.of<GroupStatusProvider>(
//                           context,
//                           listen: false);
//                       final result =
//                           await statusProvider.getGroupStatus(widget.groupId);
//
//                       result.match(
//                         (error) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text(error.message ??
//                                     "Failed to activate group")),
//                           );
//                         },
//                         (success) {
//                           bool apiStatus =
//                               (success.currentStatus?.toLowerCase() ==
//                                   "active");
//                           statusProvider.updateGroupStatus(
//                               widget.groupId, apiStatus);
//                         },
//                       );
//                     },
//                     child: const Text(
//                       "Activate Group",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Group Info Card
//               Card(
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: home1.withOpacity(0.1),
//                             child:
//                                 const Icon(Icons.group, size: 30, color: home1),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.groupName,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w700,
//                                     color: home2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "Created on $createdDate",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: home2.withOpacity(0.6),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Divider(height: 1),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildDetailItem(
//                             Icons.currency_rupee,
//                             "Default Amount",
//                             "₹${widget.amount}",
//                           ),
//                           _buildDetailItem(
//                             Icons.date_range,
//                             "Due Date",
//                             widget.dueDate,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Divider(color: Colors.grey),
//                       _buildMembersTab(),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Center(
//           child: SingleChildScrollView(
//             child: Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Padding(
//                 padding: EdgeInsets.all(50),
//                 child: Column(
//                   children: [
//                     CircularProgressIndicator(
//                       color: deepTeal,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "Please wait....",
//                       style: TextStyle(
//                         fontSize: 17,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildMembersTab() {
//     var deleteMember =
//         Provider.of<DeleteMemberProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           // Search and Add Member
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search members...",
//                     prefixIcon: const Icon(Icons.search, color: home2),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   color: home1,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (conPage) => MemberPage(
//                           groupId: widget.groupId,
//                           amount: double.parse(widget.amount),
//                           dueDate: widget.dueDate,
//                           status: '',
//                           memberName: '',
//                           memberNumber: '',
//                           contactId: 0,
//                         ),
//                       ),
//                     );
//                     if (result == "Reload") {
//                       getMembers();
//                     }
//                   },
//                   icon: const Icon(Icons.person_add, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: members.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final member = members[index];
//               return Dismissible(
//                 key: Key(index.toString()),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 confirmDismiss: (direction) async {
//                   return await showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Confirm delete'),
//                       content: const Text(
//                           'Are you sure you want to delete this member?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             Navigator.of(context).pop(false);
//                             await deleteMember.deleteMember(member.memberId);
//                             if (deleteMember.deleteMemberResponse?.status ==
//                                 true) {
//                               await getMembers();
//                               setState(() {});
//                             } else {
//                               await getMembers();
//                               setState(() {});
//                             }
//                           },
//                           child: const Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 onDismissed: (direction) async {
//                   bool success = true;
//                   if (success) {
//                     setState(() {
//                       members.removeAt(index);
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('${member.memberName} deleted')),
//                     );
//                   } else {}
//                 },
//                 child: Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadiusGeometry.circular(12)),
//                   color: Colors.white,
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),
//                     leading: CircleAvatar(
//                       backgroundColor: home1.withOpacity(0.1),
//                       child: Text(
//                         member.memberName[0],
//                         style: const TextStyle(
//                           color: home1,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       member.memberName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: home2,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               Icon(Icons.calendar_today,
//                                   size: 12, color: home2.withOpacity(0.6)),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "Joined ${member.dueDate}",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: home2.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "₹${member.amount}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: home1,
//                           ),
//                         ),
//                         Text(
//                           member.dueDate.timeZoneName,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: home2.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => UpdateMemberPage(
//                                   groupId: widget.groupId,
//                                   amount: member.amount,
//                                   dueDate: member.dueDate,
//                                   memberName: member.memberName,
//                                   memberNumber:
//                                       member.mobileNumber.replaceAll(" ", ""),
//                                   memberId: member.memberId,
//                                 )
//                             //     MemberPage(
//                             //   groupId: widget.groupId,
//                             //   amount: member.amount,
//                             //   dueDate: member.dueDate.toString(),
//                             //   status: 'EDIT',
//                             //   memberName: member.memberName,
//                             //   memberNumber: member.mobileNumber,
//                             //   contactId: member.memberId,
//                             // ),
//                             ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnalyticsTab() {
//     return Consumer<GroupStatusProvider>(
//       builder: (context, statusProvider, child) {
//         bool currentStatus =
//             statusProvider.currentGroupStatus[widget.groupId] ?? isActive!;
//
//         if (!currentStatus) {
//           return _buildInactiveMessage();
//         }
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Collection Chart
//               Card(
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Monthly Collection",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: home2,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         height: 200,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: monthlyData.map((data) {
//                             final height = (data['amount'] / 30000) * 150;
//                             return Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   width: 24,
//                                   height: height,
//                                   decoration: BoxDecoration(
//                                     color: home1,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   data['month'],
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: home2.withOpacity(0.6),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Performance Metrics
//               const Text(
//                 "Performance Metrics",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: home2,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.5,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 children: [
//                   _buildMetricCard(
//                     "Average Attendance",
//                     "89%",
//                     Icons.people,
//                     Colors.green,
//                   ),
//                   _buildMetricCard(
//                     "New Members",
//                     "4",
//                     Icons.person_add,
//                     home1,
//                   ),
//                   _buildMetricCard(
//                     "Completion Rate",
//                     "92%",
//                     Icons.check_circle,
//                     Colors.blue,
//                   ),
//                   _buildMetricCard(
//                     "Sessions Conducted",
//                     "$totalMeetings",
//                     Icons.event_available,
//                     Colors.purple,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildInactiveMessage() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.pause_circle_outline,
//                 size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             Text(
//               "Group is Inactive",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Activate the group to view this section",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(IconData icon, String title, String value) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: home1),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 12,
//             color: home2.withOpacity(0.6),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: home2,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildMetricCard(
//       String title, String value, IconData icon, Color color) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: home2,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: home2.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // getMembers();
// //updateStatus();
// /*   final statusProvider =
//             Provider.of<GroupStatusProvider>(context, listen: false);
//         if (!statusProvider.currentGroupStatus.containsKey(widget.groupId)) {
//           if (widget.groupStatus == "Active") {
//             // Trust widget data and set it without API call
//             statusProvider.updateGroupStatus(widget.groupId, true);
//           } else {
//             // If widget says not active, optionally fetch real status from API
//             _loadGroupStatus();
//           }
//         }*/
// /*
//   Widget _buildTabButton(int index, String title) {
//     bool isSelected = _selectedTab == index;
//     return Expanded(
//       child: Container(
//         height: 60, // defined space
//         margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//         decoration: BoxDecoration(
//           color: isSelected ? home1.withOpacity(0.08) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           border: Border.all(color: black),
//         ),
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               _selectedTab = index;
//             });
//           },
//           borderRadius: BorderRadius.circular(12),
//           splashColor: home1.withOpacity(0.1),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   letterSpacing: 0.2,
//                   color: isSelected ? home1 : Colors.grey[600],
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 height: 3,
//                 width: isSelected ? 28 : 0,
//                 decoration: BoxDecoration(
//                   color: isSelected ? home1 : Colors.transparent,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// */
//
// /* Widget _buildStatCard(
//       String title, String value, Color color, IconData icon) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: home2.withOpacity(0.6),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, size: 16, color: color),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }*/
//
// /*  Widget _buildActivityItem(String title, String time) {
//     return Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: home1.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.notifications_none, size: 20, color: home1),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: home2,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: home2.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }*/
// /*class GroupDetailPage extends StatefulWidget {
//   final String amount;
//   final String dueDate;
//   final String groupName;
//   final int groupId;
//
//   const GroupDetailPage(
//       {super.key,
//       required this.amount,
//       required this.dueDate,
//       required this.groupId,
//       required this.groupName});
//
//   @override
//   State<GroupDetailPage> createState() => _GroupDetailPageState();
// }
//
// class _GroupDetailPageState extends State<GroupDetailPage> {
//   bool isActive = true;
//   int _selectedTab = 0;
//
//   // Expanded financial data
//   final double collectedAmount = 24500;
//   final double dueAmount = 5500;
//   final double totalAmount = 30000;
//   final double lastMonthCollection = 22000;
//   final double growthRate = 11.36; // percentage
//
//   // Group details
//   // final String groupName = "Morning Batch";
//   final String createdDate = "15 March 2024";
//   final String meetingSchedule = "Mon, Wed, Fri at 9:00 AM";
//   final int totalMeetings = 72;
//   final String location = "Main Yoga Hall";
//   List<Member> members = [];
//
//   List<Member> allMembers = []; // Complete list
//   List<Member> filteredMembers = []; // Filtered list shown in UI
//   TextEditingController searchController = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     getMembers();
//   }
//
//   Future<void> getMembers() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showProgressDialog(context);
//     });
//     var memberProvider =
//         Provider.of<MemberListProvider>(context, listen: false);
//     await memberProvider.getMemberByGroup(widget.groupId);
//     setState(() {
//       members = memberProvider.memberListResponse!.data;
//     });
//     filteredMembers = List.from(members); // Clone the list
//
//     if (memberProvider.memberListResponse != null) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   Future<void> deleteGroup() async {
//     var deleteGroupProvider =
//         Provider.of<GroupDeleteProvider>(context, listen: false);
//     await deleteGroupProvider.deleteGroup(widget.groupId);
//     if (deleteGroupProvider.deleteGroupResponse!.status == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(deleteGroupProvider.deleteGroupResponse!.message)),
//       );
//       Navigator.pop(context, "Reload");
//     }
//   }
//
//   // Monthly collection data for chart
//   final List<Map<String, dynamic>> monthlyData = [
//     {"month": "Jan", "amount": 18000},
//     {"month": "Feb", "amount": 22000},
//     {"month": "Mar", "amount": 25000},
//     {"month": "Apr", "amount": 21000},
//     {"month": "May", "amount": 24500},
//     {"month": "Jun", "amount": 23000},
//     {"month": "Jul", "amount": 26000},
//     {"month": "Aug", "amount": 24500},
//   ];
//
//   Future<void> _editGroup() async {
//     // Implement group editing logic here
//     // You might want to navigate to an EditGroupPage or show a dialog
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Group'),
//         content: const Text('Are you sure you want to edit'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//
//     if (result == true) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => CreateGroupPage(
//                     groupName: widget.groupName,
//                     amount: widget.amount,
//                     dueDate: widget.dueDate,
//                     groupId: widget.groupId,
//                   )));
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('Group updated successfully')),
//       // );
//     }
//   }
//
//   Future<void> _deleteGroup() async {
//     final confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Group'),
//         content: const Text(
//             'Are you sure you want to delete this group? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       deleteGroup();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: white,
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: home2),
//         title: const Text(
//           "Group Details",
//           style: TextStyle(
//             color: home2,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit, color: home2),
//             onPressed: _editGroup,
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.red),
//             onPressed: _deleteGroup,
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8, right: 16),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     isActive ? "Active" : "Inactive",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isActive ? home1 : Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Transform.scale(
//                     scale: 0.8,
//                     child: Switch(
//                       value: isActive,
//                       activeColor: home1,
//                       inactiveThumbColor: home2.withOpacity(0.5),
//                       inactiveTrackColor: Colors.grey[300],
//                       onChanged: (val) {
//                         setState(() {
//                           isActive = val;
//                         });
//                         isActive == true
//                             ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const BankAccoutDetailPage()))
//                             : "";
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Tab Bar
//           Container(
//             color: Colors.white,
//             child: const Row(
//               children: [
//                 //_buildTabButton(0, "Overview"),
//                 //  _buildTabButton(1, "Members"),
//                 // _buildTabButton(2, "Analytics"),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//                 child: _selectedTab == 0
//                     ? _buildOverviewTab()
//                     : _selectedTab == 1
//                         ? _buildMembersTab()
//                         : _buildAnalyticsTab()),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabButton(int index, String title) {
//     bool isSelected = _selectedTab == index;
//     return Expanded(
//       child: Container(
//         height: 60, // defined space
//         margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//         decoration: BoxDecoration(
//             color: isSelected ? home1.withOpacity(0.08) : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             border: Border.all(color: black)),
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               _selectedTab = index;
//             });
//           },
//           borderRadius: BorderRadius.circular(12),
//           splashColor: home1.withOpacity(0.1),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   letterSpacing: 0.2,
//                   color: isSelected ? home1 : Colors.grey[600],
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 height: 3,
//                 width: isSelected ? 28 : 0,
//                 decoration: BoxDecoration(
//                   color: isSelected ? home1 : Colors.transparent,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverviewTab() {
//     if (!isActive) {
//       return Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.pause_circle_outline,
//                   size: 64, color: Colors.grey),
//               const SizedBox(height: 16),
//               Text(
//                 "Group is Inactive",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Activate the group to start collecting payments",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[500],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: home1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 12,
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isActive = true;
//                   });
//                 },
//                 child: const Text(
//                   "Activate Group",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Group Info Card
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(5),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: home1.withOpacity(0.1),
//                         child: const Icon(Icons.group, size: 30, color: home1),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.groupName,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                                 color: home2,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Created on $createdDate",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: home2.withOpacity(0.6),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(height: 1),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildDetailItem(
//                         Icons.currency_rupee,
//                         "Default Amount",
//                         "₹${widget.amount}",
//                       ),
//                       _buildDetailItem(
//                         Icons.date_range,
//                         "Due Date",
//                         widget.dueDate,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(
//                     color: Colors.grey,
//                   ),
//                   _buildMembersTab(),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // if (corpCode != null)
//                       //   _buildDetailItem(Icons.domain, "Corp Code", "corpCode"),
//                       //  if (branchCode != null)
//                       //   _buildDetailItem(Icons.location_city, "Branch", "branchCode"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: const Padding(
//                   padding: EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(
//                         color: deepTeal,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please wait....",
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   Widget _buildMembersTab() {
//     var deleteMember =
//         Provider.of<DeleteMemberProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           // Search and Add Member
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search members...",
//                     prefixIcon: const Icon(Icons.search, color: home2),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   color: home1,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (conPage) => MemberPage(
//                                   groupId: widget.groupId,
//                                   amount: double.parse(widget.amount),
//                                   dueDate: widget.dueDate,
//                                   status: '',
//                                   memberName: '',
//                                   memberNumber: '',
//                                   contactId: 0,
//                                 )));
//                     if (result == "Reload") {
//                       getMembers();
//                     }
//                   },
//                   icon: const Icon(Icons.person_add, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: members.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final member = members[index];
//               return Dismissible(
//                 // key: Key(member.id), // Use a unique key per member (use member ID or unique string)
//                 key: Key(index.toString()),
//                 // Use a unique key per member (use member ID or unique string)
//                 direction: DismissDirection.endToStart,
//                 // Swipe from right to left to delete
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 confirmDismiss: (direction) async {
//                   // Optional: Show a confirmation dialog before deleting
//                   return await showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Confirm delete'),
//                       content: const Text(
//                           'Are you sure you want to delete this member?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             Navigator.of(context).pop(false);
//                             await deleteMember.deleteMember(member.memberId);
//                             // if (!context.mounted) {
//                             //   return; // Check if widget is still active
//                             // }
//                             if (deleteMember.deleteMemberResponse!.status ==
//                                 true) {
//                               await getMembers(); // This will now trigger a rebuild
//
//                               setState(() {});
//                             }
//                             // ScaffoldMessenger.of(context).showSnackBar(
//                             //   SnackBar(
//                             //       content: Text(deleteMember
//                             //           .deleteMemberResponse!.message)),
//                             // );
//                           },
//                           child: const Text('Delete'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 onDismissed: (direction) async {
//                   // Call your API to delete the member here
//                   //     bool success = await deleteMemberApi(member.id);
//                   bool success = true;
//
//                   if (success) {
//                     setState(() {
//                       members.removeAt(index);
//                     });
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('${member.memberName} deleted')),
//                     );
//                   } else {
//                     // If delete failed, show an error and maybe undo the dismissal
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                           content:
//                               Text('Failed to delete ${member.memberName}')),
//                     );
//                     // Optionally, you can re-insert the item or refresh the list
//                   }
//                 },
//                 child: Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   color: Colors.white,
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),
//                     leading: CircleAvatar(
//                       backgroundColor: home1.withOpacity(0.1),
//                       child: Text(
//                         member.memberName[0],
//                         style: const TextStyle(
//                           color: home1,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       member.memberName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: home2,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               Icon(Icons.calendar_today,
//                                   size: 12, color: home2.withOpacity(0.6)),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "Joined ${member.dueDate}",
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: home2.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "₹${member.amount}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: home1,
//                           ),
//                         ),
//                         Text(
//                           member.dueDate.timeZoneName,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: home2.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MemberPage(
//                                     groupId: widget.groupId,
//                                     amount: member.amount,
//                                     dueDate: member.dueDate.toString(),
//                                     status: 'EDIT',
//                                     memberName: member.memberName,
//                                     memberNumber: member.mobileNumber,
//                                     contactId: member.memberId,
//                                   )));
//                       // Navigate to member details
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnalyticsTab() {
//     if (!isActive) {
//       return _buildInactiveMessage();
//     }
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Collection Chart
//           Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Monthly Collection",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: home2,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 200,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: monthlyData.map((data) {
//                         final height = (data['amount'] / 30000) * 150;
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               width: 24,
//                               height: height,
//                               decoration: BoxDecoration(
//                                 color: home1,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               data['month'],
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: home2.withOpacity(0.6),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Performance Metrics
//           const Text(
//             "Performance Metrics",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: home2,
//             ),
//           ),
//           const SizedBox(height: 12),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             childAspectRatio: 1.5,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             children: [
//               _buildMetricCard(
//                 "Average Attendance",
//                 "89%",
//                 Icons.people,
//                 Colors.green,
//               ),
//               _buildMetricCard(
//                 "New Members",
//                 "4",
//                 Icons.person_add,
//                 home1,
//               ),
//               _buildMetricCard(
//                 "Completion Rate",
//                 "92%",
//                 Icons.check_circle,
//                 Colors.blue,
//               ),
//               _buildMetricCard(
//                 "Sessions Conducted",
//                 "$totalMeetings",
//                 Icons.event_available,
//                 Colors.purple,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInactiveMessage() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.pause_circle_outline,
//                 size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             Text(
//               "Group is Inactive",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Activate the group to view this section",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(IconData icon, String title, String value) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: home1),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 12,
//             color: home2.withOpacity(0.6),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: home2,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(
//       String title, String value, Color color, IconData icon) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: home2.withOpacity(0.6),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, size: 16, color: color),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActivityItem(String title, String time) {
//     return Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: home1.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.notifications_none, size: 20, color: home1),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: home2,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: home2.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMetricCard(
//       String title, String value, IconData icon, Color color) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: home2,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: home2.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }*/
