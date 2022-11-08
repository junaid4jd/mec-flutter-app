import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:mec/screen/chapter/chapter_list.dart';
import 'package:mec/screen/teacher/addClass/addClass_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
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
      floatingActionButton: new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: primaryColor,
        onPressed: () {


          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => AddClassScreen(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 0),
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Classes").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              strokeWidth: 1,
              color: primaryColor,
            ));
          }
     else if (snapshot.hasData) {
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
                     ChapterList(classCode: ds['classCode'].toString()),
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
                     subtitle: Text(ds['teacherEmail'].toString(), style: TextStyle(fontSize: 12),),
                     trailing:  GestureDetector(
                         onTap: () {
                           setState(() {
                             text = ds['classCode'].toString();
                           });
                           share();

                         },
                         child: Icon(
                           Icons.qr_code,
                           color: primaryColor,
                         )),
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

          else {
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

  showAlertDialog(
      BuildContext context, String title, String content, String id) {
    // set up the button

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("$title", style: body2Black,),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("$id",style: subtitleGreen,),
      ),
      actions: [
        CupertinoDialogAction(
            child: Text("Cancel", style: body1Black,),
            onPressed: () {
             
              Navigator.of(context).pop();
            }),
        CupertinoDialogAction(
            child: Text("Share",style: body1Green,),
            onPressed: () {
            //  _onShare(context);
              // FirebaseFirestore.instance
              //     .collection("Teachers")
              //     .doc(id)
              //     .delete()
              //     .whenComplete(() {
              //   Navigator.of(context).pop();
              // });
            })
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
              builder: (context, setState) {
                return alert;
              }
        );
      },
    );
  }
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Classroom Code',
        text: '$text',
        linkUrl: '',
        chooserTitle: ''
    );
  }

}
