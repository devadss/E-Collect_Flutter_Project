import 'package:provider/provider.dart';
import '../../data/provider/delete_fcm_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../presentation/profile/widgets/contact_us_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../splash_screen/splash_screen.dart';


class ProfileData{
  String? userId;
  String? agentCode;
  String? agentName;
  String? mobileNumber;
  String? email;
  String? role;
  String? merchantName;
  String? merchantId;
  String? branchName;
  String? branchCode;
  String? commissionRate;
  String? eCollectFcmToken;
  String? bearerToken;
  bool? isActive;
  bool? isVerified;
  bool? isIntegrated;
  List<String>? enabledProducts;
  ProfileData({required this.userId, required this.agentCode, required this.agentName, required this.mobileNumber,
    required this.email,
    required this.role,
    required this.merchantName,
    required this.merchantId,
    required this.branchName,
    required this.branchCode,
    required this.commissionRate,
    required this.eCollectFcmToken,
    required this.isActive,
    required this.isVerified,
    required this.isIntegrated,
    required this.enabledProducts,
    required this.bearerToken
  });
}
class ProfileHomePage extends StatefulWidget {
  final ProfileData profileData;

  const ProfileHomePage({
    super.key,
    required this.profileData,
  });

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  // ============================================================
  // FINTECH COLORS
  // ============================================================

  static const Color primary = Color(0xFFEA307B);

  static const Color navy = Color(0xFF111827);
  static const Color navySoft = Color(0xFF1F2937);

  static const Color background = Color(0xFFF5F6F8);
  static const Color surface = Colors.white;

  static const Color textDark = Color(0xFF111827);
  static const Color textMedium = Color(0xFF667085);
  static const Color textLight = Color(0xFF98A2B3);

  static const Color border = Color(0xFFE4E7EC);

