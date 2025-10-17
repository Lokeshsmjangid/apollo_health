import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'app_color.dart';

TextStyle manropeTextStyle() {
  return const TextStyle(fontFamily: 'Manrope');
}
TextStyle caprasimoTextStyle() {
  return const TextStyle(fontFamily: 'Caprasimo');
}

Text addText100(String text,{TextAlign? textAlign,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // thin
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    // fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w100,height: height,decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText200(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // extralight
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w200,height: height,decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText300(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // light
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w300,height: height,decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText400(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,
  TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // regular
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines:maxLines,style: TextStyle(
    overflow: overflow,
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w400,
    height: height!=null?getLineHeight(fontSize: fontSize??14, lineHeightPx: height??1.0):height,
    decoration: decoration,color: color,
  ));
}
Text addText500(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // medium
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w500,
    height: height!=null?getLineHeight(fontSize: fontSize??14, lineHeightPx: height??1.0):height,
    decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText600(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // semi-bold
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: FontWeight.w600,
    height: height!=null?getLineHeight(fontSize: fontSize??14, lineHeightPx: height??1.0):height,
    decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText700(String text,{TextAlign? textAlign,FontWeight? fontWeight,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // bold
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: fontWeight??FontWeight.w700,height: height,decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText800(String text,{TextAlign? textAlign,FontWeight? fontWeight,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // bold
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines: maxLines,style: TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,fontWeight: fontWeight??FontWeight.w800,height: height,decoration: decoration,overflow: overflow,color: color,
  ));
}
Text addText900(String text,{TextAlign? textAlign,String? fontFamily,double? fontSize,double? height,TextDecoration? decoration,TextOverflow? overflow,int? maxLines,Color? color}){ // black
  return Text(text,textAlign: textAlign,overflow: overflow,maxLines:maxLines,
      style: TextStyle(fontFamily: fontFamily, fontSize: fontSize,fontWeight: FontWeight.w900,height: height,decoration: decoration,color: color));
}

SizedBox addWidth(double? width){
  return SizedBox(width: width);
}
SizedBox addHeight(double? height){
  return SizedBox(height: height);
}

// multi text like a row
RichText richText( String? text1,text2,
    { String? fontFamily1,String? fontFamily2,double? fontSize1,fontSize2,
      FontWeight? fontWeight1,fontWeight2, Color? textColor1,textColor2,
      GestureRecognizer? onTapText2})
{
  return RichText(
    text:  TextSpan(
      text: text1,
      style: TextStyle(
        fontFamily: fontFamily1,
        fontWeight: fontWeight1,
          fontSize: fontSize1,
          color: textColor1??AppColors.blackColor,
          // fontFamily: 'Ubuntu'
      ),
      children: [
        TextSpan(
          text: text2,
          recognizer: onTapText2,
          style: TextStyle(
            fontFamily: fontFamily2,
            fontSize: fontSize2,
            fontWeight: fontWeight2,
            color: textColor2??AppColors.blackColor,
          ),
        ),

      ],
    ),
  );
}
double getLineHeight({required double fontSize, required double lineHeightPx}) {
  return lineHeightPx / fontSize;
}

Text richText2({TextAlign? textAlign,String? text1,String?text2,String?text3,double? fontSize,Color? textColor1,Color?textColor2,Color?textColor3,double? fontSize1,double?fontSize2,double?fontSize3,
  FontWeight? fontWeight1,FontWeight?fontWeight2,FontWeight?fontWeight3,}){
  return Text.rich(
    TextSpan(
      children: <TextSpan>[
        TextSpan(text: text1, style: TextStyle(color: textColor1,fontWeight: fontWeight1,fontSize: fontSize1,)),
        TextSpan(text: text2, style: TextStyle(color: textColor2,fontWeight: fontWeight2,fontSize: fontSize2)),
        TextSpan(text: text3, style: TextStyle(color: textColor3,fontWeight: fontWeight3,fontSize: fontSize2)),
      ],
    ),
    textAlign: textAlign??TextAlign.center,
    style: TextStyle(
      height: 1.3,
        fontSize: fontSize??16, fontWeight: FontWeight.w400,
    ),
  );
}