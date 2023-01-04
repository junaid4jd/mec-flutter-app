import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:mec/screen/evaluatingStudent/evaluating_student_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentScreenTeacher extends StatefulWidget {
  final String surahName;
  final String surahAyhs;
  final String way;

  const StudentScreenTeacher({Key? key, required this.surahName, required this.surahAyhs, required this.way}) : super(key: key);

  @override
  _StudentScreenTeacherState createState() => _StudentScreenTeacherState();
}

class _StudentScreenTeacherState extends State<StudentScreenTeacher> {

  String name = '' , email = '';
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    getData();
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
        isLoading = false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: primaryColor,
        title: Text("Students"),
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
                      pageBuilder: (c, a1, a2) =>
                          UserType(),
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
      isLoading ? Center(child: CircularProgressIndicator()) :
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("StudentClasses").where(
            "teacherEmail", isEqualTo: email
        ).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: primaryColor,
                ));
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            // got data from snapshot but it is empty

            return Center(child: Text("No Data Found"));
          } else {
            return Center(
              child: Container(
                width: size.width * 0.95,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (c, a1, a2) => UserDetailScreen(
                        //       docId: snapshot.data!.docs[index].id.toString(),
                        //       userStatus: "Students",
                        //
                        //     ),
                        //     transitionsBuilder: (c, anim, a2, child) =>
                        //         FadeTransition(opacity: anim, child: child),
                        //     transitionDuration: Duration(milliseconds: 100),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 0, right: 0),
                        child: Container(
                          width: size.width * 0.95,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightGreenColor,//Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.3),//whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8,bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.green,
                                  ),
                                  width: size.width * 0.17,
                                  child: CircleAvatar(
                                    backgroundColor: lightGreyColor,
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                                  ),
                                ),
                                Container(
                                  //  color: redColor,
                                  // width: size.width * 0.73,

                                  child: Column(
                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(

                                        children: [
                                          Container(
                                            //  color: Colors.orange,
                                           // width: size.width * 0.48,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // color: Colors.yellow,
                                                  alignment: Alignment.topLeft,
                                                  child:  Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                    ["studentName"]
                                                        .toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w800,
                                                        height: 1.3),
                                                  ),

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //   MainAxisAlignment.start,
                                                  //   children: [
                                                  //     Text(
                                                  //       snapshot
                                                  //           .data!
                                                  //           .docs[index]
                                                  //       ["studentFirstName"]
                                                  //           .toString() +
                                                  //           " " +
                                                  //           snapshot
                                                  //               .data!
                                                  //               .docs[index]
                                                  //           ["studentLastName"]
                                                  //               .toString(),
                                                  //       style: TextStyle(
                                                  //           color: Colors.black,
                                                  //           fontSize: 14,
                                                  //           fontWeight: FontWeight.w800,
                                                  //           height: 1.3),
                                                  //     ),
                                                  //
                                                  //
                                                  //     // Icon(Icons.favorite, color:greyColor,size: 20,)
                                                  //   ],
                                                  // ),
                                                ),


                                                Container(

                                                  // color: Colors.greenAccent,
                                                  child:    Text(
                                                    snapshot.data!
                                                        .docs[index]["studentEmail"]
                                                        .toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.3),
                                                  ),


                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 1,
                                            height: 40,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            // color: Colors.greenAccent,
                                            // width: size.width * 0.27,
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (c, a1, a2) =>
                                                            EvaluatingStudentScreen(studentId: snapshot.data!
                                                                .docs[index]["uid"]
                                                                .toString()),
                                                        transitionsBuilder: (c, anim, a2, child) =>
                                                            FadeTransition(opacity: anim, child: child),
                                                        transitionDuration: Duration(milliseconds: 0),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(

                                                   // width: size.width*0.4,

                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Container(
                                                            child: Text("Evaluate ${snapshot.data!
                                                                .docs[index]["studentName"]
                                                                .toString().split(" ")[0]}",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(color: whiteColor,fontSize: 12),),
                                                          ),
                                                        ),
                                                        // GestureDetector(
                                                        //     onTap: (){
                                                        //       setState(() {
                                                        //         star1 = !star1;
                                                        //       });
                                                        //     },
                                                        //     child: Icon(Icons.star, color: star1 ? Colors.amber : Colors.grey,size: 60,)),
                                                        // SizedBox(
                                                        //   width: 8,
                                                        // ),
                                                        // GestureDetector(
                                                        //     onTap: (){
                                                        //       setState(() {
                                                        //         star2 = !star2;
                                                        //       });
                                                        //     },
                                                        //     child: Icon(Icons.star, color: star2 ? Colors.amber : Colors.grey,size: 60,)),
                                                        // SizedBox(
                                                        //   width: 8,
                                                        // ),
                                                        // GestureDetector(
                                                        //     onTap: () {
                                                        //       setState(() {
                                                        //         star3 = !star3;
                                                        //       });
                                                        //     },
                                                        //     child: Icon(Icons.star, color: star3 ? Colors.amber : Colors.grey,size: 60,)),


                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  //Container(child: Text('AdminHome'),),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
