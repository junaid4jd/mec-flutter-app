import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/model/teacher_class_model.dart';
import 'package:mec/screen/teacher/studentEvaluation/ayah_evaluation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentEvaluationScreen extends StatefulWidget {
  final String surahName;
  final String surahAyhs;
  final String way;
  final String classCode;
  final String teacherEmail;
  final TeacherClasseModel teacherClasseModel;

  const StudentEvaluationScreen({Key? key,
    required this.surahName, required this.surahAyhs, required this.way, required this.teacherEmail, required this.classCode, required this.teacherClasseModel}) : super(key: key);

  @override
  _StudentEvaluationScreenState createState() => _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends State<StudentEvaluationScreen> {

  String name = '' , email = '';

  @override
  void initState() {
    // TODO: implement initState
    print( 'This is teacher email ${widget.teacherEmail.toString()}');
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection("StudentClasses").where("teacherEmail",isEqualTo: widget.teacherEmail.toString()).get().then((value) {
     // print(value["teacherEmail"].toString());
    });

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: Text("Students"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("StudentClasses").where("classCode",isEqualTo: widget.classCode.toString()).snapshots(),
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
                                  surahName: "الْإِخْلَاص",
                                  surahAyhs: "4",
                                  way: "surah",
                                  teacherEmail: email,
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
                              SizedBox(height: 8,),

                              Text(snapshot.data!.docs[index]['studentName'].toString()),
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
