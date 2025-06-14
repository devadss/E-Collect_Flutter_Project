// Production
import 'package:flutter/material.dart';

const String apiUrl = "https://adsspayweb.digicob.in:8444/";
const String apiUrlTwo = "https://adsspayweb.digicob.in:8444/";
const String s3Url = "https://cdn.adsspayweb.digicob.in/";
//const String baseUrl = "https://adsspay.aanvinsolutions.com:8444/";///LIVE
const String corpBaseUrl = "https://mydop.in/";///LIVE
const String baseUrl = "https://adsspayweb.digicob.in/"; //TEST
const String baseUrlTwo = "https://api.adsspay.digicob.in";
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

const String baseURL = apiUrl;
//const String imageBaseURL = s3Url;


class NotificationChannels {
  static const String getCartNonDeliverable = "GET_CART_NON_DELIVERABLE";
  static const String login = "LOGIN";
  static const String nonDeliverableButton = "NON_DELIVERABLE_BUTTON";
  static const String getAllCart = "GET_ALL_CART";
  static const String getCart = "GET_CART";
}

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
  static const String enteredusername = "ENTERED_USER_NAME";
  static const String balance = "ACC_BALANCE";
  static const String gendervalue = "GENDER_VALUE";
  static const String password = "PASSWORD";
  static const String encryptedPassword = "ENCRYPTED_PASSWORD";
  final String login = "LOGIN";
  final String cartLogin = "CART_LOGIN";
  final String cardLimit = "SET_CARDLIMIT";
  static const String fullName = "FULL_NAME";
  static const String fcm_token = "FCM_TOKEN";
  static const String phoneNumber = "PHONE_NUMBER";
  static const String corpCode = "CORP_CODE";
  static const String email = "EMAIL_ID";
  static const String mpin = "MPIN";
  static const String mpin_value = "MPIN_VALUE";
  static const String mpin_status = "MPIN_STATUS";
  static const String shopid = "SHOPID";
  static const String adsspay_token = "ADSSPAY_TOKEN";
  static const String adsspay_user_name = "ADSSPAY_USER_NAME";
  static const String mob_num = "MOB_NUM";
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

