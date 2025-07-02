import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  home1,
                  home2,
                  Colors.white,
                ],
                stops: [0.1, 0.5, 0.9],
              ),
            ),
          ),

          // Floating QR Code Particles
          Positioned(
            top: 50,
            left: 30,
            child: _FloatingParticle(
              color: home1.withOpacity(0.3),
              size: 40,
              delay: 0,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 40,
            child: _FloatingParticle(
              color: home2.withOpacity(0.3),
              size: 60,
              delay: 0.5,
            ),
          ),
          Positioned(
            top: 150,
            right: 70,
            child: _FloatingParticle(
              color: home2.withOpacity(0.2),
              size: 30,
              delay: 1,
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated QR Code SVG
                Hero(
                  tag: 'splash-logo',
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SvgPicture.asset(
                      "assets/svg/QR Code-bro.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // App Name with Typing Animation
                _TypingText(
                  text: "QR Collection",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle with Fade Animation
                _FadeInText(
                  text: "Scan. Collect. Secure.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: black,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 30),

                // Loading Indicator
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(home1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.5, size.width, size.height * 0.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Animated Widgets
class _FloatingParticle extends StatefulWidget {
  final Color color;
  final double size;
  final double delay;

  const _FloatingParticle({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  __FloatingParticleState createState() => __FloatingParticleState();
}

class __FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(
            opacity: 0.6,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TypingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypingText({required this.text, required this.style});

  @override
  __TypingTextState createState() => __TypingTextState();
}

class __TypingTextState extends State<_TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  String _displayText = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 100),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: widget.text.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _displayText = widget.text.substring(0, _animation.value);
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}

class _FadeInText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _FadeInText({required this.text, required this.style});

  @override
  __FadeInTextState createState() => __FadeInTextState();
}

class __FadeInTextState extends State<_FadeInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}