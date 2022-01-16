import 'package:flutter/material.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:lambox_doc/page/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormData(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
        ),
        title: "LamBox Doc",
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
