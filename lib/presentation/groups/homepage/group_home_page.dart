import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_details_screen.dart';
import 'package:collection_qr_flutter/presentation/groups/homepage/payment_link_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/colors.dart';
import '../../../data/provider/group/group_list/group_list_preovider.dart';
import '../../../data/provider/group/member_list/member_list_provider.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/group/group_listing/group_list_model.dart';
import '../../../domain/model/group/members_listing/members_listing_model.dart';
import '../../splash_screen/splash_screen.dart';
import '../group_homepage/detail_page/group_detail_page.dart';

class GroupHomePage extends StatefulWidget {
  final VoidCallback? onRefresh;

  const GroupHomePage({super.key, this.onRefresh});

  @override
  State<GroupHomePage> createState() => _GroupHomePageState();
}

class _GroupHomePageState extends State<GroupHomePage> {
  String? _agentName;
  String? _agentId;
  String? _subAgentId;
  String? _agentOriginId;
  String? _agentPhone;
  String? _agentEmail;
  String? _corpCode;
  final TextEditingController _mobNumController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Group> _filteredGroups = [];
  List<Group> _groups = [];
  bool _isExpanded = false;
  List<Member> members = [];
  int avilableMembers = 0;

  final int _selectedMonthIndex = DateTime.now().month - 1;
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
  final List<Map<String, dynamic>> allGroups = [];

