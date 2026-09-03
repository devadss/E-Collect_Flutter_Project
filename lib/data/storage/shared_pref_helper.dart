import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class SharedPref {
  static final SharedPref _singleton = SharedPref._internal();
  factory SharedPref() => _singleton;
  SharedPref._internal();

  static SharedPref get shared => _singleton;
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }


  Future<Future<bool>> setFcmToken(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.fcm_token, value);
  }
  Future<String> getFcmToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.fcm_token) ?? '';
  }


  Future<Future<bool>> setBusinessCategory(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.selectedBusinessCategory, value);
  }
  Future<String> getBusinessCategory() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.selectedBusinessCategory) ?? '';
  }


  //e-Collect////////
  Future<bool> setECollectTypeList(
      List<String> types,
      ) async {
    final prefs = await _getPrefs();

    return prefs.setString(
      SharedPrefKeys.eCollectTypes,
      jsonEncode(types),
    );
  }

  Future<List<String>> getECollectTypeList() async {
    final prefs = await _getPrefs();

    final value = prefs.getString(
      SharedPrefKeys.eCollectTypes,
    );

    if (value == null) return [];

    return List<String>.from(jsonDecode(value));
  }


  Future<bool> setECollectUrlList(
      List<String> types,
      ) async {
    final prefs = await _getPrefs();

    return prefs.setString(
      SharedPrefKeys.eCollectUrlList,
      jsonEncode(types),
    );
  }

  Future<List<String>> getECollectUrlList() async {
    final prefs = await _getPrefs();

    final value = prefs.getString(
      SharedPrefKeys.eCollectUrlList,
    );

    if (value == null) return [];

    return List<String>.from(jsonDecode(value));
  }

  Future<Future<bool>> setExternalAgentID(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectAgentId, value);
  }

  Future<String> getExternalAgentID() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectAgentId) ?? '';
  }

  Future<Future<bool>> setECollectExternalBranchCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectBranchId, value);
  }

  Future<String> getECollectExternalBranchCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectBranchId) ?? '';
  }

  Future<Future<bool>> setECollectMerchantRegName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectMerchantRegName, value);
  }

  Future<String> getECollectMerchantRegName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectMerchantRegName) ?? '';
  }

  Future<Future<bool>> setECollectUserRole(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectUserRole, value);
  }

  Future<String> getECollectUserRole() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectUserRole) ?? '';
  }

  Future<Future<bool>> setECollectCommRate(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectCommRate, value);
  }

  Future<String> getECollectCommRate() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectCommRate) ?? '';
  }

  Future<Future<bool>> setECollectBranchName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectBranchName, value);
  }

  Future<String> getECollectBranchName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectBranchName) ?? '';
  }

  Future<Future<bool>> setECollectMerchantBranchCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectMerchantBranchCode, value);
  }

  Future<String> getECollectMerchantBranchCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectMerchantBranchCode) ?? '';
  }

  Future<Future<bool>> setECollectMerchantIntegrationStatus(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectMerchantIntegrationStatus, value);
  }

  Future<String> getECollectMerchantIntegrationStatus() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectMerchantIntegrationStatus) ?? '';
  }

  Future<Future<bool>> setECollectMerchantUserName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectUsername, value);
  }

  Future<String> getECollectMerchantName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectUsername) ?? '';
  }

  Future<Future<bool>> setECollectUserType(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectUserType, value);
  }

  Future<String> getECollectUserType() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectUserType) ?? '';
  }



  Future<Future<bool>> setECollectRdclCustomerunderAgentListUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectRdclCustomerunderAgentList, value);
  }

  Future<String> getECollectRdclCustomerunderAgentListUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectRdclCustomerunderAgentList) ?? '';
  }

  Future<Future<bool>> setECollectRdclDuesListunderAgentUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectRdclDueLisUnderAgent, value);
  }
  Future<String> getECollectRdclDuesListunderAgentUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectRdclDueLisUnderAgent) ?? '';
  }



  Future<bool> getECollectActiveStatus() async {
    final prefs = await _getPrefs();
    return prefs.getBool(SharedPrefKeys().eCollectActiveStatus) ?? false;
  }

  Future<bool> setECollectActiveStatus(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(SharedPrefKeys().eCollectActiveStatus, value);
  }


  Future<bool> getECollectVerifyStatus() async {
    final prefs = await _getPrefs();
    return prefs.getBool(SharedPrefKeys().eCollectVerifyStatus) ?? false;
  }

  Future<bool> setECollectVerifyStatus(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(SharedPrefKeys().eCollectVerifyStatus, value);
  }

  Future<Future<bool>> setECollectToken(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectToken, value);
  }

  Future<String> getECollectUserToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectToken) ?? '';
  }
  Future<Future<bool>> setECollectRefreshToken(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectRefreshToken, value);
  }

  Future<String> getECollectRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectRefreshToken) ?? '';
  }
  Future<Future<bool>> setECollectUserNumber(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectUserNumber, value);
  }

  Future<String> getECollectUserNumber() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectUserNumber) ?? '';
  }

  Future<Future<bool>> setECollectMerchantID(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectMerchantId, value);
  }

  Future<String> getECollectMerchantID() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectMerchantId) ?? '';
  }

  Future<Future<bool>> setECollectUserID(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.eCollectUserId, value);
  }

  Future<String> getECollectUserID() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.eCollectUserId) ?? '';
  }

  Future<bool> getECollectLoginStatus() async {
    final prefs = await _getPrefs();
    return prefs.getBool(SharedPrefKeys().eCollectLoginStatus) ?? false;
  }

  Future<bool> setECollectLoginStatus(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(SharedPrefKeys().eCollectLoginStatus, value);
  }

  Future<Future<bool>> setECollectUserEmail(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys().eCollectUserEmail, value);
  }

  Future<String> getECollectUserEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys().eCollectUserEmail) ?? '';
  }



  //e-Collect////////


  Future<bool> clearAll() async {
    final prefs = await _getPrefs();
    return prefs.clear();
  }
}
