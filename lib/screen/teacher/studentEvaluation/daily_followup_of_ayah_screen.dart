import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/studentEvaluation/student_evaluation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DailyFollowUpAyahScreen extends StatefulWidget {
  final String surahName;
  final String surahAyhs;
  final String way;
  final String teacherEmail;
  const DailyFollowUpAyahScreen({Key? key,
    required this.surahName, required this.surahAyhs, required this.way, required this.teacherEmail}) : super(key: key);

  @override
  _DailyFollowUpAyahScreenState createState() => _DailyFollowUpAyahScreenState();
}

class _DailyFollowUpAyahScreenState extends State<DailyFollowUpAyahScreen> {

  String name = '' , email = '', selectedIndex = '';

  @override
  void initState() {
    // TODO: implement initState
   // print( 'This is teacher email ${widget.teacherEmail.toString()}');
    getData();
    setState(() {
      selectedIndex = '';
    });
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
        title: Text("Daily Follow Up"),
        centerTitle: true,
      ),
      body:  Column(
        children: [
          SizedBox(
            height: size.height*0.03,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

              height: size.height*0.43,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //maxCrossAxisExtent: 200,
                      //childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,

                      mainAxisSpacing: 10),
                  itemCount: 9,//snapshot.data!.docs.length,//myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return

                      GestureDetector(
                      onTap: () {

                        setState(() {
                          selectedIndex = "${index}";
                        });

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

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  //color: redColor,
                                  border: Border.all(color:
                                  selectedIndex == index.toString() ? Colors.yellow :
                                  Colors.grey,

                                      width: 3)
                              ),
                              width: 60,
                              height: 60,

                              child: Center(child: Text(
                                "${index+1}"
                                //"الْإِخْلَاص"
                                ,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),
                              )),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child:  Icon(Icons.reply,
                                    color: Colors.black,
//color: primaryColor,
                                    size: 20,),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child:  Icon(Icons.mic,
                                    color: Colors.black,
//color: primaryColor,
                                    size: 20,),
                                ),

                              ],
                            ),
                          ],
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

                    child: Text("Individual", style: TextStyle(color: whiteColor,fontSize: 15),),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),


      //   StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection("StudentClasses").where("teacherEmail",isEqualTo: email.toString()).snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       print(" we are here 3");
      //       return Center(child: CircularProgressIndicator(
      //         strokeWidth: 1,
      //         color: primaryColor,
      //       ));
      //     }
      //     else if (snapshot.hasData) {
      //       print(" we are here");
      //       return snapshot.data!.docs.length == 0 ?
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: GridView.builder(
      //             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //                 maxCrossAxisExtent: 200,
      //                 childAspectRatio: 3 / 2,
      //                 crossAxisSpacing: 10,
      //                 mainAxisSpacing: 10),
      //             itemCount: snapshot.data!.docs.length,//myProducts.length,
      //             itemBuilder: (BuildContext ctx, index) {
      //               return Container(
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                     color: Colors.amber,
      //                     borderRadius: BorderRadius.circular(15)),
      //                 child: Column(
      //                   children: [
      //
      //                     CircleAvatar(
      //                       radius: 40,
      //                       backgroundImage: NetworkImage(
      //                           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
      //                     ),
      //                     SizedBox(height: 8,),
      //
      //                     Text("name"),
      //                   ],
      //                 ),
      //               );
      //             }),
      //       )
      //
      //           : Center(
      //         child: Text(
      //           'No Data Found...',style: TextStyle(color: Colors.black),
      //         ),
      //       );
      //     }
      //
      //     else {
      //       print(" we are here 1");
      //       return Center(
      //         child: Text(
      //           'No Data Found...',style: TextStyle(color: Colors.black),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}


