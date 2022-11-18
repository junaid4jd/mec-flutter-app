import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/studentEvaluation/recording_screen.dart';
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
  final String surahAyhs;
  final String way;
  final String teacherEmail;
  const AyahEvaluationScreen({Key? key
  ,required this.surahName, required this.surahAyhs, required this.way, required this.teacherEmail}) : super(key: key);

  @override
  _AyahEvaluationScreenState createState() => _AyahEvaluationScreenState();
}

class _AyahEvaluationScreenState extends State<AyahEvaluationScreen> {

  String name = '' , email = '', selectedIndexColor = '', selectedIndex = '';
  bool star1 = false, star2 = false,star3 = false, micOn = false, play = false;

  // FlutterSoundRecorder? _recordingSession;
  // final recordingPlayer = AssetsAudioPlayer();
  // String? pathToAudio;




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


  // Codec _codec = Codec.aacMP4;
  // String _mPath = 'tau_file.mp4';
  // FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  // FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  // bool _mPlayerIsInited = false;
  // bool _mRecorderIsInited = false;
  // bool _mplaybackReady = false;
  // final recorder = SoundRecorder();

  @override
  void initState() {

    // _mPlayer!.openPlayer().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    //
    // openTheRecorder().then((value) {
    //   setState(() {
    //     _mRecorderIsInited = true;
    //   });
    // });

    getData();
    setState(() {
      selectedIndexColor = '';
      selectedIndex = '';
    });
    super.initState();
  }

//   @override
//   void dispose() {
//     _mPlayer!.closePlayer();
//     _mPlayer = null;
//
//     _mRecorder!.closeRecorder();
//     _mRecorder = null;
//     super.dispose();
//   }
//
//   Future<void> openTheRecorder() async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//     }
//     await _mRecorder!.openRecorder();
//     if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//       _codec = Codec.opusWebM;
//       _mPath = 'tau_file.webm';
//       if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//         _mRecorderIsInited = true;
//         return;
//       }
//     }
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration(
//       avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//       avAudioSessionCategoryOptions:
//       AVAudioSessionCategoryOptions.allowBluetooth |
//       AVAudioSessionCategoryOptions.defaultToSpeaker,
//       avAudioSessionMode: AVAudioSessionMode.spokenAudio,
//       avAudioSessionRouteSharingPolicy:
//       AVAudioSessionRouteSharingPolicy.defaultPolicy,
//       avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
//       androidAudioAttributes: const AndroidAudioAttributes(
//         contentType: AndroidAudioContentType.speech,
//         flags: AndroidAudioFlags.none,
//         usage: AndroidAudioUsage.voiceCommunication,
//       ),
//       androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
//       androidWillPauseWhenDucked: true,
//     ));
//
//     _mRecorderIsInited = true;
//   }
//
//   // ----------------------  Here is the code for recording and playback -------
//   void record() {
//     _mRecorder!
//         .startRecorder(
//       toFile: _mPath,
//       codec: _codec,
//       audioSource: theSource,
//     )
//         .then((value) {
//       setState(() {});
//     });
//   }
//
//   void stopRecorder() async {
//     await _mRecorder!.stopRecorder().then((value) {
//       setState(() {
//         //var url = value;
//         _mplaybackReady = true;
//       });
//     });
//   }
//
//   void play1() {
//     assert(_mPlayerIsInited &&
//         _mplaybackReady &&
//         _mRecorder!.isStopped &&
//         _mPlayer!.isStopped);
//     _mPlayer!
//         .startPlayer(
//         fromURI: _mPath,
//         //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
//         whenFinished: () {
//           setState(() {});
//         })
//         .then((value) {
//       setState(() {});
//     });
//   }
//
//   void stopPlayer() {
//     _mPlayer!.stopPlayer().then((value) {
//       setState(() {});
//     });
//   }
//
// // ----------------------------- UI --------------------------------------------
//   _Fn? getRecorderFn() {
//     print("_mRecorder!.isRecording we are in function");
//     if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
//       return null;
//     }
//     return _mRecorder!.isStopped ? record : stopRecorder;
//   }
//
//   _Fn? getPlaybackFn() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
//       return null;
//     }
//     return _mPlayer!.isStopped ? play1 : stopPlayer;
//   }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Student Evaluation"),
        centerTitle: true,
      ),
      body: Column(
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
                  itemCount: 9,//snapshot.data!.docs.length,//myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          color: whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color:
                                      selectedIndex  == index.toString() &&
                                          selectedIndexColor == 'green' ? primaryColor :
                                      selectedIndex  == index.toString() &&
                                          selectedIndexColor == 'orange' ? Colors.orange :
                                      selectedIndex  == index.toString() && selectedIndexColor == 'yellow' ? Colors.yellow :
                                      Colors.grey, width: 3)
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: (){
                                          // print("_mRecorder!.isRecording");
                                          // print(_mRecorder!.isRecording);
                                          // getRecorderFn();
                                          setState(() {
                                            selectedIndex = index.toString();
                                          });

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) => SimpleRecorder(),
                                                  // AyahEvaluationScreen(
                                                  //   surahName: "الْإِخْلَاص",
                                                  //   surahAyhs: "4",
                                                  //   way: "surah",
                                                  //   teacherEmail: email,
                                                  // ),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );


                                        },
                                        child:
                                        Icon(
                                          //_mRecorder!.isRecording ? Icons.stop :
                                          Icons.mic,
                                          size: 25,
                                          color:
                                          //_mRecorder!.isRecording && selectedIndex == index.toString() ? Colors.red :
                                          Colors.green,
                                        ),
                                        //Icon(Icons.mic, color: micOn && selectedIndex == index.toString() ? Colors.green : Colors.grey, size: 30,)

                                    ),
                                    GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedIndex = index.toString();
                                          });
                                          //getPlaybackFn();
                                        },
                                        child: Icon(
                                          // _mPlayer!.isPlaying && selectedIndex == index.toString() ?
                                          // Icons.stop :
                                          Icons.play_arrow_sharp

                                          , color:
                                        // _mPlayer!.isPlaying && selectedIndex == index.toString()
                                        //     ? Colors.green :

                                        Colors.grey,

                                          size: 30,)),
//

                                  ],
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
                                          selectedIndexColor = "green";
                                          selectedIndex = index.toString();
                                        });
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 10,
                                        color: primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndexColor = "orange";
                                          selectedIndex = index.toString();
                                        });
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 10,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          selectedIndexColor = "yellow";
                                          selectedIndex = index.toString();
                                        });
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 10,
                                        color: Colors.yellow,
                                      ),
                                    ),
//

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

          SizedBox(
            height: size.height*0.03,
          ),
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

                  GestureDetector(
                      onTap: (){
                        setState(() {
                          star1 = !star1;
                        });
                      },
                      child: Icon(Icons.star, color: star1 ? Colors.amber : Colors.grey,size: 60,)),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          star2 = !star2;
                        });
                      },
                      child: Icon(Icons.star, color: star2 ? Colors.amber : Colors.grey,size: 60,)),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          star3 = !star3;
                        });
                      },
                      child: Icon(Icons.star, color: star3 ? Colors.amber : Colors.grey,size: 60,)),

                  // Container(
                  //
                  //   child: Text("Individual", style: TextStyle(color: whiteColor,fontSize: 15),),
                  // ),
                ],
              ),
            ),
          ),

        ],
      ),

    );
  }
}


