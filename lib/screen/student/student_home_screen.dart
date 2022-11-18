import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/student/addClass/chap_in_class_screen.dart';
import 'package:mec/screen/student/myClasses/my_class_screen.dart';
import 'package:mec/screen/student/practices/student_practice_screen.dart';
import 'package:mec/screen/student/profile/my_profile_screen.dart';
import 'package:mec/screen/student/studentSurah/student_surahs_screen.dart';


class StudentHomeScreen extends StatefulWidget {
  final String userType;
  final int index;
  final String classCode;
  const StudentHomeScreen({Key? key, required this.userType, required this.index, required this.classCode}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    StudentClassScreen(),
    StudentPracticeScreen(),
    StudentProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.index == 4) {
      setState(() {
        _selectedIndex = 0;
        _pages[0] = StudentClassChapScreen(classCode: widget.classCode.toString(),);
      });
    }
    else if (widget.index == 6) {
      setState(() {
        _selectedIndex = 0;
        _pages[0] = StudentSurahScreen(classCode: widget.classCode,);
      });
    }
    else if (widget.index == 5) {
      setState(() {
        _selectedIndex = 2;
        _pages[2] = StudentProfileScreen();
      });
    }
    super.initState();
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
                          _pages[0] = StudentClassScreen();
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
                              _pages[0] = StudentClassScreen();
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
                          _pages[1] = StudentPracticeScreen();
                        });
                      },
                      child: Icon(
                        Icons.source,
                        size: 25,
                      ),
                    ),
                  ),
                  label: 'Practice',
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
                              _pages[1] = StudentPracticeScreen();
                            });
                          },
                          child: Icon(
                            Icons.source,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Practice',
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
                          _selectedIndex = 2;
                          _pages[2] = StudentProfileScreen();
                        });
                      },
                      child: Icon(
                        Icons.account_circle,
                        size: 25,
                      ),
                    ),
                  ),
                  label: 'Profile',
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
                              _selectedIndex = 2;
                              _pages[2] = StudentProfileScreen();
                            });
                          },
                          child: Icon(
                            Icons.account_circle,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
