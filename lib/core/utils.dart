import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/provider/collection_base_url_provider.dart';
import '../data/provider/parent_agent_detail_provider/parent_agent_detil_provider.dart';
import '../data/storage/shared_pref_helper.dart';
import '../domain/model/registered_cust_model.dart';
import '../presentation/auth/login/otp_verification/otp_verification.dart';
import 'colors.dart';
import 'constants.dart';

const bool printStatementStatus = true;

void isRunningLiveBaseUrl(bool status, String mobile) async {
  if (status==true && mobile != null && mobile != uatTestMobileNumber){
    if(printStatementStatus){
      print("STATUS :$status");
      print("mobile :$mobile");
      print("returning live url");
    }

    baseUrl = "https://adsspay.aanvinsolutions.com:8444/";
  }else{
   baseUrl ="https://adsspayweb.digicob.in/";
   if(printStatementStatus){
     print("returning UAT url");
   }
  }
}

void isRunningLiveDopBaseUrl(bool status, String mobile) async {
  if (status== true && mobile != null && mobile != uatTestMobileNumber){
    dopBaseUrl =  "https://mydop.in/api/fetch/vendor/urls/";
  }else{
    dopBaseUrl =  "https://devops.mydop.in/api/fetch/vendor/urls/";
  }
}

String getBankNameFromCorpCode(String corpCode) {
  //print("getBankNameFromCorpCode $corpCode");
  // Map corpcode to bank name
  final Map<String, String> corpCodeToBankName = {
    "BNKKRMR": "KURUMATHUR SERVICE CO OPERATIVE BANK LTD",
    "BNKPDVR": "PIDAVOOR SCB",
    "BNKKNPRM": "Kannapuram SCB",
    "BNKTRK": "Thrikkakkara SCB",
    "BNKKVRY": "KOOVERY SERVICE CO OPERATIVE BANK LTD",
    "BNKKPM": "Kaipamangalam SCB",
    "BNKKPMF": "Kaipamangalam Fisherman SCB",
    "BNKPRK": "Peringottukara SCB",
    "BNKPYPL": "POOYAPALLY SCB",
    "BNKVLMK": "VELIMUKKU SCB",
    "BNKPLKL": "PALLICKAL SCB",
    "BNKCRKT": "CHERUKALATHUR SCB",
    "BNKCLNR": "CHELANNUR SERVICE CO OPERATIVE BANK",
    "BNKPPNS": "Pappinissery Rural Bank",
    "BNKELYR": "ELAYAVOOR SERVICE CO OPERATIVE BANK LTD",
    "BNKKTM": "KOTTAYAM SERVICE CO OPERATIVE BANK LTD",
    "BNKAVN": "Avinissery SCB",
    "BNKDMDM": "DHARMADAM SERVICE CO OPERATIVE BANK LTD",
    "BNKPTVM": "PATTUVAM SERVICE CO OPERATIVE BANK",
    "BNKKUTGM": "KUTTUMUGHAM SERVICE CO OPERATIVE BANK LTD",
    "BNKERKT": "ERAMAM KUTTUR SERVICE CO OPERATIVE BANK LTD",
    "BNKKDKD": "KODAKKAD SERVICE CO OPERATIVE BANK LTD",
    "BNKPMP": "PMP SERVICE CO OPERATIVE BANK",
    "BNKSKMB": "SRI KAMBILAYA MUTUAL NIDHI LIMITED",
    "BNKTSSCB": "Thuravoor South SCB",
    "BNKVBGR": "VIBGYOR NIDHI LIMITED",
    "BNKPPL": "PERUMPILLY SCB",
    "BNKKTRM": "KAITHARAM SCB",
    "BNKKZPL": "KUZHUPPILLY SCB",
    "BNKNABL": "NAYARAMBALAM SCB",
    "BNKELR": "ELOOR SCB",
    "BNKERYD": "ERIYAD SCB",
    "BNKPYVR": "PAYYAVOOR SCB",
    "BNKVDKRA": "VADAKKEKKARA SCB",
    "BNKPRVR": "PARAVUR SCB",
    "BNKVLLR": "Velloor Service Co Operative Bank",
    "BNKMANK": "Manakunnam SCB",
    "BNKAZKD": "AZHIKODE SCB",
    "BNKTHRNL": "Thirunaloor SCB",
    "BNKVDYR": "VADAYAR",
    "BNKKDKPL": "KADAKKARAPALLY SCB",
    "BNKUCMSA": "URBAN CARE MULTI STATE AGRO CSL",
    "BNKKKYR": "KOKKAYAR SCB",
    "BNKMFF": "MILK FARMERS AND FISHERIES",
    "BNKCORDL": "Cordial Gramin Development Foundation",
    "BNKCHLVR": "CHELAVUR SCB",
    "BNKVRND": "VARANAD SCB",
    "BNKVBGRK": "VIBGYOR NIDHI LIMITED KOOTTILANGADI",
    "BNKKNKRA": "KUNNUKARA SCB",
    "BNKEDVNKD": "EDAVANAKKAD",
    "BNKKRDM": "KARTHEDOM SCB",
    "BNKAROOR": "AROOR SCB",
    "BNKGMSA": "Gramin Multi State Agro Co Operative Society Ltd",
    "BNKICCSL": "Indian Cooperative Credit Society Limited",
    "BNKNNDR": "Neendoor scb",
    "BNKCOB": "Co operative bhavan",
    "BNKCHMG": "Chathamangalam SCB",
    "BNKCXTX": "COXTAX",
    "BNKORNTL": "ORIENTAL AGRO MULTISTATE CO OP SOCIETY",
    "BNKTSRA": "Thushara Nidhi",
    "BNKPRTR": "PURATHUR SCB",
    "BNKCLBT": "CLUB T",
    "BNKPNP": "Pearls N Petals",
    "BNKVLKD": "Vellarkkad SCB",
    "BNKMDS": "Medi Soft",
    "BNKPLSCB": "Pulakode service cooperative Bank",
    "BNKMNCHL": "MEENACHIL MSCS",
    "BNKOMSRY": "Omassery SCB",
    "BNKPTKL": "Pothukal SCB",
    "BNKFPMC": "FAPMCO MSCS",
    "BNKVND": "VENAD",
  };

  // Return the bank name if found, otherwise return a default value
  return corpCodeToBankName[corpCode] ?? "Unknown Bank";
}

