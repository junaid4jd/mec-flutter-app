import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/teacher/surahs/chapter_surahs_list_screen_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterList extends StatefulWidget {
  final String classCode;
  final String classDocId;
  const ChapterList({Key? key, required this.classCode, required this.classDocId}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  List<Map<String, dynamic>> chapterList = [];
  TeacherClasseModel? teacherClasseModel;
  bool chapter1 = false;

  int y=0;
  List<bool> toggleVal = [false, false];


  updateListToggle(List<dynamic> chapterList, String name, bool val, String id) {
    print('we are in toggle List');
    print(chapterList.toString());
    print(name.toString());
    print(id.toString());
    print(chapterList.length);
    print(chapterList.length);

    for(int i=0; i<chapterList.length ; i++) {
      print('we are in loop');
      print(chapterList[i]["chapterName"].toString());
      if(chapterList[i]["chapterName"].toString() == name.toString()) {

        setState(() {
          chapterList.add({
            "chapterName": chapterList[i]["chapterName"].toString(),
            "chapterId": chapterList[i]["chapterId"].toString(),
            "chapterToggle": val,
          });
        });

      }
      else {
        setState(() {
          chapterList.add({
            "chapterName": chapterList[i]["chapterName"].toString(),
            "chapterId": chapterList[i]["chapterId"].toString(),
            "chapterToggle": chapterList[i]["chapterToggle"],
          });
        });
      }
    }

    FirebaseFirestore.instance.collection("Classes").doc(id.toString()).update({
      "chapList": chapterList,
    }).whenComplete(() {
      print("Completed");
    });

  }


  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Classes').doc(widget.classDocId.toString()).get().then((value) {
      print(' This is the class data you picked');
      var data = json.encode(value.data());
      //log(data);
      setState(() {
      teacherClasseModel  =  TeacherClasseModel.fromJson(json.decode(data));
      });
      print('Teacher Name');
      print(teacherClasseModel!.teacherName.toString());
    });
  }

  updateInStudents(int number, bool val , String classCode) async {
    print('$number $val $classCode StudentClasses');
    if(number == 1) {
      FirebaseFirestore.instance.collection("StudentClasses").where("classCode", isEqualTo: classCode.toString()).get().then((value)
      {

        for(int i=0;   i < value.docs.length ; i++) {
          print(i.toString());
          print(value.docs[i].id.toString() + " in Loop");
          FirebaseFirestore.instance.collection("StudentClasses").doc(value.docs[i].id.toString()).update({
            "chapterToggle1": val,
          });
        }
      });
    }
    else if(number == 2) {
      FirebaseFirestore.instance.collection("StudentClasses").where("classCode", isEqualTo: classCode.toString()).get().then((value)
      {
        print(value.docs.length.toString());
        for(int i=0;  i < value.docs.length; i++) {
          FirebaseFirestore.instance.collection("StudentClasses").doc(value.docs[i].id.toString()).update({
            "chapterToggle2": val,
          });
        }
      });
    }
    else if(number == 3) {
      FirebaseFirestore.instance.collection("StudentClasses").where("classCode", isEqualTo: classCode.toString()).get().then((value)
      {
        print(value.docs.length.toString());
        for(int i=0;   i < value.docs.length; i++) {
          FirebaseFirestore.instance.collection("StudentClasses").doc(value.docs[i].id.toString()).update({
            "chapterToggle3": val,
          });
        }
      });
    }
    else if(number == 4) {
      FirebaseFirestore.instance.collection("StudentClasses").where("classCode", isEqualTo: classCode.toString()).get().then((value)
      {
        print(value.docs.length.toString());
        for(int i=0;   i < value.docs.length; i++) {
          FirebaseFirestore.instance.collection("StudentClasses").doc(value.docs[i].id.toString()).update({
            "chapterToggle4": val,
          });
        }
      });
    }



  }



  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Chapter"),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Classes").where("classCode",isEqualTo: widget.classCode.toString()).snapshots(),
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

            return

              Center(
              child: Container(
                width: size.width*0.95,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs[0]["chapList"].length,
                  itemBuilder: (context, index) {
                   // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
                    print(snapshot.data!.docs[0]["classCode"].toString() + " this is code" );
                    return GestureDetector(
                      onTap: () {

                        FirebaseFirestore.instance.collection('Classes').doc(widget.classDocId.toString()).get().then((value) {
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
                                    TeacherSurahListScreen(classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                      chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                      teacherClasseModel: teacherClasseModel!,
                                      classDocId: widget.classDocId.toString(),
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
                                    TeacherSurahListScreen(
                                      classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                      chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                      teacherClasseModel: teacherClasseModel!,
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
                                    TeacherSurahListScreen(
                                      classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                      chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                      teacherClasseModel: teacherClasseModel!,
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
                          else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true)
                          {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) =>
                                    TeacherSurahListScreen(classCode: snapshot.data!.docs[0]["classCode"].toString(),
                                      chapterId: snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString(),
                                      teacherClasseModel: teacherClasseModel!,
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
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: size.height*0.25,
                            width: size.width*0.95,
                            decoration: BoxDecoration(
                              color:
                              snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.white :
                              snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.white :
                              snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.white :
                              snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.white :
                              Colors.grey.withOpacity(0.5),

                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: greyColor,width: 0.5),
                            ),
                            child: Column(children: [

                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(color: greyColor,width: 0.5),
                                ),
                                width: size.width*0.95,
                                height: size.height*0.15,
                                child: Image.network('https://www.teacheracademy.eu/wp-content/uploads/2020/02/english-classroom.jpg',fit: BoxFit.cover,),
                              ),
                              ListTile(
                                tileColor: lightGreyColor,
                                leading: CircleAvatar(
                                  backgroundColor: lightGreyColor,
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                                ),
                                // CircleAvatar(
                                //   backgroundColor: const Color(0xff764abc),
                                //   child: Text(ds['name'].toString()[0]),
                                // ),
                                title: Text(snapshot.data!.docs[0]["className"].toString(), style: body1Green,), // ${snapshot.data!.docs[0]["className"].toString()}
                                subtitle: Text(snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(), style: TextStyle(fontSize: 14,color: Colors.black),),
                                trailing:   Container(
                                  width: size.width*0.2,
                                  child: FlutterSwitch(
                                    activeColor: primaryColor,
                                    width: 43.0,
                                    height: 25.0,
                                    valueFontSize: 0.0,
                                    toggleSize: 18.0,
                                    value:
                                    snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" ? snapshot.data!.docs[0]["chapterToggle1"] :
                                    snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" ? snapshot.data!.docs[0]["chapterToggle2"] :
                                    snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" ? snapshot.data!.docs[0]["chapterToggle3"] :
                                    snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" ? snapshot.data!.docs[0]["chapterToggle4"] :
                                    false,
                                    borderRadius: 30.0,
                                    onToggle: (val) async {
                                      print("chap List toggle");
                                      print(val.toString());

                                      if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString())
                                            .update({
                                          "chapterToggle1": val,
                                        });
                                        updateInStudents(1, val, snapshot.data!.docs[0]["classCode"].toString());
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle2": val,
                                        });
                                        updateInStudents(2, val, snapshot.data!.docs[0]["classCode"].toString());
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle3": val,
                                        });
                                        updateInStudents(3, val, snapshot.data!.docs[0]["classCode"].toString());
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle4": val,
                                        });
                                        updateInStudents(4, val, snapshot.data!.docs[0]["classCode"].toString());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                            ),
                          )),
                    );
                  },
                  //Container(child: Text('AdminHome'),),
                ),
              ),
            );
          }
        },
      ),


    );
  }
}
