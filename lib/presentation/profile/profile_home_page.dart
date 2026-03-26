import 'package:lottie/lottie.dart';
import '../../presentation/profile/widgets/contact_us_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../data/provider/delete_fcm_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../splash_screen/splash_screen.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  String name = "Unknown User";
  String mobNum = "No Number";

  final List<Map<String, dynamic>> profileItems = [
    {
      "image": "assets/images/telephone_5586610.png",
      "label": "Contact Us",
      "color": home1,
      "icon": Icons.phone,
    },
    {
      "image": "assets/images/logout.png",
      "label": "Logout",
      "color": Colors.redAccent,
      "icon": Icons.logout,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  Future<void> loadSharedData() async {
    String? username = await SharedPref.shared.getSubAgentName();
    String? usermobNum = await SharedPref.shared.getSubAgentMobNum();

    if (mounted) {
      setState(() {
        name = username ?? "Unknown User";
        mobNum = usermobNum ?? "No Number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Enhanced Header Section
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [home1, home2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: home1.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative elements
                const Positioned(
                  top: 20,
                  right: 20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.account_circle, size: 120, color: white),
                  ),
                ),
                const Positioned(
                  bottom: 30,
                  left: 20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.verified_user, size: 100, color: white),
                  ),
                ),

                // Profile content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated profile avatar
                      Hero(
                        tag: 'profile-avatar',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Material(
                              color: home2.withOpacity(0.2),
                              child: const Icon(Icons.person, size: 60, color: white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name with animation
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 20),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            color: white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Phone number with animation
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 700),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 20),
                              child: child,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, color: white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              mobNum,
                              style: GoogleFonts.poppins(
                                color: white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Profile Options List with animated cards
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: profileItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = profileItems[index];
                return AnimatedProfileCard(
                  index: index,
                  image: item["image"],
                  label: item["label"],
                  color: item["color"],
                  icon: item["icon"],
                  onTap: () => handleProfileItemClick(context, item["label"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Custom animated profile card widget
  Widget AnimatedProfileCard({
    required int index,
    required String image,
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + (index * 200)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 50, 0),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: color.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced logout dialog
  Future<void> showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset("assets/animations/logout.json"),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Logout Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: home1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            color: home1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Logout button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await performLogout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }

  void handleProfileItemClick(BuildContext context, String label) {
    if (label == "Logout") {
      showLogoutDialog(context);
    } else if (label == "Contact Us") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const ContactUsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }
  Future<void> performLogout(BuildContext context) async {
    String entityId = await SharedPref.shared.getSubAgentId();
    String token = await SharedPref.shared.getTokenValue();

    final fcmProvider = Provider.of<DeleteFcmProvider>(context, listen: false);
    await fcmProvider.deleteFirebaseToken(entityId, token);

    await SharedPref.shared.setLogin(false);
    await SharedPref.shared.setCustId("");
    await SharedPref.shared.setAgentName("");
    await SharedPref.shared.setParentAgentName("");
    await SharedPref.shared.setParentAgentPassword("");
    await SharedPref.shared.setParentAgentMobNum("");
    await SharedPref.shared.setSubAgentId("");
    await SharedPref.shared.setSubAgentCode("");
    await SharedPref.shared.setUserType("");
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


}
