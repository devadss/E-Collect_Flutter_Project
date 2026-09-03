import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/model/cash_transcation_model.dart';
import 'colors.dart';
import 'constants.dart';

const bool printStatementStatus = true;
class TransactionSuccessDialog extends StatelessWidget {
  final CashTranscation success;
  final VoidCallback onViewReceipt;

  const TransactionSuccessDialog({
    super.key,
    required this.success,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha:0.2),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            _buildHeader(context),
            const SizedBox(height: 24),

            // Transaction Details
            _buildTransactionDetails(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Transaction Completed",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
          label: "Status",
          value: success.status ?? 'N/A',
          valueColor: _getStatusColor(success.status),
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Transaction ID",
          value: success.transactionId ?? 'N/A',
          isImportant: true,
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Message",
          value: success.message ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    Color? valueColor,
    bool isImportant = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isImportant ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);},

            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "CLOSE",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onViewReceipt,
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "VIEW RECEIPT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
void isRunningLiveBaseUrl(bool status, String mobile) async {
  if(mobile.startsWith("+91")){
    if (status==true && mobile != null && mobile != uatTestMobileNumber){
      if(printStatementStatus){
        // print("STATUS :$status");
        // print("mobile :$mobile");
        // print("returning live url");
      }

     // baseUrl = "https://adsspay.aanvinsolutions.com:8444/";
      baseUrl ="https://adsspayweb.digicob.in/";

    }else{
      baseUrl ="https://adsspayweb.digicob.in/";
      if(printStatementStatus){
     //   print("returning UAT url");
      }
    }
  }else{
    if (status==true && "+91$mobile" != null && "+91$mobile" != uatTestMobileNumber){
      if(printStatementStatus){
        // print("STATUS :$status");
        // print("mobile :$mobile");
        // print("returning live url");
      }

     // baseUrl = "https://adsspay.aanvinsolutions.com:8444/";
      baseUrl ="https://adsspayweb.digicob.in/";

    }else{
      baseUrl ="https://adsspayweb.digicob.in/";
      if(printStatementStatus){
       // print("returning UAT url");
      }
    }
  }

}

void isRunningLiveDopBaseUrl(bool status, String mobile) async {
  if(mobile.startsWith("+91")){
    if (status== true && "+91$mobile" != null && "+91$mobile" != uatTestMobileNumber){
     // dopBaseUrl =  "https://mydop.in/api/fetch/vendor/urls/";
      dopBaseUrl =  "https://devops.mydop.in/api/fetch/vendor/urls/";

    }else{
      dopBaseUrl =  "https://devops.mydop.in/api/fetch/vendor/urls/";
    }
  }else{
    if (status== true && "+91$mobile"!= null && "+91$mobile" != uatTestMobileNumber){
      //dopBaseUrl =  "https://mydop.in/api/fetch/vendor/urls/";
      dopBaseUrl =  "https://devops.mydop.in/api/fetch/vendor/urls/";
    }else{
      dopBaseUrl =  "https://devops.mydop.in/api/fetch/vendor/urls/";
    }
  }

}
class NavItem{

  final String label;
  final IconData icon;
  final Widget page;
  NavItem({required this.label, required this.icon, required this.page});
}


/*
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
*/


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
    barrierColor: Colors.black54,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/ecollect_white.png",
                height: 55,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: home1,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Please wait...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Processing your request",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



/*void showProgressDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
             // backgroundColor: Colors.grey.shade200,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                  //  Image.asset("assets/images/ecollect.webp", scale: 10,),
                    Image.asset("assets/images/ecollect_white.png", scale: 10,),
                    const CircularProgressIndicator(color: home1),
                    const SizedBox(height: 10,),
                    const Text("Please wait....", style: TextStyle(fontSize: 17,),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}*/


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

String extractOtp(List<TextEditingController> otpController){
  var otpValue = "";
  var otp = otpController.map((x)=>  x.value.text);
  for(var x in otp){
    otpValue += x;
  }
  //print(otpValue);
  if(otpValue.length !=4 && otpValue.isNotEmpty){
    return "Enter 4 digit Otp";
  }else if(otpValue.isEmpty){
    return "Empty fields not allowed";
  }else{
    return otpValue;
  }

}


Uint8List padPKCS7(Uint8List input) {
  final padLength = 16 - (input.length % 16);
  final output = Uint8List(input.length + padLength)..setAll(0, input);
  for (var i = input.length; i < output.length; i++) {
    output[i] = padLength;
  }
  return output;
}

// Future<void> resetInitialData() async {
//
//   SharedPref.shared.setEmail("");
//   SharedPref.shared.setCorpCode("");
//   SharedPref.shared.setBranchCode("");
//   SharedPref.shared.setMpinValue("");
//   await SharedPref.shared.setAgentId('');
//   await SharedPref.shared.setParentAgentMobNum('');
//   await SharedPref.shared.setSubAgentMobNum('');
//   await SharedPref.shared.setAgentOriginId('');
//   await SharedPref.shared.setSubAgentCode('');
//   await SharedPref.shared.setSubAgentCodeNew('');
//   await SharedPref.shared.setSubAgentId('');
//   SharedPref.shared.setRdclCustomerVendorUrl('');
//   SharedPref.shared.setDueListRdclUrl('');
//   SharedPref.shared.setCustomerRdUrl('');
//   SharedPref.shared.setDueListRdUrl('');
//   SharedPref.shared.setCustomerLoanUrl('');
//   SharedPref.shared.setDueListLoanUrl('');
//   SharedPref.shared.setLoanAccountHolderUrl('');
//   SharedPref.shared.setUserType('');
//
// }

void showNotification(BuildContext context , String content, Color color, Color txtColor){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content, style: TextStyle(color: txtColor, fontWeight: FontWeight.w700),), backgroundColor: color));
}

AppBar ptpBucketAppbar(String appBarName) {
  return AppBar(
    centerTitle: true,
    title:  Text(
      appBarName,

      style: TextStyle(
          color: home1, fontSize: 23, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
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


