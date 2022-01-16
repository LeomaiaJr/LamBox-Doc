import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';

class Prescription extends StatefulWidget {
  final String docId;
  Prescription(this.docId);
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  String pill1;
  String time1;

  String pill2;
  String time2;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Prescrição de Remédios'),
          primary: false,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, right: 20, left: 20),
              child: TextField(
                onChanged: (value) {
                  pill1 = value;
                },
                style: TextStyle(color: Colors.teal),
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  labelText: 'Remédio 1',
                  labelStyle: TextStyle(color: Colors.teal),
                  icon: Icon(FontAwesomeIcons.pills, color: Colors.teal),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 10),
              child: TextField(
                onChanged: (value) {
                  time1 = value;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  labelText: 'Hora',
                  labelStyle: TextStyle(color: Colors.teal),
                  icon: Icon(FontAwesomeIcons.clock, color: Colors.teal),
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: TextField(
                onChanged: (value) {
                  pill2 = value;
                },
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  labelText: 'Remédio 2',
                  labelStyle: TextStyle(color: Colors.teal),
                  icon: Icon(FontAwesomeIcons.pills, color: Colors.teal),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  time2 = value;
                },
                style: TextStyle(color: Colors.teal),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                  labelText: 'Hora',
                  labelStyle: TextStyle(color: Colors.teal),
                  icon: Icon(FontAwesomeIcons.clock, color: Colors.teal),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, right: 10, left: 10),
              child: FlatButton(
                color: Colors.teal,
                child: Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  await Firebase.initializeApp();
                  final FirebaseFirestore _firestore =
                      FirebaseFirestore.instance;
                  _firestore
                      .collection("Doctors")
                      .doc(context.read<FormData>().loggedUserInfo['docId'])
                      .collection("pacientes")
                      .doc(widget.docId)
                      .set(
                    {
                      'pill1': pill1,
                      'time1': time1,
                      'pill2': pill2,
                      'time2': time2,
                    },
                    SetOptions(merge: true),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
