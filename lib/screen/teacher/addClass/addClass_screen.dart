import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mec/constants.dart';
import 'package:mec/screen/teacher/teacher_home_screen.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/firebase_auth.dart';

class AddClassScreen extends StatefulWidget {
  final String email;

  const AddClassScreen({Key? key, required this.email}) : super(key: key);

  @override
  _AddClassScreenState createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final TextEditingController _classNameControoler = TextEditingController();
  String dropdownvalue = 'Select Grade';
  String name = '',
      email = '',
      uid = '',
      code = '',
      chap1 = '',
      chap2 = '',
      chap3 = '',
      chap4 = '';
  List items = [
    'Select Grade',
    'KG One',
    'KG Two',
    'Grade One',
    'Grade Two',
    'Grade Three',
    'Grade Four',
  ];

  bool chp1 = false;
  bool chp2 = false;
  bool chp3 = false;
  bool chp4 = false;
  bool _isLoading = false;
  String isClassNameExist = '';

  MethodsHandler _methodsHandler = MethodsHandler();
  List<Map<String, dynamic>> chapterList = [];
  Map<String, dynamic> chapter1 = {
    "chap1": {
      "chapterId": "1",
      "chapterName": "جزء عم",
      "surahs": {
        "part1": [
          {
            "surahName": "112",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
          {
            "surahName": "113",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
          {
            "surahName": "114",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
          {
            "surahName": "108",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          }
        ],
        "part2": [
          {
            "surahName": "97",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
          {
            "surahName": "95",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
        ],
        "part3": [
          {
            "surahName": "86",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
          {
            "surahName": "87",
            "surahRecording": "record",
            "surahStars": "0",
            "surahGreenAyah": "0",
            "verses": {
              "surahVerses": [
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
              ]
            }
          },
        ],
      }
    }
  };
  Map<String, dynamic> chapterList1 = {
    "chap1": {
      "chapterId": "1",
      "chapterName": "جزء عم",
      "surahs": {
        "part1": [
          {"surahName": "12", "locked": "0", "surahRecording": "record"},
          {"surahName": "18", "locked": "0", "surahRecording": "record"}
        ],
        "part2": [
          {"surahName": "18", "locked": "0", "surahRecording": "record"}
        ],
        "part3": [
          {"surahName": "20", "locked": "0", "surahRecording": "record"}
        ]
      }
    }
  };

  addChap1() {
    if (chp1) {
      setState(() {
        chapterList.add({
          "chapterName": chap1,
          "chapterId": "1",
          "part1Toggle": false,
          "part2Toggle": false,
          "part3Toggle": false,
          "content" : {
            "chapterId": "1",
            "chapterName": "جزء عم",
        "surahs":[
          { "part1": [
            {
              "surahName": "112",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "113",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "114",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "108",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",}
                ]
              }
            }
          ],},
          { "part2": [
            {
              "surahName": "97",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "95",
              "surahRecording": "record",
              "surahLocked": "yes",
              "surahStars": "0",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "7","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "8","verseRecording": "1",},
                ]
              }
            },
          ],},
          { "part3": [
            {
              "surahName": "86",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "7","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "8","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "9","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "10","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "11","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "12","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "13","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "14","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "15","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "16","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "17","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "87",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "7","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "8","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "9","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "10","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "11","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "12","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "13","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "14","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "15","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "16","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "17","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "18","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "19","verseRecording": "1",},
                ]
              }
            },
          ],},
        ],
          }
        });
      });
    }
  }

