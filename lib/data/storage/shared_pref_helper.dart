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

  Future<bool> getLogin() async {
    final prefs = await _getPrefs();
    return prefs.getBool(SharedPrefKeys().login) ?? false;
  }

  Future<bool> setLogin(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(SharedPrefKeys().login, value);
  }
  Future<Future<bool>> setFcmToken(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.fcm_token, value);
  }
  Future<String> getFcmToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.fcm_token) ?? '';
  }

  Future<Future<bool>> setIosNumberValidator(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.IOSNUMBERVALIDATOR, value);
  }

  Future<String> getIosNumberValidator() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.IOSNUMBERVALIDATOR) ?? '';
  }





  Future<Future<bool>> setAgentId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.userId, value);
  }
  Future<String> getAgentId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.userId) ?? '';
  }

  Future<Future<bool>> setPassword(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.password, value);
  }

  Future<String> getPassword() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.password) ?? '';
  }
  Future<Future<bool>> setSubAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgent_username, value);
  }
  Future<String> getSubAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgent_username) ?? '';
  }
  Future<Future<bool>> setUserType(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.userType, value);
  }
  Future<String> getUserType() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.userType) ?? '';
  }

  Future<Future<bool>> setRdclCustomerVendorUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.RdclCustomervendorUrl, value);
  }
  Future<String> getRdclCustomerVendorUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.RdclCustomervendorUrl) ?? '';
  }

  Future<Future<bool>> setDueListRdclUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.RdclDueListvendorUrl, value);
  }
  Future<String> getDueListRdclUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.RdclDueListvendorUrl) ?? '';
  }

  Future<Future<bool>> setCustomerRdUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.RdCustomerVendorUrl, value);
  }
  Future<String> getCustomerRdUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.RdCustomerVendorUrl) ?? '';
  }

  Future<Future<bool>> setDueListRdUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.RdDueVendorUrl, value);
  }
  Future<String> getDueListRdUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.RdDueVendorUrl) ?? '';
  }

  Future<Future<bool>> setCustomerLoanUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.LoanCustomerVendorUrl, value);
  }
  Future<String> getCustomerLoanUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.LoanCustomerVendorUrl) ?? '';
  }

  Future<Future<bool>> setDueListLoanUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.LoanDueVendorUrl, value);
  }
  Future<String> getDueListLoanUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.LoanDueVendorUrl) ?? '';
  }

  Future<Future<bool>> setLoanAccountHolderUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.LoanAccountHolderVendorUrl, value);
  }
  Future<String> getLoanAccountHolderUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.LoanAccountHolderVendorUrl) ?? '';
  }

  Future<Future<bool>> setParentAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parent_username, value);
  }
  Future<String> getParentAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parent_username) ?? '';
  }

  Future<Future<bool>> setBusinessCategory(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.selectedBusinessCategory, value);
  }
  Future<String> getBusinessCategory() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.selectedBusinessCategory) ?? '';
  }

  Future<Object> setLoggedInUserType(String value)async{
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.loggedInUserType, value) ?? '';
  }

  Future<String> getLoggedInUserType()async{
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.loggedInUserType) ?? '';

  }

  Future<Future<bool>> setParentAgentPassword(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parent_agent_password, value);
  }
  Future<String> getParentAgentPassword() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parent_agent_password) ?? '';
  }

  Future<Future<bool>> setAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.username, value);
  }

  Future<String> getAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.username) ?? '';
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


  Future<Future<bool>> setMpinValue(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mpin_value, value);
  }

  Future<String> getMpinValue() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mpin_value) ?? '';
  }

  Future<Future<bool>> setMpinStatus(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mpin_status, value);
  }

  Future<String> getMpinStatus() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mpin_status) ?? '';
  }

  Future<Future<bool>> setTokenValue(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.adsspay_token, value);
  }

  Future<String> getTokenValue() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.adsspay_token) ?? '';
  }

  Future<Future<bool>> setSubAgentMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentMobNum, value);
  }
  Future<Future<bool>> setSubAgentCodeNew(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentCodeNew, value);
  }
  Future<String> getSubAgentCodeNew() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentCodeNew) ?? '';
  }
  Future<Future<bool>> setSubAgentCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentCode, value);
  }
  Future<Future<bool>> setSubAgentId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentID, value);
  }
  Future<String> getSubAgentId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentID) ?? '';
  }
  Future<String> getSubAgentCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentCode) ?? '';
  }
  Future<String> getSubAgentMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentMobNum) ?? '';
  }

  Future<Future<bool>> setParentAgentMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parentAgentMobNum, value);
  }

  Future<String> getParentAgentMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parentAgentMobNum) ?? '';
  }
  Future<Future<bool>> setMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mob_num, value);
  }

  Future<String> getMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mob_num) ?? '';
  }

  Future<Future<bool>> setEmail(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.email, value);
  }
  Future<bool> setForceLogout(bool value) async {
    final prefs = await _getPrefs();
    return prefs.setBool(SharedPrefKeys.force_logout, value);
  }
  Future<bool> getForceLogout() async {
    final prefs = await _getPrefs();
    return prefs.getBool(SharedPrefKeys.force_logout) ?? false;
  }

  Future<String> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.email) ?? '';
  }
  Future<Future<bool>> setCustId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.custid, value);
  }
  Future<String> getCustId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.custid) ?? '';
  }
  Future<Future<bool>> setAgentOriginId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.agentOriginId, value);
  }

  Future<String> getAgentOriginId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.agentOriginId) ?? '';
  }
  Future<Future<bool>> setBranchCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.branchCode, value);
  }
  Future<String> getBranchCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.branchCode) ?? '';
  }
  Future<Future<bool>> setCorpCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.corpCode, value);
  }

  Future<String> getCorpCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.corpCode) ?? '';
  }
  Future<Future<bool>> setCardRefNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.cardRefNum, value);
  }

  Future<String> getCardRefNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.cardRefNum) ?? '';
  }
  Future<bool> clearAll() async {
    final prefs = await _getPrefs();
    return prefs.clear();
  }
}
