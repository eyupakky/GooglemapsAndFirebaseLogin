import 'package:evreka_technical_question/api/auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static const String _USER_EMAIL = "email";
  static const String _USER_LOGIN = "login";

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    email = email.trim();
    password = password.trim();
    bool login = await getUserLogin();
    AuthApi authApi = AuthApi();
    if (login==null || !login) {
      String result = await authApi.login(email, password);
      await setUserData(result);
      return Future.value(result);
    } else {
      String result = await getUserData();
      return Future.value(result);
    }
  }

  Future<void> setUserData(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_USER_EMAIL, email);
    prefs.setBool(_USER_LOGIN, true);
  }

  Future<bool> getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(_USER_LOGIN);
  }

  Future<String> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(_USER_EMAIL);
  }
}