  static const Color success = Color(0xFF12B76A);
  static const Color blue = Color(0xFF2563EB);
  static const Color purple = Color(0xFF7C3AED);
  static const Color danger = Color(0xFFDC2626);

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  Future<void> showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.50),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =================================================
                  // ICON
                  // =================================================

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: danger.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: danger,
                      size: 24,
                    ),
                  ),

                  const SizedBox(height: 17),

                  // =================================================
                  // TITLE
                  // =================================================

                  Text(
                    "Log out?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: textDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    "Are you sure you want to log out of your account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: textMedium,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // SECURITY INFO
                  // =================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: navySoft,
                          size: 17,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            "Your account remains secure. You'll need to sign in again to continue.",
                            style: GoogleFonts.inter(
                              color: textMedium,
                              fontSize: 10.5,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // BUTTONS
                  // =================================================

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textDark,
                              side: const BorderSide(
                                color: border,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              performLogout(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: danger,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                            child: Text(
                              "Log out",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> performLogout(BuildContext context) async {
    final fcmProvider = Provider.of<DeleteFcmProvider>(
      context,
      listen: false,
    );

    await fcmProvider.deleteFirebaseToken(
      widget.profileData.agentCode!,
      widget.profileData.mobileNumber!,
      widget.profileData.eCollectFcmToken!,
      widget.profileData.bearerToken!,
    );

    await SharedPref.shared.clearAll();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
          (route) => false,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            // =====================================================
            // TOP BAR
            // =====================================================

            SliverToBoxAdapter(
              child: _buildTopBar(),
            ),

            // =====================================================
            // PROFILE IDENTITY
            // =====================================================

            SliverToBoxAdapter(
              child: _buildIdentityCard(),
            ),

            // =====================================================
            // CONTENT
            // =====================================================

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                18,
                22,
                18,
                20,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // =================================================
                    // BUSINESS
                    // =================================================

                    _sectionLabel("BUSINESS"),

                    const SizedBox(height: 9),

                    _buildMerchantCard(),

                    const SizedBox(height: 22),

                    // =================================================
                    // FINANCIAL PROFILE
                    // =================================================

                    _sectionLabel("FINANCIAL PROFILE"),

                    const SizedBox(height: 9),

                    _buildFinancialCard(),

                    const SizedBox(height: 22),

                    // =================================================
                    // SERVICES
                    // =================================================

                    _sectionLabel("ENABLED SERVICES"),

                    const SizedBox(height: 9),

                    _buildServices(),

                    const SizedBox(height: 22),

                    // =================================================
                    // ACCOUNT
                    // =================================================

                    _sectionLabel("ACCOUNT"),

                    const SizedBox(height: 9),

                    _buildAccountCard(),

                    const SizedBox(height: 22),

                    // =================================================
                    // SUPPORT
                    // =================================================

                    _sectionLabel("SUPPORT"),

                    const SizedBox(height: 9),

                    _buildActionCard(
                      icon: Icons.support_agent_rounded,
                      title: "Contact Support",
                      subtitle: "Get help with your account",
                      color: blue,
                      onTap: () {
                        handleProfileItemClick(
                          context,
                          "Contact Us",
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // =================================================
                    // LOGOUT
                    // =================================================

                    _buildActionCard(
                      icon: Icons.logout_rounded,
                      title: "Log out",
                      subtitle: "End your current session",
                      color: danger,
                      onTap: () {
                        handleProfileItemClick(
                          context,
                          "Logout",
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // =================================================
                    // VERSION
                    // =================================================

                    Center(
                      child: Column(
                        children: [
                          Text(
                            "AGENT BANKING",
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: textLight,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Version 1.0.8",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: textLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Profile",
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: textDark,
                letterSpacing: -0.5,
              ),
            ),
          ),

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: border,
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 19,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IDENTITY CARD
  // ============================================================

  Widget _buildIdentityCard() {
    final profile = widget.profileData;

    final bool isActive = profile.isActive == true;
    final bool isVerified = profile.isVerified == true;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =======================================================
            // PROFILE HEADER
            // =======================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // =================================================
                // INITIALS
                // =================================================

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(
                        profile.agentName ?? "",
                      ),
                      style: const TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 13),

                // =================================================
                // NAME + ROLE
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.agentName?.trim().isNotEmpty == true
                            ? profile.agentName!.trim()
                            : "Agent",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.35,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        profile.role?.trim().isNotEmpty == true
                            ? profile.role!.trim().toUpperCase()
                            : "COLLECTION AGENT",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: textLight,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // VERIFIED ICON
                // =================================================

                if (isVerified)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: blue,
                      size: 17,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // =======================================================
            // AGENT INFORMATION
            // =======================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: const Color(0xFFEEF0F3),
                ),
              ),
              child: Row(
                children: [
                  // -----------------------------------------------
                  // AGENT CODE
                  // -----------------------------------------------

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AGENT CODE",
                          style: GoogleFonts.inter(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w700,
                            color: textLight,
                            letterSpacing: 0.7,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          profile.agentCode ?? "—",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // -----------------------------------------------
                  // DIVIDER
                  // -----------------------------------------------

                  Container(
                    width: 1,
                    height: 28,
                    color: border,
                  ),

                  const SizedBox(width: 14),

                  // -----------------------------------------------
                  // AGENT ID
                  // -----------------------------------------------

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AGENT ID",
                          style: GoogleFonts.inter(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w700,
                            color: textLight,
                            letterSpacing: 0.7,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          profile.userId ?? "—",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 13),

            // =======================================================
            // STATUS
            // =======================================================

            Row(
              children: [
                if (isActive)
                  _lightStatusBadge(
                    "ACTIVE",
                    success,
                    Icons.circle,
                  ),

                if (isActive && isVerified)
                  const SizedBox(width: 7),

                if (isVerified)
                  _lightStatusBadge(
                    "VERIFIED",
                    blue,
                    Icons.verified_rounded,
                  ),

                const Spacer(),

                Text(
                  "AGENT PROFILE",
                  style: GoogleFonts.inter(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: textLight,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _lightStatusBadge(
      String label,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 8,
            color: color,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }


/*  Widget _buildIdentityCard() {
    final profile = widget.profileData;

    final bool isActive = profile.isActive == true;
    final bool isVerified = profile.isVerified == true;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        0,
      ),
      decoration: BoxDecoration(
        color: home1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // =======================================================
          // BACKGROUND ACCENT
          // =======================================================

          Positioned(
            right: -35,
            top: -45,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.10),
              ),
            ),
          ),

          Positioned(
            right: 25,
            bottom: -60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.025),
              ),
            ),
          ),

          // =======================================================
          // CONTENT
          // =======================================================

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =================================================
                    // INITIALS
                    // =================================================

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(
                            profile.agentName ?? "",
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 13),

                    // =================================================
                    // NAME
                    // =================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.agentName?.trim().isNotEmpty == true
                                ? profile.agentName!.trim()
                                : "Agent",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            profile.role?.trim().isNotEmpty == true
                                ? profile.role!.trim().toUpperCase()
                                : "COLLECTION AGENT",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ===================================================
                // AGENT CODE
                // ===================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.055),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "AGENT CODE",
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.45),
                          letterSpacing: 0.8,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        profile.agentCode ?? "—",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                // ===================================================
                // STATUS
                // ===================================================

                Row(
                  children: [
                    if (isActive)
                      _darkStatusBadge(
                        "ACTIVE",
                        success,
                        Icons.circle,
                      ),

                    if (isActive && isVerified)
                      const SizedBox(width: 7),

                    if (isVerified)
                      _darkStatusBadge(
                        "VERIFIED",
                        blue,
                        Icons.verified_rounded,
                      ),

                    const Spacer(),

                    Text(
                      "AGENT PROFILE",
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.30),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  // ============================================================
  // DARK STATUS
  // ============================================================

  Widget _darkStatusBadge(
      String label,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 9,
            color: color,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MERCHANT CARD
  // ============================================================

  Widget _buildMerchantCard() {
    final profile = widget.profileData;
    final bool isIntegrated = profile.isIntegrated == true;

    return _fintechCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // =================================================
                // MERCHANT ICON
                // =================================================

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: navy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 20,
                    color: navySoft,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MERCHANT",
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: textLight,
                          letterSpacing: 0.7,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        profile.merchantName ?? "—",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =================================================
                // LIVE STATUS
                // =================================================

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isIntegrated
                        ? success.withValues(alpha: 0.08)
                        : Colors.grey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color:
                          isIntegrated ? success : textLight,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        isIntegrated ? "LIVE" : "OFF",
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color:
                          isIntegrated ? success : textLight,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Divider(
              height: 1,
              color: border,
            ),

            const SizedBox(height: 14),

            // =====================================================
            // MERCHANT DETAILS
            // =====================================================

            Row(
              children: [
                Expanded(
                  child: _miniInfo(
                    "MERCHANT ID",
                    profile.merchantId,
                  ),
                ),

                Container(
                  width: 1,
                  height: 30,
                  color: border,
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: _miniInfo(
                    "INTEGRATION",
                    isIntegrated ? "Active" : "Inactive",
                    valueColor:
                    isIntegrated ? success : textMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FINANCIAL CARD
  // ============================================================

  Widget _buildFinancialCard() {
    final profile = widget.profileData;

    final String commission =
        profile.commissionRate?.toString() ?? "0";

    return _fintechCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ===================================================
            // COMMISSION ICON
            // ===================================================

            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.percent_rounded,
                color: primary,
                size: 21,
              ),
            ),

            const SizedBox(width: 13),

            // ===================================================
            // LABEL
            // ===================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "COLLECTION COMMISSION",
                    style: GoogleFonts.inter(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: textLight,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Commission rate",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: textMedium,
                    ),
                  ),
                ],
              ),
            ),

            // ===================================================
            // RATE
            // ===================================================

            Text(
              "$commission%",
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: primary,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SERVICES
  // ============================================================

  Widget _buildServices() {
    final products =
        widget.profileData.enabledProducts ?? <String>[];

    final List<Widget> services = [];

    if (products.contains("RD")) {
      services.add(
        Expanded(
          child: _serviceCard(
            title: "RD",
            subtitle: "Recurring Deposit",
            icon: Icons.savings_outlined,
            color: blue,
            serviceCount: 4,
          ),
        ),
      );
    }

    if (products.contains("RDCL")) {
      if (services.isNotEmpty) {
        services.add(const SizedBox(width: 10));
      }

      services.add(
        Expanded(
          child: _serviceCard(
            title: "RDCL",
            subtitle: "RD Collection",
            icon: Icons.payments_outlined,
            color: primary,
            serviceCount: 4,
          ),
        ),
      );
    }

    if (products.contains("LOAN")) {
      if (services.isNotEmpty) {
        services.add(const SizedBox(width: 10));
      }

      services.add(
        Expanded(
          child: _serviceCard(
            title: "LOAN",
            subtitle: "Loan Collection",
            icon: Icons.account_balance_wallet_outlined,
            color: purple,
            serviceCount: 4,
          ),
        ),
      );
    }

    if (services.isEmpty) {
      return _emptyServicesCard();
    }

    // Keep the row safe for 2 services.
    // If 3 services exist, make them horizontally scrollable.
    return SizedBox(
      height: 157,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: _buildServiceList(products),
      ),
    );
  }

  // ============================================================
  // SERVICE LIST
  // ============================================================

  List<Widget> _buildServiceList(
      List<String> products,
      ) {
    final List<Widget> result = [];

    if (products.contains("RD")) {
      result.add(
        _serviceCard(
          title: "RD",
          subtitle: "Recurring Deposit",
          icon: Icons.savings_outlined,
          color: blue,
          serviceCount: 4,
        ),
      );
    }

    if (products.contains("RDCL")) {
      if (result.isNotEmpty) {
        result.add(const SizedBox(width: 10));
      }

      result.add(
        _serviceCard(
          title: "RDCL",
          subtitle: "RD Collection",
          icon: Icons.payments_outlined,
          color: primary,
          serviceCount: 4,
        ),
      );
    }

    if (products.contains("LOAN")) {
      if (result.isNotEmpty) {
        result.add(const SizedBox(width: 10));
      }

      result.add(
        _serviceCard(
          title: "LOAN",
          subtitle: "Loan Collection",
          icon: Icons.account_balance_wallet_outlined,
          color: purple,
          serviceCount: 4,
        ),
      );
    }

    return result;
  }

  // ============================================================
  // SERVICE CARD
  // ============================================================

  Widget _serviceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int serviceCount,
  }) {
    return SizedBox(
      width: 155,
      child: _fintechCard(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 19,
                ),
              ),

              const Spacer(),

              // =================================================
              // TITLE
              // =================================================

              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: textLight,
                ),
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  Text(
                    "$serviceCount services",
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY SERVICES
  // ============================================================

  Widget _emptyServicesCard() {
    return _fintechCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.grid_view_rounded,
              color: textLight,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              "No services enabled",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT CARD
  // ============================================================

  Widget _buildAccountCard() {
    final profile = widget.profileData;

    return _fintechCard(
      child: Column(
        children: [
          // =====================================================
          // ACCOUNT HEADER
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              15,
              16,
              13,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: navy.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 18,
                    color: navySoft,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  "Account information",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: border,
          ),

          // =====================================================
          // FIRST ROW
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: _accountInfo(
                    icon: Icons.phone_outlined,
                    label: "Mobile",
                    value: profile.mobileNumber,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _accountInfo(
                    icon: Icons.mail_outline_rounded,
                    label: "Email",
                    value: profile.email,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            indent: 15,
            endIndent: 15,
            color: border,
          ),

          // =====================================================
          // SECOND ROW
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: _accountInfo(
                    icon: Icons.work_outline_rounded,
                    label: "Role",
                    value: profile.role,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _accountInfo(
                    icon: Icons.badge_outlined,
                    label: "Agent ID",
                    value: profile.userId,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            indent: 15,
            endIndent: 15,
            color: border,
          ),

          // =====================================================
          // THIRD ROW
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: _accountInfo(
                    icon: Icons.account_balance_outlined,
                    label: "Branch",
                    value: profile.branchName,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _accountInfo(
                    icon: Icons.tag_rounded,
                    label: "Branch Code",
                    value: profile.branchCode,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            indent: 15,
            endIndent: 15,
            color: border,
          ),

          // =====================================================
          // AGENT CODE
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(15),
            child: _accountInfo(
              icon: Icons.numbers_rounded,
              label: "Agent Code",
              value: profile.agentCode,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT INFO
  // ============================================================

  Widget _accountInfo({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final String displayValue =
    value?.trim().isNotEmpty == true
        ? value!.trim()
        : "—";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 15,
            color: textMedium,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                  color: textLight,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                displayValue,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MINI INFO
  // ============================================================

  Widget _miniInfo(
      String label,
      String? value, {
        Color valueColor = textDark,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            color: textLight,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value?.trim().isNotEmpty == true
              ? value!.trim()
              : "—",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 64,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: border,
            ),
          ),
          child: Row(
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 19,
                ),
              ),

              const SizedBox(width: 11),

              // =================================================
              // TEXT
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // ARROW
              // =================================================

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FINTECH CARD
  // ============================================================

  Widget _fintechCard({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: child,
    );
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: textLight,
        letterSpacing: 1.0,
      ),
    );
  }

  // ============================================================
  // INITIALS
  // ============================================================

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return "U";
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}"
        .toUpperCase();
  }

  // ============================================================
  // PROFILE ACTIONS
  // ============================================================

  void handleProfileItemClick(
      BuildContext context,
      String label,
      ) {
    if (label == "Logout") {
      showLogoutDialog(context);
    } else if (label == "Contact Us") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ContactUsPage(),
        ),
      );
    }
  }
}

/*class ProfileHomePage extends StatefulWidget {
  final ProfileData profileData;
  const ProfileHomePage({super.key, required this.profileData});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary = Color(0xFFEA307B);

  static const Color background = Color(0xFFF7F7F8);

  static const Color textDark = Color(0xFF18181B);

  static const Color textMedium = Color(0xFF52525B);

  static const Color textLight = Color(0xFF8A8A93);

  static const Color border = Color(0xFFE7E7EA);

  static const Color success = Color(0xFF16A34A);

  static const Color blue = Color(0xFF2563EB);

  static const Color purple = Color(0xFF7C3AED);


  Future<void> showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                      size: 25,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Title
                  Text(
                    "Log out?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: home1,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    "Are you sure you want to log out of your account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Security information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE9EBF0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: home1,
                          size: 17,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            "Your account remains secure. You'll need to sign in again to continue.",
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 10.5,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: home1,
                              side: const BorderSide(
                                color: Color(0xFFDDE0E7),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              performLogout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Text(
                              "Log out",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


*//*
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
                                        onTap: ()  {
                                          performLogout(context);
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


  }*//*
  Future<void> performLogout(BuildContext context) async {

    final fcmProvider = Provider.of<DeleteFcmProvider>(
      context,
      listen: false,
    );

    await fcmProvider.deleteFirebaseToken(
      widget.profileData.agentCode!,
      widget.profileData.mobileNumber!,
      widget.profileData.eCollectFcmToken!,
      widget.profileData.bearerToken!
    );

    // Clears ALL SharedPreferences
    await SharedPref.shared.clearAll();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: _buildProfileHeader(),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),

              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // -------------------------------
                  // BUSINESS
                  // -------------------------------

                  _sectionTitle("Business"),

                  const SizedBox(height: 10),

                  _buildMerchantCard(),

                  const SizedBox(height: 25),

                  // -------------------------------
                  // SERVICES
                  // -------------------------------

                  _sectionTitle("Services"),

                  const SizedBox(height: 10),

                  _buildServices(),

                  const SizedBox(height: 25),

                  // -------------------------------
                  // ACCOUNT
                  // -------------------------------

                  _sectionTitle("Account"),

                  const SizedBox(height: 10),

                  _buildAccountCard(),

                  const SizedBox(height: 25),

                  // -------------------------------
                  // BRANCH
                  // -------------------------------

                  _sectionTitle("Branch"),

                  const SizedBox(height: 10),

                  _buildBranchCard(),

                  const SizedBox(height: 25),

                  // -------------------------------
                  // COMMISSION
                  // -------------------------------

                  _sectionTitle("Commission"),

                  const SizedBox(height: 10),

                  _buildCommissionCard(),

                  const SizedBox(height: 28),

                  // -------------------------------
                  // CONTACT
                  // -------------------------------

                  _buildActionCard(
                    icon: Icons.phone_outlined,
                    title: "Contact Us",
                    color: blue,
                    onTap: () {
                      handleProfileItemClick(
                        context,
                        "Contact Us",
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // -------------------------------
                  // LOGOUT
                  // -------------------------------

                  _buildActionCard(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    color: const Color(0xFFDC2626),
                    onTap: () {
                      handleProfileItemClick(
                        context,
                        "Logout",
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      "version 1.0.8",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProfileHeader() {
    final profile = widget.profileData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =====================================================
          // AVATAR
          // =====================================================
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: primary.withValues(alpha: 0.10),
              ),
            ),
            child: Center(
              child: Text(
                _getInitials(profile.agentName ?? ""),
                style: const TextStyle(
                  color: primary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =====================================================
          // NAME
          // =====================================================
          Text(
            profile.agentName?.trim() ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textDark,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 4),

          // =====================================================
          // ROLE + AGENT CODE
          // =====================================================
          Text(
            "${profile.role}  •  Agent ${profile.agentCode}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textMedium,
            ),
          ),

          // =====================================================
          // STATUS
          // =====================================================
          if (profile.isActive == true || profile.isVerified == true) ...[
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (profile.isActive == true)
                  _statusBadge(
                    "Active",
                    success,
                  ),

                if (profile.isActive == true &&
                    profile.isVerified == true)
                  const SizedBox(width: 6),

                if (profile.isVerified == true)
                  _statusBadge(
                    "Verified",
                    blue,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
*//*  Widget _buildProfileHeader() {
    final profile = widget.profileData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // =====================================================
          // AVATAR
          // =====================================================
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                _getInitials(
                  profile.agentName ?? "",
                ),
                style: const TextStyle(
                  color: primary,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // =====================================================
          // NAME
          // =====================================================
          Text(
            profile.agentName?.trim() ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: textDark,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 5),

          // =====================================================
          // ROLE + AGENT CODE
          // =====================================================
          Text(
            "${profile.role}  •  Agent ${profile.agentCode}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textMedium,
            ),
          ),

          const SizedBox(height: 11),

          // =====================================================
          // STATUS
          // =====================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              if (profile.isActive == true)
                _statusBadge(
                  "Active",
                  success,
                ),

              if (profile.isActive == true &&
                  profile.isVerified == true)
                const SizedBox(width: 7),

              if (profile.isVerified == true)
                _statusBadge(
                  "Verified",
                  blue,
                ),
            ],
          ),
        ],
      ),
    );
  }*//*



  // ============================================================
  // MERCHANT
  // ============================================================
  Widget _buildMerchantCard() {
    final profile = widget.profileData;
    final isIntegrated = profile.isIntegrated == true;

    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // =====================================================
            // MERCHANT HEADER
            // =====================================================
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    size: 21,
                    color: primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Merchant",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: textLight,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        profile.merchantName ?? "—",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // =================================================
                // MERCHANT ID
                // =================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Merchant ID",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: textLight,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      profile.merchantId ?? "—",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =====================================================
            // STATUS
            // =====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isIntegrated
                    ? success.withValues(alpha: 0.06)
                    : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: isIntegrated
                      ? success.withValues(alpha: 0.12)
                      : border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isIntegrated ? success : textLight,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "Integration",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textMedium,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    isIntegrated ? "Active" : "Inactive",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isIntegrated ? success : textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
*//*  Widget _buildMerchantCard() {
    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Row(
              children: [

                _iconBox(
                  Icons.storefront_outlined,
                  primary,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Merchant",
                        style: TextStyle(
                          fontSize: 11,
                          color: textLight,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        widget.profileData.merchantName!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [

                    const Text(
                      "Merchant ID",
                      style: TextStyle(
                        fontSize: 10,
                        color: textLight,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      widget.profileData.merchantId!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              height: 1,
              color: border,
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Container(
                  width: 7,
                  height: 7,

                  decoration:
                  const BoxDecoration(
                    color: success,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 7),

                const Text(
                  "Integration Status",
                  style: TextStyle(
                    fontSize: 11,
                    color: success,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Text(
                  widget.profileData.isIntegrated!
                      ? "Active"
                      : "Inactive",

                  style: TextStyle(
                    fontSize: 11,
                    color: widget.profileData.isIntegrated!
                        ? success
                        : textLight,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*//*

  // ============================================================
  // SERVICES
  // ============================================================

  Widget _buildServices() {
    return Row(
      children: [

        if (widget.profileData.enabledProducts!.contains("RD"))
          Expanded(
            child: _serviceCard(
              title: "RD",
              subtitle: "Recurring Deposit",
              icon: Icons.savings_outlined,
              color: blue,
              serviceCount: 4,
            ),
          ),
        if (widget.profileData.enabledProducts!.contains("RDCL"))
          Expanded(
            child: _serviceCard(
              title: "RDCL",
              subtitle: "Rdcl Deposit",
              icon: Icons.savings_outlined,
              color: blue,
              serviceCount: 4,
            ),
          ),

        if (widget.profileData.enabledProducts!.contains("RD") &&
            widget.profileData.enabledProducts!.contains("LOAN"))
          const SizedBox(width: 10),

        if (widget.profileData.enabledProducts!.contains("LOAN"))
          Expanded(
            child: _serviceCard(
              title: "LOAN",
              subtitle: "Loan Collection",
              icon: Icons
                  .account_balance_wallet_outlined,
              color: purple,
              serviceCount: 4,
            ),
          ),
      ],
    );
  }

  Widget _serviceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int serviceCount,
  }) {
    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            _iconBox(
              icon,
              color,
            ),

            const SizedBox(height: 13),

            Text(
              title,

              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 10,
                color: textLight,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [

                Text(
                  "$serviceCount services",
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT
  // ============================================================
  Widget _buildAccountCard() {
    final profile = widget.profileData;

    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                    color: primary,
                  ),
                ),

                const SizedBox(width: 11),

                const Text(
                  "Account Details",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // =====================================================
            // DETAILS
            // =====================================================
            Row(
              children: [
                Expanded(
                  child: _accountDetailItem(
                    icon: Icons.phone_outlined,
                    label: "Mobile",
                    value: profile.mobileNumber,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _accountDetailItem(
                    icon: Icons.mail_outline_rounded,
                    label: "Email",
                    value: profile.email,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _divider(),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _accountDetailItem(
                    icon: Icons.work_outline_rounded,
                    label: "Role",
                    value: profile.role,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _accountDetailItem(
                    icon: Icons.badge_outlined,
                    label: "Agent ID",
                    value: profile.userId,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _divider(),

            const SizedBox(height: 16),

            _accountDetailItem(
              icon: Icons.numbers_rounded,
              label: "Agent Code",
              value: profile.agentCode,
            ),
          ],
        ),
      ),
    );
  }
  Widget _accountDetailItem({
    required IconData icon,
    required String? label,
    required String? value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7F9),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 17,
            color: textMedium,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label ?? "—",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: textLight,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value?.trim().isNotEmpty == true ? value!.trim() : "—",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
*//*  Widget _buildAccountCard() {
    return _baseCard(
      child: Column(
        children: [

          _detailRow(
            Icons.phone_outlined,
            "Mobile",
            widget.profileData.mobileNumber!,
          ),

          _divider(),

          _detailRow(
            Icons.mail_outline_rounded,
            "Email",
            widget.profileData.email!,
          ),

          _divider(),

          _detailRow(
            Icons.work_outline_rounded,
            "Role",
            widget.profileData.role!,
          ),

          _divider(),

          _detailRow(
            Icons.badge_outlined,
            "Agent ID",
            widget.profileData.userId!,
          ),

          _divider(),

          _detailRow(
            Icons.numbers_rounded,
            "Agent Code",
            widget.profileData.agentCode!,
          ),
        ],
      ),
    );
  }*//*

  // ============================================================
  // BRANCH
  // ============================================================

  Widget _buildBranchCard() {
    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [

            _iconBox(
              Icons.account_balance_outlined,
              const Color(0xFF52525B),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Branch",
                    style: TextStyle(
                      fontSize: 10,
                      color: textLight,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.profileData.branchName!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,

              children: [

                const Text(
                  "Code",
                  style: TextStyle(
                    fontSize: 10,
                    color: textLight,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  widget.profileData.branchCode!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMMISSION
  // ============================================================

  Widget _buildCommissionCard() {
    return _baseCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        child: Row(
          children: [

            _iconBox(
              Icons.percent_rounded,
              primary,
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "Collection commission",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                      color: textDark,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    "Commission rate",
                    style: TextStyle(
                      fontSize: 10,
                      color: textLight,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              "${widget.profileData.commissionRate!}%",

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION
  // ============================================================

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,

      borderRadius:
      BorderRadius.circular(17),

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(17),

        child: Container(
          height: 60,

          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),

          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(17),

            border: Border.all(
              color: border,
            ),
          ),

          child: Row(
            children: [

              _iconBox(
                icon,
                color,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON WIDGETS
  // ============================================================

  Widget _baseCard({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: border,
        ),
      ),

      child: child,
    );
  }

  Widget _iconBox(
      IconData icon,
      Color color,
      ) {
    return Container(
      width: 40,
      height: 40,

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.07,
        ),

        borderRadius:
        BorderRadius.circular(11),
      ),

      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // Widget _iconButton({
  //   required IconData icon,
  //   required VoidCallback onTap,
  // })
  // {
  //   return Material(
  //     color: Colors.white,
  //
  //     borderRadius:
  //     BorderRadius.circular(13),
  //
  //     child: InkWell(
  //       onTap: onTap,
  //
  //       borderRadius:
  //       BorderRadius.circular(13),
  //
  //       child: Container(
  //         width: 42,
  //         height: 42,
  //
  //         decoration: BoxDecoration(
  //           borderRadius:
  //           BorderRadius.circular(13),
  //
  //           border: Border.all(
  //             color: border,
  //           ),
  //         ),
  //
  //         child: Icon(
  //           icon,
  //           size: 17,
  //           color: textDark,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _detailRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          _iconBox(
            icon,
            Colors.grey.shade600,
          ),

          const SizedBox(width: 13),

          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: textMedium,
            ),
          ),

          const Spacer(flex: 1,),

          Text(
            value,

            textAlign: TextAlign.right,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w600,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 15,
      color: border,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),

      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        color: textLight,
        letterSpacing: 0.8,
      ),
    );
  }

  // Widget _statusBadge(
  //     String text,
  //     Color color,
  //     ) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 8,
  //       vertical: 4,
  //     ),
  //
  //     decoration: BoxDecoration(
  //       color: color.withValues(
  //         alpha: 0.08,
  //       ),
  //
  //       borderRadius:
  //       BorderRadius.circular(20),
  //     ),
  //
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //
  //       children: [
  //
  //         Container(
  //           width: 5,
  //           height: 5,
  //
  //           decoration: BoxDecoration(
  //             color: color,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //
  //         const SizedBox(width: 5),
  //
  //         Text(
  //           text,
  //
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 10,
  //             fontWeight:
  //             FontWeight.w700,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return "U";
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}"
        .toUpperCase();
  }

  // ============================================================
  // YOUR EXISTING METHODS
  // ============================================================

  void handleProfileItemClick(
      BuildContext context,
      String label,
      ) {
    if (label == "Logout") {
      showLogoutDialog(context);
    } else if (label == "Contact Us") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ContactUsPage(),
        ),
      );
    }
  }

// Keep your existing showLogoutDialog()
// Keep your existing performLogout()
}*/
