
import 'package:collection_qr_flutter/presentation/merchant/pages/group_home_page.dart';
import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../account_dues/rd_dues/rd_cust_list_page.dart';
import '../../account_dues/rdcl/rdcl_customer _list.dart';
import '../../account_dues/rdcl/rdcl_due_list_bloc_page.dart';
import '../../home/e_collect_homepage.dart';
import '../../loan/loan_list.dart';
import '../../profile/profile_home_page.dart';
import '../history/ecollect_transaction_report.dart';
import '../pages/all-groups.dart';
import '../pages/payment_link_page.dart';
import '../pages/settlement_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  String integrationStatus = "";
  String branCode = "";

  List<String> type = [];

  bool isLoading = true;

  //final String INTEGRATED = "Y";
  final String USER_TYPE_RDCL = "RDCL";
  final String USER_TYPE_RD = "RD";
  final String USER_TYPE_LOAN = "LOAN";
  final String USER_TYPE_GROUP = "GROUP";

  @override
  void initState() {
    super.initState();
    getSharedData();
  }
  // ---------------------------------------------------------------------------
  // GET SHARED DATA
  // ---------------------------------------------------------------------------

  Future<void> getSharedData() async {

    final integrationStatus =
    await SharedPref.shared.getECollectMerchantIntegrationStatus();

    final branCode =
    await SharedPref.shared.getECollectMerchantBranchCode();

    final type =
    await SharedPref.shared.getECollectTypeList();

    if (!mounted) return;

    debugPrint("=================================");
    debugPrint("Integration Status: [$integrationStatus]");
    debugPrint("Branch Code: [$branCode]");
    debugPrint("User Type: [$type]");
    debugPrint("=================================");

    setState(() {
      this.integrationStatus = integrationStatus;
      this.branCode = branCode;
      this.type = type;
      isLoading = false;
    });
  }

  // ---------------------------------------------------------------------------
  // CHECK USER TYPE
  // ---------------------------------------------------------------------------

  bool hasType(String userType) {
    return type.contains(userType);
  }

  // ---------------------------------------------------------------------------
  // DYNAMIC NAVIGATION ITEMS
  // ---------------------------------------------------------------------------

  List<NavItem> get navItems {
    final List<NavItem> items = [];

    // -------------------------------------------------------------------------
    // HOME
    //
    // GROUP users get GroupHomePageUI.
    // Everyone else gets ECollectHomepage.
    // -------------------------------------------------------------------------

    if (hasType(USER_TYPE_GROUP)) {
      items.add(
        NavItem(
          label: 'Home',
          icon: Icons.home,
          page: const GroupHomePageUI(),
        ),
      );
    } else {
      items.add(
        NavItem(
          label: 'Home',
          icon: Icons.home,
          page: const ECollectHomepage(),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // RD
    // -------------------------------------------------------------------------

    if (hasType(USER_TYPE_RD)) {
      items.add(
        NavItem(
          label: 'RD Dues',
          icon: Icons.event_repeat,
          page: const RdDueDetailPage(),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // LOAN
    // -------------------------------------------------------------------------

    if (hasType(USER_TYPE_LOAN)) {
      items.add(
        NavItem(
          label: 'Loan-List',
          icon: Icons.account_balance,
          page: const LoanList(),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // RDCL
    // -------------------------------------------------------------------------

    if (hasType(USER_TYPE_RDCL)) {
      items.add(
        NavItem(
          label: 'Due-Detail',
          icon: Icons.receipt_long,
          page: RdclDueDetailBlocPage(
            branchCode: branCode,
          ),
        ),
      );

      items.add(
        NavItem(
          label: 'Due-List',
          icon: Icons.receipt,
          page: const RdclDueListBocPage(),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // GROUP
    // -------------------------------------------------------------------------

    if (hasType(USER_TYPE_GROUP)) {
      items.add(
        NavItem(
          label: 'Groups',
          icon: Icons.safety_divider,
          page: AllGroupsPage(),
        ),
      );

      items.add(
        NavItem(
          label: 'TranHistory',
          icon: Icons.send_time_extension_outlined,
          page: const PaymentLinkHomePageMerchant(),
        ),
      );

      items.add(
        NavItem(
          label: 'Settlement',
          icon: Icons.settings_backup_restore,
          page: const SettlementPage(),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // COMMON TRANSACTION HISTORY
    // -------------------------------------------------------------------------

    items.add(
      NavItem(
        label: 'Tran-History',
        icon: Icons.list_alt,
        page: EcollectTransactionReport(),
      ),
    );

    // -------------------------------------------------------------------------
    // COMMON PROFILE
    // -------------------------------------------------------------------------

    items.add(
      NavItem(
        label: 'Profile',
        icon: Icons.person,
        page: const ProfileHomePage(),
      ),
    );

    return items;
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final items = navItems;

    if (items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Unable to load navigation'),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // SAFETY
    //
    // If the type changes and the number of pages changes, prevent an invalid
    // index.
    // -------------------------------------------------------------------------

    if (currentIndex >= items.length) {
      currentIndex = 0;
    }

    return Scaffold(
      // -----------------------------------------------------------------------
      // CURRENT PAGE
      // -----------------------------------------------------------------------

      body: items[currentIndex].page,

      // -----------------------------------------------------------------------
      // BOTTOM NAVIGATION
      // -----------------------------------------------------------------------

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xFFEA307B),
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,

          // Required because the number of items can be greater than 3.
          type: BottomNavigationBarType.fixed,

          currentIndex: currentIndex,

          // -------------------------------------------------------------------
          // DYNAMIC PAGE SWITCHING
          // -------------------------------------------------------------------

          onTap: (index) {
            if (index < 0 || index >= items.length) {
              return;
            }

            debugPrint(
              '------------------------------------------',
            );

            debugPrint(
              'Selected index: $index',
            );

            debugPrint(
              'Selected page: ${items[index].label}',
            );

            debugPrint(
              'Available types: $type',
            );

            setState(() {
              currentIndex = index;
            });
          },

          // -------------------------------------------------------------------
          // DYNAMIC NAVIGATION ITEMS
          // -------------------------------------------------------------------

          items: items.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}


/*class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
final GlobalKey<ECollectHomepageState> eCollectHomeKey = GlobalKey<ECollectHomepageState>();
final GlobalKey<RdclDueDetailBlocPageState> eCollectRdclDueDetailKey = GlobalKey<RdclDueDetailBlocPageState>();
final GlobalKey<EcollectTransactionReportState> eCollectTransactionKey = GlobalKey<EcollectTransactionReportState>();
final GlobalKey<RdclDueListBocPageState> eCollectRdclDueListKey = GlobalKey<RdclDueListBocPageState>();

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  String integrationStatus = "";
  String branCode = "";
  List<String> type = [];
  bool isLoading = true;
  final String INTEGRATED = "Y";
  final String USER_TYPE_RDCL = "RDCL";
  final String USER_TYPE_RD = "RD";
  final String USER_TYPE_LOAN = "LOAN";


  Future<void> getSharedData() async {
    final _integrationStatus =
    await SharedPref.shared.getECollectMerchantIntegrationStatus();
    final _branCode = await SharedPref.shared.getECollectMerchantBranchCode();
    final _type = await SharedPref.shared.getECollectTypeList();

    if (!mounted) return;
    debugPrint("=================================");
    debugPrint("Integration Status: [$integrationStatus]");
    debugPrint("Branch Code: [$_branCode]");
    debugPrint("User Type: [$_type]");
    debugPrint("=================================");
    setState(() {
    type = _type;

      integrationStatus = _integrationStatus;
      branCode = _branCode;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
  }
  /// RD, LOAN , R-D-C-L , Group these are the 4 categories we are currently using. Based on the type its been switched....
  List<NavItem> get navItemCategories {
    final List<NavItem> items = [
      type.contains("GROUP")?
      NavItem(
        label: 'Home',
        icon: Icons.home,
        page: GroupHomePageUI(key: eCollectHomeKey),
      ):
      NavItem(
        label: 'Home',
        icon: Icons.home,
        page: ECollectHomepage(key: eCollectHomeKey),
      ),
    ];

    for (final t in type) {
      switch (t) {
        case "RD":
          items.add(
            NavItem(
              label: 'RD Dues',
              icon: Icons.event_repeat,
              page: const RdDueDetailPage(),
            ),
          );
          break;

        case "LOAN":
          items.add(
            NavItem(
              label: 'Loan-List',
              icon: Icons.account_balance,
              page: const LoanList(),
            ),
          );
          break;

        case "RDCL":
          items.addAll([
            NavItem(
              label: 'Due-Detail',
              icon: Icons.receipt_long,
              page: RdclDueDetailBlocPage(
                branchCode: branCode,
                key: eCollectRdclDueDetailKey,
              ),
            ),
            NavItem(
              label: 'Due-List',
              icon: Icons.receipt,
              page: RdclDueListBocPage(
                key: eCollectRdclDueListKey,
              ),
            ),

          ]);
          break;

        case "GROUP":
          items.addAll([
            NavItem(
              label: 'Groups',
              icon: Icons.safety_divider,
              page: AllGroupsPage(),
            ),
            NavItem(
              label: 'TranHistory',
              icon: Icons.send_time_extension_outlined,
              page: const PaymentLinkHomePageMerchant(),
            ),
            NavItem(
              label: 'Settlement',
              icon: Icons.settings_backup_restore,
              page: const SettlementPage(),
            ),
          ]);
          break;
      }
    }

    items.add(NavItem(
  label: 'Tran-History',
  icon: Icons.list_alt,

  page: EcollectTransactionReport(key: eCollectTransactionKey,),
),);
    // Common Profile — add only once
    items.add(
      NavItem(
        label: 'Profile',
        icon: Icons.person,
        page: const ProfileHomePage(),
      ),
    );

    return items;
  }
  List<NavItem> get items => navItemCategories;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final navItems = items;

    if (navItems.length < 2) {
      return const Scaffold(
        body: Center(
          child: Text('Unable to load navigation'),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: navItems.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xFFEA307B),
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) async {
            setState(() {
              currentIndex = index;
            });
            if(index == 0){
              await eCollectHomeKey.currentState?.refresh();
            }
            if(index == 1){
              await eCollectRdclDueDetailKey.currentState?.refresh();
            }
            if(index == 2){
              await eCollectRdclDueListKey.currentState?.refresh();
            }
            if(index == 3){
              await eCollectTransactionKey.currentState?.refresh();
            }
            print("index : $index");
          },
          items: navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}*/
