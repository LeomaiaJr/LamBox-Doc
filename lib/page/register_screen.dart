import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_doc/models/form_data.dart';
import 'package:lambox_doc/page/waiting_screen.dart';
import 'package:lambox_doc/widget/lambox_form.dart';
import 'package:lambox_doc/widget/lambox_form_focus.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterScreen extends StatefulWidget {
  final double height;
  RegisterScreen(this.height);
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final FocusNode _focus = FocusNode();
  bool focus = false;

  final FocusNode _focus2 = FocusNode();
  bool focus2 = false;

  bool containerAnimate = true;
  bool containerAnimate2 = false;
  bool firstForm = true;
  bool secondForm = true;

  AnimationController controller;

  AnimationController containerController;
  Animation animation;

  AnimationController heightController;
  Animation<double> heightAnimation;

  double myOpacity = 1;
  bool hasAnimate = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {
        focus = !focus;
      });
      if (!hasAnimate) {
        controller.reverse(from: 1);
        hasAnimate = true;
      }
    });

    _focus2.addListener(() {
      setState(() {
        focus2 = !focus2;
      });
    });

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        containerAnimate = false;
        containerAnimate2 = true;
        containerController.reverse(from: 1);
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {
        myOpacity = controller.value;
        print(myOpacity);
      });
    });

    containerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    animation = CurvedAnimation(
      parent: containerController,
      curve: Curves.easeInQuint,
    );

    containerController.addListener(() {
      setState(() {
        print((animation.value * 100));
        if (animation.value < 0) {
          containerAnimate2 = false;
        }
      });
    });

    heightController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    heightAnimation = Tween<double>(begin: 0.0, end: widget.height / 1.35)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(heightController);

    heightAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        secondForm = false;
        heightController.reverse(from: widget.height / 1.35);
      }
    });

    heightController.addListener(() {
      setState(() {
        print(heightAnimation.value);
        if (!secondForm && heightAnimation.value == 0) {
          _focus2.requestFocus();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: 'lamboxLogo',
                  child: Image.asset(
                    'assets/lamboxlogo.png',
                    height: 100,
                  ),
                ),
                if (containerAnimate2)
                  Opacity(
                    opacity: controller.value,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.teal),
                        ),
                        color: Colors.teal,
                        onPressed: secondForm
                            ? () {
                                setState(() {
                                  context
                                      .read<FormData>()
                                      .firstRegistrationFormVerify();
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (context
                                      .read<FormData>()
                                      .firstFormVerifier) {
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    heightController.forward(from: 0);
                                  } else {
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
                                  }
                                });
                              }
                            : () {
                                context
                                    .read<FormData>()
                                    .secondRegistrationFormVerify();
                                if (context
                                    .read<FormData>()
                                    .secondFormVerifier) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WaitingScreen(),
                                      ));
                                } else {
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
                                }
                              },
                        child: Text(
                          secondForm ? 'Próximo' : 'Finalizar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          if (containerAnimate)
            Padding(
              padding: EdgeInsets.only(left: 30, top: 30, bottom: 30),
              child: AnimatedOpacity(
                opacity: myOpacity,
                duration: Duration(milliseconds: 400),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo ao LamBox!',
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w800,
                            fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Text(
                              'Não sabe o que é LamBox? Clique ',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              'aqui',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (containerAnimate2)
            SizedBox(
              height: (animation.value * 100),
            ),
          if (firstForm)
            SizedBox(
              height: (heightAnimation.value),
            ),
          Expanded(
            child: ClipPath(
              clipper: WaveClipperOne(reverse: true),
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                color: Colors.teal,
                child: AnimationLimiter(
                  child: ListView(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(milliseconds: 800),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        SizedBox(
                          height: 70,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              secondForm
                                  ? 'Começe preenchendo com suas informações pessoais:'
                                  : 'Agora, preencha com as informações do seu consultório:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        if (secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxFormFocus(
                              obscureText: false,
                              textType: 'Nome',
                              iconType: Icons.person,
                              focus: focus,
                              focusNode: _focus,
                            ),
                          ),
                        if (secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Sexo',
                              iconType: FontAwesomeIcons.venusMars,
                            ),
                          ),
                        if (secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Especialidade',
                              iconType: FontAwesomeIcons.userMd,
                            ),
                          ),
                        if (secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Telefone',
                              iconType: Icons.call,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        if (!secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxFormFocus(
                              focus: focus2,
                              focusNode: _focus2,
                              obscureText: false,
                              textType: 'Nome do Consultório',
                              iconType: FontAwesomeIcons.clinicMedical,
                            ),
                          ),
                        if (!secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Rua',
                              iconType: FontAwesomeIcons.road,
                            ),
                          ),
                        if (!secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Número',
                              iconType: FontAwesomeIcons.sortNumericUp,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        if (!secondForm)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: LamBoxForm(
                              obscureText: false,
                              textType: 'Cidade',
                              iconType: FontAwesomeIcons.city,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
