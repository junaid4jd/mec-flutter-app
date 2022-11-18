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
                child:    ListView.builder(
                  itemCount: 10,//snapshot.data!.docs[0]["chapList"].length,
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
                              width: size.width*0.9,
                              //height: size.height*0.06,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    // width: size.width*0.6,
                                    child: LinearPercentIndicator(
                                      width: size.width*0.5,//180.0,
                                      lineHeight: 14.0,
                                      percent: 0.35,
                                      leading: new Text("0 "),
                                      trailing: new Text("100"),
                                      backgroundColor: greyColor,
                                      progressColor: Colors.blue,
                                    ),
                                  ),
                                  Container(
                                    width: size.width*0.3,
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
                                              width: 25,
                                              height: 25,
                                              child: Image.asset('assets/images/ribbon.png'),
                                              // Image.asset('assets/images/trophy.png'),
                                            ),
                                          ),


                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNDgyaDCaoDZJx8N9BBE6eXm5uXuObd6FPeg&usqp=CAU'),
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





              SizedBox(height: size.height*0.04,),







            ],
          ),
        ),
      ),


    );
  }
}
