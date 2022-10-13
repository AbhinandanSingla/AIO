import 'package:dbms/services/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
