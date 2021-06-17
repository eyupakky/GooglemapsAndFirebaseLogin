import 'package:firebase_auth/firebase_auth.dart';

class AuthApi {
  Future<String> login(String email, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
      return userCredential.user.email;
    } on FirebaseAuthException catch (e) {
     return e.code;
    } catch (e) {
      print(e);
    }
  }
}
