import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FormData extends ChangeNotifier {
  List<TextEditingController> registrationFormControllers = [];
  List<String> registrationFormItems = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    ''
  ];

  List<String> loginCredentials = ['', ''];

  var loggedUserInfo = {};
  bool firstFormVerifier = true;
  bool secondFormVerifier = true;
  bool emailRegistrationVerifier = true;
  bool loginVerifier = true;

  void addFormController(TextEditingController controller) {
    registrationFormControllers.add(controller);
  }

  void firstRegistrationFormVerify() {
    firstFormVerifier = true;
    for (var x = 2; x < 6; x++) {
      var controller = registrationFormControllers[x];
      registrationFormItems[x] = controller.text;
    }
    for (var i = 2; i < 6; i++) {
      if (registrationFormItems[i] == '') {
        firstFormVerifier = false;
      }
    }
    if (firstFormVerifier) {
      for (var j = 2; j < 6; j++) {
        var controller = registrationFormControllers[j];
        controller.clear();
      }
    }
  }

  void secondRegistrationFormVerify() {
    secondFormVerifier = true;
    for (var x = 2; x < 5; x++) {
      var controller = registrationFormControllers[x];
      registrationFormItems[x + 4] = controller.text;
    }
    var controller = registrationFormControllers[6];
    registrationFormItems[9] = controller.text;
    for (var i = 6; i < 10; i++) {
      if (registrationFormItems[i] == '') {
        secondFormVerifier = false;
      }
    }
    print(registrationFormItems);
  }

  void emailRegistration() {
    emailRegistrationVerifier = true;
    for (var x = 7; x < 9; x++) {
      var controller = registrationFormControllers[x];
      if (controller.text == '') {
        emailRegistrationVerifier = false;
      }
      registrationFormItems[x + 3] = controller.text;
    }
  }

  void addToList(String field) {
    registrationFormItems.add(field);
  }

  void updateMap(Map map) {
    loggedUserInfo = Map.of(map);
  }

  void verifyLogin() {
    loginVerifier = true;
    for (var x = 0; x < 2; x++) {
      var controller = registrationFormControllers[x];
      if (controller.text == '') {
        loginVerifier = false;
      }
      loginCredentials[x] = controller.text;
    }
  }
}
