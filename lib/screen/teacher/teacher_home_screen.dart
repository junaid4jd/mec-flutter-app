import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/home/home_screen_classes_teacher.dart';
import 'package:mec/screen/teacher/profile/profile_screen_teacher.dart';
import 'package:mec/screen/teacher/student/student_screen_teacher.dart';

class TeacherHomeScreen extends StatefulWidget {
  final String userType;
  final String email;
  const TeacherHomeScreen({Key? key, required this.userType, required this.email}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {

  int _selectedIndex = 0;
  List<Widget> _pages = [
    ClassesScreen(email: "",),
    StudentScreenTeacher(surahName: "",surahAyhs: "",way: ""),
    //TeacherProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _pages = [
        ClassesScreen(email: widget.email,),
        StudentScreenTeacher(surahName: "",surahAyhs: "",way: ""),
       // TeacherProfileScreen(),
      ];
    });

  }


  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    //getToken();
    return Scaffold(
      backgroundColor: lightGreyColor,
      body: _pages.elementAt(_selectedIndex),


      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 55,
          //  color: Colors.white,
          child: SizedBox(
            height: 70,
            child: CupertinoTabBar(
              activeColor: primaryColor,
              currentIndex: _selectedIndex,
              backgroundColor: Colors.white,
              iconSize: 40,
              onTap: _onItemTapped,
              items: [
                orientation == Orientation.portrait
                    ? BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                          _pages[0] = ClassesScreen(email: widget.email,);
                        });
                      },
                      child: Icon(
                        Icons.wysiwyg_sharp,
                        size: 25,
                        //color: Color(0xFF3A5A98),
                      ),
                    ),
                  ),
                  label: 'Classes',
                )
                    : BottomNavigationBarItem(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                              _pages[0] = ClassesScreen(email: widget.email,);
                            });
                          },
                          child: Icon(
                            Icons.wysiwyg_sharp,
                            size: 25,
                            //color: Color(0xFF3A5A98),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Classes',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                orientation == Orientation.portrait
                    ? BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                          _pages[1] = StudentScreenTeacher(surahName: "",surahAyhs: "",way: "");
                        });
                      },
                      child: Icon(
                        Icons.person,
                        size: 25,
                      ),
                    ),
                  ),
                  label: 'Students',
                )
                    : BottomNavigationBarItem(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                              _pages[1] = StudentScreenTeacher(surahName: "",surahAyhs: "",way: "");
                            });
                          },
                          child: Icon(
                            Icons.person,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Students',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                // orientation == Orientation.portrait
                //     ? BottomNavigationBarItem(
                //   icon: Padding(
                //     padding: EdgeInsets.only(bottom: 4),
                //     child: InkWell(
                //       onTap: () {
                //         setState(() {
                //           _selectedIndex = 2;
                //           _pages[2] = TeacherProfileScreen();
                //         });
                //       },
                //       child: Icon(
                //         Icons.account_circle,
                //         size: 25,
                //       ),
                //     ),
                //   ),
                //   label: 'Profile',
                // )
                //     : BottomNavigationBarItem(
                //   icon: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.only(bottom: 4),
                //         child: InkWell(
                //           onTap: () {
                //             setState(() {
                //               _selectedIndex = 2;
                //               _pages[2] = TeacherProfileScreen();
                //             });
                //           },
                //           child: Icon(
                //             Icons.account_circle,
                //             size: 25,
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 8,
                //       ),
                //       Text(
                //         'Profile',
                //         style: TextStyle(fontSize: 15),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
