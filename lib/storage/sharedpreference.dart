import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManger {
  static Future setVerificationId({String? value}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("VerificationId", value!);
  }

  static Future getVerificationId() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("VerificationId");
  }

  static Future setOnBoardingScreen({bool? value}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setBool("OnBoardingScree", value!);
  }

  static Future getOnBoardingScreen() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool("OnBoardingScree");
  }

  static Future dataClear() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.clear();
  }
}
