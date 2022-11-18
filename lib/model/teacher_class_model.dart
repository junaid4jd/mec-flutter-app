// To parse this JSON data, do
//
//     final teacherClasseModel = teacherClasseModelFromJson(jsonString);

import 'dart:convert';

TeacherClasseModel teacherClasseModelFromJson(String str) => TeacherClasseModel.fromJson(json.decode(str));

String teacherClasseModelToJson(TeacherClasseModel data) => json.encode(data.toJson());

class TeacherClasseModel {
  TeacherClasseModel({
    this.classGrade,
    this.teacherUid,
    this.classCode,
    this.teacherEmail,
    this.chapList,
    this.teacherName,
    this.chapterToggle4,
    this.chapterToggle3,
    this.className,
    this.chapterToggle2,
    this.chapterToggle1,
  });

  String? classGrade;
  String? teacherUid;
  String? classCode;
  String? teacherEmail;
  List<ChapList>? chapList;
  String? teacherName;
  bool? chapterToggle4;
  bool? chapterToggle3;
  String? className;
  bool? chapterToggle2;
  bool? chapterToggle1;

  factory TeacherClasseModel.fromJson(Map<String, dynamic> json) => TeacherClasseModel(
    classGrade: json["classGrade"] == null ? null : json["classGrade"],
    teacherUid: json["teacherUid"] == null ? null : json["teacherUid"],
    classCode: json["classCode"] == null ? null : json["classCode"],
    teacherEmail: json["teacherEmail"] == null ? null : json["teacherEmail"],
    chapList: json["chapList"] == null ? null : List<ChapList>.from(json["chapList"].map((x) => ChapList.fromJson(x))),
    teacherName: json["teacherName"] == null ? null : json["teacherName"],
    chapterToggle4: json["chapterToggle4"] == null ? null : json["chapterToggle4"],
    chapterToggle3: json["chapterToggle3"] == null ? null : json["chapterToggle3"],
    className: json["className"] == null ? null : json["className"],
    chapterToggle2: json["chapterToggle2"] == null ? null : json["chapterToggle2"],
    chapterToggle1: json["chapterToggle1"] == null ? null : json["chapterToggle1"],
  );

  Map<String, dynamic> toJson() => {
    "classGrade": classGrade == null ? null : classGrade,
    "teacherUid": teacherUid == null ? null : teacherUid,
    "classCode": classCode == null ? null : classCode,
    "teacherEmail": teacherEmail == null ? null : teacherEmail,
    "chapList": chapList == null ? null : List<dynamic>.from(chapList!.map((x) => x.toJson())),
    "teacherName": teacherName == null ? null : teacherName,
    "chapterToggle4": chapterToggle4 == null ? null : chapterToggle4,
    "chapterToggle3": chapterToggle3 == null ? null : chapterToggle3,
    "className": className == null ? null : className,
    "chapterToggle2": chapterToggle2 == null ? null : chapterToggle2,
    "chapterToggle1": chapterToggle1 == null ? null : chapterToggle1,
  };
}

class ChapList {
  ChapList({
    this.part3Toggle,
    this.chapterId,
    this.chapterName,
    this.part1Toggle,
    this.part2Toggle,
    this.content,
  });

  bool? part3Toggle;
  String? chapterId;
  String? chapterName;
  bool? part1Toggle;
  bool? part2Toggle;
  Content? content;

  factory ChapList.fromJson(Map<String, dynamic> json) => ChapList(
    part3Toggle: json["part3Toggle"] == null ? null : json["part3Toggle"],
    chapterId: json["chapterId"] == null ? null : json["chapterId"],
    chapterName: json["chapterName"] == null ? null : json["chapterName"],
    part1Toggle: json["part1Toggle"] == null ? null : json["part1Toggle"],
    part2Toggle: json["part2Toggle"] == null ? null : json["part2Toggle"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
  );

  Map<String, dynamic> toJson() => {
    "part3Toggle": part3Toggle == null ? null : part3Toggle,
    "chapterId": chapterId == null ? null : chapterId,
    "chapterName": chapterName == null ? null : chapterName,
    "part1Toggle": part1Toggle == null ? null : part1Toggle,
    "part2Toggle": part2Toggle == null ? null : part2Toggle,
    "content": content == null ? null : content!.toJson(),
  };
}

class Content {
  Content({
    this.chapterId,
    this.chapterName,
    this.surahs,
  });

