import 'package:flutter/material.dart';
import 'general.dart';
import 'package:provider/provider.dart';
import 'alerts.dart';
import 'constants.dart';

String? validateEmail(String? email){
  if(email == null || email.isEmpty){
    return kEmailNullError;
  }else if(!emailValidatorRegExp.hasMatch(email)){
    return kInvalidEmailError;
  }else{
    return null;
  }
}
String ? validateFullName(String? fullName){
  if(fullName == null || fullName.isEmpty){
    return kNameNullError;
  }else if(!nameRegex.hasMatch(fullName)){
    return kNameValidError;
  }else{
    return null;
  }
}
String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return kPhoneNumberNullError;
  } else if (!phoneRegex.hasMatch(phoneNumber)) {
    return kPhoneNumberValidError;
  }
  return null;
}

String? validateOtp(String? otp) {
  if (otp == null || otp.isEmpty) {
    return kOtpNullError;
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return kPassNullError;
  } else if (password.length <= 8) {
    return kShortPassError;
  } else {
    return null;
  }
}

/*String? validateConfirmPassword(BuildContext context, String? confirmPassword) {
  final passwordProvider =
  Provider.of<PasswordProvider>(context, listen: false);
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return kPassNullError;
  } else if (confirmPassword != passwordProvider.password) {
    return kMatchPassError;
  } else {
    return null;
  }
}*/

String? validatePinCode(String? pinCode) {
  if (pinCode!.isEmpty) {
    return kPinCodeNullError;
  } else if (pinCode.length < 6) {
    return kPinCodeValidError;
  }
  return null;
}

bool containsInvalidSearchCharacter(searchTerm) {
  final invalidSearchCharacters =
  RegExp(r'^[^<>{}\"/|;:.,~!?@#$%^=&*\\]\\\\()\\[¿§«»ω⊙¤°℃℉€¥£¢¡®©_+]*$');
  return searchTerm.contains(invalidSearchCharacters);
}
String? validateEmptyField(String? value) {
  if (value == null || value.isEmpty) {
    return "This field cannot be empty";
  } else {
    return null;
  }
}