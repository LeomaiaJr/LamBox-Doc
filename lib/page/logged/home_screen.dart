import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_doc/page/logged/appointments_screen.dart';
import 'package:lambox_doc/page/logged/help_screen.dart';
import 'package:lambox_doc/page/logged/pacients_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_doc/models/form_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool load = false;
  var userInfo;
  @override
  void initState() {
    super.initState();
    userInfo = Map.of(context.read<FormData>().loggedUserInfo);
  }

  void loadImage(BuildContext context) {
    if (!load) {
      load = true;
      precacheImage(AssetImage('assets/doc.jpg'), context);
      precacheImage(AssetImage('assets/docQuestion.jpg'), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadImage(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 1],
              colors: [Colors.white, Colors.teal[300]],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            ExactAssetImage("assets/${userInfo["gender"]}.jpg"),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width / 2.3,
                          child: Text(
                            "Olá,",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          width: width / 2.3,
                          child: Text(
                            userInfo["name"] + "!",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Image.asset(
                        "assets/lamboxlogo.png",
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF76A6D7),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Bem-vindo ao LamBox!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: width / 24,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: SizedBox(
                              width: width / 2.2,
                              child: Text(
                                "Se precisar de qualquer assistência vá em ajuda para entender melhor o aplicativo.",
                                style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: width / 26,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/doctors.jpg",
                      height: height > 400 ? height / 5.5 : height / 6,
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, bottom: 20),
                child: Text(
                  "O que você está procurando?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PacientsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: width / 3.8,
                      width: width / 3.8,
                      decoration: BoxDecoration(
                        color: Color(0xff00695c),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.users,
                            color: Colors.white,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Pacientes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 23,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: width / 3.8,
                      width: width / 3.8,
                      decoration: BoxDecoration(
                        color: Color(0xFF004d40),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.notesMedical,
                            color: Colors.white,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Consultas",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 23,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: width / 3.8,
                      width: width / 3.8,
                      decoration: BoxDecoration(
                        color: Color(0xff00695c),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.question,
                            color: Colors.white,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Ajuda",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 23,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
