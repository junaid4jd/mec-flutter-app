import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LeatherBoardScreen extends StatefulWidget {
  const LeatherBoardScreen({Key? key}) : super(key: key);

  @override
  _LeatherBoardScreenState createState() => _LeatherBoardScreenState();
}

class _LeatherBoardScreenState extends State<LeatherBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Leather Board"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height*0.045,),

              Image.asset("assets/images/trophy.png",
                width: 100,
                height: 100,),

              SizedBox(height: size.height*0.04,),
              Text("Leather Board", style: TextStyle(color: Colors.black, fontSize: 28,fontWeight: FontWeight.bold),),
              SizedBox(height: size.height*0.04,),




              Container(
                height: size.height*0.6,
                child:   StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Students").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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
                      // this else if means you have enrolled below list of classes.
                      return Center(
                        child: Container(
                          width: size.width*0.95,

                          child:   ListView.builder(
                            itemCount: snapshot.data!.docs.length,//snapshot.data!.docs[0]["chapList"].length,
                            itemBuilder: (context, index) {
                              // DocumentSnapshot ds = snapshot.data!.docs[0]["chapList"][index];
                              return  Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                child: DottedBorder(
                                  strokeWidth: 3,
                                  color: greyColor,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  // padding: EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    child:   Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        // color: Colors.green,
                                        width: size.width*0.95,
                                        //height: size.height*0.06,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              // width: size.width*0.6,
                                              // studentStars
                                              child: LinearPercentIndicator(
                                                width: size.width*0.5,//180.0,
                                                lineHeight: 14.0,
                                                percent: (snapshot.data!.docs[index]['studentCups'] + snapshot.data!.docs[index]['studentBadges']
                                                    + snapshot.data!.docs[index]['studentStars']
                                                )/1000,
                                                leading: new Text("0 ",style: TextStyle(fontSize: 10),),
                                                trailing: new Text("1000", style: TextStyle(fontSize: 10),),
                                                backgroundColor: greyColor,
                                                progressColor: Colors.blue,
                                              ),
                                            ),
                                            Container(
                                             // width: size.width*0.3,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide( //                   <--- right side
                                                      color: Colors.grey,
                                                      width: 0.5,

                                                    ),
                                                  )
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [

                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: Image.asset('assets/images/trophy.png'),
                                                    ),

                                                    GestureDetector(
                                                      onTap: () {

                                                      },
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset('assets/images/ribbon.png'),
                                                        // Image.asset('assets/images/trophy.png'),
                                                      ),
                                                    ),

                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(snapshot.data!.docs[index]['name'].toString().split(' ')[0],
                                                        style: TextStyle(fontSize: 12, color: whiteColor),
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
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




              ),





              SizedBox(height: size.height*0.04,),







            ],
          ),
        ),
      ),


    );
  }
}
