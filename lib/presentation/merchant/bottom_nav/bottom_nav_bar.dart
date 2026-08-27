import 'package:e_Collect/presentation/merchant/pages/group_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String eCollectBranchID = "";
  String eCollectAgentID = "";
  String eCollectUserRole = "";
  String eCollectUserToken = "";
  bool eCollectActiveStatus= false;
  bool eCollectVerifyStatus= false;
  String eCollectUserName = "";
  String eCollectMerchantId = "";
  String eCollectMerchantNumber = "";
  String eCollectMerchantEmail = "";
  String eCollectMerchantRegName = "";
  String eCollectBranchName = "";
  String eCollectCommRate = "";
  String fcmToken = "";
  String eCollectUserID = "";
  List<String> type = [];
  List<String> eCollectUrlList = [];
  bool isLoading = true;
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
    final integrationStatus = await SharedPref.shared.getECollectMerchantIntegrationStatus();
    final branCode = await SharedPref.shared.getECollectMerchantBranchCode();
    final type =    await SharedPref.shared.getECollectTypeList();
    final result =  await Future.wait([
      SharedPref.shared.getECollectExternalBranchCode(),
      SharedPref.shared.getExternalAgentID(),
      SharedPref.shared.getECollectUrlList(),
      SharedPref.shared.getECollectUserToken(),
      SharedPref.shared.getECollectMerchantName(),
      SharedPref.shared.getECollectMerchantID(),
      SharedPref.shared.getECollectUserNumber(),
      SharedPref.shared.getFcmToken(),
      SharedPref.shared.getECollectUserID(),
      SharedPref.shared.getECollectUserEmail(),
      SharedPref.shared.getECollectMerchantRegName(),
      SharedPref.shared.getECollectBranchName(),
      SharedPref.shared.getECollectUserRole(),
      SharedPref.shared.getECollectCommRate(),
      SharedPref.shared.getECollectActiveStatus(),
      SharedPref.shared.getECollectVerifyStatus(),
      SharedPref.shared.getECollectMerchantIntegrationStatus(),
    ]);
    eCollectBranchID  = result[0] as String; //01
    eCollectAgentID = result[1] as String; //1021
    eCollectUrlList = result[2] as List<String>; //1021
    eCollectUserToken = result[3] as String; //1021
    eCollectUserName = result[4] as String; //1021
    eCollectMerchantId = result[5] as String; //1021
    eCollectMerchantNumber = result[6] as String; //1021
    fcmToken = result[7] as String; //1021
    eCollectUserID = result[8] as String; //1021
    eCollectMerchantEmail = result[9] as String; //1021
    eCollectMerchantRegName = result[10] as String; //1021
    eCollectBranchName = result[11] as String; //1021
    eCollectUserRole = result[12] as String; //1021
    eCollectCommRate = result[13] as String; //1021
    eCollectActiveStatus = result[14] as bool; //1021
    eCollectVerifyStatus = result[15] as bool; //1021
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
          page:  ECollectHomepage(eCollectUserName: eCollectUserName,
            eCollectMerchantID: eCollectMerchantId, eCollectToken:eCollectUserToken,),
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
          page: RdDueDetailPage(
            eCollectBranchID: eCollectBranchID,
            eCollectAgentID: eCollectAgentID,
            eCollectUserToken: eCollectUserToken,
            eCollectUrlList:  eCollectUrlList,),
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
          page:  LoanList(
            eCollectBranchId: eCollectBranchID,
            eCollectAgentID: eCollectAgentID,
            eCollectLoanListingUrl: eCollectUrlList),
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
        page: EcollectTransactionReport(
          eCollectMerchantID: eCollectMerchantId,
          eCollectMerchantName: eCollectUserName,
          eCollectToken: eCollectUserToken,),
      ),
    );

    // -------------------------------------------------------------------------
    // COMMON PROFILE
    // -------------------------------------------------------------------------
    items.add(
      NavItem(
        label: 'Profile',
        icon: Icons.person,
        page:  ProfileHomePage(
          profileData:
          ProfileData(
              userId: eCollectUserID,
              agentCode: eCollectAgentID,
              agentName: eCollectUserName,
              mobileNumber: eCollectMerchantNumber,
              email: eCollectMerchantEmail,
              role: eCollectUserRole,
              merchantName: eCollectMerchantRegName,
              merchantId:eCollectMerchantId,
              branchName: eCollectBranchName,
              branchCode: eCollectBranchID,
              commissionRate: eCollectCommRate,
              eCollectFcmToken: fcmToken,
              isActive: eCollectActiveStatus,
              isVerified: eCollectVerifyStatus,
              isIntegrated: integrationStatus == "Y"? true:false,
              enabledProducts: type,
            bearerToken: eCollectUserToken
          ),
        ),
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmationDialog(context);

        if (shouldExit && mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}


Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -------------------------------------------------------------
              // ICON
              // -------------------------------------------------------------

              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 27,
                  color: Color(0xFFEA307B),
                ),
              ),

              const SizedBox(height: 20),

              // -------------------------------------------------------------
              // TITLE
              // -------------------------------------------------------------

              const Text(
                'Exit e-Collect?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 8),

              // -------------------------------------------------------------
              // DESCRIPTION
              // -------------------------------------------------------------

              const Text(
                'Are you sure you want to exit the application?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------------
              // EXIT BUTTON
              // -------------------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA307B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Exit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // -------------------------------------------------------------
              // CANCEL BUTTON
              // -------------------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}