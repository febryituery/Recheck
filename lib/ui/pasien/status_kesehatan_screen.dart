import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusSehatScreen extends StatefulWidget {

  String email;
  String nama;

  StatusSehatScreen({Key key, this.email, this.nama}) : super(key: key);

  @override
  _StatusSehatScreenState createState() {
    return _StatusSehatScreenState();
  }
}

class _StatusSehatScreenState extends State<StatusSehatScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nama = "";
  String email = "";
  String jk = "";
  String usia = "";
  String bpm = "";
  String suhu = "";
  String tanggal = "";
  String notif = "";
  String status = "";

  @override
  void initState() {
    super.initState();
    checkData();
  }

  void checkData() async {
    try {
      firestore.collection('users')
          .doc(widget.email)
          .collection("listDataPasien").orderBy('Tanggal', descending: false).get()
          .then((value) {
        if (value.size > 0) {
          Map<String, dynamic> data = value.docs.last.data();
          setState(() {
            nama = widget.nama;
            email = widget.email;
            jk = data['Jenis Kelamin'];
            usia = data['Umur'].toString();
            bpm = data['BPM'].toString();
            suhu = data['Suhu']+" \u2103";
            Timestamp timestamp = data['Tanggal'];
            tanggal = DateFormat('dd MMMM yyyy – kk:mm').format(timestamp.toDate()).toString();
            notif = data['Notif'];
            status = data['Status'];
          });
        }
      });
    } catch (e){
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    firestore.terminate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Status Kesehatan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Nama                 "),
                  Text(": $nama"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Email                  "),
                  Text(": $email"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Jenis Kelamin   "),
                  Text(": $jk"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Usia                    "),
                  Text(": $usia"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("BPM                   "),
                  Text(": $bpm"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Suhu                  "),
                  Text(": $suhu"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Tanggal             "),
                  Text(": $tanggal"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Notifikasi          "),
                  Text(": $notif"),
                ],
              ),
              SizedBox(height: 32),
              Container(
                color: Colors.grey,
                padding: EdgeInsets.all(16),
                child: Text(status.toUpperCase(), style: TextStyle(
                  color: Colors.white,
                  fontSize: 24
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}