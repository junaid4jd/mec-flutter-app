import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:quran/quran.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class PractiseRecording extends StatefulWidget {
  final int ayahNumber;
  const PractiseRecording({Key? key, required this.ayahNumber})
      : super(key: key);

  @override
  _PractiseRecordingState createState() => _PractiseRecordingState();
}

class _PractiseRecordingState extends State<PractiseRecording> {
  Codec _codec = Codec.aacMP4;
  String selectedIndexColor = '', selectedIndex = '';

  String isChpEvaluated = "no";
  String isPartOneEvaluated = "no";
  String isPartTwoEvaluated = "no";
  String isPartThreeEvaluated = "no";
  String chapEvaluatedListDocId = "";
  String studentsTableDocId = "";

  String _mPath = 'tau_file.mp4';
  String recordingUrl = '';
  String evaluatedSurahCheck = 'no';
  int countGreen = 0, evaluatedSurah = 0, y = 0;
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    setState(() {
      isAlreadyRecordingPresent = false;
      isLoading = false;
    });

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

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget makeBody() {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),

          widget.ayahNumber == 8 ?

              Container(
                width: size.width*0.9,

                child: Wrap(children: [

                  Container(
                    alignment: Alignment.center,
                    width: size.width*0.9,
                    child: Text(
                      getVerse(1, 1, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    child: Text(
                      getVerse(1, 3, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    child: Text(
                      getVerse(1, 2, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    child: Text(
                      getVerse(1, 5, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    child: Text(
                      getVerse(1, 4, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    child: Text(
                      getVerse(1, 6, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    child: Text(
                      getVerse(1, 7, verseEndSymbol: true).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),

                    ),
                  ),




                ],),
              ) :

          Container(
            alignment: Alignment.center,
            width: size.width*0.9,
            child: Text(
                getVerse(1, widget.ayahNumber, verseEndSymbol: true).toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),

            ),
          ),

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
            height: size.height * 0.05,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: () async {
                    if (recordingUrl == '') {
                      Fluttertoast.showToast(
                        msg: "Please record your ayah",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                      );
                    } else {

                      print("Color Selected and recorded");
                      setState(() {
                        isLoading = true;
                      });

                      if (widget.ayahNumber == 1) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahOne': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah One Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 2) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahTwo': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Two Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 3) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahThree': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Three Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 4) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahFour': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Four Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 5) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahFive': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Five Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 6) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahSix': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Six Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 7) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'ayahSeven': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Ayah Seven Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

                        });
                      }
                      else if (widget.ayahNumber == 8) {
                        FirebaseFirestore.instance
                            .collection('Practise')
                            .doc(_auth.currentUser!.uid.toString())
                            .update({

                          'completeSurah': recordingUrl,
                        }).then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: "Complete surah Recorded and Saved Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );

                          Navigator.pop(context);

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
                            "Save",
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
        title: Text("Practise Recording"),
        centerTitle: true,
      ),
      body: makeBody(),
    );
  }
}
