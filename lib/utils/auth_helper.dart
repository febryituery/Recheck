import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance; //inisialisasi library firebase auth

  Future<UserCredential> signInWithEmail({String email, String password}) async { //function untuk login email & password
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
    GoogleSignIn().signOut(); //logout seluruh akun google login dan firebase auth
    var shared = await SharedPreferences.getInstance();
    shared.clear(); //menghapus penyimpanan lokal (data status login, data email & username)
    return _auth.signOut();
  }
}
