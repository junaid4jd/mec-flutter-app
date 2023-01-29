import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/soundRecorder.dart';
import 'package:mec/model/student_classes_model.dart';
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/teacher/studentEvaluation/ayah_evaluation_screen.dart';
import 'package:permission_handler/permission_handler.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class SimpleRecorder extends StatefulWidget {
  final String surahName;
  final String surahNumber;
  final String surahAyhs;
  final int currentAya;
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

  const SimpleRecorder({
    Key? key,
    required this.surahName,
    required this.surahAyhs,
    required this.way,
    required this.teacherEmail,
    required this.chapterName,
    required this.chapterId,
    required this.classDocId,
    required this.classCode,
    required this.studentDocId,
    required this.partIndex,
    required this.chapterIndex,
    required this.surahNumber,
    required this.currentAya,
    required this.surahIndex,
  }) : super(key: key);

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  Codec _codec = Codec.aacMP4;
  String selectedIndexColor = '', selectedIndex = '';
  TeacherClasseModel? teacherClasseModel;

  String isChpEvaluated = "no";
  String isPartOneEvaluated = "no";
  String isPartTwoEvaluated = "no";
  String isPartThreeEvaluated = "no";
  String chapEvaluatedListDocId = "";
  String studentsTableDocId = "";

  String _mPath = 'tau_file.mp4';
  String recordingUrl = '';
  String evaluatedSurahCheck = 'no';
  int countGreen = 0, evaluatedSurah = 0,  y=0;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool isAlreadyRecordingPresent = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  int partOneBadgeCount = 0;
  int partTwoBadgeCount = 0;
  int partThreeBadgeCount = 0;
  int currentListIndex = 0;
  int totalBadges = 0;
  int totalCups = 0;
  final recorder = SoundRecorder();
  String recordedUrl = '';
  String currentSurahName = '',
      isClassNameExist = "",
      currentSurahNumber = '',
      currentSurahAyahs = '',
      studentName = '',
      studentEmail = '',
      studentUid = '';
  bool isLoading = false;
  List<Map<String, dynamic>> surahVerses = [];
  List<Map<String, dynamic>> evaluatedChapterList = [];
  List<Map<String, dynamic>> chapListEvaluated = [];

  List<Map<String, dynamic>>  evaluatedChapterList2 = [];
  // List<SurahVerse>? surahVerses;
  @override
  void initState() {
    print(widget.currentAya.toString() + " Current Ayah is here");
    //checkListChapLength();
    getStudentData();
   // doesSurahCompleted();
    //checkListChapLength();
    setState(() {
      studentsTableDocId = "";
      evaluatedSurahCheck = 'no';
      evaluatedChapterList.clear();
      evaluatedChapterList2.clear();
      isChpEvaluated = "no";
      isPartOneEvaluated = "no";
      isPartTwoEvaluated = "no";
      isPartThreeEvaluated = "no";
      chapEvaluatedListDocId = "";
      currentListIndex = 0;
      totalBadges = 0;
      totalCups = 0;
      isAlreadyRecordingPresent = false;
      isLoading = false;
      isClassNameExist = "";
      countGreen = 0;
      evaluatedSurah = 0;
    });
    //getBadges();

    print(widget.surahAyhs.toString() + ' This is ayah');
    setState(() {
      selectedIndexColor = '';
      recordingUrl = '';
      selectedIndex = '';
    });

    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    //evaluateChapters();

    super.initState();
  }


  checkListChapLength() async {
    setState(() {
      y=6;
    });
    print("Classes checkListChapLength ");
    FirebaseFirestore.instance
        .collection("Classes")
        .doc(widget.classDocId)
        .get()
        .then((value) {
          print("In Class");

      for(int i=0 ;i<value["chapList"].length;i++) {

        print(value["chapList"][i]["chapterId"].toString());

        setState(() {
          chapListEvaluated.add(
              {
                "classCode": widget.classCode,
                "chapterId": value["chapList"][i]["chapterId"].toString(),
                "chapterName": value["chapList"][i]["chapterName"].toString(),
                "isChpEvaluated": "no",
                "isPartOneEvaluated": "no",
                "isPartTwoEvaluated": "no",
                "isPartThreeEvaluated": "no",
              }

          );
        });
      }

      FirebaseFirestore.instance
          .collection("StudentChapterEvaluation")
          .where("classCode", isEqualTo:widget.classCode)
          .get()
          .then((valueChap) {

            if(valueChap.docs[0]["chapEvaluationList"].length ==   value["chapList"].length) {
              print("Both length List Equals");
            } else {
              print("List Not Equals");

              FirebaseFirestore.instance
                  .collection("StudentChapterEvaluation")
                  .doc(valueChap.docs[0].id.toString())
                  .update({
                "chapEvaluationList":chapListEvaluated,
              }).then((value) {
                print("chapEvaluationList updated");
              });
            }
      });
    });
  }

  getSurahVerses() async {
    setState(() {
      surahVerses.clear();
    });

    FirebaseFirestore.instance
        .collection("StudentEvaluatedSurah")
        .where("surahNumber", isEqualTo: widget.surahNumber)
        .where("studentUid", isEqualTo: studentUid)
        .where("studentDocId", isEqualTo: widget.studentDocId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        print("we are here value.docs.isEmpty");
        print("we are here value.docs. ${widget.surahAyhs.toString()}");

        for (int i = 0; i < int.parse(widget.surahAyhs.toString()); i++) {
          print(i.toString());
          setState(() {
            surahVerses.add({
              "verseColor": "grey",
              "evaluated": "no",
              "verseNumber": i.toString(),
              "verseRecording": "1",
            });
          });
        }
        if(surahVerses.length == int.parse(widget.surahAyhs.toString())) {
          print("verses is here");
          print(surahVerses.toList());
        }

      } else {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i]["surahVerses"].isNotEmpty) {
            for (int j = 0; j < value.docs[i]["surahVerses"].length; j++) {
              if (j == widget.currentAya) {
                if (value.docs[i]["surahVerses"][j]["verseColor"] == "Green") {
                  setState(() {
                    isAlreadyRecordingPresent = true;
                  });
                  print("This ayah is already green");
                } else {
                  print("This ayah is not already green");
                }
              }

              if (value.docs[i]["surahVerses"][j]["verseColor"] == "Green") {
                setState(() {
                  countGreen = countGreen + 1;
                });
                print(" we are here in verse color $countGreen");
              }

              setState(() {
                surahVerses.add({
                  "verseColor": value.docs[i]["surahVerses"][j]["verseColor"],
                  "evaluated": value.docs[i]["surahVerses"][j]["evaluated"],
                  "verseNumber": value.docs[i]["surahVerses"][j]["verse"],
                  "verseRecording": value.docs[i]["surahVerses"][j]
                      ["verseRecording"],
                });
              });
            }
          }
        }
      }
    });

    //print(surahVerses[0].toString());
    print(countGreen.toString() + " CountGreen");
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------
  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      print('M Path is here');
      print(_mPath.toString());

      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        recordedUrl = value.toString();
        _mplaybackReady = true;
        final recordedFile = File(recordedUrl);
        print(recordedFile.toString());
        getUrl(recordedFile.path).then((value1) {
          setState(() {
            recordingUrl = value1.toString();
            print('This is recordedurl 1 ' + recordingUrl.toString());
          });
        });
        //upload(recordedFile);

        print('This is recordedurl 1 ' + recordedUrl.toString());
      });
    });
    print('This is recorded audio path 2' + recordedUrl.toString());
  }

  Future<String?> getUrl(String path) async {
    final file = File(path);
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("audio" + DateTime.now().toString())
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    }
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------
  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  getStudentData() async {
    FirebaseFirestore.instance
        .collection("StudentClasses")
        .doc(widget.studentDocId)
        .get()
        .then((value) {
      print(value["studentEmail"].toString());
      print(value["studentName"].toString());
      print(value["uid"].toString());
      setState(() {
        studentEmail = value["studentEmail"].toString();
        studentName = value["studentName"].toString();
        studentUid = value["uid"].toString();
      });
      doesSurahCompleted();
      getStudentChapterDoc();
      getTheFullChapList();


      getSurahVerses();

    });
  }

  getStudentChapterDoc() {
    FirebaseFirestore.instance
        .collection('StudentChapterEvaluation')
        .where('classCode', isEqualTo: widget.classCode.toString())
        .where('uid', isEqualTo: studentUid)
        .get()
        .then((value) {
      setState(() {
        chapEvaluatedListDocId = value.docs[0].id.toString();
      });
    });
  }

  doesSurahCompleted() async {

    FirebaseFirestore.instance
        .collection("StudentEvaluatedSurah")
        .where("surahNumber", isEqualTo: widget.surahNumber)
        .where("studentUid", isEqualTo: studentUid)
        .where("studentDocId", isEqualTo: widget.studentDocId)
        .get()
        .then((value) {

          if(value.docs.isNotEmpty) {
            if(value.docs[0]["surahCompleted"].toString() == "yes")
            {
              print("Already this ayah surah completed");
              setState(() {
                evaluatedSurahCheck = "yes";
                evaluatedSurah = int.parse(widget.surahAyhs);
              });

              print("evaluatedSurah = int.parse(widget.surahAyhs);");

            }
            else {
              setState(() {
                evaluatedSurah =0;
              });
              print("This ayah surah not completed");

              print(value.docs[0]["surahVerses"].toList() );
              print(value.docs[0]["surahVerses"][0]["evaluated"].toString() );
              for (int i = 0; i < value.docs[0]["surahVerses"].length; i++) {
                print("In Loop i=$i evaluated=${value.docs[0]["surahVerses"][i]["evaluated"].toString()} ");
                if (value.docs[0]["surahVerses"][i]["evaluated"].toString() == "yes") {
                  setState(() {
                    evaluatedSurah = evaluatedSurah + 1;
                  });
                  print(" evaluated verses count ${evaluatedSurah}");

                  //  print("In Condition evaluated $evaluatedSurah == ${widget.surahAyhs}");
                  if(evaluatedSurah.toString() == widget.surahAyhs) {
                    print(" evaluated $evaluatedSurah == ${widget.surahAyhs} True");
                    //print(" ${evaluatedSurah == widget.surahAyhs} now this ayah surah completed");
                    setState(() {
                      evaluatedSurahCheck = "yes";
                    });
                  }
                } else {
                  print("none of the verse evaluated yet");
                }
              }
            }
          }
          else {
            print("value is empty");
          }


    });

  }

  Future getFinalData() async {




    if (isAlreadyRecordingPresent != true && selectedIndexColor == "Green") {
      setState(() {
        countGreen = countGreen + 1;
      });
      print(countGreen.toString() + "one more  Green added");
    }
    print("Before evaluation");
    print(surahVerses.toList()  );

    setState(() {
      surahVerses[widget.currentAya] = {
        "verseColor": selectedIndexColor,
        "evaluated": "yes",
        "verseNumber": widget.currentAya.toString(),
        "verseRecording": recordingUrl,
      };
    });

    print("after evaluation");
    print(surahVerses.toList()  );





    //
    // if(evaluatedSurahCheck == "yes")
    // {
    //
    //   print("Already this ayah surah completed");
    //
    // }
    // else {
    //
    //   print("This ayah surah not completed");
    //
    //   for (int i = 0; i < surahVerses.length; i++) {
    //     if (surahVerses[i]["evaluated"] == "yes") {
    //       setState(() {
    //         evaluatedSurah = evaluatedSurah + 1;
    //       });
    //
    //       if(evaluatedSurah.toString() == widget.surahAyhs) {
    //         print(" evaluated $evaluatedSurah == ${widget.surahAyhs} True");
    //         //print(" ${evaluatedSurah == widget.surahAyhs} now this ayah surah completed");
    //         setState(() {
    //           evaluatedSurahCheck = "yes";
    //         });
    //       }
    //
    //     }
    //   }
    //
    //
    // }




  }

  checkPartOneChapOne() {
    print(evaluatedChapterList.length.toString() + ' List Length evaluatedChapterList IN Chap One');
    print(evaluatedChapterList.toList() );

    if (partOneBadgeCount == 4 && isPartOneEvaluated == 'no') {
      setState(() {
        isPartOneEvaluated = 'yes';
        totalBadges = totalBadges + 1;
      });
      print('we are in partOne $isPartOneEvaluated $totalBadges');

      checkPartTwo();

    } else {



      checkPartTwo();
      print('else 2 chapter ${widget.chapterId} we are in part 1 $isPartOneEvaluated $totalBadges');

    }
  }
  checkPartOneChap234() {

    if (partOneBadgeCount == 2 && isPartOneEvaluated == 'no') {
      setState(() {
        isPartOneEvaluated = 'yes';
        totalBadges = totalBadges + 1;
      });
      print('we are in partOne $isPartOneEvaluated $totalBadges');

      checkPartTwo();

    } else {



      checkPartTwo();
      print('else 2 chapter ${widget.chapterId} we are in part 1 $isPartOneEvaluated $totalBadges');

    }
  }
  checkPartTwo() {
    if (partTwoBadgeCount == 2 && isPartTwoEvaluated == 'no') {
      setState(() {
        isPartTwoEvaluated = 'yes';
        totalBadges = totalBadges + 1;
      });
      print('if 2 chapter ${widget.chapterId} we are in part 2 $isPartTwoEvaluated $totalBadges');
      checkPartThree();
    } else {



      checkPartThree();
      print('else 2 chapter ${widget.chapterId} we are in part 2 $isPartTwoEvaluated $totalBadges');

    }
  }
  checkPartThree() {

    if (partThreeBadgeCount == 2 &&
        isPartThreeEvaluated == 'no') {
      setState(() {
        isPartThreeEvaluated = 'yes';
        totalBadges = totalBadges + 1;
      });
      print(
          'if chapter ${widget.chapterId} we are in part 3 $isPartThreeEvaluated $totalBadges');
      checkChapEvaluated();
    } else {
      checkChapEvaluated();
      print('else chapter ${widget.chapterId} we are in part 3 $isPartThreeEvaluated $totalBadges');
    }
  }
  checkChapEvaluated() {

    if (isChpEvaluated == "no" &&
        (isPartOneEvaluated == "yes" &&
            isPartTwoEvaluated == "yes" &&
            isPartThreeEvaluated == "yes")) {
      print(
          'we are in chapter part  $isPartThreeEvaluated $isPartThreeEvaluated $isPartTwoEvaluated $totalCups');
      setState(() {
        isChpEvaluated = "yes";
        totalCups = totalCups + 1;
      });
      getTheListAndUploadResults();

    } else {
      getTheListAndUploadResults();
      print(
          'Sorry Every Condition is false  $isPartThreeEvaluated $isPartThreeEvaluated $isPartTwoEvaluated $totalCups');
    }

  }
  Future evaluateChapters() async {
    FirebaseFirestore.instance
        .collection("Students")
        .where("uid", isEqualTo: studentUid)
        .get()
        .then((value) {
      print("studentCups");
      print(value.docs[0]["studentCups"]);
      print(value.docs[0]["studentBadges"]);
      setState(() {
        studentsTableDocId = value.docs[0].id.toString();
        totalCups = value.docs[0]["studentCups"];
        totalBadges = value.docs[0]["studentBadges"];
      });
      print("studentCups $totalCups StudentBadges $totalBadges   studentsTableDocId $studentsTableDocId");

    });


    print('we are in chapter Evaluate ${widget.chapterId.toString()}');



    FirebaseFirestore.instance
        .collection('StudentChapterEvaluation')
        .where('classCode', isEqualTo: widget.classCode.toString())
        .where('uid', isEqualTo: studentUid)
        .get()
        .then((value) {

      if (value.docs.isNotEmpty) {
        print(
            'chapEvaluationList chapEvaluatedListDocId $chapEvaluatedListDocId');
        if (value.docs[0]['chapEvaluationList'].isNotEmpty) {

          print('List is not empty');

          for (int i = 0; i < value.docs[0]['chapEvaluationList'].length; i++) {

            print('we are in loop');
            print(value.docs[0]['chapEvaluationList'][i]['chapterId'].toString());
            print(value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'].toString());

            if (value.docs[0]['chapEvaluationList'][i]['chapterId'].toString() == widget.chapterId.toString() &&
                value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'].toString() == 'no') {
              print('we are in chapter Evaluate loop $i and condition matched');
              setState(() {
                currentListIndex = i;
                isChpEvaluated = value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'];
                isPartOneEvaluated = value.docs[0]['chapEvaluationList'][i]['isPartOneEvaluated'];
                isPartTwoEvaluated = value.docs[0]['chapEvaluationList'][i]['isPartTwoEvaluated'];
                isPartThreeEvaluated = value.docs[0]['chapEvaluationList'][i]['isPartThreeEvaluated'];
              });


              if (widget.chapterId == '1') {
                print('we are in chapter 1 eva $partOneBadgeCount $isPartOneEvaluated');

                if (partOneBadgeCount == 4 && isPartOneEvaluated == 'no') {
                  checkPartOneChapOne();

                } else {

                  if (partTwoBadgeCount == 2 && isPartTwoEvaluated == 'no') {
                    checkPartTwo();
                  }
                  else {
                    if (partThreeBadgeCount == 2 &&
                        isPartThreeEvaluated == 'no') {
                      // setState(() {
                      //   isPartThreeEvaluated = 'yes';
                      //   totalBadges = totalBadges + 1;
                      // });

                      checkPartThree();


                      print(
                          'we are in part 3 $isPartThreeEvaluated $totalBadges');
                    } else {
                      if (isChpEvaluated == "no" &&
                          (isPartOneEvaluated == "yes" &&
                              isPartTwoEvaluated == "yes" &&
                              isPartThreeEvaluated == "yes")) {
                        // print(
                        //     'we are in chapter part  $isPartThreeEvaluated $isPartThreeEvaluated $isPartTwoEvaluated $totalCups');
                        // setState(() {
                        //   isChpEvaluated == "yes";
                        //   totalCups = totalCups + 1;
                        // });

                        checkChapEvaluated();
                        //getTheListAndUploadResults();
                      } else {
                        checkChapEvaluated();

                        //    getTheListAndUploadResults();
                        print(
                            'Sorry Every Condition is false  $isPartThreeEvaluated $isPartThreeEvaluated $isPartTwoEvaluated $totalCups');
                      }
                    }
                  }
                }
              }
              else if (widget.chapterId == '2' ||
                  widget.chapterId == '3' ||
                  widget.chapterId == '4') {
                print('we are in chapter 2,3,4 eva');
                if (partOneBadgeCount == 2 && isPartOneEvaluated == 'no') {
                  // setState(() {
                  //   isPartOneEvaluated = 'yes';
                  //   totalBadges = totalBadges + 1;
                  // });
                  checkPartOneChap234();

                } else {
                  if (partTwoBadgeCount == 2 && isPartTwoEvaluated == 'no') {
                    // setState(() {
                    //   isPartTwoEvaluated = 'yes';
                    //   totalBadges = totalBadges + 1;
                    // });
                    checkPartTwo();


                  } else {
                    if (partThreeBadgeCount == 2 &&
                        isPartThreeEvaluated == 'no') {
                      // setState(() {
                      //   isPartThreeEvaluated = 'yes';
                      //   totalBadges = totalBadges + 1;
                      // });
                      checkPartThree();
                    } else {
                      if (isChpEvaluated == "no" &&
                          (isPartOneEvaluated == "yes" &&
                              isPartTwoEvaluated == "yes" &&
                              isPartThreeEvaluated == "yes")) {
                        checkChapEvaluated();

                        // setState(() {
                        //   isChpEvaluated == "yes";
                        //   totalCups = totalCups + 1;
                        // });

                      } else {
                        checkChapEvaluated();



                        print(" None of the above condition is true");
                      }
                    }
                  }
                }
              }


            }
            else {

              if (value.docs[0]['chapEvaluationList'][i]['chapterId'].toString() == widget.chapterId.toString() &&
                  value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'].toString() == 'yes') {

                setState(() {
                  i = value.docs[0]['chapEvaluationList'].length;
                  isLoading = false;
                });
                Fluttertoast.showToast(
                  msg:
                  "Successfully evaluated ayah ${widget.currentAya + 1} of surah ${widget.surahName}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 4,
                );
                Navigator.pop(context);

              } else {

                print(" We are repeating the loop $i");


              }


            }

          }
        }
      } else {
        print('empty Doc');
      }
    });

  }
  getTheFullChapList() async {

    FirebaseFirestore.instance
        .collection('StudentChapterEvaluation')
        .where('classCode', isEqualTo: widget.classCode.toString())
        .where('uid', isEqualTo: studentUid)
        .get()
        .then((value) {

      setState(() {
        evaluatedChapterList.clear();
      });

      if (value.docs.isNotEmpty) {
        print('chapEvaluationList Filling');
        if (value.docs[0]['chapEvaluationList'].isNotEmpty) {
          for (int i = 0; i < value.docs[0]['chapEvaluationList'].length; i++) {
            setState(() {
              evaluatedChapterList.add({
                "classCode": value.docs[0]['chapEvaluationList'][i]['classCode'].toString(),
                "chapterId": value.docs[0]['chapEvaluationList'][i]['chapterId'].toString(),
                "chapterName": value.docs[0]['chapEvaluationList'][i]['chapterName'].toString(),
                "isChpEvaluated": value.docs[0]['chapEvaluationList'][i]['isChpEvaluated'].toString(),
                "isPartOneEvaluated": value.docs[0]['chapEvaluationList'][i]['isPartOneEvaluated'].toString(),
                "isPartTwoEvaluated": value.docs[0]['chapEvaluationList'][i]['isPartTwoEvaluated'].toString(),
                "isPartThreeEvaluated": value.docs[0]['chapEvaluationList'][i]['isPartThreeEvaluated'].toString(),
              });
            });
          }
        }
      }
      else {
        print('empty Doc');
      }
    });

  }

  Future getTheListAndUploadResults() async {
    print('we are in getTheListAndUploadResults');


    setState(() {
      evaluatedChapterList2.clear();
    });

    for (int i = 0; i < evaluatedChapterList.length; i++)
    {
      if ( (evaluatedChapterList[i]['chapterName'].toString() == widget.chapterName) && ( evaluatedChapterList[i]['chapterId'].toString() == widget.chapterId)) {
        setState(() {
          evaluatedChapterList2.add({
            "classCode": widget.classCode,
            "chapterId": widget.chapterId,
            "chapterName": widget.chapterName,
            "isChpEvaluated": isChpEvaluated.toString() == 'yes' ? 'yes' : 'no',
            "isPartOneEvaluated": isPartOneEvaluated.toString() == 'yes' ? 'yes' : 'no',
            "isPartTwoEvaluated": isPartTwoEvaluated.toString() == 'yes' ? 'yes' : 'no',
            "isPartThreeEvaluated": isPartThreeEvaluated.toString() == 'yes' ? 'yes' : 'no',
          });
        });
      }
      else {
        setState(() {
          evaluatedChapterList2.add({
            "classCode": evaluatedChapterList[i]['classCode'].toString(),
            "chapterId": evaluatedChapterList[i]['chapterId'].toString(),
            "chapterName": evaluatedChapterList[i]['chapterName'].toString(),
            "isChpEvaluated": evaluatedChapterList[i]['isChpEvaluated'].toString() == 'yes' ? 'yes' : 'no',
            "isPartOneEvaluated": evaluatedChapterList[i]['isPartOneEvaluated'].toString() == 'yes' ? 'yes' : 'no' ,
            "isPartTwoEvaluated": evaluatedChapterList[i]['isPartTwoEvaluated'].toString() == 'yes' ? 'yes' : 'no',
            "isPartThreeEvaluated": evaluatedChapterList[i]['isParThreeEvaluated'].toString() == 'yes' ? 'yes' : 'no',
          });
        });
      }
    }
    if (evaluatedChapterList2.length == evaluatedChapterList.length) {

      FirebaseFirestore.instance
          .collection('StudentChapterEvaluation')
          .doc(chapEvaluatedListDocId.toString())
          .set({
        "studentEmail": studentEmail,
        "studentName": studentName,
        "uid": studentUid,
        "chapEvaluationList": evaluatedChapterList2,
        "classCode": widget.classCode.toString(),
        "className": widget.classDocId.toString(),
        "teacherEmail": widget.teacherEmail,
      }).then((value) {
        print("StudentChapterEvaluation Done totalBadges $totalBadges and totalCups $totalCups " );

        FirebaseFirestore.instance
            .collection("Students")
            .doc(studentsTableDocId.toString())
            .update({
          "studentBadges": totalBadges,
          "studentCups": totalCups,
        }).then((value) {
          print(' totalBadges done dana done');

          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg:
                "Successfully evaluated ayah ${widget.currentAya + 1} of surah ${widget.surahName}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
          );
          Navigator.pop(context);

        });
      });


    }
    else {
      print('List Length Issue Evaluation');
    }
  }

  @override
  Widget build(BuildContext context) {

    // if(y==5) {
    //   checkListChapLength();
    // }

    //if()
    print(widget.currentAya.toString() + ' This is no');
    //print(surahVerses[0].toString() + ' This is no');
    final size = MediaQuery.of(context).size;
    Widget makeBody() {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _mRecorder!.isRecording
                        ? 'Stop Recording'
                        : 'Record your recording',
                    style: TextStyle(
                        color:
                            _mRecorder!.isRecording ? redColor : primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: getRecorderFn(),
                    style: ElevatedButton.styleFrom(
                      primary: _mRecorder!.isRecording
                          ? Colors.red
                          : primaryColor, //Colors.green,
                    ),
                    icon: Icon(
                      _mRecorder!.isRecording ? Icons.stop : Icons.mic,
                      size: 25,
                    ),
                    label: Text(
                      '',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ]),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _mPlayer!.isPlaying
                        ? 'Pause Recording'
                        : 'Play Recording       ',
                    style: TextStyle(
                        color: _mPlayer!.isPlaying ? redColor : primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: getPlaybackFn(),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    icon: _mPlayer!.isPlaying
                        ? Icon(
                            Icons.stop,
                            size: 25,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.play_arrow_sharp,
                            size: 25,
                            color: primaryColor, //Colors.green,
                          ),
                    label: Text(
                      '',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ]),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndexColor = "Green";
                    //selectedIndex = index.toString();
                  });
                },
                child: Container(
                  width: size.width * 0.2,
                  height: 20,
                  color: primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndexColor = "Orange";
                    // selectedIndex = index.toString();
                  });
                },
                child: Container(
                  width: size.width * 0.2,
                  height: 20,
                  color: Colors.orange,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndexColor = "Yellow";
                    //selectedIndex = index.toString();
                  });
                },
                child: Container(
                  width: size.width * 0.2,
                  height: 20,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            child: Text(
              "Evaluation Selected Color: " + selectedIndexColor.toString(),
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: () async {
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (c, a1, a2) =>
                    //         StudentEvaluationScreen(
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

                    if (recordingUrl == '') {
                      Fluttertoast.showToast(
                        msg: "Please record your ayah",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                      );
                    } else if (selectedIndexColor == '') {
                      Fluttertoast.showToast(
                        msg: "Please select the evaluation color",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                      );
                    } else {
                      String docId = "";
                         int surahStars = 0;
                      print("Color Selected and recorded");
                      setState(() {
                        isLoading = true;
                      });

                      final snapshot = await FirebaseFirestore.instance
                          .collection('StudentEvaluatedSurah')
                          .get();

                      snapshot.docs.forEach((element) {
                        print('user data');
                        if (element['surahNumber'] ==
                            widget.surahNumber.toString()
                        && element['studentDocId'] == widget.studentDocId
                        && element['studentUid'] == studentUid

                        ) {
                          print('yes is here ');
                          //   print(element['age']);
                          setState(() {
                            isClassNameExist = 'yes';
                            docId = element.id.toString();
                            surahStars = element['surahStars'];
                          });
                        }
                      });

                      if (isClassNameExist == 'yes') {
                        await getFinalData().whenComplete(() {
                          print(countGreen.toString() + " Final Count green");
                          print( "Surah Alreday exists Final Count green");
                          FirebaseFirestore.instance
                              .collection("StudentEvaluatedSurah")
                              .doc(docId.toString())
                              .update(
                            {
                              "surahName": widget.surahName,
                              "surahNumber": widget.surahNumber,
                              "studentEmail": studentEmail,
                              "studentName": studentName,
                              "studentUid": studentUid,
                              "studentDocId": widget.studentDocId,
                              "teacherEmail": studentUid,
                              "classCode": widget.classCode,
                              "chapterId": widget.chapterId,
                              "chapterIndex": widget.chapterIndex,
                              "partNo": widget.partIndex,
                              "surahCompleted":
                              evaluatedSurahCheck == "yes" && (evaluatedSurah.toString() == widget.surahAyhs)  ? "yes" :
                              evaluatedSurah == int.parse(widget.surahAyhs)-1 ? "yes" :
                              "no",
                              "surahRecording": "1",
                              "surahStars": surahStars.toInt(),
                              "surahGreenAyah": countGreen.toString(),
                              "surahVerses": surahVerses
                            },
                          ).then((value) {
                            print("getBadges start done");
                            setState(() {
                              partOneBadgeCount = 0;
                              partTwoBadgeCount = 0;
                              partThreeBadgeCount = 0;
                            });

                            FirebaseFirestore.instance
                                .collection('StudentEvaluatedSurah')
                                .where('classCode',
                                    isEqualTo: widget.classCode.toString())
                                .where('studentUid', isEqualTo: studentUid)
                                .where('studentDocId', isEqualTo: widget.studentDocId)
                                .where('chapterId', isEqualTo: widget.chapterId)
                                .get()
                                .then((value) {

                              print("get data start ${value.docs.length}");
                              int listL = 0;
                                  if (value.docs.isNotEmpty) {


                                print("getBadges inside");
                                for (int i = 0; i < value.docs.length; i++) {

                                  setState(() {
                                    listL = i;
                                  });

                                  if (value.docs[i]['surahCompleted'].toString() == 'yes' && value.docs[i]['partNo'] == 0) {
                                    print(value.docs[i]['surahName'].toString() + ' Completed surah');
                                    setState(() {
                                      partOneBadgeCount = partOneBadgeCount + 1;
                                    });
                                    print('Part One Badge count $partOneBadgeCount');
                                  }
                                  else {
                                  //  print('else Part One Badge count $partOneBadgeCount');
                                  }

                                  if (value.docs[i]['surahCompleted']
                                      .toString() ==
                                      'yes' &&
                                      value.docs[i]['partNo'] == 1) {
                                    setState(() {
                                      partTwoBadgeCount = partTwoBadgeCount + 1;
                                    });
                                    print('Part Two Badge count $partTwoBadgeCount');
                                  }
                                  else {
                                    //print('else Part Two Badge count $partTwoBadgeCount');
                                  }


                               if (value.docs[i]['surahCompleted']
                                      .toString() ==
                                      'yes' &&
                                      value.docs[i]['partNo'] == 2)
                               {
                                    setState(() {
                                      partThreeBadgeCount =
                                          partThreeBadgeCount + 1;
                                    });
                                    print('Part Three Badge count $partThreeBadgeCount');
                                  }
                               else {
                                // print('else Part Three Badge count $partThreeBadgeCount');
                               }
                                }
                              }
                                  else {
                                print('doc is empty');
                              }

                                  if(listL == value.docs.length-1) {
                                    print('$listL and value data length ${value.docs.length}');
                                    print(partOneBadgeCount);
                                    print(partTwoBadgeCount);
                                    print(partThreeBadgeCount);
                                    evaluateChapters();
                                  }
                            });
                          });
                        });
                      }
                      else {


                        await getFinalData().whenComplete(() {
                          print(countGreen.toString() + " Final Count green");

                          FirebaseFirestore.instance
                              .collection("StudentEvaluatedSurah")
                              .doc()
                              .set(
                            {
                              "surahName": widget.surahName,
                              "surahNumber": widget.surahNumber,
                              "studentEmail": studentEmail,
                              "studentName": studentName,
                              "studentUid": studentUid,
                              "studentDocId": widget.studentDocId,
                              "teacherEmail": studentUid,
                              "classCode": widget.classCode,
                              "chapterId": widget.chapterId,
                              "chapterIndex": widget.chapterIndex,
                              "partNo": widget.partIndex,
                              "recordingStarted": "yes",
                              "surahCompleted":
                              evaluatedSurahCheck == "yes" && (evaluatedSurah.toString() == widget.surahAyhs)  ? "yes" :
                              evaluatedSurah == int.parse(widget.surahAyhs)-1 ? "yes" :
                              "no",
                              "surahRecording": "1",
                              "surahStars": 0,
                              "surahGreenAyah": countGreen.toString(),
                              "surahVerses": surahVerses
                            },
                          ).then((value) async {
                            //print("getBadges before");

                            print(' totalBadges done dana done');

                            setState(() {
                              isLoading = false;
                            });
                            Fluttertoast.showToast(
                              msg:
                              "Successfully evaluated ayah ${widget.currentAya + 1} of surah ${widget.surahName}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                            );
                            Navigator.pop(context);

                          });
                        });
                      }



                    }
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Save ayah recording",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Recording"),
        centerTitle: true,
      ),
      body: makeBody(),
    );
  }
}
