import 'package:flutter/material.dart';
import 'package:recheck/ui/pasien/riwayat_kesehatan_screen.dart';
import 'package:recheck/ui/pasien/status_kesehatan_screen.dart';
import 'package:recheck/utils/auth_helper.dart';
import 'package:recheck/utils/shared_preferences.dart';

class HomeScreenPasien extends StatefulWidget {
  String nama;
  String email;

  HomeScreenPasien({Key key, this.nama, this.email}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenPasien> {
  String nama;
  String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDataLogin(); //digunakan untuk memanggil data nama & email dari penyimpanan lokal
    Navigator.pop(context);
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
        title: Text('Pasien - ${nama}'),
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  child: RaisedButton(
                    child: Text("Status Kesehatan"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StatusSehatScreen(
                                email: email,
                                nama: nama,
                              ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: RaisedButton(
                    child: Text("Riwayat Check Up"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RiwayatSehatScreen(
                                email: email,
                              ),
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
