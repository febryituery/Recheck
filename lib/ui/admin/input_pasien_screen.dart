import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recheck/utils/file_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class InputPasienScreen extends StatefulWidget {
  InputPasienScreen({Key key}) : super(key: key);

  @override
  _InputPasienScreenState createState() {
    return _InputPasienScreenState();
  }
}

class _InputPasienScreenState extends State<InputPasienScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController namaController = new TextEditingController();
  TextEditingController jkController = new TextEditingController();
  TextEditingController umurController = new TextEditingController();
  TextEditingController bpmController = new TextEditingController();
  TextEditingController suhuController = new TextEditingController();
  TextEditingController notifController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // readCsv();
  }

  void createNewData(BuildContext context, String nama, String email, int bpm, String jk, String notif, String status, String suhu, int umur) async {
    firestore.collection("users") //input data pasien melalui node user
        .doc(email)
        .get()
        .then((value) async {
          if(value.exists){
            DocumentReference ref = await firestore.collection("users").doc(email).collection("listDataPasien")
                .add({
              'BPM': bpm,
              'Jenis Kelamin': jk,
              'Notif': notif,
              'Status': status,
              'Suhu': suhu,
              'Tanggal': Timestamp.now(),
              'Umur': umur,
            });
            print(ref.id);
            Navigator.pop(context);
            sendEmail(notif, "Hasil Pemeriksaan Sdr/i ${nama}", "Halo,\nBersamaan dengan dikirimnya email ini, kami dari pihak Rumah Sakit ingin mengabarkan bahwa Sdr/i ${nama} dinyatakan ${status}.\nTerima Kasih");
          } else {
            await firestore.collection("users").doc(email).set(
                {'Nama': nama,
                'Role': 'pasien'},
              SetOptions(merge: true)
            ).then((value) async {
              DocumentReference ref2 = await firestore.collection("users").doc(email).collection("listDataPasien")
                  .add({
                'BPM': bpm,
                'Jenis Kelamin': jk,
                'Notif': notif,
                'Status': status,
                'Suhu': suhu,
                'Tanggal': Timestamp.now(),
                'Umur': umur,
              });
              print(ref2.id);
              Navigator.pop(context);
              sendEmail(notif, "Hasil Pemeriksaan Sdr/i ${nama}", "Halo,\nBersamaan dengan dikirimnya email ini, kami dari pihak Rumah Sakit ingin mengabarkan bahwa Sdr/i ${nama} dinyatakan ${status}.\nTerima Kasih");
            });
          }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    namaController.dispose();
    jkController.dispose();
    umurController.dispose();
    bpmController.dispose();
    suhuController.dispose();
    notifController.dispose();
    statusController.dispose();
    firestore.terminate();
  }

  void sendEmail(String email, String subject, String message) async { //kirim email notifikasi
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=${subject}&body=${message}'
    );
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch $_emailLaunchUri';
    }
  }

  void validateInput(BuildContext context) async {
    FormState form = this.formKey.currentState;
    ScaffoldState scaffold = this.scaffoldKey.currentState;
    if(form.validate()){
      createNewData(context, namaController.text, emailController.text, int.parse(bpmController.text), jkController.text, notifController.text, statusController.text, suhuController.text, int.parse(umurController.text));
    } else {
      scaffold.showSnackBar(SnackBar(
        content: Text('Mohon lengkapi data.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Input Data Pasien"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail), hintText: "Masukkan Email"),
                  controller: emailController,
                  validator: (val) => val.length > 0 ? null : "Isi Email"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Masukkan Nama"),
                  controller: namaController,
                  validator: (val) => val.length > 0 ? null : "Isi Nama"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_contact_calendar_sharp),
                      hintText: "Masukkan Jenis Kelamin"),
                  controller: jkController,
                  validator: (val) =>
                      val.length > 0 ? null : "Isi Jenis Kelamin"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.contact_page_sharp),
                      hintText: "Masukkan Umur"),
                  controller: umurController,
                  validator: (val) => val.length > 0 ? null : "Isi Umur"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.show_chart),
                      hintText: "Masukkan Denyut Jantung"),
                  controller: bpmController,
                  validator: (val) =>
                      val.length > 0 ? null : "Isi Denyut Jantung"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.bar_chart),
                      hintText: "Masukkan Suhu Badan"),
                  controller: suhuController,
                  validator: (val) => val.length > 0 ? null : "Isi Suhu Badan"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.notifications),
                      hintText: "Masukkan Email Notifikasi"),
                  controller: notifController,
                  validator: (val) =>
                      val.length > 0 ? null : "Isi Email Notifikasi"),
              TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.transfer_within_a_station_sharp),
                      hintText: "Masukkan Status"),
                  controller: statusController,
                  validator: (val) => val.length > 0 ? null : "Isi Status"),
              SizedBox(height: 32),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: RaisedButton(
                    splashColor: Colors.grey,
                    onPressed: () {validateInput(context);},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    //borderSide: BorderSide(color: Colors.grey),
                    child: Text(
                      'Input Data',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ),
            ],
            ),
          )
        ),
      ),
    );
  }

  // Future readCsv() async {
  //   final fileName = 'dataset.csv';
  //   final bytes = await rootBundle.load('assets/datapasienfix1.csv');
  //   final dir = (await getApplicationDocumentsDirectory()).path;
  //   final filePath = join(dir, fileName);
  //
  //   if(!File(filePath).existsSync()) {
  //     await FileUtils().writeToFile(bytes, filePath);
  //   }
  //
  //   final samples = await fromCsv(filePath, headerExists: true);
  //   final targetColumnName = 'Status';
  //   final data = <Iterable>[[1, 23, 160, 78]];
  //   final predictData = DataFrame(data, headerExists: false);
  //   final knnClass = KnnClassifier(samples, targetColumnName, 5);
  //   print("KNN Classifier : ${knnClass.predict(predictData).header.toString()}");
  //   print("KNN Classifier : ${knnClass.predict(predictData).rows.toString()}");
  // }
}