  void _filterGroups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = _groups
          .where((group) => group.groupName.toLowerCase().contains(query))
          .toList();
    });
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

  void loadSharedData() async {
    String corpCode = await SharedPref.shared.getCorpCode();
    final agentName = await SharedPref().getAgentName();
    final token = await SharedPref().getTokenValue();
    final agentId = await SharedPref.shared.getAgentId();
    final subAgentId = await SharedPref.shared.getSubAgentId();
    final agentPhone = await SharedPref.shared.getSubAgentMobNum();
    final agentOriginId = await SharedPref.shared.getAgentId();
    final agentEmail = await SharedPref.shared.getEmail();
    setState(() {
      _agentName = agentName;
      _agentId = agentId;
      _subAgentId = subAgentId;
      _agentPhone = agentPhone;
      _corpCode = corpCode;
      _agentEmail = agentEmail;
      _agentOriginId = agentOriginId;
    });
    print("loadSharedData");
    print("token = ${token}");
    setState(() {});
    showProgressDialog(context);
    getGroups();
    _searchController.addListener(_filterGroups);
  }

  Future<void> getGroups() async {
    print("getGroups");
    final groupProvider =
    Provider.of<GroupListProvider>(context, listen: false);
    await groupProvider.listGroupUnderUser();
    if (groupProvider.groupListResponse != null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
    final List<Group> fetchedGroups =
        groupProvider.groupListResponse?.data ?? [];

    // Filter groups by corpCode
    final List<Group> filtered = fetchedGroups
        .where((group) => group.corpCode != null && group.corpCode == _corpCode)
        .toList();

    setState(() {
      _groups = filtered;
      _filteredGroups = filtered;
    });
    getMembers();
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
                      CircularProgressIndicator(
                        color: deepTeal,
                      ),
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

  Future<void> _performLogout(BuildContext context) async {
    // String entityId = await SharedPref.shared.getSubAgentId();
    // String token = await SharedPref.shared.getTokenValue();
    // final fcmProvider = Provider.of<DeleteFcmProvider>(context, listen: false);
    // await fcmProvider.deleteFirebaseToken(entityId, token);

    await SharedPref.shared.setLogin(false);
    await SharedPref.shared.setCustId("");
    await SharedPref.shared.setAgentName("");
    await SharedPref.shared.setParentAgentName("");
    await SharedPref.shared.setParentAgentPassword("");
    await SharedPref.shared.setParentAgentMobNum("");
    await SharedPref.shared.setSubAgentId("");
    await SharedPref.shared.setSubAgentCode("");

    await SharedPref.shared.setUserType("");
    await SharedPref.shared.setRdclCustomerVendorUrl("");
    await SharedPref.shared.setDueListRdclUrl("");
    await SharedPref.shared.setCustomerRdUrl("");
    await SharedPref.shared.setDueListRdUrl("");
    await SharedPref.shared.setCustomerLoanUrl("");
    await SharedPref.shared.setDueListLoanUrl("");
    await SharedPref.shared.setLoanAccountHolderUrl("");

    await SharedPref.shared.setSubAgentName("");
    await SharedPref.shared.setSubAgentMobNum("");
    await SharedPref.shared.setSubAgentCodeNew("");
    await SharedPref.shared.setFcmToken("");
    await SharedPref.shared.setAgentId("");
    await SharedPref.shared.setPassword("");
    await SharedPref.shared.setMpinValue("");
    await SharedPref.shared.setMpinStatus("");
    await SharedPref.shared.setTokenValue("");
    await SharedPref.shared.setMobNum("");
    await SharedPref.shared.setBranchCode("");
    await SharedPref.shared.setAgentOriginId("");
    await SharedPref.shared.setCorpCode("");
    await SharedPref.shared.setCardRefNum("");
    await SharedPref.shared.setEmail("");
    await SharedPref.shared.setLoggedInUserType("");


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
    );
  }

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
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const BankDetailsScreen(status: "EDIT")));
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
        style: const TextStyle(
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

  Future<void> getMembers() async {
    var memberProvider =
    Provider.of<MemberListProvider>(context, listen: false);
    await memberProvider.getMemberByGroup(_groups[0].groupId);

    setState(() {
      avilableMembers = memberProvider.memberListResponse!.data.length;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSharedData();
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

  Widget _buildGlassField({
    required IconData icon,
    required String label,
    required TextEditingController payemtLinkController,
    required TextInputType keyboardType,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: home1.withOpacity(0.1),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: payemtLinkController ,
        decoration: InputDecoration(
          counterText: maxLength != null ? "" : null,
          prefixIcon: Container(
            padding: const EdgeInsets.all(14),
            child: Icon(icon, color: home1, size: 22),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        maxLength: maxLength,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    final paymentLinkProvider = Provider.of<PaymentLinkProvider>(context , listen:false);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: home1.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 3,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: home1,
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            // Header with Icon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [home1, home1.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.link, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Payment Link',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: home1,
                        ),
                      ),
                      Text(
                        'Send secure payment requests instantly',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Mobile Number Field - Glassmorphism Style
            _buildGlassField(

              icon: Icons.phone_iphone,
              label: 'Mobile Number',
              keyboardType: TextInputType.number,
              maxLength: 10, payemtLinkController: _mobNumController,
            ),

            const SizedBox(height: 20),

            // Amount Field - Glassmorphism Style
            _buildGlassField(
              icon: Icons.currency_rupee,
              label: 'Amount',
              keyboardType: TextInputType.number, payemtLinkController: _amountController,
            ),

            const SizedBox(height: 20),

            // Note Field - Glassmorphism Style
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: home1.withOpacity(0.1),
                  width: 1.2,
                ),
              ),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: const Icon(Icons.note_alt_outlined, color: home1, size: 22),
                  ),
                  labelText: 'Note (optional)',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  alignLabelWithHint: true,
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Send Button - Floating Action Style
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [home1, home2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: home1.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async{

                    await paymentLinkProvider.getPaymentLink(agentName: _agentName ?? "",
                        agentId: _agentId ?? '', agentOriginId: _agentOriginId ?? '',
                        agentPhone: _agentPhone ?? '', agentEmail: _agentEmail ?? '',
                        customerName: "", customerPhone: _mobNumController.text,
                        customerAccountNumber: "", customerEmail: "",
                        customerId: "", linkAmount: int.parse(_amountController.text), note: "", corpCode: _corpCode ??'',
                        cardRefNum: "", token: "", subAgentId:_subAgentId ?? '' );


                    // Handle send action
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Generate Payment Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Security Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.green.shade600, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Secure & Encrypted',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    final monthData = currentMonthData;
    final groups = _filteredGroups;
    const totalCollected = 100;
    const totalDue = 50;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
            // User Welcome Card with Glassmorphism effect
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: home1,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [home1, home2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: home1.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 30, color: Colors.white),
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
                            _agentName ?? "",
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
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: home1.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.settings, color: home1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Monthly Financial Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${months[_selectedMonthIndex]} $currentYear Financials",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: home2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  "Total Collected",
                  "₹${monthData["collected"]}",
                  home1,
                  Icons.arrow_downward,
                ),
                _buildStatCard(
                  "Pending Dues",
                  "₹${monthData["due"]}",
                  Colors.orange,
                  Icons.arrow_upward,
                ),
                _buildStatCard(
                  "Active Groups",
                  _groups.length.toString(),
                  Colors.green,
                  Icons.group_add,
                ),
                _buildStatCard(
                  "Active Members",
                  "$avilableMembers",
                  home2,
                  Icons.groups,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Financial Overview
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Cumulative Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: home2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: home1,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                        const Text(
                          "₹$totalCollected",
                          style: TextStyle(
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
                        const Text(
                          "₹$totalDue",
                          style: TextStyle(
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
            const SizedBox(height: 24),

            // Groups Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Groups (${_groups.length})",
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
                    child: const Text(""),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Groups List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return _buildGroupCard(
                  group.groupName,
                  group.groupId,
                  group.defaultAmount,
                  group.defaultDueDate,
                  group.status.toString(),
                  group.createdDate,
                );
              },
            ),

            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [home1.withOpacity(0.1), home2.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Send Payment Link',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: home2),
                          ),
                          Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: home1),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _buildExpandedContent(),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: home1,
          width: 1,
        ),
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

  Widget _buildGroupCard(String name, int members, num collected, DateTime due,
      String status, DateTime created) {
    final isNewGroup =
        created.month - 1 == _selectedMonthIndex && created.year == currentYear;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: status == "Active" ? Colors.white : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: status == "Active" ? home1.withOpacity(0.9) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: status == "Active" ? home1.withOpacity(0.1) : home2.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(Icons.group, size: 24, color: status == "Active" ? home1 : home2),
              ),
              if (isNewGroup)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: status == "Active" ? Colors.green : home2,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      name[0],
                      style: const TextStyle(
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
              "Created at ${_formatDate(created)}",
              style: TextStyle(
                fontSize: 12,
                color: home2.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "Amount : ₹${collected.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: home1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              "Due Date : ${_formatDate(due)}",
              style: const TextStyle(
                fontSize: 12,
                color: home2,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status == "Active"
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status == "Active" ? "Active" : "Inactive",
            style: TextStyle(
              color: status == "Active" ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailPage(
                    amount: collected.toString(),
                    dueDate: DateFormat('yyyy-MM-dd').format(due),
                    groupId: members,
                    groupName: name,
                    groupStatus: status,
                  )));
          result == "Refresh" ? loadSharedData() : "";
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}


// import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../core/colors.dart';
// import '../../../data/provider/group/group_list/group_list_preovider.dart';
// import '../../../data/provider/group/member_list/member_list_provider.dart';
// import '../../../data/storage/shared_pref_helper.dart';
// import '../../../domain/model/group/group_listing/group_list_model.dart';
// import '../../../domain/model/group/members_listing/members_listing_model.dart';
// import '../group_homepage/detail_page/group_detail_page.dart';
//
// class GroupHomePage extends StatefulWidget {
//   final VoidCallback? onRefresh;
//
//   const GroupHomePage({super.key, this.onRefresh});
//
//   @override
//   State<GroupHomePage> createState() => _GroupHomePageState();
// }
//
// class _GroupHomePageState extends State<GroupHomePage> {
//   String? userName;
//   String? _corpCode;
//   final TextEditingController _searchController = TextEditingController();
//   List<Group> _filteredGroups = [];
//   List<Group> _groups = [];
//   bool _isExpanded = false;
//   List<Member> members = [];
//   int avilableMembers=0;
//
//   final int _selectedMonthIndex = DateTime.now().month - 1;
//   final List<String> months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec'
//   ];
//   final int currentYear = DateTime.now().year;
//
//   // Monthly financial data
//   final List<Map<String, dynamic>> monthlyData = [
//     {
//       "month": 0, // Jan
//       "collected": 18000,
//       "due": 4500,
//       "newGroups": 1,
//     },
//     {
//       "month": 1, // Feb
//       "collected": 22000,
//       "due": 5500,
//       "newGroups": 0,
//     },
//     {
//       "month": 2, // Mar
//       "collected": 25000,
//       "due": 6200,
//       "newGroups": 2,
//     },
//     {
//       "month": 3, // Apr
//       "collected": 21000,
//       "due": 5200,
//       "newGroups": 0,
//     },
//     {
//       "month": 4, // May
//       "collected": 24500,
//       "due": 6100,
//       "newGroups": 1,
//     },
//     {
//       "month": 5, // Jun
//       "collected": 23000,
//       "due": 5700,
//       "newGroups": 0,
//     },
//     {
//       "month": 6, // Jul
//       "collected": 26000,
//       "due": 6500,
//       "newGroups": 1,
//     },
//     {
//       "month": 7, // Aug (current month)
//       "collected": 32000,
//       "due": 8000,
//       "newGroups": 1,
//     },
//   ];
//
//   // All groups data with creation dates
//   final List<Map<String, dynamic>> allGroups = [
//   ];
//
//   void _filterGroups() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredGroups = _groups
//           .where((group) => group.groupName.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//
//
//   // Get current month data
//   Map<String, dynamic> get currentMonthData {
//     return monthlyData.firstWhere(
//       (data) => data["month"] == _selectedMonthIndex,
//       orElse: () => {
//         "collected": 0,
//         "due": 0,
//         "newGroups": 0,
//       },
//     );
//   }
//
//   void loadSharedData() async {
//     //String custid = await SharedPref.shared.getCustId();
//     String corpCode = await SharedPref.shared.getCorpCode();
//     final name = await SharedPref().getAgentName();
//     setState(() {
//       userName = name;
//       _corpCode = corpCode;
//     });
//     print("loadSharedData");
//     setState(() {});
//     showProgressDialog(context);
//     getGroups();
//     _searchController.addListener(_filterGroups);
//   }
//
//   Future<void> getGroups() async {
//     print("getGroups");
//     final groupProvider =
//         Provider.of<GroupListProvider>(context, listen: false);
//     await groupProvider.listGroupUnderUser();
//     if (groupProvider.groupListResponse != null) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pop(context);
//     }
//     final List<Group> fetchedGroups =
//         groupProvider.groupListResponse?.data ?? [];
//
//     // Filter groups by corpCode
//     final List<Group> filtered = fetchedGroups
//         // .where((group) => group.corpCode != null && group.corpCode == "MOBWER")
//         .where((group) => group.corpCode != null && group.corpCode == _corpCode)
//         .toList();
//
//     setState(() {
//       _groups = filtered;
//       _filteredGroups = filtered;
//     });
//     getMembers();
//   }
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
//   Future<Object?> _showLogoutConfirmation(BuildContext context) async {
//     return showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return ScaleTransition(
//           scale: CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOutBack,
//           ),
//           child: _buildModernDialog(context),
//         );
//       },
//     );
//   }
//
//   Widget _buildModernDialog(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(24),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.white.withOpacity(0.95),
//               Colors.white.withOpacity(0.98),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 30,
//               spreadRadius: 2,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Animated Icon
//               TweenAnimationBuilder(
//                 duration: const Duration(milliseconds: 500),
//                 tween: Tween<double>(begin: 0, end: 1),
//                 builder: (context, value, child) {
//                   return Transform.scale(
//                     scale: value,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             home1.withOpacity(0.2),
//                             home2.withOpacity(0.1),
//                           ],
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.logout_rounded,
//                         size: 36,
//                         color: home1,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               // Title
//               const Text(
//                 'Confirm Logout',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   color: home2,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Subtitle
//               Text(
//                 'Are you sure you want to sign out of your account?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: home2.withOpacity(0.7),
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Buttons
//               Row(
//                 children: [
//                   // Cancel Button
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: home2,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         side: BorderSide(color: Colors.grey.shade300),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//
//                   // Logout Button
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: home1,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         shadowColor: home1.withOpacity(0.3),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         _performLogout(context);
//                       },
//                       child: const Text(
//                         'Logout',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _performLogout(BuildContext context) {}
//
//   Future<void> _showSettingsDialog(BuildContext context) async {
//     return showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 20,
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Drag handle
//               Container(
//                 width: 48,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//
//               // Settings title
//               const Row(
//                 children: [
//                   Icon(Icons.settings_rounded, color: home1, size: 24),
//                   SizedBox(width: 12),
//                   Text(
//                     'Settings',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: home2,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               // Settings options
//               _buildSettingsOption(
//                 icon: Icons.account_balance_sharp,
//                 title: 'Bank Details',
//                 subtitle: 'Edit your Bank Details',
//                 onTap: () {
//                   // Implement theme change
//                   Navigator.pop(context);
//                   //_showThemeSelector(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               const BankDetailsScreen(status: "EDIT", )));
//                 },
//               ),
//               _buildSettingsOption(
//                 icon: Icons.notifications_rounded,
//                 title: 'Notifications',
//                 subtitle: 'Manage alerts',
//                 onTap: () {
//                   // Implement notifications settings
//                 },
//               ),
//
//               _buildSettingsOption(
//                 icon: Icons.security_rounded,
//                 title: 'Privacy',
//                 subtitle: 'Data protection',
//                 onTap: () {
//                   // Implement privacy settings
//                 },
//               ),
//
//               _buildSettingsOption(
//                 icon: Icons.help_rounded,
//                 title: 'Help & Support',
//                 subtitle: 'Get assistance',
//                 onTap: () {
//                   // Implement help center
//                 },
//               ),
//
//               const SizedBox(height: 24),
//
//               // Close button
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     backgroundColor: home1,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     side: BorderSide(color: Colors.grey.shade300),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSettingsOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: home1.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(icon, color: home1),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           color: home2,
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(
//           fontSize: 12,
//           color: home2.withOpacity(0.6),
//         ),
//       ),
//       trailing:
//           Icon(Icons.chevron_right_rounded, color: home2.withOpacity(0.5)),
//       onTap: onTap,
//     );
//   }
//   Future<void> getMembers() async {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   showProgressDialog(context);
//     // });
//     var memberProvider =
//     Provider.of<MemberListProvider>(context, listen: false);
//     await memberProvider.getMemberByGroup(_groups[0].groupId);
//
//     setState(() {
//       avilableMembers = memberProvider.memberListResponse!.data.length;
//     });
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadSharedData();
//   }
//
//   Widget _buildThemeOption(String name, Color primary, Color secondary) {
//     return ListTile(
//       leading: Container(
//         width: 24,
//         height: 24,
//         decoration: BoxDecoration(
//           color: primary,
//           shape: BoxShape.circle,
//         ),
//       ),
//       title: Text(name),
//       onTap: () {
//         // Implement theme change logic
//       },
//     );
//   }
//
//   Widget _buildGlassField({
//     required IconData icon,
//     required String label,
//     required TextInputType keyboardType,
//     int? maxLength,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: LinearGradient(
//           colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(
//           color: home1.withOpacity(0.1),
//           width: 1.2,
//         ),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           counterText: maxLength != null ? "" : null,
//           prefixIcon: Container(
//             padding: const EdgeInsets.all(14),
//             child: Icon(icon, color: home1, size: 22),
//           ),
//           labelText: label,
//           labelStyle: TextStyle(
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//           border: InputBorder.none,
//           filled: false,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 18,
//           ),
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//         ),
//         maxLength: maxLength,
//         keyboardType: keyboardType,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExpandedContent() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: home1.withOpacity(0.08),
//             blurRadius: 30,
//             spreadRadius: 3,
//             offset: const Offset(0, 12),
//           ),
//         ],
//         border: Border.all(
//           color: home1,
//           width: 1.2,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(28),
//         child: Column(
//           children: [
//             // Header with Icon
//             Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [home1, home1.withOpacity(0.7)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.link, color: Colors.white, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Create Payment Link',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: home1,
//                         ),
//                       ),
//                       Text(
//                         'Send secure payment requests instantly',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 28),
//
//             // Mobile Number Field - Glassmorphism Style
//             _buildGlassField(
//               icon: Icons.phone_iphone,
//               label: 'Mobile Number',
//               keyboardType: TextInputType.number,
//               maxLength: 10,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Amount Field - Glassmorphism Style
//             _buildGlassField(
//               icon: Icons.currency_rupee,
//               label: 'Amount',
//               keyboardType: TextInputType.number,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Note Field - Glassmorphism Style
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 gradient: LinearGradient(
//                   colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 border: Border.all(
//                   color: home1.withOpacity(0.1),
//                   width: 1.2,
//                 ),
//               ),
//               child: TextField(
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   prefixIcon: Container(
//                     padding: const EdgeInsets.all(14),
//                     child: const Icon(Icons.note_alt_outlined, color: home1, size: 22),
//                   ),
//                   labelText: 'Note (optional)',
//                   labelStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                   ),
//                   alignLabelWithHint: true,
//                   border: InputBorder.none,
//                   filled: false,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 18,
//                   ),
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                 ),
//                 keyboardType: TextInputType.text,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Send Button - Floating Action Style
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: const LinearGradient(
//                   colors: [home1, home2],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: home1.withOpacity(0.4),
//                     blurRadius: 20,
//                     spreadRadius: 3,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     // Handle send action
//                   },
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.bolt, color: Colors.white, size: 22),
//                         SizedBox(width: 12),
//                         Text(
//                           'Generate Payment Link',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Security Badge
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.green.shade100),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.verified, color: Colors.green.shade600, size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Secure & Encrypted',
//                     style: TextStyle(
//                       color: Colors.green.shade700,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final monthData = currentMonthData;
//     final groups = _filteredGroups;
//     const totalCollected = 100;
//     //groups.fold<num>(0, (sum, group) => sum + (group.["collected"] as num));
//     const totalDue = 50;
//     //   groups.fold<num>(0, (sum, group) => sum + (group["due"] as num));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: home2),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: home2),
//             onPressed: () {
//               _showLogoutConfirmation(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // User Welcome Card
//             Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 side: const BorderSide(color: home1, width: 1),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: home1.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.person, size: 30, color: home1),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Welcome back,",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: home2.withOpacity(0.7),
//                             ),
//                           ),
//                           Text(
//                             userName ?? "",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w700,
//                               color: home2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         _showSettingsDialog(context);
//                       },
//                       icon: const Icon(Icons.settings, color: home1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//
//             const SizedBox(height: 20),
//
//             // Monthly Financial Summary
//             Text(
//               "${months[_selectedMonthIndex]} $currentYear Financials",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: home2,
//               ),
//             ),
//             const SizedBox(height: 12),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               childAspectRatio: 1.4,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               children: [
//                 _buildStatCard(
//                   "Total Collected",
//                   "₹${monthData["collected"]}",
//                   home1,
//                   Icons.arrow_downward,
//                 ),
//                 _buildStatCard(
//                   "Pending Dues",
//                   "₹${monthData["due"]}",
//                   Colors.orange,
//                   Icons.arrow_upward,
//                 ),
//                 _buildStatCard(
//                   "Active Groups",
//                   _groups.length.toString(),
//                   Colors.green,
//                   Icons.group_add,
//                 ),
//                 _buildStatCard(
//                   "Active Members",
//                   "$avilableMembers",
//                   home2,
//                   Icons.groups,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Financial Overview
//             const Text(
//               "Cumulative Overview",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: home2,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 side: const BorderSide(color: home1, width: 1),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Total Collected",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: home2.withOpacity(0.7),
//                           ),
//                         ),
//                         const Text(
//                           "₹$totalCollected",
//                           style:  TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: home1,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     LinearProgressIndicator(
//                       value: totalCollected / (totalCollected + totalDue),
//                       backgroundColor: Colors.grey.shade200,
//                       color: home1,
//                       minHeight: 8,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Pending Dues",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: home2.withOpacity(0.7),
//                           ),
//                         ),
//                        const Text(
//                           "₹$totalDue",
//                           style:  TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Groups Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Your Groups (${_groups.length})",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: home2,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   style: TextButton.styleFrom(
//                     foregroundColor: home1,
//                   ),
//                  // child: const Text("View All"),
//                   child: const Text(""),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             // Groups List
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _groups.length,
//               itemBuilder: (context, index) {
//                 final group = groups[index];
//                 return _buildGroupCard(
//                     group.groupName,
//                     group.groupId,
//                     group.defaultAmount,
//                     group.defaultDueDate,
//                    group.status.toString(),
//                     group.createdDate,
//
//                 );
//               },
//             ),
//
//             Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _isExpanded = !_isExpanded;
//                     });
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: home1.withOpacity(0.1)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Send Payment Link',
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 AnimatedCrossFade(
//                   duration: const Duration(milliseconds: 300),
//                   crossFadeState: _isExpanded
//                       ? CrossFadeState.showFirst
//                       : CrossFadeState.showSecond,
//                   firstChild: _buildExpandedContent(),
//                   secondChild: const SizedBox.shrink(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10,),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatCard(
//       String title, String value, Color color, IconData icon) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: home1, width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, size: 24, color: color),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: home2.withOpacity(0.6),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: home2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGroupCard(String name,
//       int members, num collected, DateTime due,
//       String status, DateTime created) {
//     final isNewGroup =
//         created.month - 1 == _selectedMonthIndex && created.year == currentYear;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color:status == "Active"? Colors.white: Colors.grey.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color:
//         status == "Active"?
//         home1:Colors.grey.withOpacity(0.2), width: 1),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: status =="Active"?home1.withOpacity(0.1):home2.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Stack(
//             children: [
//                Center(
//                 child: Icon(Icons.group, size: 24, color:status =="Active"? home1:home2),
//               ),
//               if (isNewGroup)
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration:  BoxDecoration(
//                       color: status == "Active"?Colors.green:home2,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       name[0],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         title: Text(
//           name,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: home2,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Text(
//               "Created at ${_formatDate(created)}",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: home2.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Text(
//                   "Amount : ₹${collected.toStringAsFixed(0)}",
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: home1,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               "Due Date : ${_formatDate(due)}",
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: home2,
//               ),
//             ),
//           ],
//         ),
//         trailing: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: status == "Active"
//                 ? Colors.green.withOpacity(0.1)
//                 : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Text(
//             status == "Active" ? "Active" : "Inactive",
//             style: TextStyle(
//               color: status == "Active" ? Colors.green : Colors.grey,
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//           ),
//         ),
//         onTap: () async {
//         final result = await  Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>  GroupDetailPage(
//                         amount: collected.toString(),
//                         dueDate:DateFormat('yyyy-MM-dd').format(due) ,
//                         groupId:members,
//                         groupName: name, groupStatus: status,
//                       )));
//         result == "Refresh"?
//         loadSharedData():"";
//         },
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return "${months[date.month - 1]} ${date.day}, ${date.year}";
//   }
// }
//
//
//
// /*
//   Future<void> _showThemeSelector(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(
//             'Select Theme',
//             style: TextStyle(color: home2),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildThemeOption('Default', home1, home2),
//               _buildThemeOption('Dark', Colors.grey[900]!, Colors.white),
//               _buildThemeOption('Blue', Colors.blue, Colors.white),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: home2),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// */
//
// // Month Selector
// // Card(
// //   elevation: 0,
// //   shape: RoundedRectangleBorder(
// //     borderRadius: BorderRadius.circular(16),
// //     side: const BorderSide(color: home1, width: 1),
// //   ),
// //   child: Padding(
// //     padding: const EdgeInsets.all(12),
// //     child: Column(
// //       children: [
// //         const Text(
// //           "Select Month",
// //           style: TextStyle(
// //             fontSize: 14,
// //             fontWeight: FontWeight.w600,
// //             color: home2,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: Row(
// //             children: List.generate(months.length, (index) {
// //               final isSelected = index == _selectedMonthIndex;
// //               return GestureDetector(
// //                 onTap: () {
// //                   setState(() {
// //                     _selectedMonthIndex = index;
// //                   });
// //                 },
// //                 child: Container(
// //                   margin: const EdgeInsets.symmetric(horizontal: 4),
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 16,
// //                     vertical: 8,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: isSelected ? home1 : Colors.transparent,
// //                     borderRadius: BorderRadius.circular(20),
// //                     border: Border.all(
// //                       color:
// //                           isSelected ? home1 : Colors.grey.shade300,
// //                     ),
// //                   ),
// //                   child: Text(
// //                     months[index],
// //                     style: TextStyle(
// //                       color: isSelected ? Colors.white : home2,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             }),
// //           ),
// //         ),
// //       ],
// //     ),
// //   ),
// // ),
// // Get filtered groups based on selected month
// // List<Map<String, dynamic>> get filteredGroups {
// //   if (_selectedMonthIndex == DateTime.now().month - 1) {
// //     return allGroups;
// //   }
// //   return allGroups.where((group) {
// //     return group["created"]
// //         .isBefore(DateTime(currentYear, _selectedMonthIndex + 2, 1));
// //   }).toList();
// // }
// /*  Widget _buildExpandedContent() {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
//         side: const BorderSide(color: home1, ),
//       ),
//       elevation: 1,
//       margin: const EdgeInsets.only(top: 20),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const TextField(
//               decoration: InputDecoration(
//                 counterText: "",
//                 prefixIcon: Icon(Icons.phone_iphone, color: home1),
//                 labelText: 'Enter customer mobile number',
//                 border: OutlineInputBorder(),
//               ),
//               maxLength: 10,
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.auto_mode_outlined, color: home1),
//                 labelText: 'Enter Amount',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.note_alt_outlined, color: home1),
//                 labelText: 'Enter a note',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.text,
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // Handle send action
//                 },
//                 icon: const Icon(Icons.send),
//                 label: const Text('Send Link'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: home1,
//
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }*/
