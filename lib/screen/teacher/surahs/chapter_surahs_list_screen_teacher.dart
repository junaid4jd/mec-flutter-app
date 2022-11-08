import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/student/student_screen_teacher.dart';
import 'package:mec/screen/teacher/studentEvaluation/student_evaluation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TeacherSurahListScreen extends StatefulWidget {
  final String classCode;
  final String chapterId;
  const TeacherSurahListScreen({Key? key, required this.classCode, required this.chapterId}) : super(key: key);

  @override
  _TeacherSurahListScreenState createState() => _TeacherSurahListScreenState();
}

class _TeacherSurahListScreenState extends State<TeacherSurahListScreen> {
  bool isPartOn = false;

  String name = '' , email = '';

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Teachers').doc(prefs.getString('userId')!).get().then((value) {
      print('Teachers get');
      print(value.data());
      setState(() {
        email = value.data()!['email'].toString();
        name = value.data()!['name'].toString();
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Chapter Surahs"),
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
          else if (snapshot.hasData) {
            //print(snapshot.data!.docs[0]["chapList"].toString());
            //chapterList = snapshot.data!.docs[0]["chapList"];

            // for(int i=0;i<snapshot.data!.docs[0]["chapList"].length;i++) {
            //  // setState(() {
            //     toggleVal[i] = false;
            //  // });
            // }

            //print(chapterList.toString());

            return

              Center(
                child: Container(
                  width: size.width*0.95,

                  child: ListView.builder(
                    itemCount: 3,//snapshot.data!.docs[0]["chapList"].length,
                    itemBuilder: (context, index) {
                      // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
                      return Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 155,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                                  //primaryColor
                                  , width: 1),
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width*0.8,
                                  height: 120,
                                  child: ListView.builder(

                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,//snapshot.data!.docs[0]["chapList"].length,
                                    itemBuilder: (context, index) {
                                      // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
                                      return GestureDetector(
                                        onTap: () {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  StudentEvaluationScreen(
                                                surahName: "الْإِخْلَاص",
                                                surahAyhs: "4",
                                                way: "surah",
                                                    teacherEmail: email,
                                              ),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      //color: redColor,
                                                      border: Border.all(color: Colors.grey,width: 3)
                                                  ),
                                                  width: 70,
                                                  height: 70,

                                                  child: Center(child: Text("الْإِخْلَاص")),
                                                ),
                                                Positioned.fill(
                                                  top: size.height*0.08,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child:  Icon(Icons.lock,
                                                      color: Colors.black,
                                                      //color: primaryColor,
                                                      size: 20,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                      Padding(
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
                                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                          "chapterToggle1": val,
                                                        });
                                                      }
                                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
                                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                          "chapterToggle2": val,
                                                        });
                                                      }
                                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
                                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                          "chapterToggle3": val,
                                                        });
                                                      }
                                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
                                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                          "chapterToggle4": val,
                                                        });
                                                      }

                                                      // setState(() {
                                                      //   toggleVal[index] = val;
                                                      // });
                                                      // print(snapshot.data!.docs[0].id.toString());

                                                      // updateListToggle(snapshot.data!.docs[0]["chapList"],
                                                      //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                                      //   val,
                                                      //     snapshot.data!.docs[0].id.toString()
                                                      // );

                                                      // FirebaseFirestore.instance.collection("Classes").

                                                      //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
                                                      // print(target.toString());
                                                      // print(target["chapterToggle"].toString());

                                                      //if (target != null) {
                                                      // setState(() {
                                                      //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
                                                      // });
                                                      //target["quantity"] + 1;
                                                      //}


                                                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      // prefs.setBool('statusDaily', val );
                                                      // prefs.setString('daily', statusDaily ? 'yes' : 'no');
                                                      // getSettingsStatus();
                                                      // postData1(status, 'security');
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                            ),
                                          ));
                                    },
                                    //Container(child: Text('AdminHome'),),
                                  ),
                                ),
                                Container(
                                  width: size.width*0.8,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: size.width*0.2,
                                        child: FlutterSwitch(
                                          activeColor: primaryColor,
                                          width: 40.0,
                                          height: 25.0,
                                          valueFontSize: 0.0,
                                          toggleSize: 18.0,
                                          value:
                                          // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" ? snapshot.data!.docs[0]["chapterToggle1"] :
                                          // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" ? snapshot.data!.docs[0]["chapterToggle2"] :
                                          // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" ? snapshot.data!.docs[0]["chapterToggle3"] :
                                          // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" ? snapshot.data!.docs[0]["chapterToggle4"] :
                                          false,
                                          borderRadius: 30.0,
                                          onToggle: (val) async {
                                            print("chap List toggle");
                                            print(val.toString());

                                            if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1") {
                                              FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                "chapterToggle1": val,
                                              });
                                            }
                                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
                                              FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                "chapterToggle2": val,
                                              });
                                            }
                                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
                                              FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                "chapterToggle3": val,
                                              });
                                            }
                                            else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
                                              FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                                "chapterToggle4": val,
                                              });
                                            }

                                            // setState(() {
                                            //   toggleVal[index] = val;
                                            // });
                                            // print(snapshot.data!.docs[0].id.toString());

                                            // updateListToggle(snapshot.data!.docs[0]["chapList"],
                                            //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                            //   val,
                                            //     snapshot.data!.docs[0].id.toString()
                                            // );

                                            // FirebaseFirestore.instance.collection("Classes").

                                            //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
                                            // print(target.toString());
                                            // print(target["chapterToggle"].toString());

                                            //if (target != null) {
                                            // setState(() {
                                            //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
                                            // });
                                            //target["quantity"] + 1;
                                            //}


                                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                                            // prefs.setBool('statusDaily', val );
                                            // prefs.setString('daily', statusDaily ? 'yes' : 'no');
                                            // getSettingsStatus();
                                            // postData1(status, 'security');
                                          },
                                        ),
                                      ),

                                  ],)
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              left: size.width*0.27,
                              top: 12,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                color: Colors.white,
                                child: Text(
                                  'Chapter surah part - ${index+1}',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              )),
                        ],
                      );


                        Padding(
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
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle1": val,
                                        });
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle2": val,
                                        });
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle3": val,
                                        });
                                      }
                                      else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
                                        FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
                                          "chapterToggle4": val,
                                        });
                                      }

                                      // setState(() {
                                      //   toggleVal[index] = val;
                                      // });
                                      // print(snapshot.data!.docs[0].id.toString());

                                      // updateListToggle(snapshot.data!.docs[0]["chapList"],
                                      //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
                                      //   val,
                                      //     snapshot.data!.docs[0].id.toString()
                                      // );

                                      // FirebaseFirestore.instance.collection("Classes").

                                      //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
                                      // print(target.toString());
                                      // print(target["chapterToggle"].toString());

                                      //if (target != null) {
                                      // setState(() {
                                      //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
                                      // });
                                      //target["quantity"] + 1;
                                      //}


                                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                                      // prefs.setBool('statusDaily', val );
                                      // prefs.setString('daily', statusDaily ? 'yes' : 'no');
                                      // getSettingsStatus();
                                      // postData1(status, 'security');
                                    },
                                  ),
                                ),
                              ),
                            ],
                            ),
                          ));
                    },
                    //Container(child: Text('AdminHome'),),
                  ),
                ),
              );
          } // git commit -m "first commit"
          else {
            return Center(
              child: Text(
                'No Data Found...',style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),


    );
  }
}
