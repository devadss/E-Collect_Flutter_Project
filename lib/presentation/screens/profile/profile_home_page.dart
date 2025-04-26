import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/colors.dart';
import '../../../data/provider/delete_fcm_provider.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../splash_screen/splash_screen.dart';
import '../home/bottom_nav_bar_page.dart';
import 'contact_us_page.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  String name = "Unknown User";
  String mobNum = "No Number";

  final List<Map<String, dynamic>> profileItems = [
    {"image": "assets/images/telephone_5586610.png", "label": "Contact Us"},
    {"image": "assets/images/logout.png", "label": "Logout"},
  ];

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  Future<void> loadSharedData() async {
    String? username = await SharedPref.shared.getAgentName();
    String? usermobNum = await SharedPref.shared.getMobNum();

    if (mounted) {
      setState(() {
        name = username ?? "Unknown User";
        mobNum = usermobNum ?? "No Number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),
        );
        return true;
      },
      child: Scaffold(
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
                      opacity: 0.15,
                      child: Image.asset(
                        "assets/images/doodle.jpeg",
                        fit: BoxFit.cover,
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
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              mobNum,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: profileItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: BuildProfileBox(
                          image: item["image"],
                          label: item["label"],
                          onTap: () {
                            handleProfileItemClick(context, item["label"]);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleProfileItemClick(BuildContext context, String label) {
    if (label == "Logout") {
      showLogoutDialog(context);
    } else if (label == "Contact Us") {
      // Handle "Contact Us" click
     Navigator.push(context, MaterialPageRoute(builder: (context)=> const ContactUsPage()));
    }
  }

  Future<void> showLogoutDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logout.png",
                  scale: 8,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await performLogout(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: deepTeal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(80, 40),
                    ),
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: deepTeal,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(80, 40),
                    ),
                    child: const Text(
                      "No",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> performLogout(BuildContext context) async {
    String entityId = await SharedPref.shared.getAgentId();
    String token = await SharedPref.shared.getTokenValue();

    final fcmProvider = Provider.of<DeleteFcmProvider>(context, listen: false);
    await fcmProvider.deleteFirebaseToken(entityId, token);

    await SharedPref.shared.setLogin(false);
    await SharedPref.shared.setAgentName("");
    await SharedPref.shared.setFcmToken("");
    await SharedPref.shared.setAgentId("");
    await SharedPref.shared.setPassword("");
    await SharedPref.shared.setMpinValue("");
    await SharedPref.shared.setMpinStatus("");
    await SharedPref.shared.setTokenValue("");
    await SharedPref.shared.setMobNum("");
    await SharedPref.shared.setAgentOriginId("");
    await SharedPref.shared.setCorpCode("");
    await SharedPref.shared.setCardRefNum("");
    await SharedPref.shared.setEmail("");

    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
    );
  }

}

class BuildProfileBox extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const BuildProfileBox({
    super.key,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              Image.asset(image, scale: 20, color: white),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
