import 'package:flutter/material.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../account_dues/account_list_home_page.dart';
import '../../account_dues/rdcl_cust_list_bloc/customer _list.dart';
import '../../dues/dues_home_page.dart';
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
  final groupTypeMerchantPages = [
    const GroupHomePageUI(),
    const AllGroupsPage(),
    const PaymentLinkHomePageMerchant(),
    const SettlementPage(),
  ];

  late var integratedTypeRDMerchantPages = [];
  String integrationStatus = "";
  String branCode = "";
  String rdclCustomerUnderAgentListUrl = "";
  String rdclDueListUnderAgentUrl = "";
  String type = "";
  Future<void> getSharedData() async {
    final _integrationStatus = await SharedPref.shared.getECollectMerchantIntegrationStatus();
    final _branCode = await SharedPref.shared.getECollectMerchantBranchCode();
    final _rdclCustomerUnderAgentListUrl = await SharedPref.shared.getECollectRdclCustomerunderAgentListUrl();
    final _rdclDueListUnderAgentUrl = await SharedPref.shared.getECollectRdclDuesListunderAgentUrl();
    final _type = await SharedPref.shared.getECollectUserType();

    setState(() {
      // type = _type;
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
    integratedTypeRDMerchantPages = [
      HomePage(userType: type),
      const DuesHomePage(),
      const AccountListHomePage(),
      const ProfileHomePage()
    ];
  }
  final integratedTypeLoanMerchantPages = [];

  final nonIntegratedTypeMerchantPages = [];
  late var integratedTypeRDCLMerchantPages = [];

  @override
  void initState() {
    super.initState();
    getSharedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: integrationStatus == "Y" && type == "RDCL"
          ? integratedTypeRDCLMerchantPages[_selectedIndex]
          : integrationStatus == "Y" && type == "RD"
              ? integratedTypeRDMerchantPages[_selectedIndex]
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
          items: [
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 2),
                child: Icon(
                  _selectedIndex == 0 ? Icons.home : Icons.house_outlined,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 2),
                child: integrationStatus == "Y" && type == "RDCL"
                    ? Icon(
                        _selectedIndex == 1
                            ? Icons.receipt_long_outlined
                            : Icons.receipt_long,
                        size: 24,
                      )
                    : Icon(
                        _selectedIndex == 1
                            ? Icons.business_center
                            : Icons.business_center_outlined,
                        size: 24,
                      ),
              ),
              label: integrationStatus == "Y" && type == "RDCL" || type == "RD"
                  ? "Dues"
                  : "Bucket",
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 2),
                child: integrationStatus == "Y" && type == "RDCL"
                    ? Icon(
                        _selectedIndex == 2
                            ? Icons.list_alt_outlined
                            : Icons.list_alt,
                        size: 24,
                      )
                    : integrationStatus == "Y" && type == "RD"
                        ? Icon(
                            _selectedIndex == 2
                                ? Icons.list_alt_sharp
                                : Icons.list_alt,
                            size: 24,
                          )
                        : Icon(
                            _selectedIndex == 2
                                ? Icons.history
                                : Icons.history_toggle_off,
                            size: 24,
                          ),
              ),
              label: integrationStatus == "Y" && type == "RDCL"
                  ? 'Cust-List'
                  : integrationStatus == "Y" && type == "RD"
                      ? "Accounts"
                      : "History",
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 2),
                child: integrationStatus == "Y" && type == "RDCL"
                    ? Icon(
                        _selectedIndex == 2
                            ? Icons.person_outline
                            : Icons.person,
                        size: 24,
                      )
                    : integrationStatus == "Y" && type == "RD"
                        ? Icon(
                            _selectedIndex == 2
                                ? Icons.person
                                : Icons.personal_injury_outlined,
                            size: 24,
                          )
                        : Icon(
                            _selectedIndex == 2
                                ? Icons.transfer_within_a_station_sharp
                                : Icons.transfer_within_a_station,
                            size: 24,
                          ),
              ),
              label: integrationStatus == "Y" && type == "RDCL" || type == "RD"
                  ? "Profile"
                  : 'Settlement',
            ),
          ],
        ),
      ),
    );
  }
}
