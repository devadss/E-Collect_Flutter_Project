import 'package:collection_qr_flutter/data/provider/collection_base_url_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../data/provider/cust_register_provider.dart';
import '../../data/provider/parent_agent_detail_provider/parent_agent_detil_provider.dart';
import '../../data/provider/parent_agent_detail_provider/parent_credential_provider/parent_credential_provider.dart';
import '../../data/storage/shared_pref_helper.dart';

class MobileNumberVerificationPage extends StatefulWidget {
  const MobileNumberVerificationPage({super.key});

  @override
  State<MobileNumberVerificationPage> createState() =>
      _MobileNumberVerificationPageState();
}

class _MobileNumberVerificationPageState extends State<MobileNumberVerificationPage> {
  bool isChecked = false;
  final String termsUrl = terms;
  final String privacyUrl = privacy;
  String? errorMsg;
  final TextEditingController _mobileNumberController = TextEditingController();

 
  Future<void> checkMobileNumber() async {
    showProgressDialog(context);
    if (_mobileNumberController.text.isNotEmpty) {
      final parentAgentDetailProvider = Provider.of<ParentDetailAgentProvider>(context, listen: false);
      final vendorBaseUrlProvider = Provider.of<CollectionBaseUrlProvider>(context, listen: false);
      resetInitialData();
      parentAgentDetailProvider.clearData();
      vendorBaseUrlProvider.clearData();
      validateMobile(_mobileNumberController.text);

    } else {
      Navigator.pop(context);
      showInSnackBar("EMPTY FIELD NOT ALLOWED", context);
    }
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();

  }


  Future<void> validateMobile(String value) async {
    if (value.isEmpty) {
      showInSnackBar(mobileNumEmpty, context);
    } else if (!regExp.hasMatch(value)) {
      Navigator.pop(context);
      showInSnackBar(mobileNumEmptyMSG, context);
    }
    else {

      final parentAgentDetailProvider = Provider.of<ParentDetailAgentProvider>(context, listen: false);
      final vendorBaseUrlProvider = Provider.of<CollectionBaseUrlProvider>(context, listen: false);
      final custRegisterProvider = Provider.of<CustRegisterProvider>(context, listen: false,);

      //PROVIDER CALL 1......
      await parentAgentDetailProvider.fetchParentAgentDetails(value);
      if (parentAgentDetailProvider.subAgent != null) {
        //PROVIDER CALL 2......
        await vendorBaseUrlProvider.getCollectionUrl(parentAgentDetailProvider.subAgent?.data.mobileNumber);

        if (vendorBaseUrlProvider.collectionBaseUrlModel != null) {
          insertCollectionBaseUrl(vendorBaseUrlProvider);
        }
        insertParentDetailAgent(parentAgentDetailProvider);


        final parentAgentCredentialProvider =
            Provider.of<ParentAgentCredentialProvider>(context, listen: false);

        //PROVIDER CALL 3......
        await parentAgentCredentialProvider.fetchParentAgentCredentials(
            parentAgentDetailProvider.subAgent!.data.parentAgentMobNo
                .toString()
                .replaceAll("+91", ""));
        if (parentAgentCredentialProvider.parentAgentCredentialModel != null) {
          SharedPref.shared.setParentAgentName(parentAgentCredentialProvider.parentAgentCredentialModel!.b.userName);
          SharedPref.shared.setParentAgentPassword(parentAgentCredentialProvider.parentAgentCredentialModel!.b.mobPassword);
          SharedPref.shared.setAgentName(parentAgentCredentialProvider.parentAgentCredentialModel!.b.userName);

          //PROVIDER CALL 5......
          final response = await custRegisterProvider.checkRegCust(int.parse(parentAgentDetailProvider.subAgent!.data.parentAgentMobNo
                  .toString()
                  .replaceAll("+91", "")));

          response.fold(
            (error) {
              Navigator.pop(context);
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
                if (customer.response!.data!['Customer_type'] == "COLLECTION_AGENT"&& customer.response!.images!.integrationStaus=="Y") {
                  insertCollectionAgentIntegrationY(customer);
                  var otpData = OtpPageData(
                    subAgentmobNum: _mobileNumberController.text,
                    parentAgentMobNum: parentAgentCredentialProvider.parentAgentCredentialModel!.b.phoneNumber,
                    userName: parentAgentCredentialProvider
                        .parentAgentCredentialModel!.b.userName,
                    password: parentAgentCredentialProvider
                        .parentAgentCredentialModel!.b.mobPassword,
                    tokenStatus: customer.status.toString(),
                    loggedInUserType: 'AGENT',
                  );
                  otpPageNavigation(context,otpData );
                }

                else if(customer.response!.data!['Customer_type'] == "COLLECTION_AGENT"&& customer.response!.images!.integrationStaus=="N") {
                  //print("Phase 2");
                  insertCollectionAgentIntegrationN(customer);

                  var otpData = OtpPageData(subAgentmobNum: _mobileNumberController.text,
                      parentAgentMobNum:parentAgentCredentialProvider.parentAgentCredentialModel!.b.phoneNumber,
                      userName:parentAgentCredentialProvider.parentAgentCredentialModel!.b.userName
                      , password: parentAgentCredentialProvider.parentAgentCredentialModel!.b.mobPassword,
                      tokenStatus: customer.status.toString(),
                      loggedInUserType: 'AGENT_LOAN',);
                  otpPageNavigation(context,otpData );
                }else{

                  showInSnackBar("Not a valid collection agent", context);
                }
              } else {

                showInSnackBar("Not a valid collection agent", context);
              }
            },
          );
        } else if (parentAgentCredentialProvider
                .parentAgentCredentialFailResponse !=
            null) {
          showInSnackBar("Not a registered user", context);
        }
      }
      else {
        //PROVIDER CALL 5......
        final response = await custRegisterProvider.checkRegCust(
            int.parse(_mobileNumberController.text.replaceAll("+91", "")));

        response.fold((error) {
          Navigator.pop(context);
          showInSnackBar("Not a registered user", context);
        }, (customer) async {
          Navigator.pop(context);

          if (customer.response!.data!['CustId'] != null || customer.response!.data!['CustId']?.isNotEmpty == true) {
            insertCustRegister(customer);

            Map<String, String?> nameParts = splitName(customer.response!.data!['firstName'].toString());
            List<String> parts = customer.response!.data!['date'].toString().split('-');
            String year = parts[0];
            String? firstName = nameParts['first'];

            var otpData = OtpPageData(subAgentmobNum: _mobileNumberController.text,
                parentAgentMobNum: _mobileNumberController.text,
                userName: firstName!, password: "$firstName@$year", tokenStatus: customer.status.toString(),
                loggedInUserType: 'NOT_AN_AGENT');
              otpPageNavigation(context,otpData );

          }
        });
      }
    }
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
              height: MediaQuery.of(context).size.height * 0.43,
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
                      onPressed: () async {
                        await SharedPref.shared.setIosNumberValidator(_mobileNumberController.text);
                        if (!isChecked) {
                          showInSnackBar("Please accept Terms & Conditions", context);
                          return;
                        }
                        isRunningLiveBaseUrl(true , _mobileNumberController.text);
                        isRunningLiveDopBaseUrl(true, _mobileNumberController.text);
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
