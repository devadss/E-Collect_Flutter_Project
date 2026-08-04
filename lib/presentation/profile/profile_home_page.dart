import 'dart:ui';

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
    String? username = await SharedPref.shared.getECollectMerchantName();
    String? usermobNum = await SharedPref.shared.getECollectUserNumber();

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
                  color: home1.withValues(alpha: 0.3),
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
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Material(
                              color: home2.withValues(alpha: 0.2),
                              child: const Icon(Icons.person,
                                  size: 60, color: white),
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
                return animatedProfileCard(
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
  Widget animatedProfileCard({
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
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 50, 0),
            child: Transform.scale(
              scale: 0.95 + (value * 0.05),
              child: child,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: color.withValues(alpha: 0.2),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: color.withValues(alpha: 0.15),
          highlightColor: color.withValues(alpha: 0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Modern icon container with gradient
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: 0.2),
                          color.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),

                  // Text content with modern styling
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),

                  // Modern chevron with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..rotateZ(0),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: color,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
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
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Modern gradient header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.redAccent.withValues(alpha: 0.1),
                                Colors.redAccent.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              // Animated icon with modern design
                              TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 500),
                                tween: Tween<double>(begin: 0, end: 1),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                      scale: value, child: child);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.redAccent,
                                        Colors.redAccent.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.redAccent
                                            .withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Lottie.asset(
                                    "assets/animations/logout.json",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Ready to Leave?",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        Colors.redAccent,
                                        Colors.redAccent.shade700,
                                      ],
                                    ).createShader(
                                        Rect.fromLTWH(0, 0, 200, 50)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "You'll need to sign in again to access your account",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),

                              // Modern buttons
                              Row(
                                children: [
                                  // Cancel button
                                  Expanded(
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            "Cancel",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Logout button with modern gradient
                                  Expanded(
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        onTap: () async {
                                          await performLogout(context);
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Colors.redAccent,
                                                Colors.redAccent.shade700,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.redAccent
                                                    .withValues(alpha: 0.4),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "Logout",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Additional subtle hint
                              Text(
                                "Session will be terminated immediately",
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ContactUsPage(),
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

    await SharedPref.shared.setECollectLoginStatus(false);
    await SharedPref.shared.setECollectMerchantBranchCode('');
    await SharedPref.shared.setECollectMerchantIntegrationStatus('');
    await SharedPref.shared.setECollectRdclCustomerunderAgentListUrl('');
    await SharedPref.shared.setECollectRdclDuesListunderAgentUrl('');
    await SharedPref.shared.setECollectMerchantUserName('');
    await SharedPref.shared.setECollectUserType('');
    await SharedPref.shared.setECollectToken('');
    await SharedPref.shared.setECollectRefreshToken('');
    await SharedPref.shared.setECollectRefreshToken('');
    await SharedPref.shared.setECollectUserNumber('');
    await SharedPref.shared.setECollectMerchantID('');
    await SharedPref.shared.setECollectUserID('');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }
}
