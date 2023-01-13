import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/student/listenRecording/listen_your_recording.dart';
import 'package:mec/screen/student/studentSurah/student_surahs_screen.dart';
import 'package:mec/screen/student/student_home_screen.dart';

class StudentClassChapScreen extends StatefulWidget {
  final String classCode;
  final String classDocId;

  final int chapterIndex;
  const StudentClassChapScreen({Key? key,
    required this.classCode,
    required this.classDocId,
    required this.chapterIndex})
      : super(key: key);

  @override
  _StudentClassChapScreenState createState() => _StudentClassChapScreenState();
}

class _StudentClassChapScreenState extends State<StudentClassChapScreen> {
  TeacherClasseModel? teacherClasseModel;
  int cups = 0, badge = 0, stars = 0;
  ScrollController? controller;
  bool isAppBarPinned = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<bool> _cupsOnOrOff = [];
  bool _isLoadingCups = true;

  int totalStars = 0;
  int totalBadges = 0;
  int totalCups = 0;
  getStudentData() async {

    setState(() {
      totalStars = 0;
      totalBadges = 0;
      totalCups = 0;
    });

    FirebaseFirestore.instance.collection("Students").doc(_auth.currentUser!.uid.toString()).get().then((value) {
      setState(() {
        totalStars = value["studentStars"];
        totalBadges = value["studentBadges"];
        totalCups = value["studentCups"];
      });
    });

  }

