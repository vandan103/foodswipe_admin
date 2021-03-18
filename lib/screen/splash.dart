import 'package:flutter/material.dart';
import 'package:foodadmin/helper/style.dart';
import 'package:foodadmin/widget/custom_text.dart';
import 'package:foodadmin/widget/loading.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "Loading"),
            Loading(),
          ],
        )
    );
  }
}
