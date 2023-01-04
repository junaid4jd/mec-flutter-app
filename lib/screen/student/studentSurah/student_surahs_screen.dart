import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';


import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/soundRecorder.dart';
import 'package:mec/model/student_classes_model.dart' as studentModel;
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/teacher/studentEvaluation/ayah_evaluation_screen.dart';
import 'package:mec/screen/teacher/studentEvaluation/student_evaluation_screen.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSurahScreen extends StatefulWidget {
  final String classCode;
  final String chapterId;
  final String classDocId;
  final String chapterName;
  final String studentDocId;
  final int chapIndex;
  final TeacherClasseModel teacherClasseModel;
  const StudentSurahScreen({Key? key,
    required this.classCode, required this.chapterId, required this.teacherClasseModel, required this.classDocId,
    required this.chapterName,
    required this.studentDocId,
    required this.chapIndex
  }) : super(key: key);

  @override
  _StudentSurahScreenState createState() => _StudentSurahScreenState();
}

class _StudentSurahScreenState extends State<StudentSurahScreen> {
  bool isPartOn = false;
  bool isLoading = false;
  bool part1On = false;
  bool part2On = false;
  bool part3On = false;
  int partOneBadgeCount = 0;
  int partTwoBadgeCount = 0;
  int partThreeBadgeCount = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<ChapList>? chapListForUpdate;
  TeacherClasseModel? teacherClasseModelUpdated;
  studentModel.StudentClassesModel? studentClassesModel;
  List<Map<String, dynamic>> chapterPartList = [];
  List<Map<String, dynamic>> chapterStudentList = [];
  String name = '' , email = '',studentEmail = '',studentName = '',studentsUpdated = 'no';

  @override
  void initState() {
    // TODO: implement initState
    getStudentData();
    setState(() {
      partOneBadgeCount = 0;
      partTwoBadgeCount = 0;
      partThreeBadgeCount = 0;
    });
    getBadges();
    getChapPart();
    print('we are in teacher surah list');
    print(widget.teacherClasseModel.chapPartList!.length);
    print(widget.teacherClasseModel.chapPartList![int.parse(widget.chapterId.toString())-1].part1Toggle);
    setState(() {
      isLoading = false;
      studentsUpdated = 'no';
    });
    getData();
    //getEncodedData();
    super.initState();
  }

  getBadges() async {

    setState(() {
       partOneBadgeCount = 0;
       partTwoBadgeCount = 0;
       partThreeBadgeCount = 0;
    });

    FirebaseFirestore.instance.collection('StudentEvaluatedSurah').where('classCode', isEqualTo: widget.classCode.toString())
        .where('studentUid', isEqualTo: _auth.currentUser!.uid)
        .where('chapterId', isEqualTo: widget.chapterId).get().then((value) {


          if(value.docs.isNotEmpty) {
            for(int i=0 ;i<value.docs.length ; i++) {

              // if(widget.chapterId == '1' ) {
              //
              // }
              // else if(widget.chapterId == '2') {
              //
              // }
              // else if(widget.chapterId == '3') {
              //
              // }
              // else if(widget.chapterId == '4') {
              //
              // }

              if(value.docs[i]['surahCompleted'].toString() == 'yes' && value.docs[i]['partNo'] == 0  ) {
                print(value.docs[i]['surahName'].toString() + ' Completed surah');
                setState(() {
                  partOneBadgeCount = partOneBadgeCount +1;
                });
              } else if(value.docs[i]['surahCompleted'].toString() == 'yes' && value.docs[i]['partNo'] == 1  ){

                setState(() {
                  partTwoBadgeCount = partTwoBadgeCount +1;
                });

              } else if(value.docs[i]['surahCompleted'].toString() == 'yes' && value.docs[i]['partNo'] == 2  ){
                setState(() {
                  partThreeBadgeCount = partThreeBadgeCount +1;
                });
              }

            }
          }


    });

  }

