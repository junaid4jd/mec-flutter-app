import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:mec/screen/student/addClass/add_class_by_code_screen.dart';
import 'package:mec/screen/student/addClass/chap_in_class_screen.dart';
import 'package:mec/screen/student/student_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StudentClassScreen extends StatefulWidget {
  const StudentClassScreen({Key? key}) : super(key: key);

  @override
  _StudentClassScreenState createState() => _StudentClassScreenState();
}

class _StudentClassScreenState extends State<StudentClassScreen> {

  String name = '' , email = '',uid = '';
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
        uid = value.data()!['uid'].toString();
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: primaryColor,
        title: Text("Classes"),
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
      floatingActionButton: new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => AddClassByCodeScreen(way: "",),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("StudentClasses").where("uid",isEqualTo:uid.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              strokeWidth: 1,
              color: primaryColor,
            ));
          }
          else if (snapshot.hasData) {
            // this else if means you have enrolled below list of classes.
            return Center(
              child: Container(
                width: size.width*0.95,

                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) =>
                                StudentHomeScreen(userType: 'Student'  , classCode: ds['classCode'].toString(),index: 4 ,),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 0),
                          ),
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: size.height*0.25,
                            width: size.width*0.95,
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: greyColor,width: 0.5),
                            ),
                            child: Column(children: [

                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(color: greyColor,width: 0.5),
                                ),
                                width: size.width*0.95,
                                height: size.height*0.15,
                                child: Image.network('https://www.teacheracademy.eu/wp-content/uploads/2020/02/english-classroom.jpg',fit: BoxFit.cover,),

                              ),

                              ListTile(
                                tileColor: lightGreyColor,
                                leading: CircleAvatar(
                                  backgroundColor: lightGreyColor,
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                                ),
                                // CircleAvatar(
                                //   backgroundColor: const Color(0xff764abc),
                                //   child: Text(ds['name'].toString()[0]),
                                // ),
                                title: Text('${ds['className'].toString()}', style: body1Green,),
                                subtitle: Text(ds['studentEmail'].toString(), style: TextStyle(fontSize: 12),),
                                // trailing:  GestureDetector(
                                //     onTap: () {
                                //       setState(() {
                                //         text = ds['classCode'].toString();
                                //       });
                                //      // share();
                                //
                                //     },
                                //     child: Icon(
                                //       Icons.qr_code,
                                //       color: primaryColor,
                                //     )),
                              ),
                            ],
                            ),
                          )),
                    );
                  },
                  //Container(child: Text('AdminHome'),),
                ),
              ),
            );
          }

          else {   // this else means you do not have any enrolled class yet.
            return Center(
              child: Text(
                'No Data Found...',style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),

    );
  }
}
