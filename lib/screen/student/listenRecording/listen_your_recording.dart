import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/studentEvaluation/ayah_evaluation_screen.dart';
import 'package:quran/quran.dart';

class ListenYourRecordingScreen extends StatefulWidget {
  const ListenYourRecordingScreen({Key? key}) : super(key: key);

  @override
  _ListenYourRecordingScreenState createState() => _ListenYourRecordingScreenState();
}

class _ListenYourRecordingScreenState extends State<ListenYourRecordingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: Text("Recordings"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("StudentEvaluatedSurah")
            .where("studentUid",isEqualTo: _auth.currentUser!.uid.toString())
            .where("recordingStarted",isEqualTo: "yes")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print(" we are here 3");
            return Center(child: CircularProgressIndicator(
              strokeWidth: 1,
              color: primaryColor,
            ));
          }
          else if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
            // got data from snapshot but it is empty

            return Center(child: Text("No Data Found"));
          }
          else {
            print(" we are here");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: snapshot.data!.docs.length,//myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) =>
                                AyahEvaluationScreen(
                                  studentUid: snapshot.data!.docs[index]['studentUid'].toString(),
                                  studentName: snapshot.data!.docs[index]['studentName'].toString(),
                                  surahNumber: snapshot.data!.docs[index]['surahNumber'].toString(),
                                  surahName: snapshot.data!.docs[index]['surahName'].toString(),
                                  surahAyhs: getVerseCount(int.parse(snapshot.data!.docs[index]['surahNumber'].toString())).toString(), //snapshot.data!.docs[index]['studentUid'].toString(),
                                  way: "studentRecording",
                                  surahIndex: index,
                                  teacherEmail: snapshot.data!.docs[index]['teacherEmail'].toString(),
                                  chapterName: snapshot.data!.docs[index]['studentUid'].toString(),
                                  chapterId: snapshot.data!.docs[index]['chapterId'].toString(),
                                  classDocId: snapshot.data!.docs[index]['studentUid'].toString(),
                                  classCode: snapshot.data!.docs[index]['classCode'].toString(), // partNo
                                  studentDocId: snapshot.data!.docs[index]['studentDocId'].toString(),//snapshot.data!.docs[index]['studentUid'].toString(),
                                  partIndex: snapshot.data!.docs[index]['partNo'],
                                  chapterIndex: snapshot.data!.docs[index]['chapterIndex']
                                ),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 0),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [

                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                              ),
                              SizedBox(height: 4,),

                              Text(snapshot.data!.docs[index]['surahName'].toString()),
                              Text(snapshot.data!.docs[index]['classCode'].toString(),style: TextStyle(fontSize: 10),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }

          // else {
          //   print(" we are here 1");
          //   return Center(
          //     child: Text(
          //       'No Data Found...',style: TextStyle(color: Colors.black),
          //     ),
          //   );
          // }
        },
      ),

    );
  }
}
