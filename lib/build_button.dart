import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';

class BuildButton extends StatelessWidget {
  final String buttonText;
  const BuildButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [deepTeal, yellowGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
            buttonText,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: white
          ),
        ),
      ),
    );
  }
}