  String? chapterId;
  String? chapterName;
  List<Surah>? surahs;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    chapterId: json["chapterId"] == null ? null : json["chapterId"],
    chapterName: json["chapterName"] == null ? null : json["chapterName"],
    surahs: json["surahs"] == null ? null : List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "chapterId": chapterId == null ? null : chapterId,
    "chapterName": chapterName == null ? null : chapterName,
    "surahs": surahs == null ? null : List<dynamic>.from(surahs!.map((x) => x.toJson())),
  };
}

class Surah {
  Surah({
    this.part1,
    this.part2,
    this.part3,
  });

  List<Part>? part1;
  List<Part>? part2;
  List<Part>? part3;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
    part1: json["part1"] == null ? null : List<Part>.from(json["part1"].map((x) => Part.fromJson(x))),
    part2: json["part2"] == null ? null : List<Part>.from(json["part2"].map((x) => Part.fromJson(x))),
    part3: json["part3"] == null ? null : List<Part>.from(json["part3"].map((x) => Part.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "part1": part1 == null ? null : List<dynamic>.from(part1!.map((x) => x.toJson())),
    "part2": part2 == null ? null : List<dynamic>.from(part2!.map((x) => x.toJson())),
    "part3": part3 == null ? null : List<dynamic>.from(part3!.map((x) => x.toJson())),
  };
}

class Part {
  Part({
    this.surahName,
    this.surahGreenAyah,
    this.surahLocked,
    this.surahStars,
    this.surahRecording,
    this.verses,
  });

  String? surahName;
  String? surahGreenAyah;
  String? surahLocked;
  String? surahStars;
  String? surahRecording;
  Verses? verses;

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    surahName: json["surahName"] == null ? null : json["surahName"],
    surahLocked: json["surahLocked"] == null ? null : json["surahLocked"],
    surahRecording: json["surahRecording"] == null ? null : json["surahRecording"],
    surahGreenAyah: json["surahGreenAyah"] == null ? null : json["surahGreenAyah"],
    surahStars: json["surahStars"] == null ? null : json["surahStars"],
    verses: json["verses"] == null ? null : Verses.fromJson(json["verses"]),
  );

  Map<String, dynamic> toJson() => {
    "surahName": surahName == null ? null : surahName,
    "surahLocked": surahLocked == null ? null : surahLocked,
    "surahRecording": surahRecording == null ? null : surahRecording,
    "surahGreenAyah": surahGreenAyah == null ? null : surahGreenAyah,
    "surahStars": surahStars == null ? null : surahStars,
    "verses": verses == null ? null : verses!.toJson(),
  };
}

class Verses {
  Verses({
    this.surahVerses,
  });

  List<SurahVerse>? surahVerses;

  factory Verses.fromJson(Map<String, dynamic> json) => Verses(
    surahVerses: json["surahVerses"] == null ? null : List<SurahVerse>.from(json["surahVerses"].map((x) => SurahVerse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "surahVerses": surahVerses == null ? null : List<dynamic>.from(surahVerses!.map((x) => x.toJson())),
  };
}

class SurahVerse {
  SurahVerse({
    this.verseRecording,
    this.verseColor,
    this.evaluated,
    this.verse,
  });

  String? verseRecording;
  String? verseColor;
  String? evaluated;
  String? verse;

  factory SurahVerse.fromJson(Map<String, dynamic> json) => SurahVerse(
    verseRecording: json["verseRecording"] == null ? null : json["verseRecording"],
    verseColor: json["verseColor"] == null ? null : json["verseColor"],
    evaluated: json["evaluated"] == null ? null : json["evaluated"],
    verse: json["verse"] == null ? null : json["verse"],
  );

  Map<String, dynamic> toJson() => {
    "verseRecording": verseRecording == null ? null : verseRecording,
    "verseColor": verseColor == null ? null : verseColor,
    "evaluated": evaluated == null ? null : evaluated,
    "verse": verse == null ? null : verse,
  };
}


class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
