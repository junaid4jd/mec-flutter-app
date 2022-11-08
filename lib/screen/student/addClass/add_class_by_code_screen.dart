import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/firebase_auth.dart';
import 'package:mec/screen/student/student_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddClassByCodeScreen extends StatefulWidget {
  final String way;
  const AddClassByCodeScreen({Key? key, required this.way}) : super(key: key);

  @override
  _AddClassByCodeScreenState createState() => _AddClassByCodeScreenState();
}

class _AddClassByCodeScreenState extends State<AddClassByCodeScreen> {
  final TextEditingController _codeControoler = TextEditingController();

  bool _isLoading = false, chapterToggle1 = false,chapterToggle2 = false, chapterToggle3 = false, chapterToggle4 = false;
  String isClassNameExist = "", classId = "" , className = "";
  List<dynamic> chapList = [];
  MethodsHandler _methodsHandler = MethodsHandler();


  String name = '' , email = '',teacherEmail = '',uid = '';
  String text = '';
  String subject = '',classGrade = '';



  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Students').doc(prefs.getString('userId')!).get().then((value) {
      print('Teachers get');
      print(value.data());
      setState(() {
        email = value.data()!['email'].toString();
        name = value.data()!['name'].toString();
        uid = value.data()!['uid'].toString();
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.way.toString());
    setState(() {
      _isLoading = false;
      isClassNameExist = "";
      classId = "" ;
    });
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Code"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                height: size.height * 0.1,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: Container(

                    decoration: BoxDecoration(
                      border: Border.all(color: greyColor,width: 0.5),
                      color: whiteColor,
                    ),
                    width: size.width * 0.85,
                    child: TextFormField(
                      controller: _codeControoler,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        // prefixIcon: Icon(
                        //   Icons.wysiwyg_sharp,
                        //   color: primaryColor,
                        // ),
                        border: InputBorder.none,
                        fillColor: whiteColor,
                        contentPadding:
                        EdgeInsets.only(left: 9.0, top: 13, bottom: 13),
                        hintText: '*******',
                        label: Text("Class Code"),
                        labelStyle: body4Black,
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      onChanged: (String value) {},
                    )),
              ),

              SizedBox(
                height: size.height * 0.05,
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

                      if (_codeControoler.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Class Code is required",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else {
                        setState(() {
                          _isLoading = true;
                        });
                        final snapshot = await FirebaseFirestore.instance.collection('Classes').get();
                        snapshot.docs.forEach((element) {
                          print('user data');
                          if(element['classCode'] == _codeControoler.text.toString().trim()) {
                            print('user age in if of current user ');
                            //   print(element['age']);
                            setState(() {
                              isClassNameExist = 'yes';
                              classId = element.id.toString();
                              chapList = element['chapList'];
                              classGrade = element['classGrade'];
                              className = element['className'];
                              chapterToggle1 = element['chapterToggle1'];
                              chapterToggle2 = element['chapterToggle2'];
                              chapterToggle3 = element['chapterToggle3'];
                              chapterToggle4 = element['chapterToggle4'];
                              teacherEmail = element['teacherEmail'];

                            });
                          }
                        });

                        if(isClassNameExist == 'yes') {
                          setState(() {
                            _isLoading = false;
                          });

                          FirebaseFirestore.instance
                              .collection('StudentClasses')
                              .doc()
                              .set({
                            "studentEmail": email,
                            "studentName": name,
                            "uid":uid,
                            "classGrade": classGrade,
                            "chapList":chapList ,
                            "classCode":_codeControoler.text.toString(),
                            "className":className.toString(),
                            "chapterToggle1": chapterToggle1,
                            "chapterToggle2": chapterToggle2,
                            "chapterToggle3": chapterToggle3,
                            "chapterToggle4": chapterToggle4,
                            "teacherEmail": teacherEmail.toString(),

                          }).then((value){
                            setState(() {
                              _isLoading = false;
                            });

                            if(widget.way == "signUp") {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => StudentHomeScreen(userType: "Student", classCode: _codeControoler.text.toString(),index: 0 ,),
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

                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => StudentHomeScreen(userType: "Student" , classCode: _codeControoler.text.toString(),index: 0 ,),
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



                          });



                        }
                        else {
                          setState(() {
                            _isLoading = false;
                          });

                          _methodsHandler.showAlertDialog(
                              context, 'Sorry', 'Wrong class code');



                        }


                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text("Add", style: subtitleWhite)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
