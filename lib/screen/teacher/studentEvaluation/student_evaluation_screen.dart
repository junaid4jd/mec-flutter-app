import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentEvaluationScreen extends StatefulWidget {
  final String surahName;
  final String surahAyhs;
  final String way;
  final String teacherEmail;

  const StudentEvaluationScreen({Key? key, required this.surahName, required this.surahAyhs, required this.way, required this.teacherEmail}) : super(key: key);

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
        stream: FirebaseFirestore.instance.collection("StudentClasses").where("teacherEmail",isEqualTo: widget.teacherEmail.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print(" we are here 3");
            return Center(child: CircularProgressIndicator(
              strokeWidth: 1,
              color: primaryColor,
            ));
          }
          else if (snapshot.hasData) {
            print(" we are here");
            return snapshot.data!.docs.length == 0 ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: snapshot.data!.docs.length,//myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
                          ),
                          SizedBox(height: 8,),

                          Text("name"),
                        ],
                      ),
                    );
                  }),
            ) : Center(
              child: Text(
                'No Data Found...',style: TextStyle(color: Colors.black),
              ),
            );
          }

          else {
            print(" we are here 1");
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
