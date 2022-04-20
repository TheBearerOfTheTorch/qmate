import 'package:flutter/material.dart';

import 'loginAuth.dart';
import 'registerAuth.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isToggle = false;

  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToggle) {
      return RegisterAuth(toggleScreen: toggleScreen);
    } else {
      return LoginAuth(toggleScreen: toggleScreen);
    }
  }
}
