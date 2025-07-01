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
  setFcmToken(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.fcm_token, value);
  }
  getFcmToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.fcm_token) ?? '';
  }
  setAgentId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.userId, value);
  }
  getAgentId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.userId) ?? '';
  }

  setPassword(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.password, value);
  }

  getPassword() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.password) ?? '';
  }
  setSubAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgent_username, value);
  }
  getSubAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgent_username) ?? '';
  }
  setUserType(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.userType, value);
  }
  getUserType() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.userType) ?? '';
  }
  setDueListUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.vendorUrlTest, value);
  }
  getDueListUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.vendorUrlTest) ?? '';
  }
  setCustomerUnderAgentUrl(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.vendorUrlLive, value);
  }
  getCustomerUnderAgentUrl() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.vendorUrlLive) ?? '';
  }
  setParentAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parent_username, value);
  }
  getParentAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parent_username) ?? '';
  }

  setParentAgentPassword(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parent_agent_password, value);
  }
  getParentAgentPassword() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parent_agent_password) ?? '';
  }

  setAgentName(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.username, value);
  }

  getAgentName() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.username) ?? '';
  }

  setMpinValue(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mpin_value, value);
  }

  getMpinValue() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mpin_value) ?? '';
  }

  setMpinStatus(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mpin_status, value);
  }

  getMpinStatus() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mpin_status) ?? '';
  }

  setTokenValue(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.adsspay_token, value);
  }

  getTokenValue() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.adsspay_token) ?? '';
  }

  setSubAgentMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentMobNum, value);
  }
  setSubAgentCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentCode, value);
  }
  setSubAgentId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.subAgentID, value);
  }
  getSubAgentId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentID) ?? '';
  }
  getSubAgentCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentCode) ?? '';
  }
  getSubAgentMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.subAgentMobNum) ?? '';
  }

  setParentAgentMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.parentAgentMobNum, value);
  }

  getParentAgentMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.parentAgentMobNum) ?? '';
  }
  setMobNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.mob_num, value);
  }

  getMobNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.mob_num) ?? '';
  }

  setEmail(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.email, value);
  }

  getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.email) ?? '';
  }

  setAgentOriginId(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.agentOriginId, value);
  }

  getAgentOriginId() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.agentOriginId) ?? '';
  }
  setCorpCode(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.corpCode, value);
  }

  getCorpCode() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.corpCode) ?? '';
  }
  setCardRefNum(String value) async {
    final prefs = await _getPrefs();
    return prefs.setString(SharedPrefKeys.cardRefNum, value);
  }

  getCardRefNum() async {
    final prefs = await _getPrefs();
    return prefs.getString(SharedPrefKeys.cardRefNum) ?? '';
  }

}
