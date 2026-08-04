import 'package:collection_qr_flutter/core/utils.dart';
import 'package:collection_qr_flutter/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/basic_registartion/request/basic_registration_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors.dart';
import '../../auth/login/otp_verification/otp_verification.dart';

class BasicRegistration extends StatefulWidget {
  const BasicRegistration({super.key});

  @override
  State<BasicRegistration> createState() => _BasicRegistrationState();
}

class _BasicRegistrationState extends State<BasicRegistration> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? emailError;
  String? lastNameError;
  String? firstNameError;
  String? mobileError;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  String? confirmPasswordError;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    emailError = "";
    mobileError = "";
    confirmPasswordError = "";

    super.dispose();
  }

/////*****************VALIDATION LOGIC***********
  void validateConfirmPassword() {
    setState(() {
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Confirm password is required";
      } else if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });
  }
  bool isValidEmail(String email) {
    return RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }
/////********************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
          if (state is BasicRegistrationLoaderState) {
            showProgressDialog(context);
          }
          if (state is BasicRegistrationSuccessState) {
            Navigator.pop(context);
            if (state.basicRegistrationSuccessModel
                    .basicRegistrationSuccessResponse.requiresOtpVerification ==
                true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Registration successful. Please verify OTP")));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext cotext) =>
                          OtpRequestVerificationPage(
                            testOtp: state.basicRegistrationSuccessModel.basicRegistrationSuccessResponse.otp,
                            userId: state.basicRegistrationSuccessModel
                                .basicRegistrationSuccessResponse.userId,
                            mobileNumber: mobileNumberController.text,
                          )));
            }
          }
          else if (state is BasicRegistrationFailureState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.basicRegistrationFailureModel
                    .basicRegistrationErrorResponse.message)));
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 190,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),

                    /// 🌈 SOFT BACKGROUND
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    /// 💎 SHADOW
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      "assets/images/checklist.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                "Let's Complete the registration",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: TextField(
                  maxLength: 15,
                  keyboardType: TextInputType.name,
                  controller: firstNameController,
                  onChanged: (value){
                    setState(() {
                      if(firstNameController.text.isEmpty){
                        firstNameError = "First Name is required";
                      }else{
                        firstNameError = null;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    errorText: firstNameError,
                      counterText: "",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                          child: Icon(
                            size: 15,
                            Icons.person,
                            color: Color(0xFFEA307B),
                          ),
                        ),
                      ),
                      fillColor: lightPink,
                      filled: true,
                      label: Text("First Name"),
                      hintText: "Enter First Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: TextField(
                  maxLength: 15,
                  keyboardType: TextInputType.name,
                  controller: lastNameController,

                    onChanged: (value){
                      setState(() {
                        if(lastNameController.text.isEmpty){
                          lastNameError = "Last Name is required";
                        }else{
                          lastNameError = null;
                        }
                      });

                  },
                  decoration: InputDecoration(
                    errorText: lastNameError,
                      counterText: "",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

                              color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                          child: Icon(
                            size: 15,
                            Icons.person,
                            color: Color(0xFFEA307B),
                          ),
                        ),
                      ),
                      fillColor: lightPink,
                      filled: true,
                      label: Text("Last Name"),
                      hintText: "Enter Last Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        emailError = "Email is required";
                      } else if (!isValidEmail(value)) {
                        emailError = "Enter a valid email";
                      } else {
                        emailError = null;
                      }
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      errorText: emailError,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                          child: Icon(
                            size: 15,
                            Icons.mail,
                            color: Color(0xFFEA307B),
                          ),
                        ),
                      ),
                      fillColor: lightPink,
                      filled: true,
                      label: const Text("Email"),
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        mobileError = "Mobile number is required";
                      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        mobileError = "Enter a valid mobile number";
                      } else {
                        mobileError = null;
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: mobileNumberController,
                  maxLength: 10,
                  decoration: InputDecoration(
                      errorText: mobileError,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                          child: Icon(
                            size: 15,
                            Icons.phone,
                            color: Color(0xFFEA307B),
                          ),
                        ),
                      ),
                      fillColor: lightPink,
                      filled: true,
                      counterText: "",
                      label: const Text("Mobile number"),
                      hintText: "Enter Mobile number",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15,right: 5),
                    child: TextField(
                      obscureText: _isPasswordHidden,
                      maxLength: 6,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      decoration: InputDecoration(
                          counterText: "",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                              child: Icon( size: 15,
                                Icons.password,
                                color: Color(0xFFEA307B),
                              ),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: 15,
                              _isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          ),
                          fillColor:lightPink,
                          filled: true,
                          label: const Text("Password", style: TextStyle(fontSize: 12),),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(fontSize: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only( right: 20, top: 15),
                    child: TextField(
                      obscureText: _isConfirmPasswordHidden,
                      keyboardType: TextInputType.text,
                      controller: confirmPasswordController,
                      maxLength: 6,
                      decoration: InputDecoration(
                          errorText: confirmPasswordError,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color(0xFFEA307B).withValues(alpha: 0.1)),
                              child: Icon(
                                size: 15,
                                Icons.password,
                                color: Color(0xFFEA307B),
                              ),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: 15,
                              _isConfirmPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                              });
                            },
                          ),
                          fillColor: lightPink,
                          filled: true,
                          counterText: "",
                          label: const Text("Confirm Password", style: TextStyle(fontSize: 12),),
                          hintText: "Re-Enter Password",
                          hintStyle: TextStyle(fontSize: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10))),
                      onChanged: (_) => validateConfirmPassword(),
                    ),
                  ),
                ),
              ],),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: SizedBox(
                    width: double.infinity, child: registerButton(context)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void doRegistration() {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length == 6 &&
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.length == 6) {
      context.read<AuthenticationBloc>().add(BasicRegistrationEvent(
          BasicUserRegisterModel(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              phone: mobileNumberController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              roleId: 0,
              merchantId: 0,
              branchId: 0,
              agentId: 0)));
    } else {
      setState(() {
        if(lastNameController.text.isEmpty){
          lastNameError = "Last Name is required";
        }
        if(firstNameController.text.isEmpty){
          firstNameError = "First Name is required";
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("Empty filed's not allowed")));
    }
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        doRegistration();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEA307B),
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shadowColor: const Color(0xFFEA307B).withValues(alpha: 0.3),
      ),
      child: Text(
        "REGISTER",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
