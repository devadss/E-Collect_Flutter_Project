import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      return Future.value(false);
    }

    // Show exit confirmation dialog
    // Ensure dialog runs in the next frame
    return Future.delayed(Duration.zero, () async {
      bool exitApp = await   showDialog(
        context: context,
        barrierDismissible: false, // Prevents closing by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber_outlined,
                    color: Color(0xFFEA307B),
                    size: 40.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Are you sure?',
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF404040),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Do you really want to exit Collection Qr ?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404040).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {

SystemNavigator.pop();                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          // backgroundColor: const Color(0xFFEA307B),
                          backgroundColor:   deepTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Return true to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF404040),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          // backgroundColor: const Color(0xFFEDEDED),
                          backgroundColor: deepTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
          false;
      return exitApp;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
      ),
    );
  }
}
