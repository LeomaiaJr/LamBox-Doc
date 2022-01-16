import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lambox_doc/page/logged/home_screen.dart';
import 'package:lambox_doc/page/logged/pacients_screen.dart';
import 'package:lambox_doc/page/register_screen.dart';
import 'package:lambox_doc/widget/lambox_form.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool logging = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 100),
                          child: LamBoxForm(
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            textType: 'E-mail',
                            iconType: Icons.person,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20),
                          child: LamBoxForm(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textType: 'Senha',
                            iconType: Icons.lock,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width / 4,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterScreen(height),
                                  ),
                                );
                              },
                              child: Text(
                                "Registrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              onPressed: () async {
                                context.read<FormData>().verifyLogin();
                                if (!context.read<FormData>().loginVerifier) {
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
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                } else {
                                  setState(() {
                                    logging = true;
                                  });
                                  await Firebase.initializeApp();
                                  String email = context
                                      .read<FormData>()
                                      .loginCredentials[0];
                                  String password = context
                                      .read<FormData>()
                                      .loginCredentials[1];
                                  final _auth = FirebaseAuth.instance;
                                  var loggedUser =
                                      await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  print('testesadasdas');
                                  if (loggedUser != null) {
                                    var id = _auth.currentUser.uid;
                                    final FirebaseFirestore _firestore =
                                        FirebaseFirestore.instance;
                                    var data = await _firestore
                                        .collection('Doctors')
                                        .where('id', isEqualTo: id)
                                        .get();
                                    var userInfo = data.docs.single.data();
                                    var documentId = data.docs.single.id;
                                    context.read<FormData>().updateMap({
                                      "name": userInfo['name'],
                                      "gender": userInfo['gender'],
                                      "expertise": userInfo['expertise'],
                                      "phoneNumber": userInfo['phoneNumber'],
                                      "clinic": userInfo['clinic'],
                                      "street": userInfo['street'],
                                      "number": userInfo['number'],
                                      "city": userInfo['city'],
                                      "id": userInfo['id'],
                                      "docId": documentId,
                                    });
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomeScreen()),
                                        (Route<dynamic> route) => false);
                                  }
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
