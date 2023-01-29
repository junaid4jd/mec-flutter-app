import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/authentication/login/login_screen.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(
              child: Container(
                width: 120.0,
                height: 120.0,
                child: Image.asset('assets/images/quran.png', fit: BoxFit.scaleDown,),
              ),
            ),

            SizedBox(
              height: size.height*0.07,
            ),

          SizedBox(
            height: size.height*0.06,
            width: size.width*0.85,
            child: ElevatedButton(
                onPressed: (){
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingnIn()));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(userType: 'Admin',)));


                },
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text("Admin",
                    style: subtitleWhite
                )
            ),
          ),
          SizedBox(
            height: size.height*0.03,
          ),
          SizedBox(
            height: size.height*0.06,
            width: size.width*0.85,
            child: ElevatedButton(
                onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(userType: 'Teacher',)));

                },
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text("Teacher",
                    style: subtitleWhite
                )
            ),
          ),
          SizedBox(
            height: size.height*0.03,
          ),
          SizedBox(
            height: size.height*0.06,
            width: size.width*0.85,
            child: ElevatedButton(
                onPressed: (){
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingnIn()));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen(userType: 'Student',)));


                },
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text("Student",
                    style: subtitleWhite
                )
            ),
          ),
          SizedBox(
            height: size.height*0.03,
          ),

        ],),
      ),
    );
  }
}
