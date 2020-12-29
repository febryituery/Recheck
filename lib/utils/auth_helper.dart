import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail({String email, String password}) async {
    return _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  static logOut() async {
    GoogleSignIn().signOut();
    var shared = await SharedPreferences.getInstance();
    shared.clear();
    return _auth.signOut();
  }
}