  getChapPart() async {

    for(int i=0; i<= widget.teacherClasseModel.chapPartList!.length ; i++) {

      if(widget.teacherClasseModel.chapPartList![i].chapterName.toString() == widget.chapterName) {
        print('chapPart is here');
        setState(() {
          part1On = widget.teacherClasseModel.chapPartList![i].part1Toggle!;
          part2On = widget.teacherClasseModel.chapPartList![i].part2Toggle!;
          part3On = widget.teacherClasseModel.chapPartList![i].part3Toggle!;
        });
      }
    }

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

  getStudentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Students').doc(_auth.currentUser!.uid.toString()).get().then((value) {
      print('Student get');
      print(value.data());
      setState(() {
        studentEmail = value.data()!['email'].toString();
        studentName = value.data()!['name'].toString();
      });
    });
  }

  getStudentClasses(List<Map<String, dynamic>> model) async {

    FirebaseFirestore.instance.collection('StudentClasses').where('classCode', isEqualTo: widget.classCode.toString() ).get().then((value) {
      print(' This is the class data you picked student');
      print(value.docs.length.toString());

      for(int i=0 ;i<value.docs.length;i++) {
        FirebaseFirestore.instance.collection("StudentClasses").doc(value.docs[i].id.toString())
            .update({'chapPartList': model}).then((value1) {
          print("Updated");
        });
      }
      setState(() {
        studentsUpdated = 'yes';
        isLoading = false;
      });
      //var data = json.encode(value.data());
      // setState(() {
      //   studentClassesModel  =  studentModel.StudentClassesModel.fromJson(json.decode(data));
      // });
    });

  }

  getEncodedData() async {
    var json = jsonEncode(widget.teacherClasseModel.chapList![widget.chapIndex].content!.toJson());
    print(json + 'This is content');
    // var json = jsonEncode(opAttrList, toEncodable: (e) => e.toJsonAttr());
  }

  updateModel () async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Classes').doc(widget.classDocId.toString()).get().then((value) {
      print(' This is the class data you picked');
      var data = json.encode(value.data());
      setState(() {
        teacherClasseModelUpdated  =  TeacherClasseModel.fromJson(json.decode(data));
      });
      setState(() {
        chapterStudentList.clear();
      });
      for(int i=0; i<teacherClasseModelUpdated!.chapPartList!.length;i++) {
        chapterStudentList.add(teacherClasseModelUpdated!.chapPartList![i].toJson());
      }
      getStudentClasses(chapterStudentList);
      print('Teacher Name');
      print(teacherClasseModelUpdated!.teacherName.toString());
    });

  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.teacherClasseModel.chapList![widget.chapIndex].chapterName.toString()),
        centerTitle: true,
      ),

      body:
      isLoading ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 1,

        ),
      ) :

      ListView.builder(
        itemCount: widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs!.length,//snapshot.data!.docs[0]["chapList"].length,
        itemBuilder: (context, index) {
          // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
          return

            Container(
            width: double.infinity,
            height: 185,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                  index == 0 && part1On ? primaryColor :
                  index == 1 && part2On ? primaryColor :
                  index == 2 && part3On ? primaryColor :

                  Colors.grey
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
                    itemCount:
                    index == 0 ?  widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1!.length :
                    index == 1 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2!.length :
                    index == 2 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3!.length :
                    0
                    ,
                    itemBuilder: (context, indexSurah) {
                      return GestureDetector(
                        onTap: () {

                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (c, a1, a2) =>
                          //         DailyFollowUpAyahScreen(
                          //           surahName: "الْإِخْلَاص",
                          //           surahAyhs: "4",
                          //           way: "surah",
                          //           teacherEmail: email,
                          //         ),
                          //     transitionsBuilder: (c, anim, a2, child) =>
                          //         FadeTransition(opacity: anim, child: child),
                          //     transitionDuration: Duration(milliseconds: 0),
                          //   ),
                          // );

                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (c, a1, a2) =>
                          //         StudentEvaluationScreen(
                          //       surahName: "الْإِخْلَاص",
                          //       surahAyhs: "4",
                          //       way: "surah",
                          //           teacherEmail: email,
                          //     ),
                          //     transitionsBuilder: (c, anim, a2, child) =>
                          //         FadeTransition(opacity: anim, child: child),
                          //     transitionDuration: Duration(milliseconds: 0),
                          //   ),
                          // );


                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>
                                  AyahEvaluationScreen(
                                      studentUid: _auth.currentUser!.uid.toString(),
                                      studentName: studentName,

                                      surahNumber:

                                      index == 0 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString() :
                                      index == 1 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString() :
                                      index == 2 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString() :
                                      "الْإِخْلَاص",


                                      surahName:
                                      index == 0 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString())).toString() :
                                      index == 1 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString() :
                                      index == 2 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString() :
                                      "الْإِخْلَاص",
                                      surahAyhs:
                                      index == 0 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].verses!.surahVerses!.length.toString()
                                      //getVerseCount(int.parse(.surahName.toString())).toString()
                                          :
                                      index == 1 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].verses!.surahVerses!.length.toString() :
                                      //getVerseCount(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString() :
                                      index == 2 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].verses!.surahVerses!.length.toString() :
                                      // getVerseCount(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString() :
                                      "0",//snapshot.data!.docs[index]['studentUid'].toString(),


                                      way: "studentRecording",
                                      surahIndex: index,
                                      teacherEmail: email,
                                      chapterName: widget.chapterName,
                                      chapterId: widget.chapterId,
                                      classDocId: widget.classDocId,
                                      classCode: widget.classCode, // partNo
                                      studentDocId: widget.studentDocId,//snapshot.data!.docs[index]['studentUid'].toString(),
                                      partIndex: index,
                                      chapterIndex: widget.chapIndex
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
                            //color: redColor,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //color: redColor,
                                      border: Border.all(color:
                                      index == 0 && part1On ? primaryColor :
                                      index == 1 && part2On ? primaryColor :
                                      index == 2 && part3On ? primaryColor :

                                      Colors.grey,width: 3)
                                  ),
                                  width: 80,
                                  height: 80,

                                  child: Center(child: Text(
                                      index == 0 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString())).toString()

                                          :
                                      index == 1 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString()
                                          :
                                      index == 2 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString()
                                          :
                                      "الْإِخْلَاص"
                                      "الْإِخْلَاص")),
                                ),
                                // Positioned.fill(
                                //   top: size.height*0.09,
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child:  Icon(Icons.star,
                                //       color:
                                //       index == 0 && part1On ? Colors.amber :
                                //       index == 1 && part2On ? Colors.amber :
                                //       index == 2 && part3On ? Colors.amber :
                                //       Colors.grey,
                                //       //color: primaryColor,
                                //       size: 25,),
                                //   ),
                                // ),
                                // Positioned.fill(
                                //   left: size.width*0.15,
                                //   top: size.height*0.05,
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child:  Icon(Icons.star,
                                //       color:
                                //       index == 0 && part1On ? Colors.amber :
                                //       index == 1 && part2On ? Colors.amber :
                                //       index == 2 && part3On ? Colors.amber :
                                //
                                //
                                //       Colors.grey,
                                //       //color: primaryColor,
                                //       size: 25,),
                                //   ),
                                // ),
                                // Positioned.fill(
                                //   right: size.width*0.15,
                                //   top: size.height*0.05,
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child:  Icon(Icons.star,
                                //       color:
                                //       index == 0 && part1On ? Colors.amber :
                                //       index == 1 && part2On ? Colors.amber :
                                //       index == 2 && part3On ? Colors.amber :
                                //       Colors.grey,
                                //       //color: primaryColor,
                                //       size: 25,),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );



                        GestureDetector(
                        onTap: () {
                          // if((index == 0 && part1On)  || (index == 1 && part2On) || (index == 2 && part3On) ) {
                          //   Navigator.push(
                          //     context,
                          //     PageRouteBuilder(
                          //       pageBuilder: (c, a1, a2) =>
                          //           StudentEvaluationScreen(
                          //             surahNumber:
                          //
                          //             index == 0 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString() :
                          //             index == 1 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString() :
                          //             index == 2 ? widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString() :
                          //             "الْإِخْلَاص",
                          //
                          //
                          //             surahName:
                          //             index == 0 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString())).toString() :
                          //             index == 1 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString() :
                          //             index == 2 ? getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString() :
                          //             "الْإِخْلَاص",
                          //             surahAyhs:
                          //             index == 0 ? getVerseCount(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString())).toString() :
                          //             index == 1 ? getVerseCount(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString() :
                          //             index == 2 ? getVerseCount(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString() :
                          //             "0",
                          //             way: "surah",
                          //             chapterId: widget.chapterId,
                          //             classDocId: widget.classDocId,
                          //             chapterName: widget.chapterName,
                          //             classCode: widget.teacherClasseModel.classCode.toString(),
                          //             teacherEmail: email,
                          //             chapterIndex: widget.chapIndex,
                          //             partIndex: index,
                          //             teacherClasseModel: teacherClasseModelUpdated == null ? widget.teacherClasseModel : teacherClasseModelUpdated!,
                          //           ),
                          //       transitionsBuilder: (c, anim, a2, child) =>
                          //           FadeTransition(opacity: anim, child: child),
                          //       transitionDuration: Duration(milliseconds: 0),
                          //     ),
                          //   );
                          // }
                          // else {
                          //   Fluttertoast.showToast(
                          //     msg: "Sorry Part is off!",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 4,
                          //   );
                          // }
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
                                      border: Border.all(color:
                                      index == 0 && part1On ? primaryColor :
                                      index == 1 && part2On ? primaryColor :
                                      index == 2 && part3On ? primaryColor :

                                      Colors.grey,
                                          width: 3)
                                  ),
                                  width: 70,
                                  height: 70,

                                  child: Center(child: Text(
                                      index == 0 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part1![indexSurah].surahName.toString())).toString()

                                          :
                                      index == 1 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part2![indexSurah].surahName.toString())).toString()
                                          :
                                      index == 2 ?
                                      getSurahNameArabic(int.parse(widget.teacherClasseModel.chapList![widget.chapIndex].content!.surahs![index].part3![indexSurah].surahName.toString())).toString()
                                          :
                                      "الْإِخْلَاص"

                                  )),
                                ),
                                Positioned.fill(
                                  top: size.height*0.08,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child:
                                    index == 0 && part1On ? Container() :
                                    index == 1 && part2On ? Container() :
                                    index == 2 && part3On ? Container() :
                                    Icon(
                                      Icons.lock,
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

                    },
                    //Container(child: Text('AdminHome'),),
                  ),
                ),

                Container(
                    width: size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: size.width*0.2,
                          child:

                          widget.chapterId == '1' ? Image.asset(

                   index == 0 && partOneBadgeCount == 4 ? 'assets/images/ribbon.png' :
                   index == 1 && partTwoBadgeCount == 2 ? 'assets/images/ribbon.png' :
                   index == 2 && partThreeBadgeCount == 2 ? 'assets/images/ribbon.png' :

                       'assets/images/ribbon_black.png' ,



                          ) :
                          widget.chapterId == '2' ? Image.asset(

                            index == 0 && partOneBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 1 && partTwoBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 2 && partThreeBadgeCount == 2 ? 'assets/images/ribbon.png' :

                       'assets/images/ribbon_black.png' ,



                          ) :
                          widget.chapterId == '3' ? Image.asset(

                            index == 0 && partOneBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 1 && partTwoBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 2 && partThreeBadgeCount == 2 ? 'assets/images/ribbon.png' :
                       'assets/images/ribbon_black.png' ,



                          ) :
                          widget.chapterId == '4' ? Image.asset(

                            index == 0 && partOneBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 1 && partTwoBadgeCount == 2 ? 'assets/images/ribbon.png' :
                            index == 2 && partThreeBadgeCount == 2 ? 'assets/images/ribbon.png' :
                       'assets/images/ribbon_black.png' ,



                          ) : Image.asset('assets/images/ribbon_black.png' ,)

                          // FlutterSwitch(
                          //   activeColor: primaryColor,
                          //   width: 40.0,
                          //   height: 25.0,
                          //   valueFontSize: 0.0,
                          //   toggleSize: 18.0,
                          //   value:
                          //   index == 0 ? part1On :
                          //   index == 1 ? part2On :
                          //   index == 2 ? part3On :
                          //
                          //   false,
                          //   borderRadius: 30.0,
                          //   onToggle: (val) async {
                          //     setState(() {
                          //       chapterPartList.clear();
                          //     });
                          //     print("chap List toggle");
                          //     print(val.toString());
                          //
                          //     if(widget.chapterName.toString() == "جزء عم") {
                          //       print("chapter 1");
                          //
                          //       if( index == 0) {
                          //
                          //         setState(() {
                          //           part1On = !part1On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapPartList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapPartList![i].chapterName == "جزء عم")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //       else if(index == 1) {
                          //         setState(() {
                          //           part2On = !part2On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء عم")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //
                          //       }
                          //       else if(index == 2) {
                          //         setState(() {
                          //           part3On = !part3On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء عم")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //
                          //     }
                          //     else if(widget.chapterName.toString() == "جزء تبارك") {
                          //
                          //       if( index == 0) {
                          //
                          //         setState(() {
                          //           part1On = !part1On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء تبارك")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //       else if(index == 1) {
                          //         setState(() {
                          //           part2On = !part2On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء تبارك")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //
                          //       }
                          //       else if(index == 2) {
                          //         setState(() {
                          //           part3On = !part3On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء تبارك")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //
                          //     }
                          //     else if(widget.chapterName.toString() == "جزء قدسمع") {
                          //
                          //       if( index == 0) {
                          //
                          //         setState(() {
                          //           part1On = !part1On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء قدسمع")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //       else if(index == 1) {
                          //         setState(() {
                          //           part2On = !part2On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء قدسمع")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //
                          //       }
                          //       else if(index == 2) {
                          //         setState(() {
                          //           part3On = !part3On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء قدسمع")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //
                          //     }
                          //     else if(widget.chapterName.toString() == "جزء الذارياتِ") {
                          //       print("chapter 4");
                          //
                          //       if( index == 0) {
                          //
                          //         setState(() {
                          //           part1On = !part1On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء الذاريات")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //       else if(index == 1) {
                          //         setState(() {
                          //           part2On = !part2On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء الذاريات")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //
                          //       }
                          //       else if(index == 2) {
                          //         setState(() {
                          //           part3On = !part3On;
                          //           isLoading = true;
                          //         });
                          //
                          //         for(int i=0 ; i<widget.teacherClasseModel.chapList!.length ; i++) {
                          //           if(widget.teacherClasseModel.chapList![i].chapterName == "جزء الذاريات")
                          //           {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterId": widget.chapterId,
                          //                 "chapterName": widget.chapterName,
                          //                 "part1Toggle": part1On,
                          //                 "part2Toggle": part2On,
                          //                 "part3Toggle": part3On,
                          //               });
                          //             });
                          //           }
                          //           else {
                          //             print("$i this is i");
                          //             setState(() {
                          //               chapterPartList.add({
                          //                 "chapterName": widget.teacherClasseModel.chapPartList![i].chapterName,
                          //                 "chapterId": widget.teacherClasseModel.chapPartList![i].chapterId,
                          //                 "part1Toggle": widget.teacherClasseModel.chapPartList![i].part1Toggle,
                          //                 "part2Toggle": widget.teacherClasseModel.chapPartList![i].part2Toggle,
                          //                 "part3Toggle": widget.teacherClasseModel.chapPartList![i].part3Toggle,
                          //
                          //               });
                          //             });
                          //
                          //           }
                          //         }
                          //         FirebaseFirestore.instance.collection("Classes").doc(widget.classDocId).update({'chapPartList': chapterPartList}).then((value) {
                          //           print("Updated");
                          //           updateModel();
                          //         });
                          //       }
                          //     }
                          //
                          //
                          //   },
                          // ),
                        ),

                      ],)
                ),
              ],
            ),
          );

        },
      ),

      // StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection("Classes").where("classCode",isEqualTo: widget.classCode.toString()).snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(child: CircularProgressIndicator(
      //         strokeWidth: 1,
      //         color: primaryColor,
      //       ));
      //     }
      //     else if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
      //       // got data from snapshot but it is empty
      //       return Center(child: Text("No Data Found"));
      //     }
      //     else{
      //       //print(snapshot.data!.docs[0]["chapList"].toString());
      //       //chapterList = snapshot.data!.docs[0]["chapList"];
      //
      //       // for(int i=0;i<snapshot.data!.docs[0]["chapList"].length;i++) {
      //       //  // setState(() {
      //       //     toggleVal[i] = false;
      //       //  // });
      //       // }
      //
      //       //print(chapterList.toString());
      //       return Center(
      //           child: Container(
      //             width: size.width*0.95,
      //             child: ListView.builder(
      //               itemCount: 3,//snapshot.data!.docs[0]["chapList"].length,
      //               itemBuilder: (context, index) {
      //                 // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
      //                 return GestureDetector(
      //                   onTap: () {
      //                     // Navigator.of(context).push(MaterialPageRoute(
      //                     //   builder: (context) => DailyFollowUpAyahScreen(),
      //                     // ));
      //                   },
      //                   child: Stack(
      //                     children: <Widget>[
      //                       Container(
      //                         width: double.infinity,
      //                         height: 155,
      //                         margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      //                         padding: EdgeInsets.only(bottom: 10),
      //                         decoration: BoxDecoration(
      //                           border: Border.all(
      //                               color: Colors.grey
      //                               //primaryColor
      //                               , width: 1),
      //                           borderRadius: BorderRadius.circular(5),
      //                           shape: BoxShape.rectangle,
      //                         ),
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               width: size.width*0.8,
      //                               height: 120,
      //                               child: ListView.builder(
      //
      //                                 scrollDirection: Axis.horizontal,
      //                                 itemCount: 5,//snapshot.data!.docs[0]["chapList"].length,
      //                                 itemBuilder: (context, index) {
      //                                   // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
      //                                   return GestureDetector(
      //                                     onTap: () {
      //
      //                                       Navigator.push(
      //                                         context,
      //                                         PageRouteBuilder(
      //                                           pageBuilder: (c, a1, a2) =>
      //                                               DailyFollowUpAyahScreen(
      //                                                 surahName: "الْإِخْلَاص",
      //                                                 surahAyhs: "4",
      //                                                 way: "surah",
      //                                                 teacherEmail: email,
      //                                               ),
      //                                           transitionsBuilder: (c, anim, a2, child) =>
      //                                               FadeTransition(opacity: anim, child: child),
      //                                           transitionDuration: Duration(milliseconds: 0),
      //                                         ),
      //                                       );
      //
      //                                       // Navigator.push(
      //                                       //   context,
      //                                       //   PageRouteBuilder(
      //                                       //     pageBuilder: (c, a1, a2) =>
      //                                       //         StudentEvaluationScreen(
      //                                       //       surahName: "الْإِخْلَاص",
      //                                       //       surahAyhs: "4",
      //                                       //       way: "surah",
      //                                       //           teacherEmail: email,
      //                                       //     ),
      //                                       //     transitionsBuilder: (c, anim, a2, child) =>
      //                                       //         FadeTransition(opacity: anim, child: child),
      //                                       //     transitionDuration: Duration(milliseconds: 0),
      //                                       //   ),
      //                                       // );
      //
      //                                     },
      //                                     child: Padding(
      //                                       padding: const EdgeInsets.all(8.0),
      //                                       child: Container(
      //                                         width: 80,
      //                                         height: 80,
      //                                         child: Stack(
      //                                           alignment: Alignment.center,
      //                                           children: [
      //                                             Container(
      //                                               decoration: BoxDecoration(
      //                                                   shape: BoxShape.circle,
      //                                                   //color: redColor,
      //                                                   border: Border.all(color: Colors.grey,width: 3)
      //                                               ),
      //                                               width: 70,
      //                                               height: 70,
      //
      //                                               child: Center(child: Text("الْإِخْلَاص")),
      //                                             ),
      //                                             Positioned.fill(
      //                                               top: size.height*0.08,
      //                                               child: Align(
      //                                                 alignment: Alignment.center,
      //                                                 child:  Icon(Icons.lock,
      //                                                   color: Colors.black,
      //                                                   //color: primaryColor,
      //                                                   size: 20,),
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   );
      //
      //                                 },
      //                                 //Container(child: Text('AdminHome'),),
      //                               ),
      //                             ),
      //                             Container(
      //                               width: size.width*0.8,
      //                               height: 20,
      //                               child: Row(
      //                                 mainAxisAlignment: MainAxisAlignment.end,
      //                                 children: [
      //                                   Container(
      //                                     width: size.width*0.2,
      //                                     child: FlutterSwitch(
      //                                       activeColor: primaryColor,
      //                                       width: 40.0,
      //                                       height: 25.0,
      //                                       valueFontSize: 0.0,
      //                                       toggleSize: 18.0,
      //                                       value:
      //                                       // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" ? snapshot.data!.docs[0]["chapterToggle1"] :
      //                                       // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" ? snapshot.data!.docs[0]["chapterToggle2"] :
      //                                       // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" ? snapshot.data!.docs[0]["chapterToggle3"] :
      //                                       // snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" ? snapshot.data!.docs[0]["chapterToggle4"] :
      //                                       false,
      //                                       borderRadius: 30.0,
      //                                       onToggle: (val) async {
      //                                         print("chap List toggle");
      //                                         print(val.toString());
      //
      //                                         if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1") {
      //                                           FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                             "chapterToggle1": val,
      //                                           });
      //                                         }
      //                                         else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
      //                                           FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                             "chapterToggle2": val,
      //                                           });
      //                                         }
      //                                         else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
      //                                           FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                             "chapterToggle3": val,
      //                                           });
      //                                         }
      //                                         else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
      //                                           FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                             "chapterToggle4": val,
      //                                           });
      //                                         }
      //
      //                                         // setState(() {
      //                                         //   toggleVal[index] = val;
      //                                         // });
      //                                         // print(snapshot.data!.docs[0].id.toString());
      //
      //                                         // updateListToggle(snapshot.data!.docs[0]["chapList"],
      //                                         //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
      //                                         //   val,
      //                                         //     snapshot.data!.docs[0].id.toString()
      //                                         // );
      //
      //                                         // FirebaseFirestore.instance.collection("Classes").
      //
      //                                         //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
      //                                         // print(target.toString());
      //                                         // print(target["chapterToggle"].toString());
      //
      //                                         //if (target != null) {
      //                                         // setState(() {
      //                                         //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
      //                                         // });
      //                                         //target["quantity"] + 1;
      //                                         //}
      //
      //
      //                                         // SharedPreferences prefs = await SharedPreferences.getInstance();
      //                                         // prefs.setBool('statusDaily', val );
      //                                         // prefs.setString('daily', statusDaily ? 'yes' : 'no');
      //                                         // getSettingsStatus();
      //                                         // postData1(status, 'security');
      //                                       },
      //                                     ),
      //                                   ),
      //
      //                               ],)
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       Positioned(
      //                           left: size.width*0.27,
      //                           top: 12,
      //                           child: Container(
      //                             padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      //                             color: Colors.white,
      //                             child: Text(
      //                               'Chapter surah part - ${index+1}',
      //                               style: TextStyle(color: Colors.grey, fontSize: 12),
      //                             ),
      //                           )),
      //                     ],
      //                   ),
      //                 );
      //
      //
      //                   Padding(
      //                     padding: const EdgeInsets.all(8),
      //                     child: Container(
      //                       height: size.height*0.25,
      //                       width: size.width*0.95,
      //                       decoration: BoxDecoration(
      //                         color:
      //
      //                         snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" && snapshot.data!.docs[0]["chapterToggle1"] == true ? Colors.white :
      //                         snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" && snapshot.data!.docs[0]["chapterToggle2"] == true ? Colors.white :
      //                         snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" && snapshot.data!.docs[0]["chapterToggle3"] == true ? Colors.white :
      //                         snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" && snapshot.data!.docs[0]["chapterToggle4"] == true ? Colors.white :
      //                         Colors.grey.withOpacity(0.5),
      //
      //                         borderRadius: BorderRadius.circular(10),
      //                         border: Border.all(color: greyColor,width: 0.5),
      //                       ),
      //                       child: Column(children: [
      //
      //                         Container(
      //                           decoration: BoxDecoration(
      //                             color: primaryColor.withOpacity(0.8),
      //                             borderRadius: BorderRadius.circular(10),
      //                             //border: Border.all(color: greyColor,width: 0.5),
      //                           ),
      //                           width: size.width*0.95,
      //                           height: size.height*0.15,
      //                           child: Image.network('https://www.teacheracademy.eu/wp-content/uploads/2020/02/english-classroom.jpg',fit: BoxFit.cover,),
      //                         ),
      //                         ListTile(
      //                           tileColor: lightGreyColor,
      //                           leading: CircleAvatar(
      //                             backgroundColor: lightGreyColor,
      //                             radius: 30,
      //                             backgroundImage: NetworkImage(
      //                                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
      //                           ),
      //                           // CircleAvatar(
      //                           //   backgroundColor: const Color(0xff764abc),
      //                           //   child: Text(ds['name'].toString()[0]),
      //                           // ),
      //                           title: Text(snapshot.data!.docs[0]["className"].toString(), style: body1Green,), // ${snapshot.data!.docs[0]["className"].toString()}
      //                           subtitle: Text(snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(), style: TextStyle(fontSize: 14,color: Colors.black),),
      //                           trailing:   Container(
      //                             width: size.width*0.2,
      //                             child: FlutterSwitch(
      //                               activeColor: primaryColor,
      //                               width: 43.0,
      //                               height: 25.0,
      //                               valueFontSize: 0.0,
      //                               toggleSize: 18.0,
      //                               value:
      //                               snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1" ? snapshot.data!.docs[0]["chapterToggle1"] :
      //                               snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2" ? snapshot.data!.docs[0]["chapterToggle2"] :
      //                               snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3" ? snapshot.data!.docs[0]["chapterToggle3"] :
      //                               snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4" ? snapshot.data!.docs[0]["chapterToggle4"] :
      //                               false,
      //                               borderRadius: 30.0,
      //                               onToggle: (val) async {
      //                                 print("chap List toggle");
      //                                 print(val.toString());
      //
      //                                 if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "1") {
      //                                   FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                     "chapterToggle1": val,
      //                                   });
      //                                 }
      //                                 else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "2") {
      //                                   FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                     "chapterToggle2": val,
      //                                   });
      //                                 }
      //                                 else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "3") {
      //                                   FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                     "chapterToggle3": val,
      //                                   });
      //                                 }
      //                                 else if(snapshot.data!.docs[0]["chapList"][index]["chapterId"].toString() == "4") {
      //                                   FirebaseFirestore.instance.collection("Classes").doc(snapshot.data!.docs[0].id.toString()).update({
      //                                     "chapterToggle4": val,
      //                                   });
      //                                 }
      //
      //                                 // setState(() {
      //                                 //   toggleVal[index] = val;
      //                                 // });
      //                                 // print(snapshot.data!.docs[0].id.toString());
      //
      //                                 // updateListToggle(snapshot.data!.docs[0]["chapList"],
      //                                 //     snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString(),
      //                                 //   val,
      //                                 //     snapshot.data!.docs[0].id.toString()
      //                                 // );
      //
      //                                 // FirebaseFirestore.instance.collection("Classes").
      //
      //                                 //  var target = snapshot.data!.docs[0]["chapList"].firstWhere((item) => item["chapterName"] == snapshot.data!.docs[0]["chapList"][index]["chapterName"].toString());
      //                                 // print(target.toString());
      //                                 // print(target["chapterToggle"].toString());
      //
      //                                 //if (target != null) {
      //                                 // setState(() {
      //                                 //   snapshot.data!.docs[0]["chapList"][index]["chapterToggle"] = val;
      //                                 // });
      //                                 //target["quantity"] + 1;
      //                                 //}
      //
      //
      //                                 // SharedPreferences prefs = await SharedPreferences.getInstance();
      //                                 // prefs.setBool('statusDaily', val );
      //                                 // prefs.setString('daily', statusDaily ? 'yes' : 'no');
      //                                 // getSettingsStatus();
      //                                 // postData1(status, 'security');
      //                               },
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                       ),
      //                     ));
      //               },
      //               //Container(child: Text('AdminHome'),),
      //             ),
      //           ),
      //         );
      //     } // git commit -m "first commit"
      //     // git remote add origin https://github.com/junaid4jd/mec-flutter-app.git
      //
      //   },
      // ),


    );
  }
}



