import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lambox_doc/page/logged/home_screen.dart';
import 'package:lambox_doc/widget/lambox_form.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lambox_doc/utils/networking.dart';

NetWorkHelper myCords = NetWorkHelper();

class RegisterEmail extends StatefulWidget {
  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  bool logging = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: logging,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height / 12,
              ),
              Container(
                child: Hero(
                  tag: 'lamboxLogo',
                  child: Image.asset(
                    'assets/lamboxlogo.png',
                    height: height / 4,
                  ),
                ),
              ),
              Expanded(
                child: ClipPath(
                  clipper: WaveClipperOne(reverse: true),
                  child: Container(
                    color: Colors.teal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 70, left: 30),
                          child: Text(
                            "Para finalizar, digite seu e-mail e senha:",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 20),
                          child: LamBoxForm(
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            textType: 'E-mail',
                            iconType: Icons.person,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 30),
                          child: LamBoxForm(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textType: 'Senha',
                            iconType: Icons.lock,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Colors.white,
                                onPressed: () async {
                                  print(context
                                      .read<FormData>()
                                      .registrationFormItems);
                                  context.read<FormData>().emailRegistration();
                                  if (!context
                                      .read<FormData>()
                                      .emailRegistrationVerifier) {
                                    return Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "Erro!",
                                      desc:
                                          "Complete todos os campos com informações válidas",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  } else {
                                    setState(() {
                                      logging = true;
                                    });
                                    var registrationData = context
                                        .read<FormData>()
                                        .registrationFormItems;
                                    var cords = await myCords.getMyData(
                                      registrationData[7],
                                    );
                                    var lat =
                                        cords['results'][0]['geometry']['lat'];
                                    var lng =
                                        cords['results'][0]['geometry']['lng'];
                                    final _auth = FirebaseAuth.instance;
                                    final newUser = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: registrationData[10],
                                            password: registrationData[11]);
                                    var token;
                                    if (newUser != null) {
                                      print("Deu certo");
                                      token =
                                          FirebaseAuth.instance.currentUser.uid;
                                      print(token);
                                    }
                                    await Firebase.initializeApp();
                                    final FirebaseFirestore _firestore =
                                        FirebaseFirestore.instance;
                                    var userId = _firestore
                                        .collection("Doctors")
                                        .doc()
                                        .id
                                        .toString();
                                    _firestore
                                        .collection("Doctors")
                                        .doc(userId)
                                        .set({
                                      "name": registrationData[2],
                                      "gender": registrationData[3],
                                      "expertise": registrationData[4],
                                      "phoneNumber": registrationData[5],
                                      "clinic": registrationData[6],
                                      "street": registrationData[7],
                                      "number": registrationData[8],
                                      "city": registrationData[9],
                                      "id": token,
                                      "lat": lat,
                                      "lng": lng,
                                    }).then((value) {
                                      context.read<FormData>().updateMap({
                                        "name": registrationData[2],
                                        "gender": registrationData[3],
                                        "expertise": registrationData[4],
                                        "phoneNumber": registrationData[5],
                                        "clinic": registrationData[6],
                                        "street": registrationData[7],
                                        "number": registrationData[8],
                                        "city": registrationData[9],
                                        "id": token,
                                        "docId": userId,
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomeScreen()),
                                          (Route<dynamic> route) => false);
                                    });
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
