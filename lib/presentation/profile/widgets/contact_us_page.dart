
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:flutter/gestures.dart';
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
      body:
      SingleChildScrollView(
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
                fontSize: 12,
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
             // value: "cards@transcorpint.com",
              value: "support@adsslimited.com",
              onTap: _handleEmailTap,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 32),
            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [

                    // const TextSpan(
                    //
                    //   text: "By continuing, you agree to our ",
                    // ),

                    TextSpan(
                      text: "Terms & Conditions",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFEA307B),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (await canLaunchUrl(Uri.parse(terms))) {
                            await launchUrl(Uri.parse(terms));
                          }
                        },
                    ),
                    const TextSpan(text: " | "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFEA307B),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (await canLaunchUrl(Uri.parse(privacy))) {
                            await launchUrl(Uri.parse(privacy));
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
            // Text(
            //   "Terms & Conditions",
            //   style: GoogleFonts.poppins(
            //     color: home1,
            //     fontSize: 18,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: 12),
            // _buildDocumentLink(
            //   title: "English Version",
            //   url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
            // ),
            // const SizedBox(height: 12),
            // _buildDocumentLink(
            //   title: "Hindi Version",
            //   url: "https://transcorpint.com/wp-content/uploads/2023/07/TERMSANDCONDITIONS_with_ATM_Hindi.pdf",
            // ),
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
                backgroundColor: color.withValues(alpha: 0.1),
                radius: 24,
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
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
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      _showErrorSnackBar("Could not launch phone app");
    }
  }

  void _handleEmailTap() async {
    const email = 'mailto:cards@transcorpint.com';
    if (await canLaunchUrl(Uri.parse(email))) {
      await launchUrl(Uri.parse(email));
    } else {
      _showErrorSnackBar("Could not launch email app");
    }
  }

  void _openUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
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
