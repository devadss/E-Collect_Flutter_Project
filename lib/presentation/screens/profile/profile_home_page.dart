import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:collection_qr_flutter/presentation/splash_screen/splash_screen.dart';
import '../../../core/colors.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  String? name = "";
  String? mobNum = "";
  final List<Map<String, dynamic>> profileItems = [
    {"icon": Icons.email, "label": "Email"},
    {"icon": Icons.location_on, "label": "Address"},
    {"icon": Icons.settings, "label": "Settings"},
    {"icon": Icons.lock, "label": "Privacy"},
    {"icon": Icons.logout, "label": "Logout"},
  ];

  @override
  void initState() {
    super.initState();
    loadShredData();
  }

  Future<void> loadShredData() async {
    String username = await SharedPref.shared.getAgentName();
    String usermobNum = await SharedPref.shared.getMobNum();

    if (mounted) {
      setState(() {
        name = username;
        mobNum = usermobNum;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ProfileClipper(),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [deepTeal, yellowGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Opacity(
                    opacity: 0.15, // Adjust for visibility
                    child: Image.asset(
                      "assets/images/doodle.jpeg",
                      fit: BoxFit.cover, // ✅ Ensures it fits the clipped area
                      width: double.infinity,
                      height: 300,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: black, width: 3),
                        color: white,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 60, color: black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name!.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            mobNum!,
            style: const TextStyle(
              fontSize: 16,
              color: black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: profileItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: BuildProfileBox(
                        icon: item["icon"],
                        label: item["label"],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildProfileBox extends StatelessWidget {
  final IconData icon;
  final String label;

  const BuildProfileBox({super.key, required this.icon, required this.label});

  Future showMyDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(20.0),child:
                Column(children: <Widget>[
                  Image.asset(
                    "assets/images/exit.png",
                    scale: 10,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF404040),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Are you sure you want to logout ?",
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
                          SharedPref.shared.setLogin(false);
                          SharedPref.shared.setAgentName("");
                          SharedPref.shared.setFcmToken("");
                          SharedPref.shared.setAgentId("");
                          SharedPref.shared.setPassword("");
                          SharedPref.shared.setMpinValue("");
                          SharedPref.shared.setMpinStatus("");
                          SharedPref.shared.setTokenValue("");
                          SharedPref.shared.setMobNum("");
                          SharedPref.shared.setAgentOriginId("");
                          SharedPref.shared.setCorpCode("");
                          SharedPref.shared.setCardRefNum("");
                          SharedPref.shared.setEmail("");
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                          const SplashScreen()), (route)=> false);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          // backgroundColor: const Color(0xFFEA307B),
                          backgroundColor: white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                              const BorderSide(color: deepTeal, width: 1.5)),
                        ),
                        child: Text(
                          'Yes',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: black),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
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
                ],)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        label == "Logout" ? showMyDialog(context) : null;
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: deepTeal.withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, size: 40, color: white),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    path.lineTo(0, height - 60);
    path.quadraticBezierTo(width * 0.25, height, width * 0.5, height - 50);
    path.quadraticBezierTo(width * 0.75, height - 100, width, height - 60);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
