import 'package:collection_qr_flutter/data/provider/collection_base_url_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/colors.dart';
import '../../core/utils.dart';
import '../../data/provider/cust_register_provider.dart';
import '../../data/provider/parent_agent_detail_provider/parent_agent_detil_provider.dart';
import '../../data/provider/parent_agent_detail_provider/parent_credential_provider/parent_credential_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../groups/min_kyc/request_otp/min_kyc_page.dart';
import 'login/otp_verification/otp_verification.dart';

class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});

  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState
    extends State<MobileNumberVerificationPage> {
  bool isChecked = false;
  final String termsUrl = 'https://aanvinsolutions.com/terms.html';
  final String privacyUrl = 'https://aanvinsolutions.com/privacy.html';
  String? errorMsg;
  final TextEditingController _mobileNumberController = TextEditingController();

  // All your existing methods remain exactly the same...
  Future<void> checkMobileNumber() async {
    showProgressDialog(context);
    if (_mobileNumberController.text.isNotEmpty) {
      validateMobile(_mobileNumberController.text);
    } else {
      Navigator.pop(context);
      showInSnackBar("EMPTY FIELD NOT ALLOWED");
    }
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
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

  Future<void> validateMobile(String value) async {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      showInSnackBar('EMPTY FIELDS NOT ALLOWED');
    } else if (!regExp.hasMatch(value)) {
      Navigator.pop(context);
      showInSnackBar('Please enter valid mobile number');
    } else {
      final parentAgentDetailProvider =
          Provider.of<ParentDetailAgentProvider>(context, listen: false);
      final vendorBaseUrlProvider =
          Provider.of<CollectionBaseUrlProvider>(context, listen: false);
      // print("------------------------------PARENT AGENT MOBIE NUMBER-----------");
      // print(parentAgentDetailProvider.subAgent?.data.parentAgentMobNo);
      // print("------------------------------PARENT AGENT MOBIE NUMBER VENDOR-----------");
      // print(parentAgentDetailProvider.subAgent?.data.parentAgentMobNo);

      await parentAgentDetailProvider.fetchParentAgentDetails(value);
      if (parentAgentDetailProvider.subAgent != null) {
        await vendorBaseUrlProvider.getCollectionUrl(
           // parentAgentDetailProvider.subAgent?.data.parentAgentMobNo);
            parentAgentDetailProvider.subAgent?.data.mobileNumber);

        if (vendorBaseUrlProvider.collectionBaseUrlModel != null) {
          // print(
          //     "------------------------------VENDOR BASED URL MODEL CUST-----------");
          // print(vendorBaseUrlProvider.collectionBaseUrlModel!.getCustomerUrl
          //     .toString());

          SharedPref.shared.setRdclCustomerVendorUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getCustomerRdclUrl
              .toString());
          SharedPref.shared.setDueListRdclUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getDueListRdclUrl
              .toString());
          SharedPref.shared.setCustomerRdUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getCustomerRdUrl
              .toString());
          SharedPref.shared.setDueListRdUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getDueListRdUrl
              .toString());
          SharedPref.shared.setCustomerLoanUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getCustomerLoanUrl
              .toString());
          SharedPref.shared.setDueListLoanUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getDueListLoanUrl
              .toString());
          SharedPref.shared.setLoanAccountHolderUrl(vendorBaseUrlProvider
              .collectionBaseUrlModel!.getLoanAccountHolderUrl
              .toString());

          SharedPref.shared.setUserType(vendorBaseUrlProvider
              .collectionBaseUrlModel!.userType
              .toString());
        }

        //print(parentAgentDetailProvider.subAgent?.data.parentAgentMobNo);
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
        await SharedPref.shared.setAgentOriginId(parentAgentDetailProvider
            .subAgent!.data.subAgentOriginId
            .toString());
        await SharedPref.shared.setSubAgentCode(
          parentAgentDetailProvider.subAgent!.data.subAgentOriginId.toString(),
        );
        await SharedPref.shared.setSubAgentCodeNew(
          parentAgentDetailProvider.subAgent!.data.subAgentCode.toString(),
        );
        await SharedPref.shared.setSubAgentId(
          parentAgentDetailProvider.subAgent!.data.subAgentId.toString(),
        );
        // print(
        //     "parentAgentDetailProvider.subAgent!.parentAgentMobNo.toString() = ${parentAgentDetailProvider.subAgent!.data.parentAgentMobNo.toString()}");
        //
        final parentAgentCredentialProvider =
            Provider.of<ParentAgentCredentialProvider>(context, listen: false);

        await parentAgentCredentialProvider.fetchParentAgentCredentials(
            parentAgentDetailProvider.subAgent!.data.parentAgentMobNo
                .toString()
                .replaceAll("+91", ""));
        if (parentAgentCredentialProvider.parentAgentCredentialModel != null) {
          SharedPref.shared.setParentAgentName(parentAgentCredentialProvider
              .parentAgentCredentialModel!.b.userName);
          SharedPref.shared.setParentAgentPassword(parentAgentCredentialProvider
              .parentAgentCredentialModel!.b.mobPassword);
          SharedPref.shared.setAgentName(parentAgentCredentialProvider
              .parentAgentCredentialModel!.b.userName);
          final custRegisterProvider = Provider.of<CustRegisterProvider>(
            context,
            listen: false,
          );

          await custRegisterProvider.checkRegCust(int.parse(
              parentAgentDetailProvider.subAgent!.data.parentAgentMobNo
                  .toString()
                  .replaceAll("+91", "")));

          final response = await custRegisterProvider.checkRegCust(int.parse(
              parentAgentDetailProvider.subAgent!.data.parentAgentMobNo
                  .toString()
                  .replaceAll("+91", "")));
          response.fold(
            (error) {
              Navigator.pop(context);
              //print("Error: ${error.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Error: ${error.message}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (customer) {
              Navigator.pop(context);
              if (customer.response!.data!['Customer_type'] != null || customer.response!.data!['Customer_type']?.isNotEmpty ==
                      true) {
                //print("Phase 1");
                if (customer.response!.data!['Customer_type'] == "COLLECTION_AGENT"&& customer.response!.images!.integrationStaus=="Y") {
                 // print("Phase 2");
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
                  // print(
                  //     "customer.mpin.toString() = ${customer.mpin.toString()}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpRequestVerificationPage(
                        subAgentmobNum: _mobileNumberController.text,
                        parentAgentMobNum: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.phoneNumber,
                        userName: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.userName,
                        password: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.mobPassword,
                        tokenStatus: customer.status.toString(),
                        loggedInUserType: 'AGENT',
                      ),
                    ),
                  );
                }

                else if(customer.response!.data!['Customer_type'] == "COLLECTION_AGENT"&& customer.response!.images!.integrationStaus=="N") {
                  //print("Phase 2");
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
                  // print(
                  //     "customer.mpin.toString() = ${customer.mpin.toString()}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpRequestVerificationPage(
                        subAgentmobNum: _mobileNumberController.text,
                        parentAgentMobNum: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.phoneNumber,
                        userName: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.userName,
                        password: parentAgentCredentialProvider
                            .parentAgentCredentialModel!.b.mobPassword,
                        tokenStatus: customer.status.toString(),
                        loggedInUserType: 'AGENT_LOAN',
                       // loggedInUserType: 'AGENT',//// REMOVE THIS AFTER TESTING AND UNCOMMENT THE ABOVE ONE
                      ),
                    ),
                  );
                }else{
                  //print("Not a valid collection agent");
                  showInSnackBar("Not a valid collection agent");
                }
              } else {
               // print("Not a valid collection agent");
                showInSnackBar("Not a valid collection agent");
              }
            },
          );
        } else if (parentAgentCredentialProvider
                .parentAgentCredentialFailResponse !=
            null) {
          // print(parentAgentCredentialProvider
          //     .parentAgentCredentialFailResponse!.message);
        }
      }
      else {
       // print("Not an agent");
        final custRegisterProvider = Provider.of<CustRegisterProvider>(
          context,
          listen: false,
        );
        final response = await custRegisterProvider.checkRegCust(
            int.parse(_mobileNumberController.text.replaceAll("+91", "")));
        response.fold((error) {
          Navigator.pop(context);
          //print("Error: ${error.message}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AadhaarOtpRequest(mobNum: _mobileNumberController.text)));
        }, (customer) async {
          Navigator.pop(context);
          if (customer.response!.data!['CustId'] != null ||
              customer.response!.data!['CustId']?.isNotEmpty == true) {
            SharedPref.shared.setEmail(
              customer.response!.data!['emailId'].toString(),
            );

            // SharedPref.shared.setCustId(
            //   customer.response!.data!['subAgentId'].toString(),
            // );
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
            //print("customer.mpin.toString() = ${customer.mpin.toString()}");
            Map<String, String?> nameParts =
                splitName(customer.response!.data!['firstName'].toString());
            List<String> parts =
                customer.response!.data!['date'].toString().split('-');
            String year = parts[0];
            String? firstName = nameParts['first'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpRequestVerificationPage(
                  subAgentmobNum: _mobileNumberController.text,
                  parentAgentMobNum: _mobileNumberController.text,
                  userName: firstName!,
                  password: "$firstName@$year",
                  tokenStatus: customer.status.toString(),
                  loggedInUserType: 'NOT_AN_AGENT',
                ),
              ),
            );
          }
        });
      }
    }
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

  void showInSnackBar(String value) {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with new color theme
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEA307B), Color(0xFF470952)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child:
             /* Stack(
                children: [
                  const Positioned(
                    top: 20,
                    right: 20,
                    child: Opacity(
                      opacity: 0.2,
                      child: Icon(
                        Icons.phone_iphone,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        "assets/images/doodle.jpeg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEA307B).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/images/mobile_number.png",
                            height: 80,
                            width: 80,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Mobile Verification",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter your registered mobile number",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),*/
              Stack(
                children: [

                  /// 🌈 BACKGROUND GRADIENT (PREMIUM LOOK)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          home1,
                          home2,
                        ],
                      ),
                    ),
                  ),

                  /// 🧩 DOODLE BACKGROUND (SOFT)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Image.asset(
                        "assets/images/doodle.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// 📱 FLOATING ICON (TOP RIGHT – MORE SUBTLE)
                  const Positioned(
                    top: 40,
                    right: 30,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        Icons.phone_iphone,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// 🎯 MAIN CONTENT
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [

                        /// 🔘 ICON CONTAINER (GLASS + GLOW EFFECT)
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: home1.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              "assets/images/mobile_number.png",
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// 📝 TITLE
                        Text(
                          "Mobile Verification",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 📄 SUBTITLE
                        Text(
                          "Enter your registered mobile number\nto continue securely",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mobile Number",
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              '+91',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _mobileNumberController,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter 10 digit number',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.length < 10) {
                                  setState(() {
                                    errorMsg = 'Please enter 10 digits';
                                  });
                                } else {
                                  setState(() {
                                    errorMsg = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (errorMsg != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 5),
                      child: Text(
                        errorMsg!,
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Terms and Conditions with updated color theme
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isChecked = newValue!;
                              });
                            },
                            activeColor: const Color(0xFFEA307B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              children: [

                                const TextSpan(

                                  text: "By continuing, you agree to our ",
                                ),

                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFEA307B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await canLaunch(termsUrl)) {
                                        await launch(termsUrl);
                                      }
                                    },
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFEA307B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await canLaunch(privacyUrl)) {
                                        await launch(privacyUrl);
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Confirm Button with updated color theme
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isChecked) {
                          showInSnackBar("Please accept Terms & Conditions");
                          return;
                        }
                        checkMobileNumber();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA307B),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shadowColor: const Color(0xFFEA307B).withOpacity(0.3),
                      ),
                      child: Text(
                        "CONFIRM",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
