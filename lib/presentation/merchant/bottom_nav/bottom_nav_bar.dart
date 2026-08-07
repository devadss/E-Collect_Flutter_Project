import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../account_dues/account_list_home_page.dart';
import '../../account_dues/rdcl_cust_list_bloc/customer _list.dart';
import '../../dues/rdcl_due_list_bloc_page.dart';
import '../../home/e_collect_homepage.dart';
import '../../home/home_page.dart';
import '../../loan_integrated/loan_list.dart';
import '../../profile/profile_home_page.dart';
import '../history/ecollect_transaction_report.dart';
import '../pages/all-groups.dart';
import '../pages/group_home_page.dart';
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
  String type = "";
  bool isLoading = true;
  final String INTEGRATED = "Y";
  final String USER_TYPE_RDCL = "RDCL";
  final String USER_TYPE_RD = "RD";
  final String USER_TYPE_LOAN = "LOAN";


  Future<void> getSharedData() async {
    final _integrationStatus =
    await SharedPref.shared.getECollectMerchantIntegrationStatus();

    final _branCode =
    await SharedPref.shared.getECollectMerchantBranchCode();

    final _type =
    await SharedPref.shared.getECollectUserType();

    if (!mounted) return;
    debugPrint("=================================");
    debugPrint("Integration Status: [$integrationStatus]");
    debugPrint("Branch Code: [$_branCode]");
    debugPrint("User Type: [$_type]");
    debugPrint("=================================");
    setState(() {
    //  type = _type;
      type = "RDCL";
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
  /// RD, LOAN , RDCL , Group these are the 4 categories we are currently using. Based on the type its been switched....
  List<NavItem> get navItemCategories {
    switch(type) {
      case "RD":
        {
          return [
            NavItem(
              label: 'Home',
              icon: Icons.home,
              page: const HomePage(userType: "RD"),
            ),
            NavItem(
              label: 'Due-Detail',
              icon: Icons.receipt_long,
              page: const RdDueDetailPage(),
            ),
            NavItem(
              label: 'Profile',
              icon: Icons.person,
              page: const ProfileHomePage(),
            ),
          ];
        }
      case "LOAN":
        {
          return [
            NavItem(
              label: 'Home',
              icon: Icons.home,
              page: const HomePage(userType: "RD"),
            ),
            NavItem(
              label: 'Loan-List',
              icon: Icons.monetization_on,
              page: const LoanList(),
            ),
            NavItem(
              label: 'Profile',
              icon: Icons.person,
              page: const ProfileHomePage(),
            ),
          ];
        }
      case "RDCL":
        {
          return [
            NavItem(
              label: 'Home',
              icon: Icons.home,
            //  page: const HomePage(userType: "RDCL"),
              page: const ECollectHomepage(),
            ),
            NavItem(
              label: 'Due-Detail',
              icon: Icons.receipt_long,
              page: RdclDueDetailBlocPage(
                branchCode: branCode,
              ),
            ),
            NavItem(
              label: 'Due-List',
              icon: Icons.receipt,
              page: const RdclDueListBocPage(),
            ),
            NavItem(
              label: 'Tran-History',
              icon: Icons.timelapse,
              page: const EcollectTransactionReport(),
            ),
            NavItem(
              label: 'Profile',
              icon: Icons.person,
              page: const ProfileHomePage(),
            ),
          ];
        }
      case "GROUP":
        {
          return [
            NavItem(
                label: 'Home', icon: Icons.home, page: const GroupHomePageUI()),
            NavItem(
                label: 'Groups',
                icon: Icons.safety_divider,
                page: AllGroupsPage()),
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
            NavItem(
              label: 'Profile',
              icon: Icons.person,
              page: const ProfileHomePage(),
            ),
          ];
        }
      default:
        return [];
    }
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
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
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
}
