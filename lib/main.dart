import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/admin/admin_home_screen.dart';
import 'package:mec/screen/quran_example_screen.dart';
import 'package:mec/screen/splash/splash_screen.dart';
import 'package:mec/screen/student/leatherBoard/leather_board_screen.dart';
import 'package:mec/screen/student/student_home_screen.dart';
import 'package:mec/screen/teacher/studentEvaluation/recording_screen.dart';
import 'package:mec/screen/teacher/teacher_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(apiKey: 'AIzaSyC4wiIn0cfx0XyFmJ2TPJ8xNzi7G82rd_o',
            appId: '1:160604092231:ios:775d88e454b0638135be62',
            messagingSenderId: '160604092231',
            projectId: 'mec-flutter-app')
    );
  }
  else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String userType = '',email = '';



  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('userType') != null) {
      setState(() {
        userType = prefs.getString('userType')!;
        email = prefs.getString('userEmail')!;
      });
    } else {
      print('Starting usertype');
    }

  }
@override
  void initState() {
    // TODO: implement initState
  setState(() {
    userType = '';
    email = '';
  });
  getData();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
          //color set to purple or set your own color
        )
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:
      userType == 'Admin' ?   AdminHomeScreen(userType: userType) :
      userType == 'Teacher' ? TeacherHomeScreen(userType: userType, email: email,) :
      userType == 'Student' ? StudentHomeScreen(userType: userType  , classCode: "",index: 0 ,) :
      SplashScreen(),
    );
  }
}


