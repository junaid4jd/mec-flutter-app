import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/soundRecorder.dart';
import 'package:permission_handler/permission_handler.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class SimpleRecorder extends StatefulWidget {
  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  final recorder = SoundRecorder();
  String recordedUrl = '';

  @override
  void initState() {
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
        upload(recordedFile);
        print('This is recordedurl ' + recordedUrl.toString());
      });
    });
    print('This is recorded audio path ' + recordedUrl.toString());


  }

  upload(File fil)async{
    print('we are in upload file ');
    String fileName = fil.path
        .split('/')
        .last;
    Reference  firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask  uploadTask = firebaseStorageRef.putFile(fil);
    uploadTask.whenComplete(() {
       firebaseStorageRef.getDownloadURL().then((value) {
         print('This is url');
         print(value.toString());
         print(value.toString());
       });
    }).catchError((onError) {
      print(onError);
    });
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
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                _mRecorder!.isRecording ? 'Stop Recording' :
                'Record your recording', style: TextStyle(color: _mRecorder!.isRecording ? redColor : primaryColor,fontSize: 17, fontWeight: FontWeight.bold),),
              ElevatedButton.icon(
                onPressed: getRecorderFn(),
                style: ElevatedButton.styleFrom(
                  primary: _mRecorder!.isRecording ? Colors.red : primaryColor,//Colors.green,
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
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                _mPlayer!.isPlaying ? 'Pause Recording' :
                'Play Recording       ', style: TextStyle(color: _mPlayer!.isPlaying ? redColor : primaryColor,fontSize: 17, fontWeight: FontWeight.bold),),
              ElevatedButton.icon(
                onPressed: getPlaybackFn(),
                style: ElevatedButton.styleFrom(
                  primary:Colors.white,
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
                  color: primaryColor,//Colors.green,
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
            height: size.height*0.03,
          ),
          GestureDetector(
            onTap: (){
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
            },
            child: Container(

              width: size.width*0.8,
              height: size.height*0.05,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    child: Text("Save ayah recording", style: TextStyle(color: whiteColor,fontSize: 15, fontWeight: FontWeight.bold),),
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
