import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/audioPlayer/audio_player_screen.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:mec/screen/student/practiseRecording/practise_recording_screen.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StudentPracticeScreen extends StatefulWidget {
  const StudentPracticeScreen({Key? key}) : super(key: key);

  @override
  _StudentPracticeScreenState createState() => _StudentPracticeScreenState();
}

class _StudentPracticeScreenState extends State<StudentPracticeScreen> {

  String name = '' , email = '';
  String text = '';
  String isClassNameExist = '';
  String surahR = 'no';
  String ayaOne = 'no';
  String ayahTwo = 'no';
  String ayahThree = 'no';
  String ayahFour = 'no';
  String ayahFive = 'no';
  String ayahSix = 'no';
  String ayahSeven = 'no';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String subject = '', selectedIndex = '';
  bool isHide = false, hideAll = false, playAyahIndex = false, loadingPractise = true;
  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {

    // TODO: implement initState
    setState(() {
      loadingPractise = true;
      selectedIndex = '';
      isClassNameExist = '';
      isHide = false;
      playAyahIndex = false;
    });
    doesIhaveAnyPractiseCollection();
    super.initState();
  }


  doesIhaveAnyPractiseCollection() async {

    final snapshot = await FirebaseFirestore.instance
        .collection('Practise')
        .get();

    snapshot.docs.forEach((element) {
      print('user data');
      if (element['uid'] == _auth.currentUser!.uid.toString()) {
        print('yes is here ');

        setState(() {
          isClassNameExist = 'yes';
          surahR = element['completeSurah'];
          ayaOne = element['ayahOne'];
          ayahTwo = element['ayahTwo'];
          ayahThree = element['ayahThree'];
          ayahFour = element['ayahFour'];
          ayahFive = element['ayahFive'];
          ayahSix = element['ayahSix'];
          ayahSeven = element['ayahSeven'];
          loadingPractise = false;
        });
      }
    });


    if( isClassNameExist == 'yes') {
      print('yes its present');

    } else {

      FirebaseFirestore.instance
          .collection('Practise').doc(_auth.currentUser!.uid.toString()).set({
        'completeSurah' : 'no',
        'uid' : _auth.currentUser!.uid.toString(),
        'ayahOne' : 'no',
        'ayahTwo' : 'no',
        'ayahThree' : 'no',
        'ayahFour' : 'no',
        'ayahFive' : 'no',
        'ayahSix' : 'no',
        'ayahSeven' : 'no',

      }).then((value) {
        setState(() {
          loadingPractise = false;
        });
        print('Succcessfully practise added now');
      });



    }


  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: primaryColor,
        title: Text("Practice"),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                    ),
                    SizedBox(height: 8,),
                    Text(name.toString(), style: TextStyle(color: whiteColor,fontSize: 15,letterSpacing: 1),),
                    SizedBox(height: 8,),
                    Text(email.toString(), style: TextStyle(color: whiteColor,fontSize: 12,letterSpacing: 1),),
                  ],
                ),
              ),
            ),
            ListTile(
              tileColor: lightGreyColor,
              leading: Icon(
                Icons.logout,color: primaryColor,size: 25,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios, color: primaryColor,size: 20,
              ),
              title:  Text('Logout', style: body4Black),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('userType').whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => UserType(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 0),
                    ),
                  );
                });

              },
            ),

          ],
        ),
      ),
      body:
      loadingPractise ? Center(child: CircularProgressIndicator(

      )) :
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.05,
            ),
            DottedBorder(
              strokeWidth: 3,
              color: primaryColor,
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
             // padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 50,
                  width: 200,
                  color: primaryColor,
                  child: Center(child: Text('ألْفَاتِحَة', style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold,fontSize: 23),)),
                ),
              ),
            ),
            SizedBox(
              height: size.height*0.025,
            ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) =>
                                PractiseRecording(ayahNumber: 8),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 0),
                          ),
                        ).then((value) {
                          doesIhaveAnyPractiseCollection();
                          setState(() {

                          });
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Image.asset('assets/images/microphone.png'),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: () {

                        if(surahR != 'no') {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>
                                  AudioScreen(audioFile: surahR.toString(),),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 0),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "First record your complete surah",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                          );
                          print('surahR $surahR');
                        }

                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Image.asset('assets/images/sound.png'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),


                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height*0.025,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: size.height*0.6,
                child: ListView.builder(
                  itemCount: 7,//snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                   // DocumentSnapshot ds = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: size.width*0.86,
                        height: size.height*0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          DottedBorder(
                            strokeWidth: 3,
                            color: greyColor,//primaryColor,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            // padding: EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index.toString();
                                    isHide = !isHide;
                                  });
                                },
                                child: Container(
                                  height: size.height*0.065,
                                  width: size.width*0.7,
                                  color: selectedIndex == index.toString() && isHide ? greyColor : primaryColor,//primaryColor,
                                  child: Center(child:
                                      Text(getVerse(1, index+1, verseEndSymbol: true).toString(),
                                        style: TextStyle(
                                            color:  selectedIndex == index.toString() && isHide ? greyColor :

                                            whiteColor,
                                            fontSize: index == 6 ? 14 : 20
                                        ),)

                                  // Text('ألْفَاتِحَة', style: TextStyle(color:
                                  // selectedIndex == index.toString() && isHide ? greyColor :
                                  //
                                  // whiteColor, fontWeight: FontWeight.bold,fontSize: 23),)

                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if(index == 0) {


                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 1),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });

                                      }
                                      else if(index == 1) {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 2),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });

                                      }
                                      else if(index == 2) {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 3),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });

                                      }
                                      else if(index == 3) {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 4),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });


                                      }
                                      else if(index == 4) {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 5),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });


                                      }
                                      else if(index == 5) {

                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  PractiseRecording(ayahNumber: 6),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          ).then((value) {
                                            doesIhaveAnyPractiseCollection();
                                            setState(() {

                                            });
                                          });

                                      }
                                      else if(index == 6) {

                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) =>
                                                PractiseRecording(ayahNumber: 7),
                                            transitionsBuilder: (c, anim, a2, child) =>
                                                FadeTransition(opacity: anim, child: child),
                                            transitionDuration: Duration(milliseconds: 0),
                                          ),
                                        ).then((value) {
                                          doesIhaveAnyPractiseCollection();
                                          setState(() {

                                          });
                                        });

                                      }
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset('assets/images/microphone.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      if(index == 0) {

                                        if(ayaOne != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayaOne.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah one",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah One $ayaOne');
                                        }

                                      }
                                      else if(index == 1) {

                                        if(ayahTwo != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahTwo.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah two",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah two $ayahTwo');
                                        }

                                      }
                                      else if(index == 2) {

                                        if(ayahThree != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahThree.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah three",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah three $ayahThree');
                                        }

                                      }
                                      else if(index == 3) {

                                        if(ayahFour != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahFour.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah four",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah four $ayahFour');
                                        }

                                      }
                                      else if(index == 4) {

                                        if(ayahFive != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahFive.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah five",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah five $ayahFive');
                                        }

                                      }
                                      else if(index == 5) {

                                        if(ayahSix != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahSix.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah six",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah six $ayahSix');
                                        }

                                      }
                                      else if(index == 6) {

                                        if(ayahSeven != 'no') {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (c, a1, a2) =>
                                                  AudioScreen(audioFile: ayahSeven.toString(),),
                                              transitionsBuilder: (c, anim, a2, child) =>
                                                  FadeTransition(opacity: anim, child: child),
                                              transitionDuration: Duration(milliseconds: 0),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "First record your ayah seven",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 4,
                                          );
                                          print('Ayah seven $ayahSeven');
                                        }

                                      }
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset('assets/images/sound.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],),
                      ),
                    );
                  },
                  //Container(child: Text('AdminHome'),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
