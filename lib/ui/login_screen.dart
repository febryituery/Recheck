import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recheck/ui/admin/home_screen_admin.dart';
import 'package:recheck/ui/pasien/home_screen_pasien.dart';
import 'package:recheck/utils/auth_helper.dart';
import 'package:recheck/utils/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']); // digunakan untuk mengambil data login email gmail
  FirebaseFirestore firestore = FirebaseFirestore.instance; //inisialisasi library firestore

  _login() async{
    try{
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser.toString());
      _googleSignIn.isSignedIn().then((value) async {
        if (value) {
          checkUserExist(_googleSignIn.currentUser.email);
        }
      });
    } catch (err){
      print(err);
    }
  }

  void checkUserExist(String email) async {
    try {
      firestore.collection('users')
          .doc(email)
          .get()
          .then((value) {
        if (value.exists) {
          Map<String, dynamic> data = value.data();
          if(data['Role'] == "admin") { //jika admin, maka
            SharedPref().setPrefBool("isLogin", true);
            SharedPref().setPrefString("email", email);
            SharedPref().setPrefString("nama", data['Nama']); //data field di firestore
            SharedPref().setPrefString("role", data['Role']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreenAdmin(
                      nama: data['Nama'],
                      email: email,
                    ),
              ),
            );
          } else if (data['Role'] == "pasien"){ // jika pasien, maka
            SharedPref().setPrefBool("isLogin", true);
            SharedPref().setPrefString("email", email);
            SharedPref().setPrefString("nama", data['Nama']);
            SharedPref().setPrefString("role", data['Role']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreenPasien(
                      nama: data['Nama'],
                      email: email,
                    ),
              ),
            );
          }
        }
      });
    } catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin(); //function untuk melakukan pengecekan apakah user sudah pernah login. jika sudah, langsung ke halaman home
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firestore.terminate();
  }

  void checkLogin() async {
    if(await SharedPref().getPrefBool("isLogin")) {
      if(await SharedPref().getPrefString("role") == "admin"){
        var nama = await SharedPref().getPrefString("nama");
        var email = await SharedPref().getPrefString("email");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreenAdmin(
                  nama: nama,
                  email: email,
                ),
          ),
        );
      } else {
        var nama = await SharedPref().getPrefString("nama");
        var email = await SharedPref().getPrefString("email");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreenPasien(
                  nama: nama,
                  email: email,
                ),
          ),
        );
      }
    }
    return;
  }

  bool _isHidePassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void validateInput() async {
    FormState form = this.formKey.currentState;
    ScaffoldState scaffold = this.scaffoldKey.currentState;

    if (form.validate()) {
      try {
        await AuthHelper().signInWithEmail(
            email: _emailController.text,
            password: _passwordController.text)
            .then((res) {
          print("Login Berhasil!");
          scaffold.showSnackBar(SnackBar(
            content: Text('Proses Login Sukses..'),
          ));
          checkUserExist(res.user.email);
        });
      } catch (e) {
        print(e);
        scaffold.showSnackBar(SnackBar(
          content: Text('Akun tidak ditemukan. Harap hubungi admin.'),
        ));
      }
    }

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      print("Email dan password harus terisi!");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue[400]],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                  image: DecorationImage(
                      image: AssetImage('images/bg.png'), fit: BoxFit.fill),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 56,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Welcome Back,',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.25,
                                fontWeight: FontWeight.bold,
                                fontSize: 29),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Login with your account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                letterSpacing: 0.5,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      Container(
                        height: 27.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          hintText: 'Masukkan Email Anda',
                          hintStyle: TextStyle(
                              fontSize: 17,
                              letterSpacing: 0.5,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                          labelText: 'Email:',
                          labelStyle: TextStyle(
                              fontSize: 19,
                              letterSpacing: 1.5,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          icon: const Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 30,
                              ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          fillColor: Colors.white.withOpacity(.3),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val.length < 5 ? 'Email Anda Tidak Lengkap.' : null,
                      ),
                      Container(
                        height: 17.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isHidePassword,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          hintText: 'Masukkan Password Anda',
                          hintStyle: TextStyle(
                              fontSize: 17,
                              letterSpacing: 0.5,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                          labelText: 'Password:',
                          labelStyle: TextStyle(
                              fontSize: 19,
                              letterSpacing: 1.5,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          icon: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 30,
                              ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          fillColor: Colors.white.withOpacity(.3),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _togglePasswordVisibility();
                            },
                            child: Icon(
                              _isHidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  _isHidePassword ? Colors.white : Colors.grey,
                            ),
                          ),
                          isDense: true,
                        ),
                        validator: (val) =>
                            val.length < 6 ? 'Password Anda Salah.' : null,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      ButtonTheme(
                          buttonColor: Colors.white,
                          //minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          child: RaisedButton(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 0.7,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            onPressed: validateInput,
                          ),
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          'OR',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.9,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                  RaisedButton(
                    splashColor: Colors.grey,
                    onPressed: () {
                      _login();
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    //borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage("images/google.png"), height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                      SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                ),
                ),
              ),
            ),
          ),
        ));
  }
}