import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/presentation/profile_home_page.dart';
import '../../core/colors.dart';
import 'collection_home_page.dart';
import 'dues_home_page.dart';
import 'home_page.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  String actionType = "";

  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _controller.index = index;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
        _controller.index = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          CollectionHomePage(),
          DuesHomePage(),
          ProfileHomePage(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        itemLabelStyle: GoogleFonts.inter(
            color: white, fontWeight: FontWeight.bold, fontSize: 10),
        notchColor: deepTeal.withOpacity(0.7),
        notchBottomBarController: _controller,
        color: deepTeal.withOpacity(0.7),
        onTap: _onItemTapped,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Image.asset(
              "assets/images/home_icon.png",
              color: white,
            ),
            activeItem: Image.asset(
              "assets/images/home_icon.png",
              color: white,
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Image.asset(
              "assets/images/collection_icon.png",
              color: white,
            ),
            activeItem: Image.asset(
              "assets/images/collection_icon.png",
              color: white,
            ),
            itemLabel: 'Collection',
          ),
          BottomBarItem(
            inActiveItem: Image.asset(
              "assets/images/dues_list_icon.png",
              color: white,
            ),
            activeItem: Image.asset(
              "assets/images/dues_list_icon.png",
              color: white,
            ),
            itemLabel: 'Due List',
          ),
          BottomBarItem(
            inActiveItem: Image.asset(
              "assets/images/profile_icon.png",
              color: white,
            ),
            activeItem: Image.asset(
              "assets/images/profile_icon.png",
              color: white,
            ),
            itemLabel: 'Profile',
          ),
        ],
        kIconSize: 20,
        kBottomRadius: 30.0,
      ),
    );
  }
}
