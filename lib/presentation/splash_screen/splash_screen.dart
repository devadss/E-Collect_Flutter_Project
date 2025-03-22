import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merchant_app_flutter/core/shared_pref_helper.dart';
import 'package:merchant_app_flutter/data/service/notification_service/notification_service.dart';
import 'package:merchant_app_flutter/presentation/auth/authetication_page/google_pin_code_page.dart';

import '../auth/mobile_number_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loginStatus = false;
  String fcmToken = "";
  String entityid = "";
  String token = "";
  String mobnum = "";
  String mpin = "";
  @override
  void initState() {
    getSharedData();

    super.initState();
  }
  
  void getSharedData()async{
    loginStatus = await SharedPref.shared.getLogin();
    fcmToken = await SharedPref.shared.getFcmToken();
    entityid = await SharedPref.shared.getCustId();
    token = await SharedPref.shared.getTokenValue();
    mobnum = await SharedPref.shared.getMobNum();
    mpin = await SharedPref.shared.getMpinValue();

    if(loginStatus == true){
      if(fcmToken.isNotEmpty){
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GooglePinCodePage()));
          }
        });
      }
      else{
        if(mounted){
          saveFcmToken(entityid, context, "GPIN", token, mobnum, mpin);
        }
      }

    }else{
      Future.delayed(const Duration(milliseconds: 100), () {
        // Do something
        if (mounted) {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MobileNumberVerificationPage()));
        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/collection_splash_screen.jpg",
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
