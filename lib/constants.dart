import 'package:flutter/material.dart';

const primaryColor = Color(0xffb2cf41);//Color(0xff37A000);
const lightGreenColor = Color(0xffD9E9D1);
const lightGreyColor = Color(0xffF6F6F6);
const textColor = Color(0xff333333);
const greyColor = Color(0xffB4C2CD);
const greyColor1 = Color(0xffDEDEDE);
const darkGreyColor = Color(0xff939393);
const redColor = Color(0xffFF6644);
const whiteColor = Color(0xffffffff);

//textSizess

double titleSize = 24;
double subTitleSize = 20;
double body12_16 = 16; // bold
double body34_14 = 14; // medium
double caption12_12 = 10;
double caption3 = 10;

// textStyles
TextStyle  titleBlack = TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold,color: textColor);
TextStyle  titleGreen = TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold,color: primaryColor);
TextStyle  titleWhite = TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold,color: Colors.white);

TextStyle  subtitleBlack = TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold,color: textColor);
TextStyle  subtitleGreen = TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold,color: primaryColor);
TextStyle  subtitleWhite = TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold,color: Colors.white);

TextStyle  body1Black = TextStyle(fontSize: body12_16, fontWeight: FontWeight.bold,color: textColor);
TextStyle  body1Red = TextStyle(fontSize: body12_16, fontWeight: FontWeight.bold,color: redColor);
TextStyle  body1Green = TextStyle(fontSize: body12_16, fontWeight: FontWeight.bold,color: primaryColor);
TextStyle  body1White = TextStyle(fontSize: body12_16, fontWeight: FontWeight.bold,color: Colors.white);

TextStyle  body2Black = TextStyle(fontSize: body12_16,color: textColor);
TextStyle  body2Green = TextStyle(fontSize: body12_16,color: primaryColor);
TextStyle  body2White = TextStyle(fontSize: body12_16,color: Colors.white);

TextStyle  body3Black = TextStyle(fontSize: body34_14,color: textColor,fontWeight: FontWeight.bold,);
TextStyle  body3Green = TextStyle(fontSize: body34_14,color: primaryColor,fontWeight: FontWeight.bold,);
TextStyle  body3Red = TextStyle(fontSize: body34_14,color: redColor,fontWeight: FontWeight.bold,);
TextStyle  body3White = TextStyle(fontSize: body34_14,color: Colors.white,fontWeight: FontWeight.bold,);

TextStyle  body4Black = TextStyle(fontSize: body34_14,color: textColor);
TextStyle  body4Grey = TextStyle(fontSize: body34_14,color: darkGreyColor);
TextStyle  body4Green = TextStyle(fontSize: body34_14,color: primaryColor);
TextStyle  body4Red = TextStyle(fontSize: body34_14,color: redColor);
TextStyle  body4White = TextStyle(fontSize: body34_14,color: Colors.white);
TextStyle  body4GreenBold = TextStyle(fontSize: 13,color: primaryColor,fontWeight: FontWeight.bold,);
TextStyle  body4BlackBold = TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold,);


TextStyle  caption1Black = TextStyle(fontSize: caption12_12,color: textColor,fontWeight: FontWeight.bold, );
TextStyle  caption1Green = TextStyle(fontSize: caption12_12,color: primaryColor,fontWeight: FontWeight.bold,);
TextStyle  caption1White = TextStyle(fontSize: caption12_12,color: Colors.white,fontWeight: FontWeight.bold,);
TextStyle  caption1Red = TextStyle(fontSize: caption12_12,color: redColor,fontWeight: FontWeight.bold,);

TextStyle  caption2Black = TextStyle(fontSize: caption12_12,color: textColor);
TextStyle  caption2Green = TextStyle(fontSize: caption12_12,color: primaryColor);
TextStyle  caption2White = TextStyle(fontSize: caption12_12,color: Colors.white);
TextStyle  caption2Grey = TextStyle(fontSize: caption12_12,color: darkGreyColor);

TextStyle  caption3Black = TextStyle(fontSize: caption3,color: textColor,height: 1.3);
TextStyle  caption3Red = TextStyle(fontSize: caption3,color: redColor,height: 1.3);
TextStyle  caption3Green = TextStyle(fontSize: caption3,color: primaryColor);
TextStyle  caption3White = TextStyle(fontSize: caption3,color: Colors.white);