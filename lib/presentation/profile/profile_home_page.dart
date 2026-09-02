import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../data/provider/delete_fcm_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../presentation/profile/widgets/contact_us_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
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


  }
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
                      "version 1.0.4",
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
  Widget _statusBadge(
      String text,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
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
  }


/*
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        28,
      ),

      child: Row(
        children: [

          // -------------------------------
          // AVATAR
          // -------------------------------

          Container(
            width: 66,
            height: 66,

            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F1),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Center(
              child: Text(
                _getInitials(widget.profileData.agentName!),

                style: const TextStyle(
                  color: primary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // -------------------------------
          // USER INFO
          // -------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  widget.profileData.agentName!,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${widget.profileData.role}  •  Agent ${widget.profileData.agentCode}",

                  style: const TextStyle(
                    fontSize: 12,
                    color: textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [

                    if (widget.profileData.isActive!)
                      _statusBadge(
                        "Active",
                        success,
                      ),

                    if (widget.profileData.isActive! && widget.profileData.isVerified!)
                      const SizedBox(width: 6),

                    if (widget.profileData.isVerified!)
                      _statusBadge(
                        "Verified",
                        blue,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/

  // ============================================================
  // MERCHANT
  // ============================================================

  Widget _buildMerchantCard() {
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
  }

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
  }

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
}
// class ProfileHomePage extends StatefulWidget {
//   final String eCollectMerchantName;
//   final String eCollectMerchantID;
//   final String eCollectFcmToken;
//   final String eCollectMerchantNumber;
//   const ProfileHomePage({super.key, required this.eCollectMerchantName, required this.eCollectMerchantNumber, required this.eCollectMerchantID, required this.eCollectFcmToken});
//
//   @override
//   State<ProfileHomePage> createState() => _ProfileHomePageState();
// }
//
// class _ProfileHomePageState extends State<ProfileHomePage> {
//
//   final List<Map<String, dynamic>> profileItems = [
//     {
//       "image": "assets/images/telephone_5586610.png",
//       "label": "Contact Us",
//       "color": home1,
//       "icon": Icons.phone,
//     },
//     {
//       "image": "assets/images/logout.png",
//       "label": "Logout",
//       "color": Colors.redAccent,
//       "icon": Icons.logout,
//     },
//   ];
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w700,
//         color: Colors.grey.shade600,
//         letterSpacing: 0.2,
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Top bar
//           Center(
//             child: Text(
//               "Profile",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: home1,
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 42),
//
//           const SizedBox(height: 30),
//
//           // Avatar
//           Container(
//             width: 82,
//             height: 82,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFFEA307B),
//                   Color(0xFF9B51E0),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFEA307B).withValues(alpha: 0.18),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 widget.eCollectMerchantName.isNotEmpty
//                     ? widget.eCollectMerchantName[0].toUpperCase()
//                     : "U",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           Text(
//             widget.eCollectMerchantName,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style:  TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF171717),
//               letterSpacing: -0.5,
//             ),
//           ),
//
//           const SizedBox(height: 7),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.phone_outlined,
//                 size: 15,
//                 color: Colors.grey.shade500,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 widget.eCollectMerchantNumber,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 18),
//
//           // Merchant ID
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 7,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF6F6F7),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               "Merchant ID  •  ${widget.eCollectMerchantID}",
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildProfileAction({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//     bool showArrow = true,
//   }) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(18),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(18),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: Colors.black.withValues(alpha: 0.05),
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 46,
//                 height: 46,
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.09),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 22,
//                 ),
//               ),
//
//               const SizedBox(width: 14),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF202020),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 11.5,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               if (showArrow)
//                 Icon(
//                   Icons.chevron_right_rounded,
//                   color: Colors.grey.shade400,
//                   size: 23,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F8),
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverToBoxAdapter(
//               child: _buildProfileHeader(),
//             ),
//
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   _buildSectionTitle("Account"),
//
//                   const SizedBox(height: 10),
//
//                   _buildProfileAction(
//                     icon: Icons.phone_outlined,
//                     title: "Contact Us",
//                     subtitle: "Get help or reach our support team",
//                     color: const Color(0xFF2563EB),
//                     onTap: () => handleProfileItemClick(
//                       context,
//                       "Contact Us",
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   _buildProfileAction(
//                     icon: Icons.logout_rounded,
//                     title: "Logout",
//                     subtitle: "Sign out from this account",
//                     color: const Color(0xFFDC2626),
//                     onTap: () => handleProfileItemClick(
//                       context,
//                       "Logout",
//                     ),
//                     showArrow: false,
//                   ),
//
//                   const SizedBox(height: 28),
//
//                   Center(
//                     child: Text(
//                       "eCollect",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey.shade400,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Custom animated profile card widget
//   // Widget animatedProfileCard({
//   //   required int index,
//   //   required String image,
//   //   required String label,
//   //   required Color color,
//   //   required IconData icon,
//   //   required VoidCallback onTap,
//   // }) {
//   //   return TweenAnimationBuilder(
//   //     duration: Duration(milliseconds: 500 + (index * 200)),
//   //     tween: Tween<double>(begin: 0, end: 1),
//   //     curve: Curves.easeOutCubic,
//   //     builder: (context, value, child) {
//   //       return Opacity(
//   //         opacity: value,
//   //         child: Transform.translate(
//   //           offset: Offset((1 - value) * 50, 0),
//   //           child: Transform.scale(
//   //             scale: 0.95 + (value * 0.05),
//   //             child: child,
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //     child: Card(
//   //       elevation: 0,
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(20),
//   //       ),
//   //       shadowColor: color.withValues(alpha: 0.2),
//   //       color: Colors.white,
//   //       child: InkWell(
//   //         borderRadius: BorderRadius.circular(20),
//   //         onTap: onTap,
//   //         splashColor: color.withValues(alpha: 0.15),
//   //         highlightColor: color.withValues(alpha: 0.05),
//   //         child: Container(
//   //           decoration: BoxDecoration(
//   //             borderRadius: BorderRadius.circular(20),
//   //             boxShadow: [
//   //               BoxShadow(
//   //                 color: Colors.black.withValues(alpha: 0.04),
//   //                 blurRadius: 10,
//   //                 offset: const Offset(0, 4),
//   //               ),
//   //             ],
//   //           ),
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(16),
//   //             child: Row(
//   //               children: [
//   //                 // Modern icon container with gradient
//   //                 Container(
//   //                   width: 56,
//   //                   height: 56,
//   //                   decoration: BoxDecoration(
//   //                     gradient: LinearGradient(
//   //                       begin: Alignment.topLeft,
//   //                       end: Alignment.bottomRight,
//   //                       colors: [
//   //                         color.withValues(alpha: 0.2),
//   //                         color.withValues(alpha: 0.1),
//   //                       ],
//   //                     ),
//   //                     borderRadius: BorderRadius.circular(18),
//   //                     boxShadow: [
//   //                       BoxShadow(
//   //                         color: color.withValues(alpha: 0.2),
//   //                         blurRadius: 8,
//   //                         offset: const Offset(0, 2),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   child: Center(
//   //                     child: Icon(
//   //                       icon,
//   //                       color: color,
//   //                       size: 28,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(width: 18),
//   //
//   //                 // Text content with modern styling
//   //                 Expanded(
//   //                   child: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text(
//   //                         label,
//   //                         style: GoogleFonts.inter(
//   //                           fontSize: 17,
//   //                           fontWeight: FontWeight.w600,
//   //                           color: Colors.grey[800],
//   //                           letterSpacing: -0.3,
//   //                         ),
//   //                       ),
//   //                       const SizedBox(height: 4),
//   //                     ],
//   //                   ),
//   //                 ),
//   //
//   //                 // Modern chevron with animation
//   //                 AnimatedContainer(
//   //                   duration: const Duration(milliseconds: 200),
//   //                   transform: Matrix4.identity()..rotateZ(0),
//   //                   child: Container(
//   //                     width: 32,
//   //                     height: 32,
//   //                     decoration: BoxDecoration(
//   //                       color: color.withValues(alpha: 0.1),
//   //                       borderRadius: BorderRadius.circular(10),
//   //                     ),
//   //                     child: Icon(
//   //                       Icons.arrow_forward_ios_rounded,
//   //                       color: color,
//   //                       size: 16,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // Enhanced logout dialog


//   void handleProfileItemClick(BuildContext context, String label) {
//     if (label == "Logout") {
//       showLogoutDialog(context);
//     } else if (label == "Contact Us") {
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               const ContactUsPage(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(1, 0),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 300),
//         ),
//       );
//     }
//   }
//
//
// }
