import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/colors.dart';
import '../../../core/utils.dart';
import '../../../data/service/notification_service/notification_service.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../app/bottom_nav_bar_page.dart';
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
  String mpin = "";
  String fcmToken = "";
  String contactNum = ""; // contains +91
  String subAgentContactNum = ""; // contains +91
  final LocalAuthentication auth = LocalAuthentication();
  final String sk = "770A8A65DA156D24EE2A093277530142";
  final String iv = "1234567890123456";

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  void loadSharedData() async {
    String custid = await SharedPref.shared.getSubAgentId();
    String tok = await SharedPref.shared.getTokenValue();
    String fcmTok = await SharedPref.shared.getFcmToken();
    String m_pin = await SharedPref.shared.getMpinValue();
    String mobNum = await SharedPref.shared.getParentAgentMobNum();
    String subAgentMobNum = await SharedPref.shared.getSubAgentMobNum();
    setState(() {
      token = tok;
      contactNum = mobNum;
      mpin = m_pin;
      subAgentContactNum =subAgentMobNum;
      custID = custid;
      fcmToken = fcmTok;
    });
   //_openScreenLock();
    _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    // 🔥 RESET AUTH STATE ON EVERY ATTEMPT
    authenticated = false;

    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        if(printStatementStatus ){
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
        if(printStatementStatus ){
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
      if(printStatementStatus ){
        debugPrint('PlatformException during biometric auth: ${e.code} - ${e.message}');
      }

    } catch (e) {
      authenticated = false;
      if(printStatementStatus ){
        debugPrint('Exception during biometric authentication: $e');
      }

    }
  }

  Future<void> validateMpinFingerAuth() async {
    if (!mounted) return; // ✅ very important before using context
    if (fcmToken.isNotEmpty && authenticated == true) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
          BottomNavBar()));
    } else if (fcmToken.isEmpty && authenticated == true) {
      await saveFcmToken(custID, context, "GPIN", token, subAgentContactNum, mpin);
    } else {
      if (!mounted) return; // ✅ re-check before using context again

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white, // Using home2 as background
      appBar: AppBar(
        backgroundColor: white, // Matching background
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Please authenticate to proceed",
          style: GoogleFonts.poppins(
            color: home2, // Using home2 for text
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: home2,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Authenticate to Continue",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: home2.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // Number Pad
                Column(
                  children: [
                    GridView.count(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 1,
                      childAspectRatio: 2.5,
                      padding: EdgeInsets.zero,
                      children: [
                        _buildBiometricButton()
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildBiometricButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: _authenticateWithBiometrics,
       // onTap: _openScreenLock,
        child:const Center(
          child: Icon(
            Icons.fingerprint,
            color: home2,
            size: 100,
          ),
        ),
      ),
    );
  }
}




