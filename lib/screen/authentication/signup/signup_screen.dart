
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/firebase_auth.dart';
import 'package:mec/model/input_validator.dart';
import 'package:mec/screen/admin/admin_home_screen.dart';
import 'package:mec/screen/authentication/login/login_screen.dart';
import 'package:mec/screen/student/addClass/add_class_by_code_screen.dart';
import 'package:mec/screen/student/student_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;
  final String userId;
  final String update;
  const SignUpScreen({Key? key, required this.userType, required this.userId, required this.update}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _fullNameControoler = TextEditingController();
  final TextEditingController _firstNameControoler = TextEditingController();
  final TextEditingController _lastNameControoler = TextEditingController();
  final TextEditingController _emailControoler = TextEditingController();
  final TextEditingController _phoneControoler = TextEditingController();
  final TextEditingController _addressControoler = TextEditingController();
  final TextEditingController _passwordControoler = TextEditingController();
  final TextEditingController _confirmPasswordControoler = TextEditingController();


  MethodsHandler _methodsHandler = MethodsHandler();
  InputValidator _inputValidator = InputValidator();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isVisible = false;
  bool _isVisibleC = false;



  getData() {
    FirebaseFirestore.instance.collection('Teachers').doc(widget.userId.toString()).get().then((value) {
      print('Teachers get');
      print(value.data());
      setState(() {
        _emailControoler.text = value.data()!['email'].toString();
        _firstNameControoler.text = value.data()!['name'].toString().split(' ')[0];
        _lastNameControoler.text = value.data()!['name'].toString().split(' ')[1];
        _passwordControoler.text = value.data()!['password'].toString();
        _confirmPasswordControoler.text = value.data()!['password'].toString();
      });

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    if(widget.update == 'yes' ) {
      getData();
    }
    setState(() {
      _isVisible = false;
      _isVisibleC = false;
      _isLoading = false;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        // leading: Row(
        //   children: [
        //     SizedBox(
        //       width: size.width*0.03,
        //     ),
        //     GestureDetector(
        //       onTap: (){
        //         Navigator.pop(context);
        //       },
        //       child: Image.asset("assets/images/backicon.png",height: 17,width: 30,),
        //     ),
        //   ],
        // ),
        iconTheme: IconThemeData(
            color: textColor,
            size: 25
        ),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,),),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white
        ,title: Text('Sign up',style:titleBlack,),centerTitle: true,),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              SizedBox(
                height: size.height*0.05,
              ),
              Center(
                child: Container(
                  width: 150.0,
                  height: 100.0,
                  child: Image.asset('assets/images/quran.png', fit: BoxFit.scaleDown,),
                ),
              ),
              SizedBox(
                height: size.height*0.05,
              ),


              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: Container(
                        color: whiteColor,
                        width: size.width * 0.85,
                        child: TextFormField(

                          controller: _firstNameControoler,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,color: primaryColor,),
                            border: InputBorder.none,
                            fillColor: whiteColor,

                            contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                            hintText: 'Tauhid',
                            label: Text("First Name"),
                            labelStyle: body1Black,
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          onChanged: (String value){

                          },

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

                          controller: _lastNameControoler,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,color: primaryColor,),
                            border: InputBorder.none,
                            fillColor: whiteColor,

                            contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                            hintText: 'Hasan',
                            label: Text("Last Name"),
                            labelStyle: body1Black,
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          onChanged: (String value){

                          },

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

                          controller: _emailControoler,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email,color: primaryColor,),
                            border: InputBorder.none,
                            fillColor: whiteColor,

                            contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                            hintText: 'example@yoursite.com',
                            label: Text("Email"),
                            labelStyle: body1Black,
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          onChanged: (String value){

                          },

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
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,color: primaryColor,),
                            suffixIcon: IconButton(
                              icon: Icon(  _isVisible ?  Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined
                                ,color: greyColor,size: 23,),
                              onPressed: () {

                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                                print(_isVisible);
                              },
                            ),
                            border: InputBorder.none,
                            fillColor: whiteColor,

                            contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                            hintText: '***************',
                            label: Text("Password"),
                            labelStyle: body1Black,
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          onChanged: (String value){
                          },
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

                          controller: _confirmPasswordControoler,
                          keyboardType: TextInputType.text,
                          obscureText: _isVisibleC ? false : true,
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,color: primaryColor,),
                            suffixIcon: IconButton(
                              icon: Icon(  _isVisibleC ?  Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined
                                ,color: greyColor,size: 23,),
                              onPressed: () {

                                setState(() {
                                  _isVisibleC = !_isVisibleC;
                                });
                                print(_isVisibleC);
                              },
                            ),
                            border: InputBorder.none,
                            fillColor: whiteColor,

                            contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                            hintText: '***************',
                            label: Text("Confirm Password"),
                            labelStyle: body1Black,
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          onChanged: (String value){
                          },
                        )),
                  ),
                ],
              ),


              SizedBox(
                height: size.height*0.03,
              ),
              _isLoading ? CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2
                ,
              ) :
              SizedBox(
                height: size.height*0.06,
                width: size.width*0.85,
                child:
                ElevatedButton(
                    onPressed: () async {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingnIn()));
                      if (_inputValidator.validateName(
                          _firstNameControoler.text) !=
                          'success' &&
                          _firstNameControoler.text.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: "Invalid First Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else if (_inputValidator.validateName(
                          _lastNameControoler.text) !=
                          'success' &&
                          _lastNameControoler.text.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: "Invalid Last Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );

                      }
                      else if (_inputValidator.validateEmail(
                          _emailControoler.text) !=
                          'success' &&
                          _emailControoler.text.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: "Wrong email address",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }

                      else if ((_passwordControoler.text.length <
                          7 &&
                          _passwordControoler
                              .text.isNotEmpty) &&
                          (_confirmPasswordControoler.text.length < 7 &&
                              _confirmPasswordControoler
                                  .text.isNotEmpty)) {
                        Fluttertoast.showToast(
                            msg: "Password and Confirm Password must be same",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );

                      }
                      else if (_passwordControoler.text !=
                          _confirmPasswordControoler.text) {
                        Fluttertoast.showToast(
                            msg: "Password and Confirm Password must be same",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else {
                        if(_firstNameControoler.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: "First Name is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else if(_lastNameControoler.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: "Last Name is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else if(_emailControoler.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: "Email Address is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }

                        else if(_passwordControoler.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: "Password is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else if(_confirmPasswordControoler.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: "Confirm Password is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else {

                          setState(() {
                            _isLoading = true;
                            print('We are in loading');
                            //  state = ButtonState.loading;
                          });

                          print(_firstNameControoler.text.toString());
                          print(_lastNameControoler.text.toString());
                          print( _emailControoler.text.toString());
                          print( _addressControoler.text.toString());
                          print( _passwordControoler.text.toString());
                          print( _phoneControoler.text.toString());
                          //createAccount();
                          //_methodsHandler.createAccount(name: _controllerClinic.text, email: _controller.text, password: _controllerPass.text, context: context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          try {

                            if(widget.userType == "Admin" && widget.update == 'yes') {
                              FirebaseFirestore.instance
                                  .collection('Teachers')
                                  .doc(widget.userId)
                                  .set({
                                "email": _emailControoler.text.trim(),
                                "password": _passwordControoler.text.trim(),
                                "uid": widget.userId,
                                "name": _firstNameControoler.text +' '+ _lastNameControoler.text.toString(),
                              }).then((value) => print('success'));

                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      AdminHomeScreen(userType: widget.userType,),
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
                                msg: "Teacher updated successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 4,
                              );
                            }
                            else {

                              User? result = (await _auth
                                  .createUserWithEmailAndPassword(
                                  email:
                                  _emailControoler.text.trim(),
                                  password: _passwordControoler.text
                                      .trim()))
                                  .user;

                              if(result != null) {
                                var user = result;
                                if(widget.userType == 'Admin' ) {
                                  FirebaseFirestore.instance
                                      .collection('Teachers')
                                      .doc(user.uid)
                                      .set({
                                    "email": _emailControoler.text.trim(),
                                    "password": _passwordControoler.text.trim(),
                                    "uid": user.uid,
                                    "name": _firstNameControoler.text +' '+ _lastNameControoler.text.toString(),
                                  }).then((value) => print('success'));

                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          AdminHomeScreen(userType: widget.userType,),
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
                                    msg: "Teacher created successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                  );
                                }
                                else {
                                  FirebaseFirestore.instance
                                      .collection('Students')
                                      .doc(user.uid)
                                      .set({
                                    "email": _emailControoler.text.trim(),
                                    "password": _passwordControoler.text.trim(),
                                    "uid": user.uid,
                                    "name": _firstNameControoler.text +' ' + _lastNameControoler.text.toString(),

                                  }).then((value) => print('success'));

                                  prefs.setString('userEmail',
                                      _emailControoler.text.trim());
                                  prefs.setString('userPassword',
                                      _passwordControoler.text.trim());
                                  prefs.setString('name',
                                      _firstNameControoler.text.trim());
                                  prefs.setString('userId', user.uid);
                                  print('Account creation successful');
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          AddClassByCodeScreen(way: 'signUp',),
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
                                    msg: "Account created successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                  );

                                }
                              }
                              else {
                                setState(() {
                                  _isLoading = false;
                                });
                                print('error');
                              }

                            }


                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            if(e.code == 'email-already-in-use') {

                              showAlertDialog(context, 'Sorry', 'The email address is already in use by another account.');
                            }
                            print(e.message);
                            print(e.code);
                          }



                        //  await Future.delayed(Duration(seconds: 1));


                        }

                      }







                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text(
                        widget.userType == "Admin" && widget.update == '' ? "Add Teacher" :
                        widget.userType == "Admin" && widget.update == 'yes' ? "Update Teacher" :
                             "Sign up now",
                        style: subtitleWhite
                    )
                ),
              ),
              SizedBox(
                height: size.height*0.03,
              ),

              widget.userType == "Admin" ? Container() :
              Container(
                width: size.width * 0.85,
                margin: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Do you have an account?',
                      style: body4Black,
                      textAlign: TextAlign.center,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => LoginScreen(userType: widget.userType,),
                            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      child: Text(
                        'Sign in now!',
                        style: body4Green,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: size.height*0.03,
              ),



            ],),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("$title"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$content"),
      ),
      actions: [
        // CupertinoDialogAction(
        //     child: Text("YES"),
        //     onPressed: ()
        //     {
        //       Navigator.of(context).pop();
        //     }
        // ),
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