Map<String, String?> splitName(String fullName) {
  List<String> parts = fullName.trim().split(RegExp(r'\s+'));

  String? first;
  String? middle;
  String? last;

  if (parts.isEmpty) {
    return {'first': null, 'middle': null, 'last': null};
  }

  if (parts.length == 1) {
    first = parts[0];
  } else if (parts.length == 2) {
    first = parts[0];
    last = parts[1];
  } else {
    first = parts[0];
    last = parts.last;
    middle = parts.sublist(1, parts.length - 1).join(' ');
  }

  return {
    'first': first,
    'middle': middle,
    'last': last,
  };
}

void checkForUpdate() async {
  try {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate(); // or .startFlexibleUpdate()
    }
  } catch (e) {
    //print("Update check failed: $e");
  }
}

void showInSnackBar(String value, BuildContext context) {
  var snackBar = SnackBar(
    content: Text(
      value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showProgressDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: home2),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please wait....",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

void insertCollectionAgentIntegrationY(RegistedCustomerModel customer) {
  SharedPref.shared.setEmail(
    customer.response!.data!['emailId'].toString(),
  );
  SharedPref.shared.setCorpCode(
    customer.response!.data!['CorpCode'].toString(),
  );
  SharedPref.shared.setBranchCode(
    customer.response!.data!['BranchCode'].toString(),
  );
  SharedPref.shared.setMpinValue(customer.mpin.toString());
}

void insertCollectionAgentIntegrationN(RegistedCustomerModel customer) {
  SharedPref.shared.setCustId(
    customer.response!.data!['CustId'].toString(),
  );
  SharedPref.shared.setEmail(
    customer.response!.data!['emailId'].toString(),
  );
  SharedPref.shared.setCorpCode(
    customer.response!.data!['CorpCode'].toString(),
  );
  SharedPref.shared.setBranchCode(
    customer.response!.data!['BranchCode'].toString(),
  );
  SharedPref.shared.setMpinValue(customer.mpin.toString());
}

void insertCustRegister(RegistedCustomerModel customer) {
  SharedPref.shared.setEmail(
    customer.response!.data!['emailId'].toString(),
  );
  SharedPref.shared.setCustId(
    customer.response!.data!['CustId'].toString(),
  );
  SharedPref.shared.setCorpCode(
    customer.response!.data!['CorpCode'].toString(),
  );
  SharedPref.shared.setBranchCode(
    customer.response!.data!['BranchCode'].toString(),
  );
  SharedPref.shared.setSubAgentMobNum(
    customer.response!.data!['contactNo'].toString(),
  );
  SharedPref.shared.setAgentName(
    customer.response!.data!['firstName'].toString(),
  );
  SharedPref.shared.setMpinValue(customer.mpin.toString());
}

void insertCollectionBaseUrl(CollectionBaseUrlProvider vendorBaseUrlProvider) {
  SharedPref.shared.setRdclCustomerVendorUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getCustomerRdclUrl
      .toString());
  SharedPref.shared.setDueListRdclUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getDueListRdclUrl
      .toString());
  SharedPref.shared.setCustomerRdUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getCustomerRdUrl
      .toString());
  SharedPref.shared.setDueListRdUrl(
      vendorBaseUrlProvider.collectionBaseUrlModel!.getDueListRdUrl.toString());
  SharedPref.shared.setCustomerLoanUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getCustomerLoanUrl
      .toString());
  SharedPref.shared.setDueListLoanUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getDueListLoanUrl
      .toString());
  SharedPref.shared.setLoanAccountHolderUrl(vendorBaseUrlProvider
      .collectionBaseUrlModel!.getLoanAccountHolderUrl
      .toString());
  SharedPref.shared.setUserType(
      vendorBaseUrlProvider.collectionBaseUrlModel!.userType.toString());
}

