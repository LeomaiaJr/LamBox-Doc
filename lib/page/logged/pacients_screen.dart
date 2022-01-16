import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_doc/page/logged/prescription_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'dart:math';

var height;
var width;

class PacientsScreen extends StatefulWidget {
  @override
  _PacientsScreenState createState() => _PacientsScreenState();
}

class _PacientsScreenState extends State<PacientsScreen> {
  var pacients;
  bool noPacients = false;
  bool getPacientsFromFirebase = false;

  List<PacientCard> myPacients = [];

  @override
  void initState() {
    super.initState();
    getPacients();
  }

  void getPacients() async {
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
        var docId = pacients[x].id;
        print(docId);
        myPacients.add(
          PacientCard(
            name: myPacient['name'],
            gender: myPacient['gender'],
            birthday: myPacient['birthday'],
            body: myPacient['height'],
            number: randomNumber,
            docId: docId,
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
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    print(height);
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
                    "Pacientes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: height > 400 ? height / 12 : height / 15,
                left: 10,
                right: 10),
            child: Text(
                'Clique em um paciente para fazer a prescrição de remédios:'),
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
                    FontAwesomeIcons.frown,
                    color: Colors.grey,
                    size: 80,
                  ),
                  Text(
                    'Você não possui nenhum paciente.',
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

// ignore: must_be_immutable
class PacientCard extends StatelessWidget {
  final String docId;
  final String name;
  final String gender;
  final String birthday;
  final String body;
  final int number;
  PacientCard({
    this.name,
    this.gender,
    this.birthday,
    this.body,
    this.number,
    this.docId,
  });

  Color primaryColor;
  void getColor() {
    if (gender == 'feminino') {
      primaryColor = Colors.amber;
    } else {
      primaryColor = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    getColor();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Prescription(docId),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/$gender$number.png"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PacientChip(
                  myColor: primaryColor,
                  size: 3,
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  size2: 1,
                  text: name,
                ),
                SizedBox(
                  height: 10,
                ),
                PacientChip(
                  myColor: primaryColor,
                  size: 6,
                  icon: Icon(
                    FontAwesomeIcons.venusMars,
                    color: Colors.white,
                    size: 22,
                  ),
                  text: gender,
                  size2: 3,
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            LayoutBuilder(builder: (context, constraints) {
              if (width < 400) {
                return SizedBox();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PacientChip(
                      myColor: primaryColor,
                      text: birthday,
                      icon: Icon(
                        FontAwesomeIcons.birthdayCake,
                        color: Colors.white,
                        size: 22,
                      ),
                      size: 3,
                      size2: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PacientChip(
                      myColor: primaryColor,
                      size: 3,
                      icon: Icon(
                        FontAwesomeIcons.child,
                        color: Colors.white,
                        size: 22,
                      ),
                      text: body,
                      size2: 3,
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class PacientChip extends StatelessWidget {
  final String text;
  final Icon icon;
  final double size;
  final double size2;
  final Color myColor;
  const PacientChip({
    this.text,
    this.icon,
    this.size,
    this.size2,
    this.myColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: size, left: size2),
            child: icon,
          ),
          Padding(
            padding: EdgeInsets.only(right: 2),
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
