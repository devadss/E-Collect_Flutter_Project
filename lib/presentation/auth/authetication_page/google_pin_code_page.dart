import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../../data/service/notification_service/notification_service.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../merchant/bottom_nav/bottom_nav_bar.dart';

class GooglePinCodePage extends StatefulWidget {
  const GooglePinCodePage({super.key});

  @override
  State<GooglePinCodePage> createState() => _GooglePinCodePageState();
}

class _GooglePinCodePageState extends State<GooglePinCodePage> {
  String pin = "";
  String custID = "";
  String token = "";
  bool authenticated = false;
  String fcmToken = "";
  String contactNum = ""; // contains +91
  final LocalAuthentication auth = LocalAuthentication();


  @override
  void initState() {
    super.initState();

    loadSharedData();
  }

  void loadSharedData() async {
    final result = await Future.wait([
      SharedPref.shared.getECollectMerchantID(),
      SharedPref.shared.getTokenValue(),
      SharedPref.shared.getFcmToken(),
      SharedPref.shared.getMpinValue(),
      SharedPref.shared.getECollectUserNumber(),
     ]);
    custID = result[0];
    token = result[1];
    fcmToken = result[2];
    contactNum = result[4];


    if(fcmToken.isEmpty){
      print("Saving fcm");
      if(!mounted) return;
      await saveFcmToken(custID, context, "GPIN", fcmToken, contactNum, "");

    }
    _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    // 🔥 RESET AUTH STATE ON EVERY ATTEMPT
    authenticated = false;

    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        if (printStatementStatus) {
          debugPrint('No biometric or device auth support');
        }

        return;
      }

      final bool result = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: false,
        ),
      );

      // ❌ STOP immediately if widget disposed or auth failed
      if (!mounted || result != true) {
        if (printStatementStatus) {
          debugPrint('Authentication canceled or failed');
        }

        return;
      }

      // ✅ AUTH SUCCEEDED (fresh)
      authenticated = true;

      await validateMpinFingerAuth();
    } on PlatformException catch (e) {
      // ❌ NEVER allow navigation on exception
      authenticated = false;
      if (printStatementStatus) {
        debugPrint(
            'PlatformException during biometric auth: ${e.code} - ${e.message}');
      }
    } catch (e) {
      authenticated = false;
      if (printStatementStatus) {
        debugPrint('Exception during biometric authentication: $e');
      }
    }
  }

  Future<void> validateMpinFingerAuth() async {
    if (!mounted) return; // ✅ very important before using context
    if (fcmToken.isNotEmpty && authenticated == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
    } else if (fcmToken.isEmpty && authenticated == true) {
      //  await saveFcmToken(custID, context, "GPIN", fcmToken, subAgentContactNum, mpin);
    } else {
      if (!mounted) return; // ✅ re-check before using context again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  // Container(
                  //   width: 44,
                  //   height: 44,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(14),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withValues(alpha: 0.05),
                  //         blurRadius: 15,
                  //         offset: const Offset(0, 5),
                  //       ),
                  //     ],
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () => Navigator.of(context).pop(),
                  //     icon: const Icon(
                  //       Icons.arrow_back_ios_new_rounded,
                  //       size: 19,
                  //       color: home2,
                  //     ),
                  //   ),
                  // ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    "Security",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: home2,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 45),

                    // Top Security Icon
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: home1.withValues(alpha: 0.08),
                      ),
                      child: Center(
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: home1.withValues(alpha: 0.12),
                          ),
                          child: const Icon(
                            Icons.shield_moon,
                            size: 34,
                            color: home1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      "Authenticate to Continue",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171A21),
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Verify your identity using your device's\nbiometric authentication.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.6,
                        color: const Color(0xFF777D89),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // Authentication Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.055),
                            blurRadius: 30,
                            spreadRadius: 1,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Secure Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF252933),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Tap below to authenticate",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF8A8F9A),
                            ),
                          ),

                          const SizedBox(height: 30),

                          _buildBiometricButton(),

                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FC),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 16,
                                  color: home1.withValues(alpha: 0.8),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Your biometric data stays on your device",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      color: const Color(0xFF747A86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Bottom hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Use fingerprint, face unlock or device PIN",
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: const Color(0xFF8B919C),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _authenticateWithBiometrics,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: home1.withValues(alpha: 0.08),
            border: Border.all(
              color: home1.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: home1,
                boxShadow: [
                  BoxShadow(
                    color: home1.withValues(alpha: 0.28),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
