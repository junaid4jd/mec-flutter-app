import 'package:flutter/material.dart';
import 'package:mec/constants.dart';

class StudentSurahScreen extends StatefulWidget {
  final String classCode;
  const StudentSurahScreen({Key? key, required this.classCode}) : super(key: key);

  @override
  _StudentSurahScreenState createState() => _StudentSurahScreenState();
}

class _StudentSurahScreenState extends State<StudentSurahScreen> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Chapter Surahs"),
        centerTitle: true,
      ),
      body:
      ListView.builder(
        itemCount: 3,//snapshot.data!.docs[0]["chapList"].length,
        itemBuilder: (context, index) {
          // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height*0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2,color: primaryColor)
                    ),
                    height: size.height*0.31,
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //maxCrossAxisExtent: 200,
                          //childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            crossAxisCount: 4,

                            mainAxisSpacing: 10),
                        itemCount: 12,//snapshot.data!.docs.length,//myProducts.length,
                        itemBuilder: (BuildContext ctx, index) {
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

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                //color: redColor,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          //color: redColor,
                                          border: Border.all(color: Colors.grey,width: 3)
                                      ),
                                      width: 60,
                                      height: 60,

                                      child: Center(child: Text("الْإِخْلَاص")),
                                    ),
                                    Positioned.fill(
                                      top: size.height*0.055,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:  Icon(Icons.star,
                                          color: Colors.black,
                                          //color: primaryColor,
                                          size: 20,),
                                      ),
                                    ),
                                    Positioned.fill(
                                      left: size.width*0.11,
                                      top: size.height*0.04,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:  Icon(Icons.star,
                                          color: Colors.black,
                                          //color: primaryColor,
                                          size: 20,),
                                      ),
                                    ),
                                    Positioned.fill(
                                      right: size.width*0.11,
                                      top: size.height*0.04,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:  Icon(Icons.star,
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
                        }),
                  ),
                ),

              ],
            ),
          );
        },
        //Container(child: Text('AdminHome'),),
      ),













    );
  }
}
