import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/student/leatherBoard/leather_board_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/userType/usertype_screen.dart';
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  String name = '' , email = '';
  String text = '';
  String subject = '';

  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: primaryColor,
        title: Text("Profile"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height*0.045,),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
            ),
            SizedBox(height:  size.height*0.02,),
            Text(name.toString(), style: TextStyle(color: Colors.black,fontSize: 18,letterSpacing: 1, fontWeight: FontWeight.bold),),
            SizedBox(height: size.height*0.01,),
            Text(email.toString(), style: TextStyle(color: Colors.black,fontSize: 14,letterSpacing: 2,fontWeight: FontWeight.w400),),

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
                      percent: 0.85,
                      leading: new Text("0 "),
                      trailing: new Text("100"),
                      backgroundColor: greyColor,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Image.asset("assets/images/star.png",
                    width: 60,
                    height: 60,),

                ],
              ),
            ),

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
                      percent: 0.35,
                      leading: new Text("0 "),
                      trailing: new Text("100"),
                      backgroundColor: greyColor,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Image.asset("assets/images/ribbon.png",
                    width: 60,
                    height: 60,),

                ],
              ),
            ),

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
                      percent: 0.25,
                      leading: new Text("0 "),
                      trailing: new Text("100"),
                      backgroundColor: greyColor,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Image.asset("assets/images/trophy.png",
                    width: 60,
                    height: 60,)

                ],
              ),
            ),

            SizedBox(height: size.height*0.04,),

            Container(
              // color: Colors.green,
              width: size.width*0.9,
              //height: size.height*0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
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
                      width: size.width*0.6,
                      height: size.height*0.05,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(

                            child: Text("My Records", style: TextStyle(color: whiteColor,fontSize: 15),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset("assets/images/microphone.png",
                    width: 60,
                    height: 60,)

                ],
              ),
            ),
            SizedBox(height: size.height*0.04,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) =>
                        LeatherBoardScreen(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 0),
                  ),
                );
              },
              child: Container(
                width: size.width*0.9,
                height: size.height*0.05,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Check leather board", style: TextStyle(color: whiteColor,fontSize: 15),),
                    ),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
