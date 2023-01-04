import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/signup/signup_screen.dart';
import 'package:mec/screen/authentication/userType/usertype_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  final String userType;
  const AdminHomeScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
      WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(

        appBar: AppBar(

          backgroundColor: primaryColor,
          title: Text("Admin"),
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
                      SizedBox(height: 10,),
                      Text('MEC ADMIN', style: TextStyle(color: whiteColor,fontSize: 18,letterSpacing: 3),),
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
                pageBuilder: (c, a1, a2) =>
                    SignUpScreen(userType: widget.userType, update: "", userId: "",),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 0),
              ),
            );
          },
        ),
        body: new StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Teachers").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
              // got data from snapshot but it is empty

              return Center(child: Text("No Data Found"));
            }


            else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
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
                      title: Text('${ds['name'].toString()}', style: body1Green,),
                      subtitle: Text(ds['email'].toString(), style: TextStyle(fontSize: 12),),
                      trailing: Container(
                        width: size.width * 0.2,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          SignUpScreen(userType: widget.userType, update: "yes", userId: ds.id,),
                                      transitionsBuilder: (c, anim, a2, child) =>
                                          FadeTransition(opacity: anim, child: child),
                                      transitionDuration: Duration(milliseconds: 0),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            GestureDetector(
                                onTap: () {
                                  showAlertDialog(
                                      context,
                                      'Delete',
                                      'Are you sure you want to delete?',
                                      ds.id.toString());
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: redColor,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },

                //Container(child: Text('AdminHome'),),
              );
            }
          },
        ),
        //     Container(
        // child: Text(
        //     'No Data...',
        // ),
        // ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, String title, String content, String id) {
    // set up the button

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("$title"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$content"),
      ),
      actions: [
        CupertinoDialogAction(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        CupertinoDialogAction(
            child: Text("Yes"),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Teachers")
                  .doc(id)
                  .delete()
                  .whenComplete(() {
                Navigator.of(context).pop();
              });
            })
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the App?'),
        actions:[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: primaryColor,
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            //return true when click on "Yes"
            style: ElevatedButton.styleFrom(
                primary: redColor,
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            child:Text('Yes'),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
}
