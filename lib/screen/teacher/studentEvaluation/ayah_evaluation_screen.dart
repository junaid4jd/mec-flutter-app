import 'dart:convert';
import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/audioPlayer/audio_player_screen.dart';
import 'package:mec/screen/evaluatingStudent/evaluating_student_screen.dart';
import 'package:mec/screen/teacher/studentEvaluation/recording_screen.dart';
import 'package:mec/screen/teacher/studentEvaluation/student_evaluation_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:mec/model/soundRecorder.dart';
import 'package:permission_handler/permission_handler.dart';

// typedef _Fn = void Function();
//
// const theSource = AudioSource.microphone;

class AyahEvaluationScreen extends StatefulWidget {
  final String surahName;
  final String studentUid;
  final String surahAyhs;
  final String surahNumber;
  final String studentName;
  final String way;
  final String teacherEmail;
  final String classCode;
  final String chapterId;
  final String classDocId;
  final String studentDocId;
  final String chapterName;
  final int chapterIndex;
  final int partIndex;
  final int surahIndex;


  const AyahEvaluationScreen({Key? key
  ,required this.surahName, required this.surahAyhs, required this.way, required this.teacherEmail
  , required this.chapterName, required this.chapterId, required this.classDocId, required this.classCode,
    required this.studentDocId,
    required this.partIndex,
    required this.chapterIndex,
    required this.surahNumber,
    required this.studentUid,
    required this.studentName,
    required this.surahIndex,


  }) : super(key: key);

  @override
  _AyahEvaluationScreenState createState() => _AyahEvaluationScreenState();
}

class _AyahEvaluationScreenState extends State<AyahEvaluationScreen> {

  String name = '' , email = '', selectedIndexColor = '', selectedIndex = '',surahDocId = '', isSurahCompleted = 'no';
  bool star1 = false, star2 = false,star3 = false, micOn = false, play = false, isLoaded = false;
  int surahIndex = 0, totalVerses =0, currentEvaluatedVerses = 0;
      double surahStar = 0, surahPercent = 0.0;
  final assetsAudioPlayer = AssetsAudioPlayer();
  List<SurahVersesModel> _list = [];
  bool starLoading = false;
  bool isHide = false, hideAll = false, playAyahIndex = false, gettingList = false;


  TeacherClasseModel? studentClasseModelUpdated;
  // FlutterSoundRecorder? _recordingSession;
  // final recordingPlayer = AssetsAudioPlayer();
  // String? pathToAudio;

  int totalStars = 0;

