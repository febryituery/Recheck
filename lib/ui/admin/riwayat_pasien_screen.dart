import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recheck/model/document_pasien.dart';

class RiwayatPasienScreen extends StatefulWidget {
  RiwayatPasienScreen({Key key}) : super(key: key);

  @override
  _RiwayatPasienScreenState createState() {
    return _RiwayatPasienScreenState();
  }
}

class _RiwayatPasienScreenState extends State<RiwayatPasienScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nama = "";
  String email = "";
  String jk = "";
  String usia = "";
  String bpm = "";
  String suhu = "";
  String notif = "";
  String status = "";
  Future<List<DocumentPasien>> listPasien;


  @override
  void initState() {
    super.initState();
    getListData();
  }

  @override
  void dispose() {
    super.dispose();
    firestore.terminate();
  }

  void getListData() async {
    setState(() {
      listPasien = getAllDocument();
    });
  }

  Future<List<DocumentPasien>> getAllDocument() async {
    List<DocumentPasien> list = new List<DocumentPasien>();
    firestore.collection('users').get().then((value) {
      for(int i = 0; i<value.size; i++){
        DocumentPasien pasien = new DocumentPasien();
        Map<String, dynamic> data = value.docs.elementAt(i).data();
        pasien.email = value.docs.elementAt(i).id;
        pasien.nama = data['Nama'];
        firestore.collection('users').doc(value.docs.elementAt(i).id).collection('listDataPasien').snapshots().forEach((val) {
          for(int j = 0; j<val.size; j++){
            Map<String, dynamic> dataList = val.docs.elementAt(j).data();
            pasien.jk = dataList['Jenis Kelamin'];
            pasien.bpm = dataList['BPM'].toString();
            pasien.suhu = dataList['Suhu'];
            pasien.umur = dataList['Umur'].toString();
            pasien.status = dataList['Status'];
            Timestamp timestamp = dataList['Tanggal'];
            pasien.tanggal = DateFormat('dd MMMM yyyy – kk:mm').format(timestamp.toDate());
            setState(() {
              list.add(pasien);
            });
          }
        });
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Pasien"),
      ),
      body: FutureBuilder<List<DocumentPasien>>(
        future: listPasien,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.separated(
                shrinkWrap: false,
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index){
                  return Container(height: 1, color: Colors.black12);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data.elementAt(index).nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data.elementAt(index).jk),
                        Text(snapshot.data.elementAt(index).bpm+" BPM"),
                        Text(snapshot.data.elementAt(index).suhu+" \u2103"),
                        Text(snapshot.data.elementAt(index).umur+" Tahun"),
                        Text(snapshot.data.elementAt(index).tanggal),
                        Text(snapshot.data.elementAt(index).status.toUpperCase()),
                      ],
                    ),
                  );
                });
          } else if(!snapshot.hasData){
            return Center(child: Text("There is no data"));
          } else if(snapshot.hasError){
            return Center(child: Text("There is an error"));
          }
          return Container(child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}