Future<void> insertParentDetailAgent(
    ParentDetailAgentProvider parentAgentDetailProvider) async {
  await SharedPref.shared.setAgentId(
    parentAgentDetailProvider.subAgent!.data.parentAgentId.toString(),
  );
  await SharedPref.shared.setParentAgentMobNum(
    parentAgentDetailProvider.subAgent!.data.parentAgentMobNo.toString(),
  );
  await SharedPref.shared.setSubAgentName(
    parentAgentDetailProvider.subAgent!.data.subAgentName.toString(),
  );
  await SharedPref.shared.setSubAgentMobNum(
    parentAgentDetailProvider.subAgent!.data.mobileNumber.toString(),
  );
  await SharedPref.shared.setAgentOriginId(
      parentAgentDetailProvider.subAgent!.data.subAgentOriginId.toString());
  await SharedPref.shared.setSubAgentCode(
    parentAgentDetailProvider.subAgent!.data.subAgentOriginId.toString(),
  );
  await SharedPref.shared.setSubAgentCodeNew(
    parentAgentDetailProvider.subAgent!.data.subAgentCode.toString(),
  );
  await SharedPref.shared.setSubAgentId(
    parentAgentDetailProvider.subAgent!.data.subAgentId.toString(),
  );
}
class HomeVariablesModel{
  int todaysCount;
  String? userName;
  String? entityId;
  String? token;
  String? cashCollectionType;
  String? userType;
  String? corpCode;
  String? agentOriginId;
  String? mobNum;
  String? subAgentID;
  String? customerRdUrl;
  bool forceLogout;
  int selectedTabIndex;
  bool isFilterApplied;
  String currentFilterPeriod; // Track current filter period
  String currentFromDate; // Track current from date
  String currentToDate; // Track current to date
  int currentBannerIndex;
  HomeVariablesModel({
    required this.todaysCount,
    required this.userName,
    required this.entityId,
    required this.token,
    required this.cashCollectionType,
    required this.userType,
    required this.corpCode,
    required this.agentOriginId,
    required this.mobNum,
    required this.subAgentID,
    required this.customerRdUrl,
    required this.forceLogout,
    required this.selectedTabIndex,
    required this.isFilterApplied,
    required this.currentFilterPeriod,
    required this.currentFromDate,
    required this.currentToDate,
    required this.currentBannerIndex,

});

}


class LoanRequestModel {
  final String? customerName;
  final String? accountNo;
  final String? status;
  final String? scheme;
  final String? agent;
  final String? corpCode;
  final int? page;
  final int? pageSize;
  LoanRequestModel(
      {required this.customerName,
        required  this.accountNo,
        required   this.status,
        required   this.scheme,
        required   this.agent,
        required  this.corpCode,
        required    this.page,
        required   this.pageSize});
}

class TransactionHistoryModel {
  final String paymentStatus;
  final double amount;
  final String dat;
  final String accountNumber;
  final String transactionType;
  final String transferId;
  final String agentName;
  final String agentPhone;
  final String customerName;
  final String customerId;
  final String customerNumber;
  final String corpCode;
  final String tnxType;
  final String paymentMode;

