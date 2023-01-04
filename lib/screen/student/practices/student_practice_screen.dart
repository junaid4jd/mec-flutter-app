import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StudentPracticeScreen extends StatefulWidget {
  const StudentPracticeScreen({Key? key}) : super(key: key);

  @override
  _StudentPracticeScreenState createState() => _StudentPracticeScreenState();
}

class _StudentPracticeScreenState extends State<StudentPracticeScreen> {

  String name = '' , email = '';
  String text = '';
  String subject = '', selectedIndex = '';
  bool isHide = false, hideAll = false, playAyahIndex = false;
  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      selectedIndex = '';
      isHide = false;
      playAyahIndex = false;
    });
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('Students').doc(prefs.getString('userId')!).get().then((value) {
      print('Teachers get');
      print(value.data());
      setState(() {
        email = value.data()!['email'].toString();
        name = value.data()!['name'].toString();
      });

    });
  }

  playAyah() async {
    setState(() {
      assetsAudioPlayer.play();
    });

    try {
      await assetsAudioPlayer.open(
        Audio.network("https://firebasestorage.googleapis.com/v0/b/mec-flutter-app.appspot.com/o/uploads%2Ftau_file.mp4?alt=media&token=9cfae658-b5a8-40f7-a994-a8af749d0c26"),
      ).whenComplete(() {
        setState(() {
          playAyahIndex = false;
          assetsAudioPlayer.stop();
        });
      });
    } catch (t) {
      print(t.toString() + "Error is here");
      //mp3 unreachable
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
      body: SingleChildScrollView(
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
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/images/microphone.png'),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      child: Icon(
                        Icons.play_arrow_sharp,size: 30, color: primaryColor,)
                     // Image.asset('assets/images/trophy.png'),
                    ),
                    SizedBox(
                      width: 20,
                    ),

                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/save-instagram.png'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (c, a1, a2) => StudentHomeScreen(userType: "Student" , classCode: "",index: 5 ,),
                        //     transitionsBuilder:
                        //         (c, anim, a2, child) =>
                        //         FadeTransition(
                        //             opacity: anim,
                        //             child: child),
                        //     transitionDuration:
                        //     Duration(milliseconds: 0),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Image.asset('assets/images/share-option.png'),
                      ),
                    ),
                    SizedBox(
                      width: 8,
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
                  itemCount: 6,//snapshot.data!.docs.length,
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
                                  width: size.width*0.6,
                                  color: selectedIndex == index.toString() && isHide ? greyColor : primaryColor,//primaryColor,
                                  child: Center(child: Text('ألْفَاتِحَة', style: TextStyle(color:
                                  selectedIndex == index.toString() && isHide ? greyColor :

                                  whiteColor, fontWeight: FontWeight.bold,fontSize: 23),)),
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
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset('assets/images/microphone.png'),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                      setState(() {
                                        playAyahIndex = !playAyahIndex;
                                        selectedIndex = index.toString();
                                      });

                                      if(playAyahIndex) {
                                        playAyah();
                                      } else {

                                        setState(() {
                                          assetsAudioPlayer.stop();
                                        });

                                      }

                                    },
                                    child: Container(
                                        width: 25,
                                        height: 25,
                                        child: Icon(
                                          playAyahIndex &&
                                              selectedIndex == index.toString() ?
                                              Icons.pause :
                                          Icons.play_arrow_sharp,size: 30, color: primaryColor,)
                                      // Image.asset('assets/images/trophy.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset('assets/images/sound.png'),
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

            // Center(
            //   child: Container(
            //     child: Text("My Practice"),
            //   ),
            // ),
          ],
        ),
      ),

    );
  }
}
