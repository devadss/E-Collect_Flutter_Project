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
        centerTitle: true,
        title: Text(
          "Contact Us",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: deepTeal),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: deepTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "If you have any inquiries get in touch with us we'll be happy to help you",
                      style: TextStyle(color: white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: _handlePhoneTap,
                      child: SizedBox(
                        width: double.infinity, // Make the width same as parent
                        child: _buildContactInfo(
                          icon: Icons.phone,
                          text: "7597182222"   , // Replace with your phone number
                        ),
                      )
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _handleEmailTap,
                    child: SizedBox(
                      width: double.infinity, // Make the width same as parent
                      child: _buildContactInfo(
                        icon: Icons.email,
                        text:
                        "cards@transcorpint.com", // Replace with your email
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ListTile(
                    title: Text(
                      "Please refer to the exhaustive Terms & Conditions for Transcorp",
                      style: TextStyle(color: white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _openUrl(
                          "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf");
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "English : ",
                        style: TextStyle(color: white),
                        children: [
                          TextSpan(
                            text:
                            "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _openUrl(
                          "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf");
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Hindi : ",
                        style: TextStyle(color: white),
                        children: [
                          TextSpan(
                            text:
                            "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePhoneTap() {
    const phoneNumber = 'tel:7597182222';
    launch(phoneNumber);
  }

  void _handleEmailTap() {
    const emailAddress = 'mailto:cards@transcorpint.com';
    launch(emailAddress);
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: teal500,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.touch_app,
                    color: Colors.tealAccent), // Add the same icon
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
