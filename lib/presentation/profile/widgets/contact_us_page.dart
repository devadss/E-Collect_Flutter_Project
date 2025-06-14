// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../core/colors.dart';
//
//
// class ContactUsPage extends StatefulWidget {
//   const ContactUsPage({super.key});
//
//   @override
//   State<ContactUsPage> createState() => _ContactUsPageState();
// }
//
// class _ContactUsPageState extends State<ContactUsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         centerTitle: true,
//         title: Text(
//           "Contact Us",
//           style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: deepTeal),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.white,
//           ),
//           Positioned(
//             top: 50,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: deepTeal,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const ListTile(
//                     title: Text(
//                       "If you have any inquiries get in touch with us we'll be happy to help you",
//                       style: TextStyle(color: white),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                       onTap: _handlePhoneTap,
//                       child: SizedBox(
//                         width: double.infinity, // Make the width same as parent
//                         child: _buildContactInfo(
//                           icon: Icons.phone,
//                           text: "7597182222"   , // Replace with your phone number
//                         ),
//                       )
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: _handleEmailTap,
//                     child: SizedBox(
//                       width: double.infinity, // Make the width same as parent
//                       child: _buildContactInfo(
//                         icon: Icons.email,
//                         text:
//                         "cards@transcorpint.com", // Replace with your email
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const ListTile(
//                     title: Text(
//                       "Please refer to the exhaustive Terms & Conditions for Transcorp",
//                       style: TextStyle(color: white),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       _openUrl(
//                           "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf");
//                     },
//                     child: RichText(
//                       text: const TextSpan(
//                         text: "English : ",
//                         style: TextStyle(color: white),
//                         children: [
//                           TextSpan(
//                             text:
//                             "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       _openUrl(
//                           "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf");
//                     },
//                     child: RichText(
//                       text: const TextSpan(
//                         text: "Hindi : ",
//                         style: TextStyle(color: white),
//                         children: [
//                           TextSpan(
//                             text:
//                             "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handlePhoneTap() {
//     const phoneNumber = 'tel:7597182222';
//     launch(phoneNumber);
//   }
//
//   void _handleEmailTap() {
//     const emailAddress = 'mailto:cards@transcorpint.com';
//     launch(emailAddress);
//   }
//
//   Widget _buildContactInfo({required IconData icon, required String text}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       decoration: BoxDecoration(
//         color: teal500,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     text,
//                     style: const TextStyle(color: Colors.black, fontSize: 16),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const Icon(Icons.touch_app,
//                     color: Colors.tealAccent), // Add the same icon
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _openUrl(String url) async {
//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       print('Error launching URL: $e');
//     }
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../core/colors.dart';
//
// class ContactUsPage extends StatefulWidget {
//   const ContactUsPage({super.key});
//
//   @override
//   State<ContactUsPage> createState() => _ContactUsPageState();
// }
//
// class _ContactUsPageState extends State<ContactUsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: home1),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Contact Us",
//           style: GoogleFonts.poppins(
//             color: home1,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "We're here to help",
//               style: GoogleFonts.poppins(
//                 color: home1,
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Get in touch with our support team for any inquiries",
//               style: GoogleFonts.poppins(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             // Contact Cards
//             _buildContactCard(
//               icon: Icons.phone,
//               title: "Call Us",
//               subtitle: "Available 9AM - 6PM, Monday to Friday",
//               value: "7597182222",
//               onTap: _handlePhoneTap,
//               color: Colors.blueAccent,
//             ),
//             const SizedBox(height: 16),
//             _buildContactCard(
//               icon: Icons.email,
//               title: "Email Us",
//               subtitle: "We typically reply within 24 hours",
//               value: "cards@transcorpint.com",
//               onTap: _handleEmailTap,
//               color: Colors.redAccent,
//             ),
//             const SizedBox(height: 32),
//
//             // Terms & Conditions Section
//             Text(
//               "Terms & Conditions",
//               style: GoogleFonts.poppins(
//                 color: home1,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 12),
//             _buildDocumentLink(
//               title: "English Version",
//               url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
//             ),
//             const SizedBox(height: 12),
//             _buildDocumentLink(
//               title: "Hindi Version",
//               url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContactCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required String value,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Card(
//       elevation: 9,
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
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: GoogleFonts.poppins(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Text(
//                     value,
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Tap to contact",
//                       style: GoogleFonts.poppins(
//                         color: color,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDocumentLink({required String title, required String url}) {
//     return Card(
//       elevation: 0,
//       color: Colors.grey[100],
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: () => _openUrl(url),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.description,
//                 color: home1,
//                 size: 24,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey[500],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handlePhoneTap() async {
//     const phoneNumber = 'tel:7597182222';
//     if (await canLaunch(phoneNumber)) {
//       await launch(phoneNumber);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not launch phone app")),
//       );
//     }
//   }
//
//   void _handleEmailTap() async {
//     const emailAddress = 'mailto:cards@transcorpint.com';
//     if (await canLaunch(emailAddress)) {
//       await launch(emailAddress);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not launch email app")),
//       );
//     }
//   }
//
//   void _openUrl(String url) async {
//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error opening link: ${e.toString()}")),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/colors.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: home1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Contact Us",
          style: GoogleFonts.poppins(
            color: home1,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We're here to help",
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Reach out to our support team with your inquiries.",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            _buildContactCard(
              icon: Icons.phone,
              title: "Call Us",
              subtitle: "9AM – 6PM, Mon to Fri",
              value: "7597182222",
              onTap: _handlePhoneTap,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.email,
              title: "Email Us",
              subtitle: "Reply within 24 hours",
              value: "cards@transcorpint.com",
              onTap: _handleEmailTap,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 32),
            Text(
              "Terms & Conditions",
              style: GoogleFonts.poppins(
                color: home1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildDocumentLink(
              title: "English Version",
              url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
            ),
            const SizedBox(height: 12),
            _buildDocumentLink(
              title: "Hindi Version",
              url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 24,
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Tap to contact",
                      style: GoogleFonts.poppins(
                        color: color,
                        fontSize: 10,
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
  }

  Widget _buildDocumentLink({required String title, required String url}) {
    return Card(
      elevation: 1,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openUrl(url),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.description, color: home1, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePhoneTap() async {
    const phoneNumber = 'tel:7597182222';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      _showErrorSnackBar("Could not launch phone app");
    }
  }

  void _handleEmailTap() async {
    const email = 'mailto:cards@transcorpint.com';
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      _showErrorSnackBar("Could not launch email app");
    }
  }

  void _openUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      _showErrorSnackBar("Error opening link: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
