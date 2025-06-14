// import '../../presentation/profile/widgets/contact_us_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../core/colors.dart';
// import '../../data/provider/delete_fcm_provider.dart';
// import '../../data/storage/shared_pref_helper.dart';
// import '../app/bottom_nav_bar_page.dart';
// import '../splash_screen/splash_screen.dart';
//
// class ProfileHomePage extends StatefulWidget {
//   const ProfileHomePage({super.key});
//
//   @override
//   State<ProfileHomePage> createState() => _ProfileHomePageState();
// }
//
// class _ProfileHomePageState extends State<ProfileHomePage> {
//   String name = "Unknown User";
//   String mobNum = "No Number";
//
//   final List<Map<String, dynamic>> profileItems = [
//     {"image": "assets/images/telephone_5586610.png", "label": "Contact Us","color" : white},
//     {"image": "assets/images/logout.png", "label": "Logout","color" : white},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     loadSharedData();
//   }
//
//   Future<void> loadSharedData() async {
//     String? username = await SharedPref.shared.getAgentName();
//     String? usermobNum = await SharedPref.shared.getMobNum();
//
//     if (mounted) {
//       setState(() {
//         name = username ?? "Unknown User";
//         mobNum = usermobNum ?? "No Number";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       body: Column(
//         children: [
//           // Header Section with Profile Picture
//           Container(
//             height: 280,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [home1, home2.withOpacity(0.8)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   bottom: -30,
//                   right: -30,
//                   child: Opacity(
//                     opacity: 0.1,
//                     child: Icon(
//                       Icons.account_circle,
//                       size: 200,
//                       color: home2,
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: home2, width: 3),
//                           color: white,
//                         ),
//                         child: Icon(
//                           Icons.person,
//                           size: 50,
//                           color: home2,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         name,
//                         style: GoogleFonts.poppins(
//                           color: white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         mobNum,
//                         style: GoogleFonts.poppins(
//                           color: white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 40),
//
//           // Profile Options List
//           Expanded(
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               itemCount: profileItems.length,
//               separatorBuilder: (context, index) => const SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 final item = profileItems[index];
//                 return _buildProfileOption(
//                   image: item["image"],
//                   label: item["label"],
//                   color: item["color"],
//                   onTap: () => handleProfileItemClick(context, item["label"]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileOption({
//     required String image,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Image.asset(image)
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey[400],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> showLogoutDialog(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.logout,
//                   size: 48,
//                   color: Colors.redAccent,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Logout Confirmation",
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Are you sure you want to logout?",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           side: BorderSide(color: home1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: GoogleFonts.poppins(
//                             color: home1,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           Navigator.pop(context);
//                           await performLogout(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: home1,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           "Logout",
//                           style: GoogleFonts.poppins(
//                             color: home2,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void handleProfileItemClick(BuildContext context, String label) {
//     if (label == "Logout") {
//       showLogoutDialog(context);
//     } else if (label == "Contact Us") {
//       // Handle "Contact Us" click
//      Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactUsPage()));
//     }
//   }
//
//
//   Future<void> performLogout(BuildContext context) async {
//     String entityId = await SharedPref.shared.getAgentId();
//     String token = await SharedPref.shared.getTokenValue();
//
//     final fcmProvider = Provider.of<DeleteFcmProvider>(context, listen: false);
//     await fcmProvider.deleteFirebaseToken(entityId, token);
//
//     await SharedPref.shared.setLogin(false);
//     await SharedPref.shared.setAgentName("");
//     await SharedPref.shared.setFcmToken("");
//     await SharedPref.shared.setAgentId("");
//     await SharedPref.shared.setPassword("");
//     await SharedPref.shared.setMpinValue("");
//     await SharedPref.shared.setMpinStatus("");
//     await SharedPref.shared.setTokenValue("");
//     await SharedPref.shared.setMobNum("");
//     await SharedPref.shared.setAgentOriginId("");
//     await SharedPref.shared.setCorpCode("");
//     await SharedPref.shared.setCardRefNum("");
//     await SharedPref.shared.setEmail("");
//
//     Navigator.pop(context);
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const SplashScreen()),
//           (route) => false,
//     );
//   }
//
// }
//
// class BuildProfileBox extends StatelessWidget {
//   final String image;
//   final String label;
//   final VoidCallback onTap;
//
//   const BuildProfileBox({
//     super.key,
//     required this.image,
//     required this.label,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: deepTeal.withOpacity(0.5),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: [
//               Image.asset(image, scale: 20, color: white),
//               const SizedBox(width: 10),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                   color: white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProfileClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     double width = size.width;
//     double height = size.height;
//
//     path.lineTo(0, height - 60);
//     path.quadraticBezierTo(width * 0.25, height, width * 0.5, height - 50);
//     path.quadraticBezierTo(width * 0.75, height - 100, width, height - 60);
//     path.lineTo(width, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// Widget build(BuildContext context) {
//   return WillPopScope(
//     onWillPop: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const BottomNavScreen()),
//       );
//       return true;
//     },
//     child: Scaffold(
//       backgroundColor: white,
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               ClipPath(
//                 clipper: ProfileClipper(),
//                 child: Container(
//                   height: 300,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [deepTeal, yellowGreen],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Opacity(
//                     opacity: 0.15,
//                     child: Image.asset(
//                       "assets/images/doodle.jpeg",
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       height: 300,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 200,
//                 left: 0,
//                 right: 0,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: black, width: 3),
//                         color: white,
//                       ),
//                       child: const Center(
//                         child: Icon(Icons.person, size: 60, color: black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             name,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w800,
//               color: black,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             mobNum,
//             style: const TextStyle(
//               fontSize: 16,
//               color: black,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: profileItems.map((item) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: BuildProfileBox(
//                         image: item["image"],
//                         label: item["label"],
//                         onTap: () {
//                           handleProfileItemClick(context, item["label"]);
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//

//
// Future<void> showLogoutDialog(BuildContext context) {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text(
//           "Logout",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//               child: Image.asset(
//                 "assets/images/log-out.png",
//                 scale: 8,
//               ),
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               "Are you sure you want to logout?",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 OutlinedButton(
//                   onPressed: () async {
//                     await performLogout(context);
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: deepTeal),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     minimumSize: const Size(80, 40),
//                   ),
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: deepTeal,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: deepTeal,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     minimumSize: const Size(80, 40),
//                   ),
//                   child: const Text(
//                     "No",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     },
//   );
// }

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
                          Navigator.pop(context);
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

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
    );
  }

}


// await SharedPref.shared.setLogin(false);
// await SharedPref.shared.setAgentName("");
// await SharedPref.shared.setFcmToken("");
// await SharedPref.shared.setAgentId("");
// await SharedPref.shared.setPassword("");
// await SharedPref.shared.setMpinValue("");
// await SharedPref.shared.setMpinStatus("");
// await SharedPref.shared.setTokenValue("");
// await SharedPref.shared.setMobNum("");
// await SharedPref.shared.setAgentOriginId("");
// await SharedPref.shared.setCorpCode("");
// await SharedPref.shared.setCardRefNum("");
// await SharedPref.shared.setEmail("");

// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => const SplashScreen()),
//       (route) => false,
// );