import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const _isLoggedIn = "is_logged_in";
  static const _userSrNo = "user_sr_no";
  static const _userName = "user_name";

  /// SAVE LOGIN DATA
  static Future<void> saveLogin({
    required String userSrNo,
    required String name,
  }) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_isLoggedIn, true);
    await pref.setString(_userSrNo, userSrNo);
    await pref.setString(_userName, name);
  }

  /// CHECK LOGIN STATUS
  static Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_isLoggedIn) ?? false;
  }

  /// GET USER SR NO
  static Future<String?> getUserSrNo() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_userSrNo);
  }

  /// GET USER NAME
  static Future<String?> getUserName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_userName);
  }

  /// LOGOUT (CLEAR ALL)
  static Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