// class StudentSurahScreen extends StatefulWidget {
//   final String classCode;
//   final int chapterIndex;
//   const StudentSurahScreen({Key? key, required this.classCode, required this.chapterIndex}) : super(key: key);
//
//   @override
//   _StudentSurahScreenState createState() => _StudentSurahScreenState();
// }
//
// class _StudentSurahScreenState extends State<StudentSurahScreen> {
//   @override
//   Widget build(BuildContext context) {
//
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: Text("Chapter Surahs"),
//         centerTitle: true,
//       ),
//       body:
//       ListView.builder(
//         itemCount: 3,//snapshot.data!.docs[0]["chapList"].length,
//         itemBuilder: (context, index) {
//           // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
//           return
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: size.height*0.01,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(width: 2,color: primaryColor)
//                     ),
//                     height: size.height*0.31,
//                     child: GridView.builder(
//                         padding: EdgeInsets.zero,
//                         shrinkWrap: true,
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           //maxCrossAxisExtent: 200,
//                           //childAspectRatio: 3 / 2,
//                             crossAxisSpacing: 10,
//                             crossAxisCount: 4,
//
//                             mainAxisSpacing: 10),
//                         itemCount: 12,//snapshot.data!.docs.length,//myProducts.length,
//                         itemBuilder: (BuildContext ctx, index) {
//                           return
//                           GestureDetector(
//                             onTap: () {
//
//                               // Navigator.push(
//                               //   context,
//                               //   PageRouteBuilder(
//                               //     pageBuilder: (c, a1, a2) =>
//                               //         DailyFollowUpAyahScreen(
//                               //           surahName: "الْإِخْلَاص",
//                               //           surahAyhs: "4",
//                               //           way: "surah",
//                               //           teacherEmail: email,
//                               //         ),
//                               //     transitionsBuilder: (c, anim, a2, child) =>
//                               //         FadeTransition(opacity: anim, child: child),
//                               //     transitionDuration: Duration(milliseconds: 0),
//                               //   ),
//                               // );
//
//                               // Navigator.push(
//                               //   context,
//                               //   PageRouteBuilder(
//                               //     pageBuilder: (c, a1, a2) =>
//                               //         StudentEvaluationScreen(
//                               //       surahName: "الْإِخْلَاص",
//                               //       surahAyhs: "4",
//                               //       way: "surah",
//                               //           teacherEmail: email,
//                               //     ),
//                               //     transitionsBuilder: (c, anim, a2, child) =>
//                               //         FadeTransition(opacity: anim, child: child),
//                               //     transitionDuration: Duration(milliseconds: 0),
//                               //   ),
//                               // );
//
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 //color: redColor,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           //color: redColor,
//                                           border: Border.all(color: Colors.grey,width: 3)
//                                       ),
//                                       width: 60,
//                                       height: 60,
//
//                                       child: Center(child: Text("الْإِخْلَاص")),
//                                     ),
//                                     Positioned.fill(
//                                       top: size.height*0.055,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child:  Icon(Icons.star,
//                                           color: Colors.black,
//                                           //color: primaryColor,
//                                           size: 20,),
//                                       ),
//                                     ),
//                                     Positioned.fill(
//                                       left: size.width*0.11,
//                                       top: size.height*0.04,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child:  Icon(Icons.star,
//                                           color: Colors.black,
//                                           //color: primaryColor,
//                                           size: 20,),
//                                       ),
//                                     ),
//                                     Positioned.fill(
//                                       right: size.width*0.11,
//                                       top: size.height*0.04,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child:  Icon(Icons.star,
//                                           color: Colors.black,
//                                           //color: primaryColor,
//                                           size: 20,),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//
//               ],
//             ),
//           );
//         },
//         //Container(child: Text('AdminHome'),),
//       ),
//
//
//
//
//
//
//
//
//
//
//
//
//
//     );
//   }
// }
