import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/login/login_screen.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';


class SplashScreen extends StatefulWidget {
  //final Color backgroundColor = Colors.white;
  //final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  const SplashScreen({Key? key, }) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5; // delay for 5 seconds

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UserType()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: new BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/quran.png', fit: BoxFit.scaleDown,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