  addChap2() {
    if (chp2) {
      setState(() {
        chapterList.add({
          "chapterName": chap2,
          "chapterId": "2",
          "part1Toggle": false,
          "part2Toggle": false,
          "part3Toggle": false,
          "content" : {
            "chapterId": "2",
            "chapterName": "جزء تبارك",
            "surahs": [
              { "part1": [
                {
                  "surahName": "77",
                  "surahRecording": "record",
                  "surahStars": "0",
                  "surahLocked": "yes",
                  "surahGreenAyah": "0",
                  "verses": {
                    "surahVerses": [
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                    ]
                  }
                },
                {
                  "surahName": "76",
                  "surahRecording": "record",
                  "surahStars": "0",
                  "surahLocked": "yes",
                  "surahGreenAyah": "0",
                  "verses": {
                    "surahVerses": [
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                    ]
                  }
                },
              ],},
              {
                "part2": [
                  {
                    "surahName": "73",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                  {
                    "surahName": "72",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                ],
              },
              {
              "part3": [
                {
                  "surahName": "69",
                  "surahRecording": "record",
                  "surahStars": "0",
                  "surahLocked": "yes",
                  "surahGreenAyah": "0",
                  "verses": {
                    "surahVerses": [
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "6","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "7","verseRecording": "1",},
                    ]
                  }
                },
                {
                  "surahName": "67",
                  "surahRecording": "record",
                  "surahStars": "0",
                  "surahLocked": "yes",
                  "surahGreenAyah": "0",
                  "verses": {
                    "surahVerses": [
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      {"verseColor": "Colors.grey", "evaluated": "no", "verse": "5","verseRecording": "1",},
                    ]
                  }
                },
              ],
            },
            ]
          }
        });
      });
    }
  }

  addChap3() {
    if (chp3) {
      setState(() {
        chapterList.add({
          "chapterName": chap3,
          "chapterId": "3",
          "part1Toggle": false,
          "part2Toggle": false,
          "part3Toggle": false,
          "content" : {
            "chapterId": "1",
            "chapterName": "جزء عم",
        "surahs":[
          { "part1": [
            {
              "surahName": "66",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                ]
              }
            },
            {
              "surahName": "65",
              "surahRecording": "record",
              "surahStars": "0",
              "surahLocked": "yes",
              "surahGreenAyah": "0",
              "verses": {
                "surahVerses": [
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                  {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                ]
              }
            },
          ],},
          {
            "part2": [
              {
                "surahName": "62",
                "surahRecording": "record",
                "surahStars": "0",
                "surahLocked": "yes",
                "surahGreenAyah": "0",
                "verses": {
                  "surahVerses": [
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  ]
                }
              },
              {
                "surahName": "61",
                "surahRecording": "record",
                "surahStars": "0",
                "surahLocked": "yes",
                "surahGreenAyah": "0",
                "verses": {
                  "surahVerses": [
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  ]
                }
              },
            ],
          },
          {
            "part3": [
              {
                "surahName": "59",
                "surahRecording": "record",
                "surahStars": "0",
                "surahLocked": "yes",
                "surahGreenAyah": "0",
                "verses": {
                  "surahVerses": [
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  ]
                }
              },
              {
                "surahName": "58",
                "surahRecording": "record",
                "surahStars": "0",
                "surahLocked": "yes",
                "surahGreenAyah": "0",
                "verses": {
                  "surahVerses": [
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                    {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                  ]
                }
              },
            ],
          },
        ],
          }
        });
      });
    }
  }

  addChap4() {
    if (chp4) {
      setState(() {
        chapterList.add({
          "chapterName": chap4,
          "chapterId": "4",
          "part1Toggle": false,
          "part2Toggle": false,
          "part3Toggle": false,
          "content" : {
            "chapterId": "1",
            "chapterName": "جزء عم",

            "surahs":[
              {
                "part1": [
                  {
                    "surahName": "57",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                  {
                    "surahName": "56",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                ],
              },
              {
                "part2": [
                  {
                    "surahName": "55",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                  {
                    "surahName": "54",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                ],
              },
              {
                "part3": [
                  {
                    "surahName": "52",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                  {
                    "surahName": "51",
                    "surahRecording": "record",
                    "surahStars": "0",
                    "surahLocked": "yes",
                    "surahGreenAyah": "0",
                    "verses": {
                      "surahVerses": [
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "1","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "2","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "3","verseRecording": "1",},
                        {"verseColor": "Colors.grey", "evaluated": "no", "verse": "4","verseRecording": "1",},
                      ]
                    }
                  },
                ],
              },
            ],
          }
        });
      });
    }
  }

  getChapterList() {
    setState(() {
      chapterList.clear();
    });
    addChap1();
    addChap2();
    addChap3();
    addChap4();
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      dropdownvalue = 'Select Grade';
      isClassNameExist = '';
      chp1 = false;
      chp2 = false;
      chp3 = false;
      chp4 = false;
      _isLoading = false;
    });
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('Teachers')
        .doc(prefs.getString('userId')!)
        .get()
        .then((value) {
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
        title: Text("Add Class"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor, width: 0.5),
                    color: whiteColor,
                  ),
                  width: size.width * 0.85,
                  child: TextFormField(
                    controller: _classNameControoler,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      // prefixIcon: Icon(
                      //   Icons.wysiwyg_sharp,
                      //   color: primaryColor,
                      // ),
                      border: InputBorder.none,
                      fillColor: whiteColor,
                      contentPadding:
                          EdgeInsets.only(left: 9.0, top: 13, bottom: 13),
                      hintText: 'KG1 A',
                      label: Text("Class Name"),
                      labelStyle: body4Black,
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    onChanged: (String value) {},
                  )),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.075,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    //borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyColor, width: 0.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dropdownvalue,

                      hint: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Select',
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      isDense: true, // Reduces the dropdowns height by +/- 50%
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: greyColor,
                        ),
                      ),
                      items: items.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(item, style: body4Black),
                          ),
                        );
                      }).toList(),
                      onChanged: (selectedItem) => setState(
                        () => dropdownvalue = selectedItem.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Select Quran chapter for your class',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: whiteColor,
                //borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor, width: 0.5),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: primaryColor,
                                value: chp1,
                                onChanged: (bool? value) {
                                  setState(() {
                                    chp1 = value!;
                                    chap1 = 'جزء عم';
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'جزء عم',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: size.width * 0.4,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: primaryColor,
                                value: chp2,
                                onChanged: (bool? value) {
                                  setState(() {
                                    chp2 = value!;
                                    chap2 = 'جزء تبارك';
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'جزء تبارك',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: primaryColor,
                                value: chp3,
                                onChanged: (bool? value) {
                                  setState(() {
                                    chp3 = value!;
                                    chap3 = 'جزء قدسمع';
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'جزء قدسمع',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: size.width * 0.4,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: primaryColor,
                                value: chp4,
                                onChanged: (bool? value) {
                                  setState(() {
                                    chp4 = value!;
                                    chap4 = 'جزء الذارياتِ';
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'جزء الذاريات',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            _isLoading
                ? CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 2,
                  )
                : SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.85,
                    child: ElevatedButton(
                        onPressed: () async {
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SingnIn()));

                          print(chapterList.toString());
                          if (_classNameControoler.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Class Name is required",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (dropdownvalue == 'Select Grade') {
                            Fluttertoast.showToast(
                                msg: "Select Class Grade",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (chp1 == false &&
                              chp2 == false &&
                              chp3 == false &&
                              chp4 == false) {
                            Fluttertoast.showToast(
                                msg: "Select Chapter",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final snapshot = await FirebaseFirestore.instance
                                .collection('Classes')
                                .get();
                            snapshot.docs.forEach((element) {
                              print('user data');
                              if (element['className'] ==
                                  _classNameControoler.text.toString().trim()) {
                                print('user age in if of current user ');
                                //   print(element['age']);
                                setState(() {
                                  isClassNameExist = 'yes';
                                });
                              }
                            });

                            if (isClassNameExist == 'yes') {
                              setState(() {
                                _isLoading = false;
                              });
                              _methodsHandler.showAlertDialog(context, 'Sorry',
                                  'Class name already exists');

                              // Navigator.pushReplacement(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (c, a1, a2) =>
                              //         TeacherHomeScreen(userType: widget.userType,),
                              //     transitionsBuilder:
                              //         (c, anim, a2, child) =>
                              //         FadeTransition(
                              //             opacity: anim,
                              //             child: child),
                              //     transitionDuration:
                              //     Duration(milliseconds: 0),
                              //   ),
                              // );
                            } else {
                              getChapterList();
                              print(chapterList.toString());
                              var rng = Random();
                              setState(() {
                                code = rng.nextInt(10000000).toString();
                              });
                              FirebaseFirestore.instance
                                  .collection('Classes')
                                  .doc()
                                  .set({
                                "teacherEmail": email,
                                "teacherName": name,
                                "teacherUid": uid,
                                "classGrade": dropdownvalue.toString(),
                                "chapList": chapterList,
                                "chapterToggle1": false,
                                "chapterToggle2": false,
                                "chapterToggle3": false,
                                "chapterToggle4": false,
                                "classCode": code.toString(),
                                "className":
                                    _classNameControoler.text.toString(),
                              }).then((value) {
                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        TeacherHomeScreen(
                                      userType: "Teacher",
                                      email: widget.email,
                                    ),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 0),
                                  ),
                                );
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text("Add", style: subtitleWhite)),
                  ),
          ],
        ),
      ),
    );
  }
}
