import 'dart:async';
import 'package:e_Collect/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors.dart';
import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../auth/authetication_page/google_pin_code_page.dart';
import '../auth/login/mobile_number_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loggedInUser = false;
  String fcmToken = "";
  String entityid = "";
  String subAgentid = "";
  String ecollectTokenValue = "";
  String ecollectRefreshToken = "";
  String mobnum = "";
  String subAgentmobnum = "";
  String mpin = "";
  bool _animationsCompleted = false;

  @override
  void initState() {

    getSharedData();
    super.initState();
  }

  void showInSnackBar(String value, String color) {
    var snackBar = SnackBar(
      content: Text(
        value,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      backgroundColor: color == "RED" ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _navigateAfterAnimations(Widget page) {
    if (_animationsCompleted) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
        }
      });
    }
  }
  Future<void> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (mainly for iOS)
    await messaging.requestPermission();

    var fcmToken = await messaging.getToken();
   // SharedPref.shared.setFcmToken(fcmToken.toString());
    print("FCM Token: $fcmToken");

  }
  Future<void> getSharedData() async {
    final results = await Future.wait([
      SharedPref.shared.getECollectLoginStatus(),
      SharedPref.shared.getFcmToken(),
      SharedPref.shared.getAgentId(),
      SharedPref.shared.getSubAgentId(),
      SharedPref.shared.getECollectUserToken(),
      SharedPref.shared.getParentAgentMobNum(),
      SharedPref.shared.getSubAgentMobNum(),
      SharedPref.shared.getMpinValue(),
      SharedPref.shared.getFcmToken(),
      SharedPref.shared.getECollectRefreshToken(),
    ]);

    final lgStatus = results[0] as bool;

    fcmToken = results[1] as String;
    entityid = results[2] as String;
    subAgentid = results[3] as String;
    ecollectTokenValue = results[4] as String;
    mobnum = results[5] as String;
    subAgentmobnum = results[6] as String;
    mpin = results[7] as String;
    ecollectRefreshToken = results[8] as String;


    var fcmtok = fcmToken;
   // print("fcmtok : $fcmToken");

    if(fcmtok.isEmpty){
      getDeviceToken();
    }

    isRunningLiveBaseUrl(true, subAgentmobnum);
    isRunningLiveDopBaseUrl(true, subAgentmobnum);

    if (!mounted) return;

    setState(() {
      loggedInUser = lgStatus;
    });

    if (loggedInUser) {
      validateECollectToken();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MobileNumberVerificationPage(),
        ),
      );
    }
  }


  void validateECollectToken(){
    context.read<AuthenticationBloc>().add(TokenVerificationEvent(ecollectTokenValue));
  }



  void _onAnimationsComplete() {
    if (!_animationsCompleted) {
      setState(() {
        _animationsCompleted = true;
      });

      // Trigger navigation based on login status
      if (loggedInUser) {
        if (fcmToken.isNotEmpty) {
          if (printStatementStatus) {
          //  print("Gpin page from _onAnimationsComplete");
          }

           _navigateAfterAnimations(const GooglePinCodePage());
        }
      } else {
        _navigateAfterAnimations(const MobileNumberVerificationPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(color: Colors.grey.shade200
                ),
          ),

          // Floating QR Code Particles
          Positioned(
            top: 50,
            left: 30,
            child: _FloatingParticle(
              color: green.withValues(alpha: 0.3),
              size: 40,
              delay: 0,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 40,
            child: _FloatingParticle(
              color: Colors.blue.withValues(alpha: 0.3),
              size: 60,
              delay: 0.5,
            ),
          ),
          Positioned(
            top: 150,
            right: 70,
            child: _FloatingParticle(
              color: orange.withValues(alpha: 0.2),
              size: 30,
              delay: 1,
            ),
          ),

          // Main Content
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (BuildContext context, AuthenticationState state) {

              if(state is TokenVerificationSuccessState){
                var data = state.tokenVerificationSuccessModel.tokenValidationSuccessResponse;
               // print(data.message);
                data.isValid == true?

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GooglePinCodePage()))
                    :
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MobileNumberVerificationPage()));

              }
              if(state is TokenRegenerationSuccessState){
                SharedPref.shared.setECollectToken(state.tokenRegenerationSuccessModel.eCollectTokenGenSuccess.token);
                SharedPref.shared.setECollectRefreshToken(state.tokenRegenerationSuccessModel.eCollectTokenGenSuccess.refreshToken);
              }
              else if(state is TokenVerificationFailureState){
               // print(state.tokenVerificationFailureModel.tokenValidationFailureResponse.message);

                context.read<AuthenticationBloc>().add(TokenRegenerationEvent(ecollectTokenValue,ecollectRefreshToken ));
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset("assets/images/ecollect.webp"),
                    const SizedBox(height: 40),

                    // App Name with Typing Animation
                    _TypingText(
                      //text: "Collection QR",
                      text: "SMART PAYMENT SOLUTION",
                      style: TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
                      ),
                      onComplete: _onAnimationsComplete,
                    ),

                    const SizedBox(height: 10),
                    Text("Version 1.0.7", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),),

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
            ),
          ),

        ],
      ),
    );
  }
}

// Custom Clippers (kept from original code)
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

class __FloatingParticleState extends State<_FloatingParticle> with SingleTickerProviderStateMixin {
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

    Future.delayed(
      Duration(milliseconds: (widget.delay * 500).round()),
      () {
        if (mounted) _controller.forward();
      },
    );
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
  final VoidCallback onComplete;

  const _TypingText({
    required this.text,
    required this.style,
    required this.onComplete,
  });

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

    _animation =
        IntTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {
              _displayText = widget.text.substring(0, _animation.value);
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete();
            }
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
  final VoidCallback onComplete;

  const _FadeInText({
    required this.text,
    required this.style,
    required this.onComplete,
  });

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
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });

    Future.delayed(const Duration(milliseconds: 200), () {
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

