
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

}
