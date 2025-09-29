// Production
import 'dart:io';

import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

//******************************************************************
//const String baseUrl = "https://adsspay.aanvinsolutions.com:8444/"8905564553;///LIVE
const String baseUrl = "https://adsspayweb.digicob.in/"; //TEST
//*******************************************************************
const String dopBaseUrl = "https://devops.mydop.in/api/fetch/vendor/urls/"; //UAT
//const String dopBaseUrl = "https://mydop.in/api/fetch/vendor/urls/"; //LIVE


const String port = ":8444/";
const String agentIdLive = "ADSS20231011";
const String agentIdUat = "AANVIN20230627";
//Collection type instead of description in loan...
//1823 crpfwn
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final phoneRegex = RegExp("[0-9]");
final nameRegex = RegExp("[a-zA-Z]");
const String kEmailNullError = "Enter your email";
const String kInvalidEmailError = "Enter Valid Email";
const String kPassNullError = "Enter your password";
const String kConfirmPassNullError = "confirm your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Enter your name";
const String kPhoneNumberNullError = "Enter your phone number";
const String kAddressNullError = "Enter your address";
const String kPhoneNumberValidError = "Enter a valid phone number";
const String kPinCodeNullError = "Enter your pin code";
const String kPinCodeValidError = "Enter a valid pin code";
const String kNameValidError = "Enter a valid name";
const String kOtpNullError = "Enter the otp";




class NotificationChannels {
  static const String getCartNonDeliverable = "GET_CART_NON_DELIVERABLE";
  static const String login = "LOGIN";
  static const String nonDeliverableButton = "NON_DELIVERABLE_BUTTON";
  static const String getAllCart = "GET_ALL_CART";
  static const String getCart = "GET_CART";
}


