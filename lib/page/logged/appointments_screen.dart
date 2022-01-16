import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  var pacients;
  bool noPacients = false;
  bool getPacientsFromFirebase = false;

  List<AppointmentCard> myPacients = [];

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  void getAppointments() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var pacientsFromFirebase = await _firestore
        .collection("Doctors")
        .doc(context.read<FormData>().loggedUserInfo["docId"])
        .collection("pacientes")
        .get();
    pacients = pacientsFromFirebase.docs;
    if (pacients.length == 0) {
      setState(() {
        noPacients = true;
      });
    }
    if (!noPacients) {
      for (var x = 0; x < pacients.length; x++) {
        Random random = Random();
        int randomNumber = random.nextInt(3) + 1;
        print(randomNumber);
        var myPacient = pacients[x].data();
        myPacients.add(
          AppointmentCard(
            name: myPacient['name'],
            time: myPacient['appointment'],
          ),
        );
      }
      setState(() {
        getPacientsFromFirebase = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: height / 20,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Image.asset('assets/doc.jpg'),
              ),
              Positioned(
                top: height / 3.3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.teal,
                  ),
                  child: Text(
                    "Consultas",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height > 400 ? height / 25 : height / 25,
          ),
          if (!getPacientsFromFirebase && !noPacients)
            Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
              ),
            ),
          if (getPacientsFromFirebase)
            Expanded(
              child: Theme(
                data: ThemeData(
                  accentColor: Color(0xFFC9E7F2),
                ),
                child: ListView(
                  children: myPacients,
                ),
              ),
            ),
          if (noPacients)
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendarTimes,
                    color: Colors.grey,
                    size: 80,
                  ),
                  Text(
                    'Você não possui nenhuma consulta.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  const AppointmentCard({this.name, this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 50, left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.calendarDay,
            color: Colors.teal,
            size: 70,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentChip(
                text: name,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                size: 3,
                size2: 3,
              ),
              SizedBox(
                height: 10,
              ),
              AppointmentChip(
                text: time,
                icon: Icon(
                  FontAwesomeIcons.clock,
                  color: Colors.white,
                ),
                size: 3,
                size2: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentChip extends StatelessWidget {
  final String text;
  final Icon icon;
  final double size;
  final double size2;
  const AppointmentChip({
    this.text,
    this.icon,
    this.size,
    this.size2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: size, left: size2),
            child: icon,
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
