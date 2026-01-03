import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:collection_qr_flutter/presentation/dues/rdcl_due_home_page.dart';
import 'package:collection_qr_flutter/presentation/loan_integrated/loan_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../account_dues/account_list_home_page.dart';
import '../account_dues/rdcl_account_list_home_page.dart';
import '../dues/dues_home_page.dart';
import '../groups/group_homepage/all_groups_page.dart';
import '../groups/homepage/group_home_page.dart';
import '../home/home_page.dart';
import '../profile/profile_home_page.dart';
import '../test_page.dart';
import '../trancstion/payment_link_home_page.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
   String? userTPYE;
  String? loggedInUserTPYE;
  double _indicatorPosition = 0.0;
  final List<GlobalKey> _tabKeys = List.generate(5, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    getSharedData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndicatorPosition(animate: false);
    });
  }

  Future<void> getSharedData() async {
    await SharedPref.shared.setLogin(true);
    var userType = await SharedPref.shared.getUserType();
    var loggedInUserType = await SharedPref.shared.getLoggedInUserType();
    print("getUserType value = $userType");
    setState(() {

      userTPYE = userType;
      loggedInUserTPYE = loggedInUserType;
    });
  }

  Widget loanPages(int index) {
    switch (index) {
      case 0:
        return  HomePage(userType: loggedInUserTPYE.toString(),);
      case 1:
       // return const LoanHomePage();
        return const LoanList();
      case 2:
      //  return const ProfileHomePage();
       return const TestProfilePage();
      default:
        return  HomePage(userType: loggedInUserTPYE.toString(),);
    }
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return  HomePage(userType: loggedInUserTPYE.toString(),);
      case 1:
        return userTPYE?.contains("RDCL") == true
            ? const RdclDuesHomePage()
            : const DuesHomePage();

      case 2:
        return userTPYE?.contains("RDCL") == true
            ? const RdclAccountListHomePage()
            : const AccountListHomePage();
      case 3:
        return const ProfileHomePage();
      default:
        return  HomePage(userType: loggedInUserTPYE.toString(),);
    }
  }

  Widget _getNonAgentSelectedPage(int index) {
    switch (index) {
      case 0:
        // return const FeeHomePage();
        return const GroupHomePage();
      case 1:
        return const AllGroupsPage();
      case 2:

        /// return const ProfileHomePage();
        //return const BankDetailsScreen();
        return const PaymentLinkHomePage();
      default:
        return  HomePage(userType: loggedInUserTPYE.toString(),);
    }
  }

  void _updateIndicatorPosition({bool animate = true}) {
    try {
      // Check if index is valid
      if (_selectedIndex < 0 || _selectedIndex >= _tabKeys.length) {
        debugPrint('Invalid index: $_selectedIndex');
        return;
      }

      // Get the key
      final key = _tabKeys[_selectedIndex];
      if (key.currentContext == null) {
        debugPrint('No context for index $_selectedIndex');
        return;
      }

      // Get render object
      final renderObject = key.currentContext!.findRenderObject();
      if (renderObject == null || renderObject is! RenderBox) {
        debugPrint('No RenderBox for index $_selectedIndex');
        return;
      }

      final RenderBox renderBox = renderObject;

      // Check if widget is still in the tree
      if (!renderBox.attached) {
        debugPrint('RenderBox not attached for index $_selectedIndex');
        return;
      }

      final position = renderBox.localToGlobal(Offset.zero);
      final newPosition = position.dx + (renderBox.size.width / 2) - 20;

      if (animate) {
        if (mounted) {
          setState(() {
            _indicatorPosition = newPosition;
          });
        }
      } else {
        _indicatorPosition = newPosition;
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Error in _updateIndicatorPosition: $e');
      // Set a default position or skip
      _indicatorPosition = 0.0;
      if (mounted) setState(() {});
    }
  }
  // void _updateIndicatorPosition({bool animate = true}) {
  //   final RenderBox renderBox = _tabKeys[_selectedIndex]
  //       .currentContext
  //       ?.findRenderObject() as RenderBox;
  //   final position = renderBox.localToGlobal(Offset.zero);
  //   final newPosition = position.dx + (renderBox.size.width / 2) - 20;
  //
  //   if (animate) {
  //     setState(() {
  //       _indicatorPosition = newPosition;
  //     });
  //   } else {
  //     _indicatorPosition = newPosition;
  //     if (mounted) setState(() {});
  //   }
  // }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _updateIndicatorPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (context) => exitAlert(context));
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        body:
            loggedInUserTPYE == "AGENT" && loggedInUserTPYE?.isNotEmpty == true
                ? _getSelectedPage(_selectedIndex)
                : loggedInUserTPYE == "AGENT_LOAN" && loggedInUserTPYE?.isNotEmpty == true
                    ? loanPages(_selectedIndex)
                    : loggedInUserTPYE == "NOT_AN_AGENT" &&
                            loggedInUserTPYE?.isNotEmpty == true
                        ? _getNonAgentSelectedPage(_selectedIndex)
                        : const SizedBox.shrink(),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background floating pill
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuad,
                  left: _indicatorPosition,
                  bottom: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: home2,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: home2.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                // Navigation items
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: loggedInUserTPYE == "AGENT"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNavItem(
                                key: _tabKeys[0],
                                index: 0,
                                icon: Icons.home_outlined,
                                activeIcon: Icons.home,
                                label: 'Home',
                              ),
                              _buildNavItem(
                                key: _tabKeys[1],
                                index: 1,
                                icon: Icons.receipt_long_outlined,
                                activeIcon: Icons.receipt_long,
                                label: 'Dues',
                              ),
                              _buildNavItem(
                                key: _tabKeys[2],
                                index: 2,
                                icon: Icons.list_alt_outlined,
                                activeIcon: Icons.list_alt,
                                label: userTPYE?.contains("RDCL") == true
                                    ? "Cust List"
                                    : 'Accounts',
                              ),
                              // _buildNavItem(
                              //   key: _tabKeys[1],
                              //   index: 1,
                              //   icon: Icons.list_alt_outlined,
                              //   activeIcon: Icons.list_alt,
                              //   label: userTPYE?.contains("RDCL") == true
                              //       ? "Cust List"
                              //       : 'Accounts',
                              // ),
                              _buildNavItem(
                                key: _tabKeys[3],
                                index: 3,
                                icon: Icons.person_outline,
                                activeIcon: Icons.person,
                                label: 'Profile',
                              ),
                            ],
                          )
                        : loggedInUserTPYE == "AGENT_LOAN"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildNavItem(
                                    key: _tabKeys[0],
                                    index: 0,
                                    icon: Icons.home_outlined,
                                    activeIcon: Icons.home,
                                    label: 'Home',
                                  ),
                                  _buildNavItem(
                                      key: _tabKeys[1],
                                      index: 1,
                                      icon: Icons.paid_outlined,
                                      activeIcon: Icons.paid,
                                      label: "Loan"),
                                  _buildNavItem(
                                    key: _tabKeys[2],
                                    index: 2,
                                    icon: Icons.person_outline,
                                    activeIcon: Icons.person,
                                    label: 'Profile',
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // _buildGroupNavItem(0, Icons.home_rounded, Icons.home_outlined),
                                  // _buildGroupNavItem(1, Icons.groups, Icons.groups_outlined),
                                  // _buildGroupNavItem(2, Icons.person_rounded, Icons.person_outline),
                                  _buildNavItem(
                                    key: _tabKeys[0],
                                    index: 0,
                                    icon: Icons.home_outlined,
                                    activeIcon: Icons.home,
                                    label: 'Home',
                                  ),

                                  _buildNavItem(
                                    key: _tabKeys[1],
                                    index: 1,
                                    icon: Icons.group_add_outlined,
                                    activeIcon: Icons.group_add,
                                    label: 'Groups',
                                  ),
                                  _buildNavItem(
                                    key: _tabKeys[2],
                                    index: 2,
                                    icon: Icons.history_toggle_off,
                                    activeIcon: Icons.history,
                                    label: 'History',
                                  ),
                                ],
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required GlobalKey key,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        key: key,
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 56,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey<bool>(isSelected),
                  size: 24,
                  color: isSelected ? home2 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? home2 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