AlertDialog exitAlert(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: home1.withOpacity(0.2), width: 1.5),
    ),
    shadowColor: home1.withOpacity(0.3),
    elevation: 25,
    contentPadding: const EdgeInsets.all(0),
    content: StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon with Pulse Effect
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [home1, home2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: home1.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Animated Title
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "Exit Collection QR?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: home1,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Animated Message
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 700),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 15 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "Are you sure you want to exit the application?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Buttons Row with Staggered Animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 900),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  children: [
                    // No Button with Hover Animation
                    Expanded(
                      child: MouseRegion(
                        onEnter: (_) => setState(() {}),
                        onExit: (_) => setState(() {}),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: home1.withOpacity(0.3),
                              width: 1.5,
                            ),
                            color: Colors.transparent,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Scale down animation on tap
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    "STAY",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: home1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Yes Button with Hover and Pulse Animation
                    Expanded(
                      child: MouseRegion(
                        onEnter: (_) => setState(() {}),
                        onExit: (_) => setState(() {}),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [home1, home2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: home1.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Add exit animation before closing
                                exit(0);
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: const Center(
                                  child: Text(
                                    "EXIT",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Optional: Add this function to show the dialog with animation
Future<void> showExitDialog(BuildContext context) async {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: exitAlert(context),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

// AlertDialog exitAlert(BuildContext context){
//   return AlertDialog(
//     icon: const Icon(Icons.warning_amber, color: home1,size: 30,),
//     alignment: Alignment.center,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10))
//     ),
//     title:const Center(child:Text("Alert")) ,
//     backgroundColor: Colors.white,
//     content: SizedBox(
//       height: 120,
//       child: Column(children: [
//         const Text("Are you sure you want to exit Collection Qr? ",
//         style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black,
//         fontSize: 15),),
//         const SizedBox(height: 30,),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: home1,
//                 foregroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))
//                   )
//               ),
//               onPressed: (){
//                // Navigator.pop(context);
//                // SystemNavigator.pop();
//                 exit(0);
//               }, child: const Text("YES")),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: homeColor,
//                     foregroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10))
//                   )
//                 ),
//                 onPressed: (){
//                   Navigator.pop(context);
//                 }, child: const Text("NO")),
//         ],)
//       ],),
//     ),
//   );
// }

class SharedPrefKeys {
  static const String guestCartCount = "GET_CART_COUNT";
  static const String userId = "USER_ID";
  static const String token = "TOKEN";
  static const String dob = "DOB";
  static const String pinCode = "PIN_CODE";
  static const String kitNo = "KIT_NO";
  static const String dateRange = "DATE_RANGE";
  static const String nearestPinCode = "NEAREST_PIN_CODE";
  static const String pinCodeText = "PIN_CODE_TEXT";
  static const String username = "USER_NAME";
  static const String parent_username = "PARENT_USERNAME";
  static const String vendorUrlLive = "VENDOR_LIVE_URL";
  static const String vendorUrlTest = "VENDOR_TEST_URL";
  static const String userType = "USER_TYPE";
  static const String subAgent_username = "SUB_AGENT_USERNAME";
  static const String enteredusername = "ENTERED_USER_NAME";
  static const String balance = "ACC_BALANCE";
  static const String gendervalue = "GENDER_VALUE";
  static const String password = "PASSWORD";
  static const String parent_agent_password = "PARENT_AGENT_PASSWORD";
  static const String encryptedPassword = "ENCRYPTED_PASSWORD";
  final String login = "LOGIN";
  final String cartLogin = "CART_LOGIN";
  final String cardLimit = "SET_CARDLIMIT";
  static const String fullName = "FULL_NAME";
  static const String fcm_token = "FCM_TOKEN";
  static const String phoneNumber = "PHONE_NUMBER";
  static const String loggedInUserType = "LOGGED_IN_USER_TYPE";
  static const String corpCode = "CORP_CODE";
  static const String branchCode = "BRANCH_CODE";
  static const String email = "EMAIL_ID";
  static const String custid = "CUST_ID";
  static const String mpin = "MPIN";
  static const String mpin_value = "MPIN_VALUE";
  static const String mpin_status = "MPIN_STATUS";
  static const String shopid = "SHOPID";
  static const String adsspay_token = "ADSSPAY_TOKEN";
  static const String adsspay_user_name = "ADSSPAY_USER_NAME";
  static const String mob_num = "MOB_NUM";
  static const String parentAgentMobNum = "PARENT_AGENT_MOB_NUM";
  static const String subAgentMobNum = "SUB_AGENT_MOB_NUM";
  static const String subAgentCode = "SUB_AGENT_CODE";
  static const String subAgentCodeNew = "SUB_AGENT_CODE_NEW";
  static const String subAgentID = "SUB_AGENT_ID";
  static const String adsspay_pswd = "ADSSPAY_PSWD";
  static const String adsspay_entity_id = "ADSSPAY_ENTITY_ID";
  static const String cardType = "CARDTYPE";
  static const String refID = "REF_ID";
  final String kycComplete = "KYC_COMPLETE";
  final String fcmToken = "FCM_TOKEN";
  final String referralCode = "REF_CODE";
  final String fullKycComplete = "FULL_KYC_COMPLETE";
  final String corpLoadRequest = "CORP_LOAD_REQUEST";
  final String cartUserName = "CART_USER_NAME";
  final String cartEmailId = "CART_EMAIL_ID";
  final String cartDob = "CART_DOB";
  final String cartPhoneNumber = "CART_PHONE_NUMBER";
  final String cartUserId = "CART_USER_ID";
  final String static = "STATIC";
  final String quantity = "QUANTITY";
  final String stock = "STOCK";
  final String integrationStatus = "INTEGRATION_STATUS";
  final String addressId = "ADDRESS_ID";
  static const String notificationValue = "NOTIFICATION_VALUE";
  static const String quickaction = "QUICK_ACTION";
  static const String cardNumber = "CARD_NUMBER";
  static const String businessId = "BUSINNESS_ID";
  static const String businessCategoryId = "CATEGORY_ID";
  static const String categoryId = "CATEGORY_ID";
  static const String agentOriginId = "AGENT_ORIGIN_ID";
  static const String cardRefNum = "CARD_REF_NUM";
}
String capitalizeFirstLetter(String? input){
  if(input == null || input.isEmpty) return '';
  return input[0].toUpperCase()+input.substring(1);
}