  getCups() async {
    setState(() {
      _isLoadingCups = true;
      _cupsOnOrOff.clear();
    });
    FirebaseFirestore.instance
        .collection('StudentChapterEvaluation')
        .where('classCode', isEqualTo: widget.classCode.toString())
        .where('uid', isEqualTo: _auth.currentUser!.uid.toString())
        .get()
        .then((value) {

          if(value.docs.isNotEmpty) {
            for(int i=0 ;i<value.docs[0]['chapEvaluationList'].length ; i++)
            {

              setState(() {
                _cupsOnOrOff.add(value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'].toString() == 'yes' ? true : false);
              });

              if(i == value.docs[0]['chapEvaluationList'].length-1) {

                setState(() {
                  _isLoadingCups = false;
                });
                print('Cups o or off list');
                print(_cupsOnOrOff.toList());
              }

            }
          } else {
            setState(() {
              _isLoadingCups = false;
            });
          }


          
    });
  }


  @override
  void initState() {
    setState(() {
      _isLoadingCups = true;
    });
    getCups();
    getStudentData();
    super.initState();
    controller = ScrollController()..addListener(onScroll);
    isAppBarPinned = true;
  }

  void onScroll() {
    if (controller!.position.pixels > 200) {
      if (isAppBarPinned) {
        setState(() => isAppBarPinned = false);
      }
    } else {
      if (!isAppBarPinned) {
        setState(() => isAppBarPinned = true);
      }
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: whiteColor,
      body:
      _isLoadingCups ? Center(child: CircularProgressIndicator(

      )) :
      NestedScrollView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        floatHeaderSlivers: false,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: whiteColor,
              iconTheme: IconThemeData(color: Colors.black),
              //automaticallyImplyLeading: innerBoxIsScrolled ? false : true,
              expandedHeight: 170.0,
              floating: true,
              snap: true,
              pinned: true,
              shape: Border(
                  bottom: BorderSide(
                      color: Colors.amber,
                      width: 1
                  )
              ),
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(0),
              //   child: AppBar(),
              // ),
              //stretch: false,
              flexibleSpace: FlexibleSpaceBar(
                // collapseMode: CollapseMode.,
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(
                      //   height: 25,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide( //                   <--- right side
                              color: Colors.grey,
                              width: 0.5,

                            ),
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap:() {

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => ListenYourRecordingScreen(),
                                      transitionsBuilder: (c, anim, a2, child) =>
                                          FadeTransition(opacity: anim, child: child),
                                      transitionDuration: Duration(milliseconds: 0),
                                    ),
                                  );

                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset('assets/images/microphone.png'),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                // decoration: BoxDecoration(
                                //     border: Border(
                                //       right: BorderSide( //                   <--- right side
                                //         color: Colors.grey,
                                //         width: 0.5,
                                //
                                //       ),
                                //     )
                                // ),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child:
                                          Image.asset('assets/images/trophy.png'),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: redColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: 15,
                                      height: 15,
                                      child: Center(
                                          child: Text(
                                        totalCups.toString(),
                                        style: TextStyle(fontSize: 10),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child:
                                          Image.asset('assets/images/ribbon.png'),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: redColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: 15,
                                      height: 15,
                                      child: Center(
                                          child: Text(
                                        totalBadges.toString(),
                                        style: TextStyle(fontSize: 10),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: Image.asset('assets/images/star.png'),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: redColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: 15,
                                      height: 15,
                                      child: Center(
                                          child: Text(
                                        totalStars.toString(),
                                        style: TextStyle(fontSize: 10),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          StudentHomeScreen(
                                            userType: "Student" , classCode: "",index: 5 ,
                                              chapterIndex: widget.chapterIndex,
                                            classIndex: 0,
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
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset('assets/images/user.png'),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                  background: Container(color: whiteColor,)
                  // Image.network(
                  //   "https://cool-math.co.uk/wp-content/uploads/2013/07/background1.jpg",
                  //   fit: BoxFit.cover,
                  // )

              ),
            ),
          ];
        },
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("StudentClasses").where("classCode",isEqualTo: widget.classCode.toString()).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(
                strokeWidth: 1,
                color: primaryColor,
              ));
            }
            else if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
              // got data from snapshot but it is empty

              return Center(child: Text("No Data Found"));
            }
            else  {

              return Center(
                child: Container(
                  width: size.width*0.95,

                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: snapshot.data!.docs[widget.chapterIndex]["chapList"].length,
                    itemBuilder: (context, index) {
                      // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
                      return GestureDetector(
                        onTap: () async {
                          print(widget.classDocId.toString());

                          FirebaseFirestore.instance.collection('StudentClasses').doc(widget.classDocId.toString()).get().then((value) {
                            print(' This is the class data you picked');

                            var data = json.encode(value.data());

                            setState(() {
                              teacherClasseModel  =  TeacherClasseModel.fromJson(json.decode(data));
                            });

                            if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true)
                            {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      StudentSurahScreen(
                                        classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                        chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                        teacherClasseModel: teacherClasseModel!,
                                        classDocId: widget.classDocId.toString(),
                                        studentDocId: snapshot.data!.docs[0].id.toString(),
                                        chapterName: snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(), chapIndex: index,
                                      ),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ),
                              );
                            }
                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true)
                            {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      StudentSurahScreen(
                                        classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                        chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                        teacherClasseModel: teacherClasseModel!,
                                        studentDocId: snapshot.data!.docs[0].id.toString(),
                                        classDocId: widget.classDocId.toString(),
                                        chapterName: snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(), chapIndex: index,
                                      ),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ),
                              );
                            }
                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true)
                            {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      StudentSurahScreen(
                                        classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                        chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                        teacherClasseModel: teacherClasseModel!,
                                        classDocId: widget.classDocId.toString(),
                                        studentDocId: snapshot.data!.docs[0].id.toString(),
                                        chapterName: snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                        chapIndex: index,
                                      ),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ),
                              );
                            }
                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true)
                            {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      StudentSurahScreen(classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                        chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                        teacherClasseModel: teacherClasseModel!,
                                        studentDocId: snapshot.data!.docs[0].id.toString(),
                                        classDocId: widget.classDocId.toString(),
                                        chapterName: snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                        chapIndex: index,
                                      ),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 0),
                                ),
                              );
                            }
                            else
                            {
                              print("chap ${index+1} is locked");
                              Fluttertoast.showToast(
                                msg: "Sorry locked by teacher",
                                toastLength: Toast.LENGTH_SHORT,
                                fontSize: 18.0,
                              );
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Center(
                            child: Container(
                              // color: redColor,
                              height: size.height*0.38,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: new BoxDecoration(

                                        border: Border.all(color:
                                        snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? primaryColor :
                                        snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? primaryColor :
                                        snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? primaryColor :
                                        snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? primaryColor :
                                        Colors.grey.withOpacity(0.5),
                                            width: 5
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                            style: TextStyle(fontSize: 16,color: Colors.blue, fontWeight: FontWeight.bold),
                                          ),

                                          Icon(Icons.play_arrow_sharp,
                                            color:
                                            snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? primaryColor :
                                            snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? primaryColor :
                                            snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? primaryColor :
                                            snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? primaryColor :
                                            Colors.grey.withOpacity(0.9),
                                            size: 28,


                                          )

                                        ],
                                      )),
                                    ),
                                  ),
                                  Positioned.fill(

                                    top: size.height*0.13,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child:  Container(
                                          // color: greyColor,
                                          height: size.height*0.22,
                                          child: Column(children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 70,
                                              height: 70,
                                              // decoration: BoxDecoration(
                                              //     shape: BoxShape.circle,
                                              //     color: Colors.amber
                                              // ),
                                              child:

                                                  _cupsOnOrOff[index] ?
                                                  Image.asset('assets/images/trophy.png')
                                                      : Image.asset('assets/images/trophy_black.png'),

                                              // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Image.asset('assets/images/trophy.png') :
                                              // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Image.asset('assets/images/trophy.png'):
                                              // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Image.asset('assets/images/trophy.png') :
                                              // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Image.asset('assets/images/trophy.png') :
                                              // Image.asset('assets/images/trophy_black.png'),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:

                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.amber :
                                                snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.amber :
                                                Colors.grey.withOpacity(0.9),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],),
                                        )
                                    ),
                                  ),

                                  // Container(
                                  //   height: size.height*0.3,
                                  //   color: greyColor,
                                  //   child: Column(
                                  //     // mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //
                                  //       // Positioned(
                                  //       //     //top: 20,
                                  //       //     bottom: 20,
                                  //       //     child: Icon(Icons.star,color: Colors.amber,size: 40,)),
                                  //       // Row(
                                  //       //   mainAxisAlignment: MainAxisAlignment.center,
                                  //       //   children: [
                                  //       //     Icon(Icons.star,color: Colors.amber,size: 40,),
                                  //       //
                                  //       //     Icon(Icons.star,color: Colors.amber,size: 40,),
                                  //       //
                                  //       //   ],),
                                  //
                                  //     ],),
                                  // ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );


                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: Container(
                      //     height: size.height*0.25,
                      //     width: size.width*0.95,
                      //     decoration: BoxDecoration(
                      //       color:
                      //
                      //       snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.white :
                      //       snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.white :
                      //       snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.white :
                      //       snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.white :
                      //       Colors.grey.withOpacity(0.5),
                      //
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: greyColor,width: 0.5),
                      //     ),
                      //     child: Column(children: [
                      //
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: primaryColor.withOpacity(0.8),
                      //           borderRadius: BorderRadius.circular(10),
                      //           //border: Border.all(color: greyColor,width: 0.5),
                      //         ),
                      //         width: size.width*0.95,
                      //         height: size.height*0.15,
                      //         child: Image.network('https://www.teacheracademy.eu/wp-content/uploads/2020/02/english-classroom.jpg',fit: BoxFit.cover,),
                      //       ),
                      //       ListTile(
                      //         tileColor: lightGreyColor,
                      //         leading: CircleAvatar(
                      //           backgroundColor: lightGreyColor,
                      //           radius: 30,
                      //           backgroundImage: NetworkImage(
                      //               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                      //         ),
                      //         // CircleAvatar(
                      //         //   backgroundColor: const Color(0xff764abc),
                      //         //   child: Text(ds['name'].toString()[0]),
                      //         // ),
                      //         title: Text(snapshot.data!.docs[0]["className"].toString(), style: body1Green,), // ${snapshot.data!.docs[0]["className"].toString()}
                      //         subtitle: Text(snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(), style: TextStyle(fontSize: 14,color: Colors.black),),
                      //         // trailing:   Container(
                      //         //   width: size.width*0.2,
                      //         //   child: FlutterSwitch(
                      //         //     activeColor: primaryColor,
                      //         //     width: 43.0,
                      //         //     height: 25.0,
                      //         //     valueFontSize: 0.0,
                      //         //     toggleSize: 18.0,
                      //         //     value:
                      //         //     snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" ? snapshot.data!.docs[0]["chapterToggle1"] :
                      //         //     snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" ? snapshot.data!.docs[0]["chapterToggle2"] :
                      //         //     snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" ? snapshot.data!.docs[0]["chapterToggle3"] :
                      //         //     snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" ? snapshot.data!.docs[0]["chapterToggle4"] :
                      //         //     false,
                      //         //     borderRadius: 30.0,
                      //         //     onToggle: (val) async {
                      //         //       print("chap List toggle");
                      //         //       print(val.toString());
                      //         //
                      //         //       if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1") {
                      //         //         FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                      //         //           "chapterToggle1": val,
                      //         //         });
                      //         //       }
                      //         //       else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
                      //         //         FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                      //         //           "chapterToggle2": val,
                      //         //         });
                      //         //       }
                      //         //       else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
                      //         //         FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                      //         //           "chapterToggle3": val,
                      //         //         });
                      //         //       }
                      //         //       else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
                      //         //         FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                      //         //           "chapterToggle4": val,
                      //         //         });
                      //         //       }
                      //         //
                      //         //       // setState(() {
                      //         //       //   toggleVal[index] = val;
                      //         //       // });
                      //         //       // print(snapshot.data!.docs[0].id.toString());
                      //         //
                      //         //       // updateListToggle(snapshot.data!.docs[0]["chapList"],
                      //         //       //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                      //         //       //   val,
                      //         //       //     snapshot.data!.docs[0].id.toString()
                      //         //       // );
                      //         //
                      //         //       // FirebaseFirestore.instance.collection("Classes").
                      //         //
                      //         //       //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
                      //         //       // print(target.toString());
                      //         //       // print(target["chapterToggle"].toString());
                      //         //
                      //         //       //if (target != null) {
                      //         //       // setState(() {
                      //         //       //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
                      //         //       // });
                      //         //       //target["quantity"] + 1;
                      //         //       //}
                      //         //
                      //         //
                      //         //       // SharedPreferences prefs = await SharedPreferences.getInstance();
                      //         //       // prefs.setBool('statusDaily', val );
                      //         //       // prefs.setString('daily', statusDaily ? 'yes' : 'no');
                      //         //       // getSettingsStatus();
                      //         //       // postData1(status, 'security');
                      //         //     },
                      //         //   ),
                      //         // ),
                      //       ),
                      //     ],
                      //     ),
                      //   ));



                    },

                  ),
                ),
              );
            }


          },
        ),
      ),
    );
  }
}
