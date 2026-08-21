import 'dart:io';
import 'package:flutter/material.dart';

import '../presentation/merchant/pages/all-groups.dart';
import 'colors.dart' hide home1;

String baseUrl = "";
String dopBaseUrl = "";
String eCollectBaseUrl = "https://dev.collect.org.in/";

const String uatTestMobileNumber = "+917663220991"; ///Currently this number is provided for appstore...
final String termsUrl = "https://your-terms-url.com";
final String privacyUrl = "https://your-privacy-url.com";

const String terms = 'https://collect.org.in/terms-of-conditions.html';
const String privacy = 'https://collect.org.in/privacy-policy.html';
String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
RegExp regExp = RegExp(pattern);

AlertDialog exitAlert(BuildContext context){
  return AlertDialog(
    icon: Icon(Icons.warning_amber, color: home1,size: 30,),
    alignment: Alignment.center,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    title:const Center(child:Text("Alert")) ,
    backgroundColor: Colors.white,
    content: SizedBox(
      height: 120,
      child: Column(children: [
        const Text(
          "Are you sure you want to exit e-Collect? ",
        style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black,
        fontSize: 15),),
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: home1,
                foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )
              ),
              onPressed: (){
               // Navigator.pop(context);
               // SystemNavigator.pop();
                exit(0);
              }, child: const Text("YES")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: homeColor,
                    foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
                onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("NO")),
        ],)
      ],),
    ),
  );
}

class SharedPrefKeys {
  static const String guestCartCount = "GET_CART_COUNT";
  static const String selectedBusinessCategory = "SELECTED_BUSINESS_CAT";
  static const String eCollectName = "E_COLLECT_NAME";
  static const String userId = "USER_ID";
  static const String token = "TOKEN";
  static const String dob = "DOB";
  static const String pinCode = "PIN_CODE";
  static const String kitNo = "KIT_NO";
  static const String dateRange = "DATE_RANGE";
  static const String nearestPinCode = "NEAREST_PIN_CODE";
  static const String pinCodeText = "PIN_CODE_TEXT";
  static const String username = "USER_NAME";
  static const String eCollectUsername = "E-COLLECT_USER_NAME";
  static const String eCollectUserType = "E-COLLECT_USER_TYPE";
  static const String eCollectRdclCustomerunderAgentList = "E-COLLECT_RDCL_CUSTOMER_UNDER_AGENT_LIST";
  static const String eCollectRdclDueLisUnderAgent = "E-COLLECT_RDCL_DUE_LIST_UNDER_AGENT";
  static const String eCollectMerchantBranchCode = "E-COLLECT_MERCHANT_BRANCH_CODE";
  static const String eCollectBranchName= "E-COLLECT_BRANCH_NAME";
  static const String eCollectUserRole= "E-COLLECT_USER_ROLE";
  static const String eCollectCommRate= "E-COLLECT_COMM_RATE";
  static const String eCollectMerchantRegName = "E-COLLECT_MERCHANT_REG_NAME";
  static const String eCollectMerchantName= "E-COLLECT_MERCHANT_NAME";
  static const String eCollectBranchCode = "E-COLLECT_BRANCH_CODE";
  static const String eCollectBranchId= "E-COLLECT_BRANCH_ID";
  static const String eCollectAgentId = "E-COLLECT_AGENT_ID";
  static const String eCollectMerchantIntegrationStatus = "E-COLLECT_MERCHANT_INTEGRATION_STATUS";
  static const String eCollectTypes = "E-COLLECT_TYPES";
  static const String eCollectUrlList = "E-COLLECT_URL_LIST";
  static const String eCollectUserNumber= "E-COLLECT_USER_NUMBER";
  static const String eCollectMerchantId= "E-COLLECT_MERCHANT_ID";
  static const String eCollectUserId= "E-COLLECT_USER_ID";
  static const String eCollectToken = "E-COLLECT_TOKEN";
  static const String eCollectRefreshToken = "E-COLLECT_REFRESH_TOKEN";
  //static const String parent_username = "PARENT_USERNAME";
  //----------------------------------------------------------------------------
  //static const String RdclCustomervendorUrl = "getCustomerRdclUrl"; //
  //static const String RdclDueListvendorUrl = "getDueListRdclUrl";//
  //static const String RdCustomerVendorUrl = "getCustomerRdUrl";//
  //static const String RdDueVendorUrl = "getDueListRdUrl";//
  //static const String LoanCustomerVendorUrl = "getCustomerLoanUrl";//
  //static const String LoanDueVendorUrl = "getDueListLoanUrl";
 // static const String LoanAccountHolderVendorUrl = "getLoanAccountHolderUrl";
  static const String IOSNUMBERVALIDATOR = "ios_number_validator";

  //----------------------------------------------------------------------------
  static const String force_logout = "FORCE_LOGOUT";
  //static const String vendorUrlTest = "VENDOR_TEST_URL";
 // static const String userType = "USER_TYPE";
  //static const String subAgent_username = "SUB_AGENT_USERNAME";
 // static const String enteredusername = "ENTERED_USER_NAME";
 // static const String balance = "ACC_BALANCE";
 // static const String gendervalue = "GENDER_VALUE";
 // static const String password = "PASSWORD";
 // static const String parent_agent_password = "PARENT_AGENT_PASSWORD";
 // static const String encryptedPassword = "ENCRYPTED_PASSWORD";
  final String login = "LOGIN";
  final String eCollectLoginStatus = "E-COLLECT_LOGIN_STATUS";
  final String eCollectActiveStatus = "E-COLLECT_ACTIVE_STATUS";
  final String eCollectVerifyStatus = "E-COLLECT_VERIFY_STATUS";
  final String eCollectUserEmail = "E-COLLECT_USER_EMAIL";
 // final String cartLogin = "CART_LOGIN";
 // final String cardLimit = "SET_CARDLIMIT";
 // static const String fullName = "FULL_NAME";
  static const String fcm_token = "FCM_TOKEN";
 // static const String phoneNumber = "PHONE_NUMBER";
 // static const String loggedInUserType = "LOGGED_IN_USER_TYPE";
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
