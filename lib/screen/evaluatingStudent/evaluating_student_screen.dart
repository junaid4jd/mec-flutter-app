import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';

class EvaluatingStudentScreen extends StatefulWidget {
  final String studentId;
  const EvaluatingStudentScreen({Key? key,
  required this.studentId
  }) : super(key: key);

  @override
  _EvaluatingStudentScreenState createState() => _EvaluatingStudentScreenState();
}

class _EvaluatingStudentScreenState extends State<EvaluatingStudentScreen> {

  final TextEditingController _totalCompletedPartsControoler = TextEditingController();
  final TextEditingController _totalCompletedChaptersControoler = TextEditingController();

  int totalStars = 0;
  int totalCups = 0;
  int totalBadges = 0;
  bool _isLoading = false;

 Future getStudentStarsData() async {

    setState(() {
      totalStars = 0;
    });

    FirebaseFirestore.instance.collection("StudentEvaluatedSurah").where("studentUid", isEqualTo: widget.studentId.toString()).get().then((value) {

      for(int i=0 ; i< value.docs.length ; i++ ) {

        setState(() {
          totalStars = int.parse(value.docs[i]["surahStars"].toString()) + totalStars;
        });
      }
      print(totalStars.toString());
    });
    print("Total Stars $totalStars ");
  }




  @override
  void initState() {
    // TODO: implement initState
    getStudentStarsData();
    setState(() {
      _isLoading = false;
      print(widget.studentId.toString() + "Student Uid");
      _totalCompletedChaptersControoler.text = "0";
      _totalCompletedPartsControoler.text = "0";
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: textColor,
            size: 25
        ),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,),),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white
        ,title: Text('Student Evaluation',style:titleBlack,),centerTitle: true,),

      body:
      SingleChildScrollView(
        child: Column(children: [

          SizedBox(
            height: size.height*0.05,
          ),
          Center(
            child: Container(
              width: 150.0,
              height: 100.0,
              child: Image.asset('assets/images/quran.png', fit: BoxFit.scaleDown,),
            ),
          ),
          SizedBox(
            height: size.height*0.05,
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 0,
            ),
            child: Container(
                color: whiteColor,
                width: size.width * 0.85,
                child: TextFormField(

                  controller: _totalCompletedPartsControoler,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.badge,color: primaryColor,),
                    border: InputBorder.none,
                    fillColor: whiteColor,

                    contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                    hintText: 'Total Parts',
                    label: Text("Total Completed Parts"),
                    labelStyle: body1Black,
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  onChanged: (String value){

                  },

                )),
          ),
          SizedBox(
            height: size.height*0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
            ),
            child: Container(
                color: whiteColor,
                width: size.width * 0.85,
                child: TextFormField(
                  controller: _totalCompletedChaptersControoler,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.wysiwyg,color: primaryColor,),
                    border: InputBorder.none,
                    fillColor: whiteColor,
                    contentPadding: EdgeInsets.only(left: 9.0,top: 13,bottom: 13),
                    hintText: 'Total Completed Chapters',
                    label: Text("Total Completed Chapters"),
                    labelStyle: body1Black,
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  onChanged: (String value){

                  },

                )),
          ),
          SizedBox(
            height: size.height*0.03,
          ),

          Container(

            width: size.width*0.85,

            // decoration: BoxDecoration(
            //   color: primaryColor,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child:   Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child:
                Text("Note: Only evaluate the total completed parts and chapters of this class. Based on these parts and chapters completed the student will get total ${_totalCompletedPartsControoler.text}"
                    " badges and total ${_totalCompletedChaptersControoler.text} Cups respectively.", style: TextStyle(color: textColor,fontSize: 15, fontWeight: FontWeight.w600),),
              ),
            ),
          ),

          SizedBox(
            height: size.height*0.03,
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) :
          GestureDetector(
            onTap: () async
            {

              if(_totalCompletedPartsControoler.text.isEmpty) {

                Fluttertoast.showToast(
                    msg: "Enter total completed parts of this class if nothing then put 0",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);

              } else if(_totalCompletedChaptersControoler.text.isEmpty)  {

                Fluttertoast.showToast(
                    msg: "Enter total completed chapters of this class if nothing then put 0",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {

                setState(() {
                  _isLoading = true;
                });


                setState(() {
                  totalCups = 0;
                  totalBadges = 0;
                });

                FirebaseFirestore.instance.collection("Students").doc(widget.studentId.toString()).get().then((value) {


                  setState(() {
                    totalCups = value["studentCups"] + int.parse(_totalCompletedChaptersControoler.text.toString().trim());
                    totalBadges = value["studentBadges"] + int.parse(_totalCompletedPartsControoler.text.toString().trim());
                  });
                  print("Total Badges $totalBadges Total Cups $totalCups ");
                  print("Total Badges $totalBadges Total Cups $totalCups ");
                }).whenComplete(() {

                  FirebaseFirestore.instance.collection("Students").doc(widget.studentId.toString()).update({
                    "studentCups": totalCups,
                    "studentBadges": totalBadges,
                    "studentStars": totalStars,
                  }).then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Student Evaluated Successfully",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                  Navigator.of(context).pop();
                });

              }

              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (c, a1, a2) =>
              //         EvaluatingStudentScreen(studentId: widget.studentUid),
              //     transitionsBuilder: (c, anim, a2, child) =>
              //         FadeTransition(opacity: anim, child: child),
              //     transitionDuration: Duration(milliseconds: 0),
              //   ),
              // );
            },
            child: Container(

              width: size.width*0.85,

              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: Text("Submit", style: TextStyle(color: whiteColor,fontSize: 15),),
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



        ],),
      ),

    );
  }
}