  getStudentData() async {

    setState(() {
      totalStars = 0;
      surahPercent =( currentEvaluatedVerses/totalVerses)*(100/100);
    });



    FirebaseFirestore.instance.collection("Students").doc(widget.studentUid.toString()).get().then((value) {
      setState(() {
        totalStars = value["studentStars"];
      });
    });

  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('StudentClasses').doc(widget.studentDocId).get().then((value) {
      print('Teachers get');
      print(value.data());

      print(' This is the class data you picked');
      var data = json.encode(value.data());
      setState(() {
        studentClasseModelUpdated  =  TeacherClasseModel.fromJson(json.decode(data));
        if(widget.way != "studentRecording"){
          setState(() {
            surahIndex = widget.surahIndex;
            isLoaded = false;
          });
        }
       //
      });

      if(widget.way == "studentRecording") {
        if(widget.partIndex == 0) {
          print('in 0 part');
          for( int i=0 ;i<studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part1!.length;i++) {

            if(
            getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part1![i].surahName.toString())).toString()
                ==
                widget.surahName.toString())
            {
              print('Surah Matched $i');
              setState(() {
                surahIndex = i;
                isLoaded = false;
              });
              log(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part1![i].toString());
            } else {
              print('No surah Name match $i');
              print(widget.surahName.toString());
              print(getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part1![i].surahName.toString())));
            }
          }

        }
        else {

          if(widget.partIndex == 1) {

            for( int i=0 ;i<studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2!.length;i++) {

              if(
              //studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2![i].surahName
              getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2![i].surahName.toString()))
                  == widget.surahName.toString())
              {
                setState(() {
                  surahIndex = i;
                  isLoaded = false;
                });
                log(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2![i].toString());
              } else {
                print('No surah Name match $i');
                print(widget.surahName.toString());
                print(getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2![i].surahName.toString())));
              }
            }
          }
          else {
            if(widget.partIndex == 2) {

              for( int i=0 ;i<studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3!.length;i++) {

                if(
                //  studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3![i].surahName
                getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3![i].surahName.toString()))  == widget.surahName.toString())
                {
                  setState(() {
                    surahIndex = i;
                    isLoaded = false;
                  });
                  log(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3![i].toString());
                }
                else {
                  print('No surah Name match $i');
                  print(widget.surahName.toString());
                  print(getSurahNameArabic(int.parse(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3![i].surahName.toString())));
                }
              }
            }
          }
        }
      }



    });
  }





  @override
  void initState() {
    print(widget.partIndex.toString());
    print(widget.surahIndex.toString());
    print(widget.surahAyhs.toString());
      setState(() {
        totalVerses =0;
        isSurahCompleted = 'no';
        surahPercent = 0.0;
        currentEvaluatedVerses = 0;
        starLoading = false;
        surahStar = 0;
        surahDocId = '';
       // surahIndex = widget.surahIndex;
        gettingList = true;
      });



    getStudentEvaluatedData();
    setState(() {

      isLoaded = true;
      playAyahIndex = false;
    });
      getData();

    setState(() {
      selectedIndexColor = '';
      selectedIndex = '';
     // isLoaded = false;
    });
    super.initState();
  }

  getStudentEvaluatedData() async {
    setState(() {
      _list.clear();
    });
    print(" we are here in getStudentEvaluatedData");
    print(" we are here in getStudentEvaluatedData ${widget.surahNumber} ${widget.studentUid} ${widget.surahName}");

    FirebaseFirestore.instance.collection("StudentEvaluatedSurah").where("studentUid", isEqualTo: widget.studentUid)
        .where("surahNumber", isEqualTo: widget.surahNumber).where("surahName", isEqualTo: widget.surahName).where("studentDocId", isEqualTo: widget.studentDocId)
        .where("classCode", isEqualTo: widget.classCode).get().then((value) {





          if(value.docs.isNotEmpty) {
            setState(() {
              isSurahCompleted = value.docs[0]["surahCompleted"];
            });
            for(int i=0; i<value.docs[0]["surahVerses"].length ; i++) {

            //  print()

              setState(() {
                totalVerses = value.docs[0]["surahVerses"].length;
                surahStar = double.parse(value.docs[0]["surahStars"].toString());
                surahDocId = value.docs[0].id.toString();
                _list.add(SurahVersesModel(
                    verseColor: value.docs[0]["surahVerses"][i]["verseColor"],
                    verseRecording: value.docs[0]["surahVerses"][i]["verseRecording"]
                ));
              });

              if(value.docs[0]["surahVerses"][i]["evaluated"] == "yes") {
                setState(() {
                  currentEvaluatedVerses = currentEvaluatedVerses + 1;
                });
              }

            }

            if(surahStar == 0 || surahStar == 0.0) {
              getStudentData();
            }

            setState(() {
              gettingList = false;
            });
          } else {
            print(" we are here in getStudentEvaluatedData else $gettingList");
            setState(() {
              gettingList = false;
            });
          }

    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("${widget.surahName}"),
        centerTitle: true,
      ),
      body: isLoaded ? Center(child: CircularProgressIndicator(
        strokeWidth: 1,
        color: primaryColor,
      )) :
      gettingList ?   Center(child: CircularProgressIndicator(
        strokeWidth: 1,
        color: primaryColor,
      )) :
      SingleChildScrollView(

        child: Column(
          children: [
            SizedBox(
              height: size.height*0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                height: size.height*0.66,
                child: GridView.builder(
                  //  padding: EdgeInsets.only(top: 8),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10),
                    itemCount:

                        widget.partIndex == 0 ? studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part1![surahIndex].verses!.surahVerses!.length :
                        widget.partIndex == 1 ? studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part2![surahIndex].verses!.surahVerses!.length :
                        widget.partIndex == 2 ? studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.surahs![widget.partIndex].part3![surahIndex].verses!.surahVerses!.length :
                        int.parse(widget.surahAyhs.toString()),

                    itemBuilder: (BuildContext ctx, index) {

                      // print(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.
                      // surahs![widget.partIndex].part1![surahIndex].verses!.surahVerses!.length);
                      // print(studentClasseModelUpdated!.chapList![widget.chapterIndex].content!.
                      // surahs![widget.partIndex].part1![surahIndex].verses!.surahVerses![index].verseRecording.toString() + " surah record");

                      return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (c, a1, a2) => SimpleRecorder(),
                            //     transitionsBuilder: (c, anim, a2, child) =>
                            //         FadeTransition(opacity: anim, child: child),
                            //     transitionDuration: Duration(milliseconds: 0),
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                          border: Border.all(color:
                          _list.isNotEmpty && _list[index].verseColor == "Green" ? Colors.green :
                          _list.isNotEmpty && _list[index].verseColor == "Orange" ? Colors.orange :
                          _list.isNotEmpty && _list[index].verseColor == "Yellow" ? Colors.yellow :
                          Colors.transparent,
                            ),
                              color: whiteColor,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration:
                              widget.partIndex == 0 ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color:
                                            _list.isNotEmpty && _list[index].verseColor == "Green" ? Colors.green :
                                            _list.isNotEmpty && _list[index].verseColor == "Orange" ? Colors.orange :
                                            _list.isNotEmpty && _list[index].verseColor == "Yellow" ? Colors.yellow :
                                                Colors.grey,

                                            width: 3

                                        )
                                    ) :
                              widget.partIndex == 1 ? BoxDecoration(


                                  shape: BoxShape.circle,
                                  border: Border.all(color:
                                  _list.isNotEmpty && _list[index].verseColor == "Green" ? Colors.green :
                                  _list.isNotEmpty && _list[index].verseColor == "Orange" ? Colors.orange :
                                  _list.isNotEmpty && _list[index].verseColor == "Yellow" ? Colors.yellow :
                                  Colors.grey,

                                      width: 3

                                  )
                              ) :
                              widget.partIndex == 2 ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:
                                  _list.isNotEmpty && _list[index].verseColor == "Green" ? Colors.green :
                                  _list.isNotEmpty && _list[index].verseColor == "Orange" ? Colors.orange :
                                  _list.isNotEmpty && _list[index].verseColor == "Yellow" ? Colors.yellow :
                                  Colors.grey,
                                      width: 3

                                  )
                              ) :
                              BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:
                                  Colors.grey,

                                      width: 3

                                  )
                              ),

                                    width: 50,
                                    height: 50,

                                    child: Center(child: Text(
                                      "${index+1}"
//"الْإِخْلَاص"
                                      ,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),
                                    )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                 widget.way == "studentRecording" ?

                                     Center(
                                       child: GestureDetector(
                                         onTap:() {
                                           if( _list.isNotEmpty && _list[index].verseRecording != "1") {
                                             Navigator.push(
                                               context,
                                               PageRouteBuilder(
                                                 pageBuilder: (c, a1, a2) =>
                                                     AudioScreen(audioFile: _list[index].verseRecording.toString(),),
                                                 transitionsBuilder: (c, anim, a2, child) =>
                                                     FadeTransition(opacity: anim, child: child),
                                                 transitionDuration: Duration(milliseconds: 0),
                                               ),
                                             );
                                           }
                                         },
                                         child: Container(
                                           decoration: BoxDecoration(
                                             color:
                                             _list.isNotEmpty && _list[index].verseRecording != "1" ?
                                             primaryColor : Colors.grey,
                                             borderRadius: BorderRadius.circular(10)
                                           ),
                                           child: Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text(
                                               _list.isNotEmpty && _list[index].verseRecording != "1" ?
                                               "Listen" : "Not Recorded", style: TextStyle(color: whiteColor,fontSize: 12),),
                                           ),
                                         ),
                                       ),
                                     ) :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {


                                            if(widget.way != "studentRecording") {
                                              setState(() {
                                                selectedIndex = index.toString();
                                              });


                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (c, a1, a2) => SimpleRecorder(
                                                    way: widget.way,
                                                    currentAya:  int.parse(selectedIndex),
                                                    surahNumber: widget.surahNumber,
                                                    surahIndex: widget.surahIndex,
                                                    surahName: widget.surahName,
                                                    surahAyhs: widget.surahAyhs,
                                                    teacherEmail: widget.teacherEmail,
                                                    chapterName: widget.chapterName,
                                                    chapterId: widget.chapterId,
                                                    classDocId: widget.classDocId,
                                                    classCode: widget.classCode,
                                                    studentDocId: widget.studentDocId,
                                                    partIndex: widget.partIndex,
                                                    chapterIndex: widget.chapterIndex,
                                                  ),
                                                  transitionsBuilder: (c, anim, a2, child) =>
                                                      FadeTransition(opacity: anim, child: child),
                                                  transitionDuration: Duration(milliseconds: 0),
                                                ),
                                              ).then((value) {
                                                getStudentEvaluatedData();
                                                setState(() {

                                                });
                                                // setState(() {
                                                //   getStudentEvaluatedData();
                                                // });
                                              });
                                            }



                                          },
                                          child:
                                          Icon(Icons.mic,
                                            size: 25,
                                            color:
                                            //_mRecorder!.isRecording && selectedIndex == index.toString() ? Colors.red :
                                            Colors.green,
                                          ),
                                          //Icon(Icons.mic, color: micOn && selectedIndex == index.toString() ? Colors.green : Colors.grey, size: 30,)

                                      ),



                                      _list.isNotEmpty && _list[index].verseRecording != "1" ?
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) =>
                                                   AudioScreen(audioFile: _list[index].verseRecording.toString(),),
                                                transitionsBuilder: (c, anim, a2, child) =>
                                                    FadeTransition(opacity: anim, child: child),
                                                transitionDuration: Duration(milliseconds: 0),
                                              ),
                                            );
                                          },
                                          child: Icon(

                                            playAyahIndex ? Icons.pause :
                                            Icons.play_arrow_sharp
                                            , color: playAyahIndex ? redColor :
                                          Colors.grey,

                                            size: 30,)) : Container(),


                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ),
                        );
                    }),
              ),
            ),


            widget.way == "studentRecording" ?
            Column(children: [
              SizedBox(height: size.height*0.04,),

              Container(
                // color: Colors.green,
                width: size.width*0.9,
                //height: size.height*0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      //width: size.width*0.9,
                      child: LinearPercentIndicator(
                        width: size.width*0.55,//180.0,
                        lineHeight: 14.0,
                        percent: (currentEvaluatedVerses/totalVerses),
                        leading: new Text("0%"),
                        trailing: new Text("100%"),
                        backgroundColor: greyColor,
                        progressColor: Colors.blue,
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: size.height*0.04,),
            ],) : Container(),



            GestureDetector(
              onTap: (){
              },
              child: Container(

                width: size.width*0.8,

                // decoration: BoxDecoration(
                //   color: primaryColor,
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  RatingBar.builder(
                  initialRating: surahStar,
                  ignoreGestures: widget.way == "studentRecording" || isSurahCompleted == "no" ? true : false,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 3,
                  itemSize: 50,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),

                  onRatingUpdate: ( rating) {



                    if(widget.way != "studentRecording") {

                      if(isSurahCompleted == "yes") {
                        if(surahStar == 0 || surahStar == 0.0) {
                          setState(() {
                            surahStar = rating;
                          });
                          showAlertDialog(context,surahDocId);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Already Evaluated Surah ${widget.surahName}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Surah ${widget.surahName} is not completed yet",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 4,
                        );
                      }


                    }


                  },
                ),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Container(
                    //     child: Text("Evaluate ${widget.studentName}", style: TextStyle(color: whiteColor,fontSize: 15),),
                    //   ),
                    // ),
                    // GestureDetector(
                    //     onTap: (){
                    //       setState(() {
                    //         star1 = !star1;
                    //       });
                    //     },
                    //     child: Icon(Icons.star, color: star1 ? Colors.amber : Colors.grey,size: 60,)),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    // GestureDetector(
                    //     onTap: (){
                    //       setState(() {
                    //         star2 = !star2;
                    //       });
                    //     },
                    //     child: Icon(Icons.star, color: star2 ? Colors.amber : Colors.grey,size: 60,)),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    // GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         star3 = !star3;
                    //       });
                    //     },
                    //     child: Icon(Icons.star, color: star3 ? Colors.amber : Colors.grey,size: 60,)),


                  ],
                ),
              ),
            ) ,

          ],
        ),
      ),

    );
  }

  showAlertDialog(
      BuildContext context, String id) {
    // set up the button

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoAlertDialog(
              title: Text("Star Evaluation"),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("You are giving ${surahStar.toInt()} stars?"),
              ),
              actions: [
                CupertinoDialogAction(
                    child: Text("No"),
                    onPressed: () {
                      setState(() {
                        surahStar = 0;
                      });
                      Navigator.of(context).pop();
                    }),
                starLoading ? Center(child: CircularProgressIndicator()) :
                CupertinoDialogAction(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        starLoading = true;
                      });
                      FirebaseFirestore.instance.collection("StudentEvaluatedSurah").doc(surahDocId.toString()).update({
                        "surahStars" : surahStar.toInt(),
                      }).then((value) {
                        FirebaseFirestore.instance.collection("Students").doc(widget.studentUid.toString()).update({
                          "studentStars" : totalStars + surahStar.toInt(),
                        }).then((value) {
                          setState(() {
                            starLoading = false;
                          });
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: "Successfully Evaluated Surah ${widget.surahName}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );
                        });



                      });
                      // FirebaseFirestore.instance
                      //     .collection("Teachers")
                      //     .doc(id)
                      //     .delete()
                      //     .whenComplete(() {

                      // });
                    })
              ],
            );

            },
        );
      },
    );
  }

}

class SurahVersesModel {
  final String verseColor;
  final String verseRecording;

  SurahVersesModel({
    required this.verseColor,
    required this.verseRecording
});

}


