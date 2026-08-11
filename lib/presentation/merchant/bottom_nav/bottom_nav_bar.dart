import 'package:flutter/material.dart';
import '../../../core/utils.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../account_dues/account_list_home_page.dart';
import '../../account_dues/rdcl_cust_list_bloc/customer _list.dart';
import '../../dues/rdcl_due_list_bloc_page.dart';
import '../../home/e_collect_homepage.dart';
import '../../loan_integrated/loan_list.dart';
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
final GlobalKey<ECollectHomepageState> eCollectHomeKey = GlobalKey<ECollectHomepageState>();
final GlobalKey<RdclDueDetailBlocPageState> eCollectRdclDueDetailKey = GlobalKey<RdclDueDetailBlocPageState>();
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
  /// RD, LOAN , RDCL , Group these are the 4 categories we are currently using. Based on the type its been switched....
  List<NavItem> get navItemCategories {
    final List<NavItem> items = [
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
              icon: Icons.receipt_long,
              page: const RdDueDetailPage(),
            ),
          );
          break;

        case "LOAN":
          items.add(
            NavItem(
              label: 'Loan-List',
              icon: Icons.monetization_on,
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
  icon: Icons.timelapse,
  page: const EcollectTransactionReport(),
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
}
