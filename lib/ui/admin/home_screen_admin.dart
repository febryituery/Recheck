import 'package:flutter/material.dart';
import 'package:recheck/ui/admin/input_pasien_screen.dart';
import 'package:recheck/ui/admin/riwayat_pasien_screen.dart';
import 'package:recheck/utils/auth_helper.dart';
import 'package:recheck/utils/shared_preferences.dart';

class HomeScreenAdmin extends StatefulWidget {
  String nama;
  String email;

  HomeScreenAdmin({Key key, this.nama, this.email}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenAdmin> {
  String nama;
  String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDataLogin();
  }

  void checkDataLogin() async {
    var nam = await SharedPref().getPrefString("nama");
    var ema = await SharedPref().getPrefString("email");
    setState(() {
      nama = nam;
      email = ema;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - ${nama}'),
      ),
      body: SafeArea(
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  child: RaisedButton(
                    child: Text("Input Pasien"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InputPasienScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: RaisedButton(
                    child: Text("Riwayat Pasien"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RiwayatPasienScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: RaisedButton(
                    child: Text("Log Out"),
                    onPressed: () {
                      AuthHelper.logOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
