import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatSehatScreen extends StatefulWidget {

  String email;

  RiwayatSehatScreen({Key key, this.email}) : super(key: key);

  @override
  _RiwayatSehatScreenState createState() {
    return _RiwayatSehatScreenState();
  }
}

class _RiwayatSehatScreenState extends State<RiwayatSehatScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nama = "";
  String email = "";
  String jk = "";
  String usia = "";
  String bpm = "";
  String suhu = "";
  String notif = "";
  String status = "";

  @override
  void initState() {
    super.initState();
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
        title: Text("Riwayat Kesehatan"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('users')
            .doc(widget.email)
            .collection("listDataPasien").orderBy('Tanggal', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There is no data");
          return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (context, index){
                return Container(height: 1, color: Colors.black12);
              },
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snapshot.data.docs.elementAt(index).data();
                Timestamp timestamp = data['Tanggal'];
                return ListTile(
                  title: Text(DateFormat('dd MMMM yyyy – kk:mm').format(timestamp.toDate())),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['Jenis Kelamin']),
                      Text(data['BPM'].toString()+" BPM"),
                      Text(data['Suhu']+" \u2103"),
                      Text(data['Umur'].toString()+" Tahun"),
                      Text(data['Status'].toString().toUpperCase()),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}