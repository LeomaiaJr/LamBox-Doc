import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:lambox_doc/page/register_email.dart';
import 'package:lambox_doc/widget/animated_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  var registrationUserData = [];
  String userRegistrationState = "Fazendo cadastro...";
  String userId;

  int changesNumber = 0;

  bool registration = false;

  void waitTime() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      userRegistrationState = "Esperando aprovação da Equipe Lambox...";
    });
    listenAprovation();
  }

  @override
  void initState() {
    super.initState();

    for (var i = 2; i < 10; i++) {
      var registrationData = context.read<FormData>().registrationFormItems[i];
      registrationUserData.add(registrationData);
    }
    registerUserInFirebase();
  }

  void listenAprovation() {
    var userQuery = FirebaseFirestore.instance
        .collection('newDoctors')
        .where('name',
            isEqualTo: context.read<FormData>().registrationFormItems[2])
        .limit(1);
    StreamSubscription subscription;

    subscription = userQuery.snapshots().listen((data) {
      data.docChanges.forEach((change) {
        changesNumber++;
        print(changesNumber);
        if (changesNumber > 1) {
          subscription.cancel();
          deleteUserDocument();
        }
      });
    });
  }

  void deleteUserDocument() async {
    setState(() {
      userRegistrationState = "Cadastro Aprovado!";
    });
    await FirebaseFirestore.instance
        .collection("newDoctors")
        .doc(userId)
        .delete();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterEmail(),
      ),
    );
  }

  void registerUserInFirebase() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    userId = _firestore.collection("users").doc().id.toString();
    _firestore.collection("newDoctors").doc(userId).set({
      "name": registrationUserData[0],
      "gender": registrationUserData[1],
      "expertise": registrationUserData[2],
      "phoneNumber": registrationUserData[3],
      "clinic": registrationUserData[4],
      "street": registrationUserData[5],
      "number": registrationUserData[6],
      "city": registrationUserData[7],
      "approved": false,
    }).then((value) {
      setState(() {
        userRegistrationState = "Cadastro feito com sucesso!";
        registration = true;
      });
      waitTime();
    }).catchError((err) {
      print(err);
      setState(() {
        userRegistrationState = "Erro ao realizar o cadastro, tente novamente!";
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 4,
            child: LoadingPage(),
          ),
          SizedBox(
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userRegistrationState,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 30),
                SpinKitThreeBounce(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                          color: index.isEven ? Colors.teal : Colors.green,
                          shape: BoxShape.circle),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
