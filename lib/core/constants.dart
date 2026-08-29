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
  static const String selectedBusinessCategory = "SELECTED_BUSINESS_CAT";
  static const String eCollectName = "E_COLLECT_NAME";
  static const String userId = "USER_ID";
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
  final String eCollectLoginStatus = "E-COLLECT_LOGIN_STATUS";
  final String eCollectActiveStatus = "E-COLLECT_ACTIVE_STATUS";
  final String eCollectVerifyStatus = "E-COLLECT_VERIFY_STATUS";
  final String eCollectUserEmail = "E-COLLECT_USER_EMAIL";
  static const String fcm_token = "FCM_TOKEN";
  static const String corpCode = "CORP_CODE";
  static const String branchCode = "BRANCH_CODE";
  static const String email = "EMAIL_ID";
  static const String custid = "CUST_ID";
  static const String mpin_value = "MPIN_VALUE";
  static const String adsspay_token = "ADSSPAY_TOKEN";
  static const String parentAgentMobNum = "PARENT_AGENT_MOB_NUM";
  static const String subAgentCode = "SUB_AGENT_CODE";
  static const String subAgentCodeNew = "SUB_AGENT_CODE_NEW";
  static const String subAgentID = "SUB_AGENT_ID";
}

String capitalizeFirstLetter(String? input){
  if(input == null || input.isEmpty) return '';
  return input[0].toUpperCase()+input.substring(1);
}
