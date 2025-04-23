import 'dart:async';
import 'package:flutter/material.dart';
import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:collection_qr_flutter/data/provider/token_expiry_provider.dart';
import 'package:collection_qr_flutter/data/provider/token_request_provider.dart';
import 'package:collection_qr_flutter/data/service/notification_service/notification_service.dart';
import 'package:collection_qr_flutter/presentation/auth/authetication_page/google_pin_code_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  void showInSnackBar(String value, String color) {
    var snackBar = SnackBar(
      content: Text(
        value,
        style: GoogleFonts.inter(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      backgroundColor:
      color == "RED"?
      Colors.red:
      Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> validateToken(String token,

      String userName,
      String password,
      String mobNum,
      String type,


      ) async {
    final provider = Provider.of<TokenExpiryProvider>(context, listen: false);
    final tokenValidateResponse = await provider.validateToken(token);

    tokenValidateResponse.fold(
      (error) {
       // Navigator.pop(context);
        print("Token Validation Error: $error");
        showInSnackBar(error, "RED");
      },
      (data) async {
        print("Token Validation ${data.isExpired}");
        if(data.isExpired == false){
          if (loginStatus == true) {
            if (fcmToken.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GooglePinCodePage()));
                }
              });
            }
            else {
              if (mounted) {
                saveFcmToken(entityid, context, "GPIN", token, mobnum, mpin);
              }
            }
          }
          else {
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
        }else{
          final tokenRequest = Provider.of<TokenRequestProvider>(context , listen: false);
          final requestNewTokenResponse = await tokenRequest.requestToken(userName, password, mobNum, type);


          requestNewTokenResponse.fold(
                (error) {
              print("Error: ${error}");

            },
                (data) {
              print("Token Response : ${data}");
              SharedPref.shared.setTokenValue(data);
              if (loginStatus == true) {
                if (fcmToken.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GooglePinCodePage()));
                    }
                  });
                }
                else {
                  if (mounted) {
                    saveFcmToken(entityid, context, "GPIN", token, mobnum, mpin);
                  }
                }
              }
              else {
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
            },
          );
        }


      },
    );

  }

  void getSharedData() async {
    loginStatus = await SharedPref.shared.getLogin();
    fcmToken = await SharedPref.shared.getFcmToken();
    entityid = await SharedPref.shared.getAgentId();
    token = await SharedPref.shared.getTokenValue();
    mobnum = await SharedPref.shared.getMobNum();
    mpin = await SharedPref.shared.getMpinValue();
    String username = await SharedPref.shared.getAgentName();
    String password = await SharedPref.shared.getPassword();
    if(loginStatus == true){
      validateToken(token,
          username , password,mobnum,"Mob"
      );
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
              "assets/images/collection_qr_image.png",
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