  TransactionHistoryModel(
      {required this.paymentStatus,
      required this.amount,
      required this.dat,
      required this.accountNumber,
      required this.transactionType,
      required this.transferId,
      required this.agentName,
      required this.agentPhone,
      required this.customerName,
      required this.customerId,
      required this.customerNumber,
      required this.corpCode,
      required this.tnxType,
      required this.paymentMode});
}

class ReceiptDataModel {
  final String amount;
  final String dat;
  final String bankName;
  final String agentName;
  final String agentPhone;
  final String custName;
  final String custPhone;
  final String custId;
  final String txnId;
  final String txnType;
  final String tranType;
  final String accNo;
  ReceiptDataModel(
      {required this.amount,
      required this.dat,
      required this.bankName,
      required this.agentName,
      required this.agentPhone,
      required this.custName,
      required this.custPhone,
      required this.custId,
      required this.txnId,
      required this.txnType,
      required this.tranType,
      required this.accNo});
}

class LoanDetailsModel {
  final String customerName;
  final String customerPhoneNumber;
  final String loanNumber;
  final String loanStatus;
  final num emiAmount;
  final num loanTerm;
  final num loanAmount;
  final String scheme;
  final String paymentDate;
  final String collectionFrequency;
  final String email;
  final double dueAmount;
  final String dueDate;
  final String assignedAgent;
  final String custId;
  final String createdAt;

  LoanDetailsModel({
    required this.customerName,
    required this.customerPhoneNumber,
    required this.loanNumber,
    required this.loanStatus,
    required this.dueAmount,
    required this.emiAmount,
    required this.loanTerm,
    required this.loanAmount,
    required this.scheme,
    required this.paymentDate,
    required this.collectionFrequency,
    required this.email,
    required this.custId,
    required this.dueDate,
    required this.assignedAgent,
    required this.createdAt,
  });
}

class OtpPageData {
  final String subAgentmobNum;
  final String parentAgentMobNum;
  final String userName;
  final String password;
  final String tokenStatus;
  final String loggedInUserType;
  OtpPageData(
      {required this.subAgentmobNum,
      required this.parentAgentMobNum,
      required this.userName,
      required this.password,
      required this.tokenStatus,
      required this.loggedInUserType});
}

void otpPageNavigation(BuildContext context, OtpPageData otpData) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OtpRequestVerificationPage(
        otpPageData: otpData,
      ),
    ),
  );
}

Uint8List padPKCS7(Uint8List input) {
  final padLength = 16 - (input.length % 16);
  final output = Uint8List(input.length + padLength)..setAll(0, input);
  for (var i = input.length; i < output.length; i++) {
    output[i] = padLength;
  }
  return output;
}

Future<void> resetInitialData() async {
  SharedPref.shared.setEmail("");
  SharedPref.shared.setCorpCode("");
  SharedPref.shared.setBranchCode("");
  SharedPref.shared.setMpinValue("");
  await SharedPref.shared.setAgentId('');
  await SharedPref.shared.setParentAgentMobNum('');
  await SharedPref.shared.setSubAgentName('');
  await SharedPref.shared.setSubAgentMobNum('');
  await SharedPref.shared.setAgentOriginId('');
  await SharedPref.shared.setSubAgentCode('');
  await SharedPref.shared.setSubAgentCodeNew('');
  await SharedPref.shared.setSubAgentId('');
  SharedPref.shared.setRdclCustomerVendorUrl('');
  SharedPref.shared.setDueListRdclUrl('');
  SharedPref.shared.setCustomerRdUrl('');
  SharedPref.shared.setDueListRdUrl('');
  SharedPref.shared.setCustomerLoanUrl('');
  SharedPref.shared.setDueListLoanUrl('');
  SharedPref.shared.setLoanAccountHolderUrl('');
  SharedPref.shared.setUserType('');
}

void showNotification(BuildContext context , String content, Color color, Color txtColor){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content, style: TextStyle(color: txtColor, fontWeight: FontWeight.w700),), backgroundColor: color));

}



AppBar ptp_bucket_appbar(String appBarName) {
  return AppBar(
    centerTitle: true,
    title:  Text(
      appBarName,

      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
    ),
    backgroundColor: home1.withAlpha(180),
  );
}

Future<void> openGoogleMaps(double latitude , double longitude) async {
  final googleMapUri = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving");
  if(await canLaunchUrl(googleMapUri)){
    launchUrl(googleMapUri,mode: LaunchMode.externalApplication);
  }else{
    throw 'Could not open Google Maps';
  }
}