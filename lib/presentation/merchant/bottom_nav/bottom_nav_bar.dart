import 'package:flutter/material.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../account_dues/account_list_home_page.dart';
import '../../account_dues/rdcl_cust_list_bloc/customer _list.dart';
import '../../dues/rdcl_due_list_bloc_page.dart';
import '../../home/home_page.dart';
import '../../profile/profile_home_page.dart';
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
  var _selectedIndex = 0;
  late var integratedTypeRDLoanMerchantPages = [];
  String integrationStatus = "";
  String branCode = "";
  String rdclCustomerUnderAgentListUrl = "";
  String rdclDueListUnderAgentUrl = "";
  String type = "";
  final String INTEGRATED = "Y";
  final String USER_TYPE_RDCL = "RDCL";
  final String USER_TYPE_RD = "RD&LOAN";

  final rdclItems = [
    ["Home", Icons.home, Icons.house_outlined],
    ["Dues", Icons.receipt, Icons.receipt_long],
    ["Cust-List", Icons.list, Icons.list_alt_outlined],
    ["Profile", Icons.personal_injury_outlined, Icons.person],
  ];
  final rdLoanItems = [
    ["Home", Icons.home, Icons.house_outlined],
    ["RD_Loan", Icons.monetization_on_outlined, Icons.monetization_on],
    ["Profile", Icons.personal_injury_outlined, Icons.person],
  ];
  final groupItems = [
    ["Home", Icons.home, Icons.house_outlined],
    ["Groups", Icons.safety_divider, Icons.safety_divider_rounded],
    [
      "Transactions",
      Icons.transfer_within_a_station,
      Icons.transfer_within_a_station_rounded
    ],
    [
      "Settlement",
      Icons.settings_backup_restore,
      Icons.settings_backup_restore_sharp
    ],
  ];
  final integratedTypeLoanMerchantPages = [];
  final nonIntegratedTypeMerchantPages = [];
  late var integratedTypeRDCLMerchantPages = [];
  final groupTypeMerchantPages = [
    const GroupHomePageUI(),
    const AllGroupsPage(),
    const PaymentLinkHomePageMerchant(),
    const SettlementPage(),
  ];
  Future<void> getSharedData() async {
    final _integrationStatus =
        await SharedPref.shared.getECollectMerchantIntegrationStatus();
    final _branCode = await SharedPref.shared.getECollectMerchantBranchCode();
    final _rdclCustomerUnderAgentListUrl =
        await SharedPref.shared.getECollectRdclCustomerunderAgentListUrl();
    final _rdclDueListUnderAgentUrl =
        await SharedPref.shared.getECollectRdclDuesListunderAgentUrl();
    final _type = await SharedPref.shared.getECollectUserType();

    setState(() {
      //type = _type;
      type = "RDCL";
      integrationStatus = _integrationStatus;
      branCode = _branCode;
      rdclCustomerUnderAgentListUrl = _rdclCustomerUnderAgentListUrl;
      rdclDueListUnderAgentUrl = _rdclDueListUnderAgentUrl;
    });

    integratedTypeRDCLMerchantPages = [
      HomePage(userType: type),
      RdclDueListBlocPage(
        branchCode: branCode,
      ),
      const CustomerList(),
      const ProfileHomePage()
    ];
    integratedTypeRDLoanMerchantPages = [
      HomePage(userType: type),
      const AccountListHomePage(),
      const ProfileHomePage()
    ];
  }

  @override
  void initState() {
    super.initState();
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: integrationStatus.toLowerCase() == INTEGRATED.toLowerCase() &&
              type.toLowerCase() == USER_TYPE_RDCL.toLowerCase()
          ? integratedTypeRDCLMerchantPages[_selectedIndex]
          : integrationStatus.toLowerCase() == INTEGRATED.toLowerCase() &&
                  type.toLowerCase() == USER_TYPE_RD.toLowerCase()
              ? integratedTypeRDLoanMerchantPages[_selectedIndex]
              : groupTypeMerchantPages[_selectedIndex],
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
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFFEA307B),
              unselectedItemColor: Colors.grey.shade500,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
                letterSpacing: -0.2,
              ),
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items:
                  integrationStatus.toLowerCase() == INTEGRATED.toLowerCase() &&
                          type.toLowerCase() == USER_TYPE_RDCL.toLowerCase()
                      ? List.generate(rdclItems.length, (index) {
                          return buildBottomNavigationBarItem(
                              rdclItems[index][0] as String,
                              rdclItems[index][1] as IconData,
                              rdclItems[index][2] as IconData,
                              _selectedIndex);
                        })
                      : integrationStatus.toLowerCase() ==
                                  INTEGRATED.toLowerCase() &&
                              type.toLowerCase() == USER_TYPE_RD.toLowerCase()
                          ? List.generate(rdLoanItems.length, (index) {
                              return buildBottomNavigationBarItem(
                                  rdLoanItems[index][0] as String,
                                  rdLoanItems[index][1] as IconData,
                                  rdLoanItems[index][2] as IconData,
                                  _selectedIndex);
                            })
                          : List.generate(groupItems.length, (index) {
                              return buildBottomNavigationBarItem(
                                  groupItems[index][0] as String,
                                  groupItems[index][1] as IconData,
                                  groupItems[index][2] as IconData,
                                  _selectedIndex);
                            }))),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(String labelName,
      IconData selectedIconData, IconData unSelectedIconData, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(bottom: 2),
        child: Icon(
          index == 0 ? selectedIconData : unSelectedIconData,
          size: 24,
        ),
      ),
      label: labelName,
    );
  }
}
