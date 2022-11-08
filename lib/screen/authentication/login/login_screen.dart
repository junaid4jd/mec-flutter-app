import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/firebase_auth.dart';
import 'package:mec/model/input_validator.dart';
import 'package:mec/screen/admin/admin_home_screen.dart';
import 'package:mec/screen/authentication/signup/signup_screen.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:mec/screen/student/student_home_screen.dart';
import 'package:mec/screen/teacher/teacher_home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({Key? key, required this.userType}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordControoler = TextEditingController();
  final TextEditingController _emailControoler = TextEditingController();
  bool _isLoading = false;
  bool _isVisible = false;
  MethodsHandler _methodsHandler = MethodsHandler();
  InputValidator _inputValidator = InputValidator();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String isCreated = '';
  String isCreatedStudent = '';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isCreated = '';
      isCreatedStudent = '';
      _isVisible = false;
      _isLoading = false;
    });
    print('userType');
    print(widget.userType.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor, size: 25),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => UserType(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 100),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Sign in',
          style: titleBlack,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Center(
              child: Container(
                width: 150.0,
                height: 100.0,
                child: Image.asset(
                  'assets/images/quran.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              child: Container(
                  color: whiteColor,
                  width: size.width * 0.85,
                  child: TextFormField(
                    controller: _emailControoler,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                      fillColor: whiteColor,
                      contentPadding:
                          EdgeInsets.only(left: 9.0, top: 13, bottom: 13),
                      hintText: 'example@yoursite.com',
                      label: Text("Email"),
                      labelStyle: body1Black,
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    onChanged: (String value) {},
                  )),
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Container(
                  color: whiteColor,
                  width: size.width * 0.85,
                  child: TextFormField(
                    controller: _passwordControoler,
                    keyboardType: TextInputType.text,
                    obscureText: _isVisible ? false : true,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          color: greyColor,
                          size: 23,
                        ),
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                          print(_isVisible);
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                      fillColor: whiteColor,
                      label: Text("Password"),
                      labelStyle: body1Black,
                      hintStyle: TextStyle(color: greyColor),
                      contentPadding:
                          EdgeInsets.only(left: 9.0, top: 13, bottom: 13),
                      hintText: '***************',
                    ),
                    onChanged: (String value) {},
                  )),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),

            // widget.userType.toString() == 'Admin' || widget.userType.toString() == 'Teacher'
            // Container(
            //   margin: const EdgeInsets.only(top: 0),
            //   child: GestureDetector(
            //     onTap: () {
            //       // Navigator.push(
            //       //   context,
            //       //   PageRouteBuilder(
            //       //     pageBuilder: (c, a1, a2) => ForgetPasswordScreen(),
            //       //     transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            //       //     transitionDuration: Duration(milliseconds: 100),
            //       //   ),
            //       // );
            //     },
            //     child: Text(
            //       'Forget to password ?',
            //       style: body2Green,
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),

            SizedBox(
              height: size.height * 0.03,
            ),
            _isLoading
                ? CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 2,
                  )
                : SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.85,
                    child: ElevatedButton(
                        onPressed: () async {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingnIn()));
                          if (_inputValidator
                                      .validateEmail(_emailControoler.text) !=
                                  'success' &&
                              _emailControoler.text.isNotEmpty) {
                            Fluttertoast.showToast(
                                msg: "Wrong email, please use a correct email",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1);
                          }
                          // else if (_passwordControoler.text.length < 7 &&
                          //     _passwordControoler.text.isNotEmpty) {
                          //   Fluttertoast.showToast(
                          //       msg: "Password length must be 8 char",
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIosWeb: 1);
                          // }
                          else {
                            if (_emailControoler.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Email is required",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (_passwordControoler.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Password is required",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              setState(() {
                                _isLoading = true;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (widget.userType == 'Admin') {
                                if (_emailControoler.text ==
                                        'admin@gmail.com' &&
                                    _passwordControoler.text == '12345678') {
                                  prefs.setString('userType', widget.userType.toString());
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                           AdminHomeScreen(
                                            userType: widget.userType.toString(),
                                          ),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 0),
                                    ),
                                  );

                                  Fluttertoast.showToast(
                                    msg: "Login successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                  );
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _methodsHandler.showAlertDialog(
                                      context, 'Sorry', 'User Not Found');
                                }
                              }
                              else {
                                try {
                                  if (widget.userType == 'Teacher') {
                                    final snapshot = await FirebaseFirestore.instance.collection('Teachers').get();
                                    snapshot.docs.forEach((element) {
                                      print('user data');
                                      if(element['email'] == _emailControoler.text.toString().trim()) {
                                        print('user age in if of current user ');
                                        //   print(element['age']);
                                        setState(() {
                                          isCreated = 'yes';

                                        });
                                      }
                                    });

                                    if(isCreated == 'yes') {
                                      final result =
                                      await _auth.signInWithEmailAndPassword(
                                          email: _emailControoler.text
                                              .trim()
                                              .toString(),
                                          password: _passwordControoler.text);
                                      final user = result.user;

                                      prefs.setString(
                                          'userEmail', _emailControoler.text);
                                      prefs.setString(
                                          'userPassword', _passwordControoler.text);
                                      prefs.setString('userId', user!.uid);
                                      prefs.setString('userType', widget.userType.toString());
                                      print('Account creation successful');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) =>
                                              TeacherHomeScreen(userType: widget.userType,),
                                          transitionsBuilder:
                                              (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim,
                                                  child: child),
                                          transitionDuration:
                                          Duration(milliseconds: 0),
                                        ),
                                      );
                                    }
                                    else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _methodsHandler.showAlertDialog(
                                          context, 'Sorry', 'User Not Found');
                                    }



                                  }
                                  else {

                                    final snapshot = await FirebaseFirestore.instance.collection('Students').get();
                                    snapshot.docs.forEach((element) {
                                      print('user data');
                                      if(element['email'] == _emailControoler.text.toString().trim()) {
                                        print('user age in if of current user ');
                                        //   print(element['age']);
                                        setState(() {
                                          isCreatedStudent = 'yes';

                                        });
                                      }
                                    });

                                    if(isCreatedStudent == 'yes') {
                                      try {

                                        final result =
                                        await _auth.signInWithEmailAndPassword(
                                            email: _emailControoler.text
                                                .trim()
                                                .toString(),
                                            password: _passwordControoler.text);
                                        final user = result.user;

                                        prefs.setString(
                                            'userEmail', _emailControoler.text);
                                        prefs.setString(
                                            'userPassword', _passwordControoler.text);
                                        prefs.setString('userId', user!.uid);
                                        prefs.setString('userType', widget.userType.toString());
                                        print('Account creation successful');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) =>
                                                StudentHomeScreen(userType: widget.userType
                                                    , classCode: "",index: 0 ,
                                                ),
                                            transitionsBuilder:
                                                (c, anim, a2, child) =>
                                                FadeTransition(
                                                    opacity: anim,
                                                    child: child),
                                            transitionDuration:
                                            Duration(milliseconds: 0),
                                          ),
                                        );
                                        Fluttertoast.showToast(
                                          msg: "Login successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 4,
                                        );

                                      } on FirebaseAuthException catch (e)
                                      {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        print(e.code);
                                        switch (e.code) {
                                          case 'invalid-email':
                                            _methodsHandler.showAlertDialog(context,
                                                'Sorry', 'Invalid Email Address');

                                            setState(() {
                                              _isLoading = false;
                                            });
                                            break;
                                          case 'wrong-password':
                                            _methodsHandler.showAlertDialog(
                                                context, 'Sorry', 'Wrong Password');
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            break;
                                          case 'user-not-found':
                                            _methodsHandler.showAlertDialog(
                                                context, 'Sorry', 'User Not Found');
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            break;
                                          case 'user-disabled':
                                            _methodsHandler.showAlertDialog(
                                                context, 'Sorry', 'User Disabled');
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            break;
                                        }
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }

                                    }
                                    else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _methodsHandler.showAlertDialog(
                                          context, 'Sorry', 'User Not Found');
                                    }

                                  }


                                }
                                on FirebaseAuthException catch (e)
                                {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  print(e.code);
                                  switch (e.code) {
                                    case 'invalid-email':
                                      _methodsHandler.showAlertDialog(context,
                                          'Sorry', 'Invalid Email Address');

                                      setState(() {
                                        _isLoading = false;
                                      });
                                      break;
                                    case 'wrong-password':
                                      _methodsHandler.showAlertDialog(
                                          context, 'Sorry', 'Wrong Password');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      break;
                                    case 'user-not-found':
                                      _methodsHandler.showAlertDialog(
                                          context, 'Sorry', 'User Not Found');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      break;
                                    case 'user-disabled':
                                      _methodsHandler.showAlertDialog(
                                          context, 'Sorry', 'User Disabled');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      break;
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text("Sign in", style: subtitleWhite)),
                  ),
            // SizedBox(
            //   height: size.height*0.03,
            // ),
            // Container(
            //   width: size.width * 0.85,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(6),
            //         child: Image.asset('assets/images/facebook.png', fit: BoxFit.scaleDown,
            //           width: size.width*0.4,
            //           height: size.height*0.06,
            //         ),
            //       ),
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(6),
            //         child: Image.asset('assets/images/google.png', fit: BoxFit.scaleDown,
            //           width: size.width*0.4,
            //           height: size.height*0.06,
            //         ),
            //       )
            //
            //     ],
            //   ),
            // ),
            SizedBox(
              height: size.height * 0.05,
            ),
            widget.userType.toString() == 'Admin' ||
                    widget.userType.toString() == 'Teacher'
                ? Container()
                : Container(
                    width: size.width * 0.85,
                    margin: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: body4Black,
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => SignUpScreen(
                                  userType: widget.userType,
                                  update: "",
                                  userId: "",
                                ),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 100),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up now!',
                            style: body4Green,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
